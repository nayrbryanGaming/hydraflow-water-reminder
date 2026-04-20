import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hydration_log.dart';


final hydrationStatsProvider = Provider<HydrationStatsService>((ref) {
  return HydrationStatsService(ref);
});

class HydrationStatsService {
  final Ref _ref;
  HydrationStatsService(this._ref);

  /// Calculates the current daily streak of meeting hydration goals
  int calculateStreak(List<HydrationLog> allLogs, int dailyGoal) {
    if (allLogs.isEmpty) return 0;

    // Group logs by day for O(1) lookup
    final dailyTotals = <String, int>{};
    for (final log in allLogs) {
      final key = _getDateKey(log.timestamp);
      dailyTotals[key] = (dailyTotals[key] ?? 0) + log.amountMl;
    }

    int streak = 0;
    DateTime checkDate = DateTime.now();
    final String todayKey = _getDateKey(checkDate);

    // Safety limit: Don't look back more than 1000 days or past the oldest log
    final oldestLogDate = allLogs.map((e) => e.timestamp).reduce((a, b) => a.isBefore(b) ? a : b);
    
    while (checkDate.isAfter(oldestLogDate.subtract(const Duration(days: 1)))) {
      final key = _getDateKey(checkDate);
      final dailyTotal = dailyTotals[key] ?? 0;

      if (dailyTotal >= dailyGoal) {
        streak++;
      } else {
        // If it's today and goal not met yet, continue checking yesterday
        // but don't break the streak yet.
        if (key == todayKey) {
          // Progressing...
        } else {
          // Missed a day in the past, streak ends.
          break;
        }
      }
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Calculates hydration efficiency over the last 7 days
  double calculateEfficiency(List<HydrationLog> allLogs, int dailyGoal) {
    if (allLogs.isEmpty) return 0.0;

    final dailyTotals = <String, int>{};
    for (final log in allLogs) {
      final key = _getDateKey(log.timestamp);
      dailyTotals[key] = (dailyTotals[key] ?? 0) + log.amountMl;
    }

    int goalsMet = 0;
    for (int i = 0; i < 7; i++) {
      final checkDate = DateTime.now().subtract(Duration(days: i));
      final key = _getDateKey(checkDate);
      if ((dailyTotals[key] ?? 0) >= dailyGoal) {
        goalsMet++;
      }
    }

    return (goalsMet / 7) * 100;
  }

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Categorizes user into a Rank based on total consumption and consistency
  String calculateRank(int totalMl, int streak) {
    if (totalMl >= 500000 && streak >= 30) return 'Hydration God 🔱';
    if (totalMl >= 100000 && streak >= 14) return 'Aqua Elite 💎';
    if (totalMl >= 50000 && streak >= 7) return 'Consistent 🌊';
    if (totalMl >= 10000) return 'Habit Builder 🧊';
    return 'Beginner 🌱';
  }
}


