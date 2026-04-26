import 'package:uuid/uuid.dart';

class AchievementModel {
  final String achievementId;
  final String userId;
  final int streakDays;
  final int longestStreak;
  final int totalGoalsCompleted;
  final int totalWaterMl;
  final List<int> milestones;
  final DateTime unlockedAt;

  AchievementModel({
    String? achievementId,
    required this.userId,
    this.streakDays = 0,
    this.longestStreak = 0,
    this.totalGoalsCompleted = 0,
    this.totalWaterMl = 0,
    List<int>? milestones,
    DateTime? unlockedAt,
  })  : achievementId = achievementId ?? const Uuid().v4(),
        milestones = milestones ?? [],
        unlockedAt = unlockedAt ?? DateTime.now();

  factory AchievementModel.fromMap(Map<dynamic, dynamic> data) {
    return AchievementModel(
      achievementId: data['achievementId'] as String? ?? const Uuid().v4(),
      userId: data['userId'] as String? ?? '',
      streakDays: data['streakDays'] as int? ?? 0,
      longestStreak: data['longestStreak'] as int? ?? 0,
      totalGoalsCompleted: data['totalGoalsCompleted'] as int? ?? 0,
      totalWaterMl: data['totalWaterMl'] as int? ?? 0,
      milestones: (data['milestones'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      unlockedAt: data['unlockedAt'] != null ? DateTime.parse(data['unlockedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'achievementId': achievementId,
      'userId': userId,
      'streakDays': streakDays,
      'longestStreak': longestStreak,
      'totalGoalsCompleted': totalGoalsCompleted,
      'totalWaterMl': totalWaterMl,
      'milestones': milestones,
      'unlockedAt': unlockedAt.toIso8601String(),
    };
  }

  AchievementModel copyWith({
    String? achievementId,
    String? userId,
    int? streakDays,
    int? longestStreak,
    int? totalGoalsCompleted,
    int? totalWaterMl,
    List<int>? milestones,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      achievementId: achievementId ?? this.achievementId,
      userId: userId ?? this.userId,
      streakDays: streakDays ?? this.streakDays,
      longestStreak: longestStreak ?? this.longestStreak,
      totalGoalsCompleted: totalGoalsCompleted ?? this.totalGoalsCompleted,
      totalWaterMl: totalWaterMl ?? this.totalWaterMl,
      milestones: milestones ?? this.milestones,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
