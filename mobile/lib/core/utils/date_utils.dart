import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDate(DateTime date) =>
      DateFormat('MMM d, yyyy').format(date);

  static String formatTime(DateTime date) =>
      DateFormat('h:mm a').format(date);

  static String formatDateShort(DateTime date) =>
      DateFormat('MMM d').format(date);

  static String formatWeekday(DateTime date) =>
      DateFormat('EEE').format(date);

  static String formatMonthYear(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  static List<DateTime> getLast7Days() {
    final today = DateTime.now();
    return List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
  }

  static List<DateTime> getLast30Days() {
    final today = DateTime.now();
    return List.generate(30, (i) => today.subtract(Duration(days: 29 - i)));
  }

  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return formatDate(date);
  }

  /// Returns greeting based on current hour
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
