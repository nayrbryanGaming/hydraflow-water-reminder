import '../../core/constants/app_constants.dart';

class HydrationCalculator {
  HydrationCalculator._();

  /// Calculate daily water goal in mL based on weight
  /// Formula: WHO recommendation ~35ml per kg body weight
  static int calculateDailyGoal(double weightKg) {
    final goal = (weightKg * AppConstants.mlPerKg).round();
    return goal.clamp(AppConstants.minDailyGoalMl, AppConstants.maxDailyGoalMl);
  }

  /// Calculate hydration percentage
  static double calculatePercentage(int consumedMl, int goalMl) {
    if (goalMl <= 0) return 0.0;
    return (consumedMl / goalMl).clamp(0.0, 1.0);
  }

  /// Get hydration status based on percentage
  static HydrationStatus getStatus(double percentage) {
    if (percentage >= 1.0) return HydrationStatus.excellent;
    if (percentage >= 0.7) return HydrationStatus.good;
    if (percentage >= 0.4) return HydrationStatus.medium;
    return HydrationStatus.low;
  }

  /// Get remaining water needed in mL
  static int getRemainingMl(int consumedMl, int goalMl) {
    final remaining = goalMl - consumedMl;
    return remaining.clamp(0, goalMl);
  }

  /// Format ml value for display (e.g., 1500 → "1.5L", 500 → "500ml")
  static String formatMl(int ml) {
    if (ml >= 1000) {
      final liters = ml / 1000;
      return '${liters.toStringAsFixed(liters.truncateToDouble() == liters ? 0 : 1)}L';
    }
    return '${ml}ml';
  }

  /// Get motivational message based on hydration status
  static String getMotivationalMessage(HydrationStatus status) {
    switch (status) {
      case HydrationStatus.low:
        return 'You need water! Start drinking now 💧';
      case HydrationStatus.medium:
        return 'Halfway there! Keep it up 🚀';
      case HydrationStatus.good:
        return 'Great progress! Almost at your goal ⚡';
      case HydrationStatus.excellent:
        return 'Goal achieved! You\'re fully hydrated 🎉';
    }
  }
}

enum HydrationStatus {
  low,
  medium,
  good,
  excellent,
}
