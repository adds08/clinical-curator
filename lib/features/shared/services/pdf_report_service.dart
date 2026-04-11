import 'dart:convert';
import 'dart:typed_data';

import 'package:fhir/r4.dart' as fhir;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/database/isar_service.dart';
import '../../../core/utils/fhir_helpers.dart';

class PdfReportService {
  Future<Uint8List> generatePatientReport({
    required fhir.Patient patient,
    required List<fhir.Observation> vitals,
    required List<fhir.DiagnosticReport> labs,
    required List<fhir.MedicationRequest> medications,
    required List<fhir.AllergyIntolerance> allergies,
    required List<fhir.Immunization> immunizations,
  }) async {
    final pdf = pw.Document(
      title: 'Patient Health Report',
      author: 'Clinical Curator',
    );

    final patientName = FhirHelpers.extractPatientName(patient);
    final birthDate = patient.birthDate != null
        ? FhirHelpers.formatFhirDate(patient.birthDate)
        : 'N/A';
    final gender = patient.gender?.value ?? 'N/A';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(patientName, context),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildPatientInfo(patientName, birthDate, gender, patient),
          pw.SizedBox(height: 20),
          if (vitals.isNotEmpty) ...[
            _buildSectionTitle('Vital Signs'),
            _buildVitalsTable(vitals),
            pw.SizedBox(height: 16),
          ],
          if (labs.isNotEmpty) ...[
            _buildSectionTitle('Lab Results'),
            _buildLabsSection(labs),
            pw.SizedBox(height: 16),
          ],
          if (medications.isNotEmpty) ...[
            _buildSectionTitle('Medications'),
            _buildMedicationsTable(medications),
            pw.SizedBox(height: 16),
          ],
          if (allergies.isNotEmpty) ...[
            _buildSectionTitle('Allergies'),
            _buildAllergiesSection(allergies),
            pw.SizedBox(height: 16),
          ],
          if (immunizations.isNotEmpty) ...[
            _buildSectionTitle('Immunizations'),
            _buildImmunizationsTable(immunizations),
            pw.SizedBox(height: 16),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> generatePatientReportFromLocal(
      String patientRef) async {
    final box = DatabaseService.fhirResources;

    fhir.Patient? patient;
    final vitals = <fhir.Observation>[];
    final labs = <fhir.DiagnosticReport>[];
    final medications = <fhir.MedicationRequest>[];
    final allergies = <fhir.AllergyIntolerance>[];
    final immunizations = <fhir.Immunization>[];

    for (final r in box.values) {
      if (r.syncStatus == 2) continue; // skip pending-delete

      try {
        final json = jsonDecode(r.jsonData) as Map<String, dynamic>;
        final resource = fhir.Resource.fromJson(json);

        if (r.resourceType == 'Patient' && r.fhirId == patientRef.replaceFirst('Patient/', '')) {
          if (resource is fhir.Patient) patient = resource;
        } else if (r.patientReference == patientRef) {
          if (resource is fhir.Observation) {
            final isVital = r.category == 'vital-signs';
            if (isVital) {
              vitals.add(resource);
            }
          } else if (resource is fhir.DiagnosticReport) {
            labs.add(resource);
          } else if (resource is fhir.MedicationRequest) {
            medications.add(resource);
          } else if (resource is fhir.AllergyIntolerance) {
            allergies.add(resource);
          } else if (resource is fhir.Immunization) {
            immunizations.add(resource);
          }
        }
      } catch (_) {}
    }

    if (patient == null) {
      throw Exception('Patient not found for reference: $patientRef');
    }

    return generatePatientReport(
      patient: patient,
      vitals: vitals,
      labs: labs,
      medications: medications,
      allergies: allergies,
      immunizations: immunizations,
    );
  }

  // ---------------------------------------------------------------------------
  // PDF Building Helpers
  // ---------------------------------------------------------------------------

  pw.Widget _buildHeader(String patientName, pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.blue800, width: 2),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Clinical Curator',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.Text(
            'Health Report — $patientName',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    final now = DateTime.now();
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 8),
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated: ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPatientInfo(
    String name,
    String birthDate,
    String gender,
    fhir.Patient patient,
  ) {
    final identifier = patient.identifier?.isNotEmpty == true
        ? patient.identifier!.first.value ?? 'N/A'
        : 'N/A';

    final phone = patient.telecom
        ?.where((t) => t.system?.toString() == 'phone')
        .map((t) => t.value)
        .firstOrNull;

    final address = patient.address?.isNotEmpty == true
        ? [
            patient.address!.first.line?.join(', '),
            patient.address!.first.city,
            patient.address!.first.state,
          ].where((e) => e != null && e.isNotEmpty).join(', ')
        : null;

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            name,
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _infoChip('DOB', birthDate),
              pw.SizedBox(width: 24),
              _infoChip('Gender', gender),
              pw.SizedBox(width: 24),
              _infoChip('ID', identifier),
            ],
          ),
          if (phone != null) ...[
            pw.SizedBox(height: 4),
            _infoChip('Phone', phone),
          ],
          if (address != null && address.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            _infoChip('Address', address),
          ],
        ],
      ),
    );
  }

  pw.Widget _infoChip(String label, String value) {
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$label: ',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
          pw.TextSpan(
            text: value,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey900),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.only(bottom: 4),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue800,
        ),
      ),
    );
  }

  pw.Widget _buildVitalsTable(List<fhir.Observation> vitals) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      headers: ['Measurement', 'Value', 'Unit', 'Date'],
      data: vitals.map((obs) {
        final display = obs.code.coding?.first.display ?? obs.code.text ?? 'Unknown';
        final value = obs.valueQuantity?.value?.value?.toString() ?? _extractBPValue(obs);
        final unit = obs.valueQuantity?.unit ?? '';
        final date = obs.effectiveDateTime?.value != null
            ? _formatDate(obs.effectiveDateTime!.value)
            : 'N/A';
        return [display, value, unit, date];
      }).toList(),
    );
  }

  String _extractBPValue(fhir.Observation obs) {
    final components = obs.component;
    if (components == null || components.isEmpty) return 'N/A';

    String systolic = '--';
    String diastolic = '--';
    for (final comp in components) {
      final code = comp.code.coding?.first.code?.value;
      final val = comp.valueQuantity?.value?.value;
      if (val == null) continue;
      final display = val == val.roundToDouble()
          ? val.toInt().toString()
          : val.toString();
      if (code == '8480-6') systolic = display;
      if (code == '8462-4') diastolic = display;
    }
    return '$systolic/$diastolic';
  }

  pw.Widget _buildLabsSection(List<fhir.DiagnosticReport> labs) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: labs.map((report) {
        final name = report.code.coding?.first.display ??
            report.code.text ??
            'Lab Report';
        final status = report.status?.value ?? 'unknown';
        final date = report.effectiveDateTime?.value != null
            ? _formatDate(report.effectiveDateTime!.value)
            : 'N/A';
        final conclusion = report.conclusion;

        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 8),
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(name,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.Text('$status • $date',
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColors.grey600)),
                ],
              ),
              if (conclusion != null) ...[
                pw.SizedBox(height: 4),
                pw.Text(conclusion,
                    style:
                        const pw.TextStyle(fontSize: 9, color: PdfColors.grey800)),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildMedicationsTable(List<fhir.MedicationRequest> medications) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      headers: ['Medication', 'Dosage', 'Status'],
      data: medications.map((med) {
        final name = med.medicationCodeableConcept?.coding?.first.display ??
            med.medicationCodeableConcept?.text ??
            'Unknown';
        final dosage = med.dosageInstruction?.isNotEmpty == true
            ? med.dosageInstruction!.first.text ?? 'N/A'
            : 'N/A';
        final status = med.status?.value ?? 'unknown';
        return [name, dosage, status];
      }).toList(),
    );
  }

  pw.Widget _buildAllergiesSection(List<fhir.AllergyIntolerance> allergies) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: allergies.map((allergy) {
        final name = allergy.code?.coding?.first.display ??
            allergy.code?.text ??
            'Unknown Allergen';
        final severity = allergy.criticality?.value ?? 'unknown';
        final reactions = allergy.reaction
                ?.map((r) =>
                    r.manifestation.map((m) => m.text ?? m.coding?.first.display ?? '').join(', '))
                .join('; ') ??
            'N/A';

        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 6,
                height: 6,
                margin: const pw.EdgeInsets.only(top: 3, right: 6),
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  color: severity == 'high'
                      ? PdfColors.red
                      : severity == 'low'
                          ? PdfColors.amber
                          : PdfColors.grey,
                ),
              ),
              pw.Expanded(
                child: pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: name,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.TextSpan(
                        text: ' ($severity) — $reactions',
                        style: const pw.TextStyle(
                            fontSize: 9, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildImmunizationsTable(List<fhir.Immunization> immunizations) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      headers: ['Vaccine', 'Date', 'Status'],
      data: immunizations.map((imm) {
        final name = imm.vaccineCode.coding?.first.display ??
            imm.vaccineCode.text ??
            'Unknown';
        final date = imm.occurrenceDateTime?.value != null
            ? _formatDate(imm.occurrenceDateTime!.value)
            : 'N/A';
        final status = imm.status.toString();
        return [name, date, status];
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
}

final pdfReportServiceProvider = Provider<PdfReportService>((ref) {
  return PdfReportService();
});
