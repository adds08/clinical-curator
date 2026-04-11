import 'package:flutter_test/flutter_test.dart';
import 'package:clinical_curator/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('returns error for null', () {
        expect(Validators.validateEmail(null), isNotNull);
      });

      test('returns error for empty string', () {
        expect(Validators.validateEmail(''), isNotNull);
      });

      test('returns error for whitespace', () {
        expect(Validators.validateEmail('   '), isNotNull);
      });

      test('returns error for invalid email', () {
        expect(Validators.validateEmail('notanemail'), isNotNull);
        expect(Validators.validateEmail('no@'), isNotNull);
        expect(Validators.validateEmail('@no.com'), isNotNull);
      });

      test('returns null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name+tag@domain.co'), isNull);
      });
    });

    group('validatePassword', () {
      test('returns error for null', () {
        expect(Validators.validatePassword(null), isNotNull);
      });

      test('returns error for empty', () {
        expect(Validators.validatePassword(''), isNotNull);
      });

      test('returns error for short password', () {
        expect(Validators.validatePassword('abc1'), isNotNull);
      });

      test('returns error for no digit', () {
        expect(Validators.validatePassword('abcdefgh'), isNotNull);
      });

      test('returns null for valid password', () {
        expect(Validators.validatePassword('password1'), isNull);
        expect(Validators.validatePassword('SecurePass123'), isNull);
      });
    });

    group('validateName', () {
      test('returns error for null', () {
        expect(Validators.validateName(null), isNotNull);
      });

      test('returns error for empty', () {
        expect(Validators.validateName(''), isNotNull);
      });

      test('returns error for single character', () {
        expect(Validators.validateName('A'), isNotNull);
      });

      test('returns null for valid name', () {
        expect(Validators.validateName('Arjun'), isNull);
        expect(Validators.validateName('Dr. Priya Thapa'), isNull);
      });
    });

    group('validatePhone', () {
      test('returns error for null', () {
        expect(Validators.validatePhone(null), isNotNull);
      });

      test('returns error for empty', () {
        expect(Validators.validatePhone(''), isNotNull);
      });

      test('returns error for wrong length', () {
        expect(Validators.validatePhone('98412345'), isNotNull);
        expect(Validators.validatePhone('98412345678'), isNotNull);
      });

      test('returns error for number not starting with 9', () {
        expect(Validators.validatePhone('1234567890'), isNotNull);
      });

      test('returns null for valid Nepal number', () {
        expect(Validators.validatePhone('9841234567'), isNull);
      });

      test('strips non-digit characters', () {
        expect(Validators.validatePhone('984-123-4567'), isNull);
      });
    });

    group('validateLicenseNumber', () {
      test('returns error for null', () {
        expect(Validators.validateLicenseNumber(null), isNotNull);
      });

      test('returns error for empty', () {
        expect(Validators.validateLicenseNumber(''), isNotNull);
      });

      test('returns error for non-alphanumeric', () {
        expect(Validators.validateLicenseNumber('ABC-123'), isNotNull);
        expect(Validators.validateLicenseNumber('license@123'), isNotNull);
      });

      test('returns null for valid license', () {
        expect(Validators.validateLicenseNumber('NMC12345'), isNull);
        expect(Validators.validateLicenseNumber('ABC123'), isNull);
      });
    });
  });
}
