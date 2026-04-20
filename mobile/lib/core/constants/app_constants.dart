class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'HydraFlow';
  static const String appTagline = 'Smart hydration habit builder';
  static const String appVersion = '1.0.0';

  // Hydration Defaults
  static const int defaultDailyGoalMl = 2000;
  static const int minDailyGoalMl = 1000;
  static const int maxDailyGoalMl = 5000;
  static const double defaultWeightKg = 70.0;

  // Hydration Calculation
  // WHO recommendation: ~35ml per kg body weight
  static const double mlPerKg = 35.0;

  // Quick-add amounts (ml)
  static const List<int> quickAddAmounts = [150, 200, 250, 300, 350, 500];

  // Reminder intervals (minutes)
  static const List<int> reminderIntervals = [30, 45, 60, 90, 120];
  static const int defaultReminderInterval = 60;

  // Streak
  static const int streakResetHour = 0; // midnight

  // Achievement milestones
  static const List<int> streakMilestones = [3, 7, 14, 21, 30, 60, 90, 180, 365];
  static const List<int> goalMilestones = [1, 7, 14, 30, 50, 100, 200];

  // Hive box keys
  static const String prefsBox = 'hydraflow_prefs';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyUserWeight = 'user_weight';
  static const String keyDailyGoal = 'daily_goal';
  static const String keyReminderEnabled = 'reminder_enabled';
  static const String keyReminderInterval = 'reminder_interval';
  static const String keyLastLogDate = 'last_log_date';
  static const String keyCurrentStreak = 'current_streak';
  static const String keyLongestStreak = 'longest_streak';
  static const String keyIsPremium = 'is_premium';

  // Notification channel
  static const String notificationChannelId = 'hydraflow_reminders';
  static const String notificationChannelName = 'HydraFlow Reminders';
  static const String notificationChannelDesc =
      'Periodic reminders to drink water and stay hydrated.';

  // Premium
  static const double premiumPriceUsd = 2.0;
  static const String premiumProductId = 'hydraflow_premium_monthly';

  // Analytics events
  static const String eventWaterLogged = 'water_logged';
  static const String eventGoalCompleted = 'goal_completed';
  static const String eventStreakUpdated = 'streak_updated';
  static const String eventAchievementUnlocked = 'achievement_unlocked';
  static const String eventReminderToggled = 'reminder_toggled';
  static const String eventOnboardingCompleted = 'onboarding_completed';
}


