import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/firestore_constants.dart';

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

  factory AchievementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AchievementModel(
      achievementId: data[FirestoreConstants.achievementId] as String? ?? doc.id,
      userId: data[FirestoreConstants.userId] as String? ?? '',
      streakDays: data[FirestoreConstants.streakDays] as int? ?? 0,
      longestStreak: data[FirestoreConstants.longestStreak] as int? ?? 0,
      totalGoalsCompleted: data[FirestoreConstants.totalGoalsCompleted] as int? ?? 0,
      totalWaterMl: data[FirestoreConstants.totalWaterMl] as int? ?? 0,
      milestones: (data[FirestoreConstants.milestones] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      unlockedAt: (data[FirestoreConstants.unlockedAt] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirestoreConstants.achievementId: achievementId,
      FirestoreConstants.userId: userId,
      FirestoreConstants.streakDays: streakDays,
      FirestoreConstants.longestStreak: longestStreak,
      FirestoreConstants.totalGoalsCompleted: totalGoalsCompleted,
      FirestoreConstants.totalWaterMl: totalWaterMl,
      FirestoreConstants.milestones: milestones,
      FirestoreConstants.unlockedAt: Timestamp.fromDate(unlockedAt),
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


