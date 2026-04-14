class DateFormatters {
  DateFormatters._();

  static const _monthsShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const _monthsFull = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  /// Formats a date as a short string, e.g. "Mar 27, 2026".
  static String formatShortDate(DateTime date) {
    final month = _monthsShort[date.month - 1];
    final day = date.day.toString().padLeft(2, '0');
    return '$month $day, ${date.year}';
  }

  /// Returns a human-friendly relative time string.
  ///
  /// Examples: "Just now", "2m ago", "3h ago", "Yesterday", "Mar 25, 2026".
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.isNegative) {
      return formatShortDate(date);
    }

    if (diff.inSeconds < 60) {
      return 'Just now';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays == 1) {
      return 'Yesterday';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }

    return formatShortDate(date);
  }

  /// Formats a time as "10:30 AM" / "02:15 PM".
  static String formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;
    return '$displayHour:$minute $period';
  }

  /// Formats a date as a full string, e.g. "March 27, 2026".
  static String formatFullDate(DateTime date) {
    final month = _monthsFull[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }
}
