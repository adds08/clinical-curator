import 'package:flutter_test/flutter_test.dart';
import 'package:clinical_curator/core/utils/date_formatters.dart';

void main() {
  group('DateFormatters', () {
    group('formatShortDate', () {
      test('formats date correctly', () {
        final date = DateTime(2026, 3, 27);
        expect(DateFormatters.formatShortDate(date), 'Mar 27, 2026');
      });

      test('pads single digit days', () {
        final date = DateTime(2026, 1, 5);
        expect(DateFormatters.formatShortDate(date), 'Jan 05, 2026');
      });

      test('handles December', () {
        final date = DateTime(2025, 12, 25);
        expect(DateFormatters.formatShortDate(date), 'Dec 25, 2025');
      });
    });

    group('formatFullDate', () {
      test('formats full month name', () {
        final date = DateTime(2026, 3, 27);
        expect(DateFormatters.formatFullDate(date), 'March 27, 2026');
      });

      test('handles January', () {
        final date = DateTime(2026, 1, 1);
        expect(DateFormatters.formatFullDate(date), 'January 1, 2026');
      });
    });

    group('formatTime', () {
      test('formats AM time', () {
        final date = DateTime(2026, 1, 1, 10, 30);
        expect(DateFormatters.formatTime(date), '10:30 AM');
      });

      test('formats PM time', () {
        final date = DateTime(2026, 1, 1, 14, 15);
        expect(DateFormatters.formatTime(date), '2:15 PM');
      });

      test('handles midnight as 12 AM', () {
        final date = DateTime(2026, 1, 1, 0, 0);
        expect(DateFormatters.formatTime(date), '12:00 AM');
      });

      test('handles noon as 12 PM', () {
        final date = DateTime(2026, 1, 1, 12, 0);
        expect(DateFormatters.formatTime(date), '12:00 PM');
      });

      test('pads single digit minutes', () {
        final date = DateTime(2026, 1, 1, 9, 5);
        expect(DateFormatters.formatTime(date), '9:05 AM');
      });
    });

    group('formatTimeAgo', () {
      test('returns Just now for very recent', () {
        final date = DateTime.now().subtract(const Duration(seconds: 30));
        expect(DateFormatters.formatTimeAgo(date), 'Just now');
      });

      test('returns minutes ago', () {
        final date = DateTime.now().subtract(const Duration(minutes: 5));
        expect(DateFormatters.formatTimeAgo(date), '5m ago');
      });

      test('returns hours ago', () {
        final date = DateTime.now().subtract(const Duration(hours: 3));
        expect(DateFormatters.formatTimeAgo(date), '3h ago');
      });

      test('returns Yesterday', () {
        final date = DateTime.now().subtract(const Duration(days: 1));
        expect(DateFormatters.formatTimeAgo(date), 'Yesterday');
      });

      test('returns days ago for recent past', () {
        final date = DateTime.now().subtract(const Duration(days: 4));
        expect(DateFormatters.formatTimeAgo(date), '4d ago');
      });

      test('returns formatted date for older dates', () {
        final date = DateTime.now().subtract(const Duration(days: 30));
        final result = DateFormatters.formatTimeAgo(date);
        // Should be a formatted date string (e.g., "Feb 25, 2026")
        expect(result, isNot('Yesterday'));
        expect(result, contains(','));
      });

      test('returns formatted date for future dates', () {
        final date = DateTime.now().add(const Duration(days: 5));
        final result = DateFormatters.formatTimeAgo(date);
        expect(result, contains(','));
      });
    });
  });
}
