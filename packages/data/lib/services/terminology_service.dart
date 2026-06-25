/// Pure Dart terminology service providing ICD-10 and LOINC code lookups.
///
/// Contains built-in maps for common clinical diagnoses and lab tests.
/// All data is static and const — no Flutter dependency.
class TerminologyService {
  TerminologyService._();

  // ═══════════════════════════════════════════════════════════════════════════
  // ICD-10 codes
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, String> _icd10Map = {
    // ── Hypertension ──────────────────────────────────────────────────────
    'Hypertension': 'I10',
    'Hypertensive heart disease': 'I11.9',
    'Hypertensive chronic kidney disease': 'I12.9',
    'Hypertensive heart and chronic kidney disease': 'I13.10',
    'Malignant hypertension': 'I15.0',

    // ── Diabetes ──────────────────────────────────────────────────────────
    'Type 1 diabetes mellitus': 'E10.9',
    'Type 2 diabetes mellitus': 'E11.9',
    'Diabetes mellitus unspecified': 'E14.9',
    'Type 2 diabetes with neuropathy': 'E11.40',
    'Type 2 diabetes with retinopathy': 'E11.319',
    'Type 2 diabetes with renal complications': 'E11.21',
    'Type 2 diabetes with foot ulcer': 'E11.621',

    // ── Heart Disease ─────────────────────────────────────────────────────
    'Chronic ischemic heart disease': 'I25.9',
    'Acute myocardial infarction': 'I21.9',
    'Angina pectoris': 'I20.9',
    'Heart failure': 'I50.9',
    'Systolic (congestive) heart failure': 'I50.20',
    'Diastolic heart failure': 'I50.30',
    'Atrial fibrillation': 'I48.91',
    'Coronary atherosclerosis': 'I25.10',

    // ── COPD & Asthma ─────────────────────────────────────────────────────
    'COPD': 'J44.9',
    'Emphysema': 'J43.9',
    'Chronic bronchitis': 'J42',
    'Asthma': 'J45.909',
    'Asthma exacerbation': 'J45.901',

    // ── CKD ───────────────────────────────────────────────────────────────
    'Chronic kidney disease stage 3': 'N18.3',
    'Chronic kidney disease stage 4': 'N18.4',
    'Chronic kidney disease stage 5': 'N18.5',
    'End stage renal disease': 'N18.6',

    // ── Hyperlipidemia ────────────────────────────────────────────────────
    'Hyperlipidemia': 'E78.5',
    'Hypercholesterolemia': 'E78.00',
    'Hypertriglyceridemia': 'E78.1',
    'Mixed hyperlipidemia': 'E78.2',

    // ── Musculoskeletal & Pain ────────────────────────────────────────────
    'Low back pain': 'M54.5',
    'Sciatica': 'M54.30',
    'Osteoarthritis of knee': 'M17.9',
    'Osteoarthritis of hip': 'M16.9',
    'Osteoarthritis generalized': 'M15.9',
    'Migraine unspecified': 'G43.909',
    'Migraine with aura': 'G43.109',
    'Tension headache': 'G44.209',
    'Headache unspecified': 'R51',
    'Gout': 'M10.9',
    'Gout left foot': 'M10.072',
    'Cervicalgia': 'M54.2',

    // ── Infections ────────────────────────────────────────────────────────
    'Pneumonia unspecified organism': 'J18.9',
    'Lobar pneumonia': 'J18.1',
    'Bronchitis acute': 'J20.9',
    'Acute sinusitis': 'J01.90',
    'Chronic sinusitis': 'J32.9',
    'Acute pharyngitis': 'J02.9',
    'Strep throat': 'J02.0',
    'Acute tonsillitis': 'J03.90',
    'Urinary tract infection': 'N39.0',
    'Acute cystitis': 'N30.00',
    'Cellulitis unspecified': 'L03.90',
    'Cellulitis of leg': 'L03.116',
    'Conjunctivitis': 'H10.9',
    'Allergic conjunctivitis': 'H10.45',
    'Acute otitis media': 'H66.90',
    'Serous otitis media': 'H65.20',
    'Allergic rhinitis': 'J30.9',

    // ── GI ────────────────────────────────────────────────────────────────
    'GERD': 'K21.9',
    'GERD with esophagitis': 'K21.0',
    'Abdominal pain unspecified': 'R10.9',
    'Abdominal pain right upper quadrant': 'R10.11',
    'Abdominal pain left lower quadrant': 'R10.32',
    'Acute gastroenteritis': 'K52.9',
    'Constipation': 'K59.00',
    'Irritable bowel syndrome': 'K58.9',

    // ── Endocrine ─────────────────────────────────────────────────────────
    'Hypothyroidism': 'E03.9',
    'Hashimoto thyroiditis': 'E06.3',
    'Hyperthyroidism': 'E05.90',

    // ── Hematologic ───────────────────────────────────────────────────────
    'Anemia unspecified': 'D64.9',
    'Iron deficiency anemia': 'D50.9',
    'Vitamin B12 deficiency anemia': 'D51.0',
    'Anemia of chronic disease': 'D63.8',

    // ── Mental Health ─────────────────────────────────────────────────────
    'Generalized anxiety disorder': 'F41.1',
    'Panic disorder': 'F41.0',
    'Major depressive disorder recurrent': 'F33.9',
    'Major depressive disorder single episode': 'F32.9',
    'Depression unspecified': 'F32.A',
    'Bipolar disorder': 'F31.9',

    // ── Other ─────────────────────────────────────────────────────────────
    'Dehydration': 'E86.0',
    'Hypokalemia': 'E87.6',
    'Hyperkalemia': 'E87.5',
    'Hyponatremia': 'E87.1',
    'Acute kidney injury': 'N17.9',
    'Obesity': 'E66.9',
    'Vitamin D deficiency': 'E55.9',
    'Syncope': 'R55',
    'Fever unspecified': 'R50.9',
    'Cough unspecified': 'R05',
    'Dysuria': 'R30.0',
    'Chest pain unspecified': 'R07.9',
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // LOINC codes
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, String> _loincMap = {
    // ── Basic Chemistry / Metabolic ───────────────────────────────────────
    'Basic Metabolic Panel': '24326-1',
    'Comprehensive Metabolic Panel': '24323-8',
    'Sodium': '2951-2',
    'Potassium': '2823-3',
    'Chloride': '2075-0',
    'Carbon dioxide': '2028-9',
    'BUN': '3094-0',
    'Creatinine': '14682-9',
    'eGFR': '62238-1',
    'Glucose': '2345-7',
    'Fasting glucose': '1558-6',
    'Calcium': '17861-6',
    'Ionized calcium': '1992-5',
    'Albumin': '1751-7',
    'Total Protein': '2885-2',
    'Globulin': '2862-1',
    'Anion gap': '33037-3',
    'Osmolality': '2931-1',

    // ── Lipid Panel ───────────────────────────────────────────────────────
    'Lipid Panel': '57698-2',
    'Total Cholesterol': '2093-3',
    'HDL Cholesterol': '2085-9',
    'LDL Cholesterol': '18262-6',
    'Triglycerides': '2571-8',
    'Non-HDL Cholesterol': '43396-1',
    'VLDL': '2089-1',

    // ── Liver Function ────────────────────────────────────────────────────
    'Liver Function Panel': '24320-4',
    'ALT': '1742-6',
    'AST': '1920-8',
    'Alkaline Phosphatase': '6768-6',
    'GGT': '2324-2',
    'Total Bilirubin': '1975-2',
    'Direct Bilirubin': '1968-7',
    'Indirect Bilirubin': '1971-1',
    'LDH': '14804-9',

    // ── Hematology ────────────────────────────────────────────────────────
    'CBC': '58410-2',
    'CBC with Differential': '57021-8',
    'Hemoglobin': '718-7',
    'Hematocrit': '4544-3',
    'Red Blood Cell Count': '789-8',
    'MCV': '787-2',
    'MCH': '785-6',
    'MCHC': '786-4',
    'RDW': '788-0',
    'Platelet Count': '777-3',
    'White Blood Cell Count': '6690-2',
    'Neutrophils': '751-8',
    'Lymphocytes': '731-0',
    'Monocytes': '742-7',
    'Eosinophils': '711-2',
    'Basophils': '704-7',

    // ── Diabetes ──────────────────────────────────────────────────────────
    'HbA1c': '4548-4',
    'HbA1c (IFCC)': '71875-1',
    'Fructosamine': '15069-5',
    'Insulin': '20448-7',
    'C-peptide': '4547-6',

    // ── Thyroid ───────────────────────────────────────────────────────────
    'TSH': '3016-3',
    'Free T4': '3024-7',
    'Total T4': '3025-4',
    'Free T3': '3051-0',
    'Total T3': '3050-2',
    'T3 Uptake': '3049-4',
    'Thyroglobulin': '29835-4',
    'Anti-TPO': '8099-1',

    // ── Inflammatory Markers ──────────────────────────────────────────────
    'CRP': '1988-5',
    'High Sensitivity CRP': '30522-7',
    'ESR': '4537-7',
    'Ferritin': '2276-4',
    'Procalcitonin': '33862-6',

    // ── Iron Studies ──────────────────────────────────────────────────────
    'Iron': '2498-4',
    'TIBC': '2500-7',
    'Transferrin': '30200-5',
    'Transferrin Saturation': '30350-8',

    // ── Vitamins & Nutrients ──────────────────────────────────────────────
    'Vitamin D': '35365-6',
    'Vitamin D 25-Hydroxy': '62292-8',
    'Vitamin D 1,25-Dihydroxy': '18203-0',
    'Vitamin B12': '2132-9',
    'Folate': '2284-8',
    'Vitamin A': '743-6',
    'Vitamin E': '20644-7',
    'Magnesium': '19123-9',
    'Phosphorus': '2777-1',

    // ── Urinalysis ────────────────────────────────────────────────────────
    'Urinalysis': '24356-8',
    'Urinalysis with Microscopic': '5802-2',
    'Urine pH': '5803-0',
    'Urine Specific Gravity': '5811-3',
    'Urine Glucose': '5792-5',
    'Urine Protein': '2888-6',
    'Urine Ketones': '5779-2',
    'Urine Bilirubin': '5770-1',
    'Urine Blood': '5794-1',
    'Urine Leukocyte Esterase': '5799-0',
    'Urine Nitrite': '5801-4',
    'Urine Sediment': '33356-3',
    'Microalbumin': '14959-1',

    // ── Coagulation ───────────────────────────────────────────────────────
    'PT/INR': '5964-2',
    'Prothrombin Time': '5964-2',
    'aPTT': '14979-9',
    'Fibrinogen': '3255-7',
    'D-dimer': '48066-5',
    'D-dimer Quantitative': '48065-7',

    // ── Cardiac ───────────────────────────────────────────────────────────
    'Troponin I': '10839-9',
    'Troponin T': '6598-7',
    'High Sensitivity Troponin': '89579-7',
    'BNP': '42636-1',
    'NT-proBNP': '33762-8',
    'CK-MB': '20448-7',
    'Myoglobin': '5378-6',
    'Homocysteine': '13965-1',
    'Lp(a)': '14519-3',

    // ── Endocrinology ─────────────────────────────────────────────────────
    'Cortisol': '2140-2',
    'Cortisol AM': '2141-0',
    'Cortisol PM': '2142-8',
    'Testosterone': '2986-6',
    'Free Testosterone': '2991-6',
    'Estradiol': '2242-6',
    'Progesterone': '2841-5',
    'Prolactin': '2842-3',
    'LH': '2354-9',
    'FSH': '15068-7',
    'DHEA-S': '2190-7',
    'Aldosterone': '1873-0',
    'Renin': '18234-5',
    'Parathyroid Hormone': '2731-8',
    'Vitamin D 1,25 Dihydroxy': '18203-0',

    // ── Infectious Disease ────────────────────────────────────────────────
    'SARS-CoV-2 PCR': '94531-1',
    'SARS-CoV-2 Antigen': '95209-3',
    'Influenza A PCR': '68964-7',
    'Influenza B PCR': '68965-4',
    'RSV PCR': '68967-0',
    'HIV 1/2 Antibody': '31204-4',
    'HBsAg': '5195-3',
    'HCV Antibody': '48160-6',
    'VDRL': '20484-6',
    'RPR': '20507-3',
    'TPHA': '24100-0',
    'ASO Titer': '2081-8',
    'Monospot': '14413-9',
    'Urine Culture': '630-4',
    'Blood Culture': '600-7',
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Public API
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns the full ICD-10 code map (display name → code).
  static Map<String, String> get icd10Map => Map.unmodifiable(_icd10Map);

  /// Returns the full LOINC code map (display name → code).
  static Map<String, String> get loincMap => Map.unmodifiable(_loincMap);

  /// Searches built-in ICD-10 codes by [query] (case-insensitive).
  ///
  /// Returns a list of `(displayName, code)` tuples sorted alphabetically by
  /// display name. Matches against display name only.
  static List<(String displayName, String code)> searchICD10(String query) {
    if (query.trim().isEmpty) return [];

    final lower = query.toLowerCase();
    final results = <(String, String)>[];

    for (final entry in _icd10Map.entries) {
      if (entry.key.toLowerCase().contains(lower)) {
        results.add((entry.key, entry.value));
      }
    }

    results.sort((a, b) => a.$1.compareTo(b.$1));
    return results;
  }

  /// Looks up an ICD-10 code by an exact (case-insensitive) display name.
  ///
  /// Returns the ICD-10 code string, or `null` if not found.
  static String? getIcd10Code(String displayName) {
    for (final entry in _icd10Map.entries) {
      if (entry.key.toLowerCase() == displayName.toLowerCase()) {
        return entry.value;
      }
    }
    return null;
  }

  /// Looks up a LOINC code by an exact (case-insensitive) display name.
  ///
  /// Returns the LOINC code string, or `null` if not found.
  static String? getLoincCode(String displayName) {
    for (final entry in _loincMap.entries) {
      if (entry.key.toLowerCase() == displayName.toLowerCase()) {
        return entry.value;
      }
    }
    return null;
  }
}
