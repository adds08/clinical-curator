import 'package:cc_fhir_models/models/encounter_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EncounterStatus state machine', () {
    test('planned → arrived is allowed', () {
      expect(
        EncounterStatus.planned.canTransitionTo(EncounterStatus.arrived),
        isTrue,
      );
    });

    test('planned → finished is rejected', () {
      expect(
        EncounterStatus.planned.canTransitionTo(EncounterStatus.finished),
        isFalse,
      );
    });

    test('inProgress → finished is allowed', () {
      expect(
        EncounterStatus.inProgress.canTransitionTo(EncounterStatus.finished),
        isTrue,
      );
    });

    test('finished is terminal', () {
      for (final next in EncounterStatus.values) {
        expect(
          EncounterStatus.finished.canTransitionTo(next),
          isFalse,
          reason: 'finished → ${next.code} should be rejected',
        );
      }
    });

    test('cancelled is terminal', () {
      for (final next in EncounterStatus.values) {
        expect(
          EncounterStatus.cancelled.canTransitionTo(next),
          isFalse,
        );
      }
    });

    test('any non-finished status can be cancelled', () {
      const nonTerminal = [
        EncounterStatus.planned,
        EncounterStatus.arrived,
        EncounterStatus.triaged,
        EncounterStatus.inProgress,
        EncounterStatus.onleave,
      ];
      for (final s in nonTerminal) {
        expect(
          s.canTransitionTo(EncounterStatus.cancelled),
          isTrue,
          reason: '${s.code} → cancelled should be allowed',
        );
      }
    });

    test('fromCode round-trips known FHIR codes', () {
      for (final s in EncounterStatus.values) {
        expect(EncounterStatus.fromCode(s.code), s);
      }
    });

    test('fromCode throws on unknown code', () {
      expect(
        () => EncounterStatus.fromCode('not-a-real-status'),
        throwsArgumentError,
      );
    });
  });
}
