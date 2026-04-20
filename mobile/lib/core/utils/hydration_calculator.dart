import '../../core/constants/app_constants.dart';

class HydrationCalculator {
  HydrationCalculator._();

  /// Calculate daily water goal in mL based on weight, activity, climate, age, and objective
  /// Formula: ((Weight * WeightFactor) * AgeMultiplier) + ActivityLevelAdjustment + ClimateAdjustment + ObjectiveAdjustment
  /// Calculate daily water goal in mL based on physiological and environmental factors
  /// Formula is based on the 'Volumetric Fluid Requirement' model:
  /// Base = (Weight * Factor)
  /// Adjustment = Base * (ActivityIndex + ClimateIndex + HealthObjectiveIndex)
  static int calculateDailyGoal(
    double weightKg, {
    int age = 25,
    ActivityLevel activityLevel = ActivityLevel.moderate,
    bool isHotClimate = false,
    HydrationObjective objective = HydrationObjective.general,
  }) {
    // 1. Basal Metabolic Water Requirement (approx 35ml per kg for adults)
    // We adjust this slightly by age to account for changes in body composition/lean mass
    double ageFactor = 35.0;
    if (age > 60) ageFactor = 30.0;
    if (age < 18) ageFactor = 40.0;
    
    double baseGoal = weightKg * ageFactor;

    // 2. Metabolic Activity Overhead (MAO)
    // Physical exertion increases caloric burn and fluid loss proportional to base volume
    double activityMultiplier = 0.0;
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        activityMultiplier = 0.1; // Baseline metabolic maintenance
        break;
      case ActivityLevel.moderate:
        activityMultiplier = 0.25; // Light exercise/active commute
        break;
      case ActivityLevel.active:
        activityMultiplier = 0.45; // High intensity or long duration exertion
        break;
    }

    // 3. Environmental Transpiration Load (ETL)
    double climateMultiplier = isHotClimate ? 0.2 : 0.0;

    // 4. Goal-Oriented Precision Adjustment
    double objectiveMultiplier = 0.0;
    switch (objective) {
      case HydrationObjective.cognitive:
        objectiveMultiplier = 0.1; // Optimize for cerebral vascularity
        break;
      case HydrationObjective.energy:
        objectiveMultiplier = 0.15; // Mitigate fatigue-related dehydration
        break;
      case HydrationObjective.skin:
        objectiveMultiplier = 0.05; // Targeted skin turgor support
        break;
      case HydrationObjective.general:
        objectiveMultiplier = 0.0;
        break;
    }

    // Combined Calculation
    double finalGoal = baseGoal * (1 + activityMultiplier + climateMultiplier + objectiveMultiplier);

    // Safety Clamping: No less than 1200ml, no more than 6000ml (unless under medical advice)
    return finalGoal.round().clamp(1200, 6000);
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
  static String formatMl(int ml, {bool isMetric = true}) {
    if (!isMetric) {
      final oz = (ml / 29.5735).toStringAsFixed(1);
      return '${oz}oz';
    }
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

enum ActivityLevel {
  sedentary,
  moderate,
  active,
}

enum HydrationObjective {
  general,
  cognitive,
  skin,
  energy,
}


