class FirestoreConstants {
  FirestoreConstants._();

  // Collections
  static const String users = 'users';
  static const String hydrationLogs = 'hydration_logs';
  static const String reminders = 'reminders';
  static const String achievements = 'achievements';

  // User document fields
  static const String userId = 'user_id';
  static const String email = 'email';
  static const String displayName = 'display_name';
  static const String photoUrl = 'photo_url';
  static const String weightKg = 'weight_kg';
  static const String dailyWaterGoalMl = 'daily_water_goal_ml';
  static const String isPremium = 'is_premium';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String fcmToken = 'fcm_token';
  static const String age = 'age';
  static const String hydrationObjective = 'hydration_objective';
  static const String activityLevel = 'activity_level';
  static const String climate = 'climate';

  // Hydration log fields
  static const String logId = 'log_id';
  static const String amountMl = 'amount_ml';
  static const String timestamp = 'timestamp';
  static const String note = 'note';
  static const String drinkType = 'drink_type';

  // Reminder fields
  static const String reminderId = 'reminder_id';
  static const String intervalMinutes = 'interval_minutes';
  static const String enabled = 'enabled';
  static const String startHour = 'start_hour';
  static const String endHour = 'end_hour';
  static const String days = 'days';

  // Achievement fields
  static const String achievementId = 'achievement_id';
  static const String streakDays = 'streak_days';
  static const String longestStreak = 'longest_streak';
  static const String totalGoalsCompleted = 'total_goals_completed';
  static const String totalWaterMl = 'total_water_ml';
  static const String milestones = 'milestones';
  static const String unlockedAt = 'unlocked_at';
}

