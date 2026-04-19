import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firestore_constants.dart';

class UserModel {
  final String userId;
  final String email;
  final String displayName;
  final String? photoUrl;
  final double weightKg;
  final int dailyWaterGoalMl;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? fcmToken;
  final int age;
  final String hydrationObjective;
  final String activityLevel;
  final bool isHotClimate;

  const UserModel({
    required this.userId,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.weightKg,
    required this.dailyWaterGoalMl,
    this.isPremium = false,
    required this.createdAt,
    required this.updatedAt,
    this.fcmToken,
    required this.age,
    required this.hydrationObjective,
    required this.activityLevel,
    required this.isHotClimate,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: data[FirestoreConstants.userId] as String? ?? doc.id,
      email: data[FirestoreConstants.email] as String? ?? '',
      displayName: data[FirestoreConstants.displayName] as String? ?? 'User',
      photoUrl: data[FirestoreConstants.photoUrl] as String?,
      weightKg: (data[FirestoreConstants.weightKg] as num?)?.toDouble() ?? 70.0,
      dailyWaterGoalMl: data[FirestoreConstants.dailyWaterGoalMl] as int? ?? 2000,
      isPremium: data[FirestoreConstants.isPremium] as bool? ?? false,
      createdAt: (data[FirestoreConstants.createdAt] as Timestamp?)?.toDate() ??
          DateTime.now(),
      updatedAt: (data[FirestoreConstants.updatedAt] as Timestamp?)?.toDate() ??
          DateTime.now(),
      fcmToken: data[FirestoreConstants.fcmToken] as String?,
      age: data[FirestoreConstants.age] as int? ?? 25,
      hydrationObjective: data[FirestoreConstants.hydrationObjective] as String? ?? 'general',
      activityLevel: data[FirestoreConstants.activityLevel] as String? ?? 'moderate',
      isHotClimate: data[FirestoreConstants.climate] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirestoreConstants.userId: userId,
      FirestoreConstants.email: email,
      FirestoreConstants.displayName: displayName,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.weightKg: weightKg,
      FirestoreConstants.dailyWaterGoalMl: dailyWaterGoalMl,
      FirestoreConstants.isPremium: isPremium,
      FirestoreConstants.createdAt: Timestamp.fromDate(createdAt),
      FirestoreConstants.updatedAt: Timestamp.fromDate(updatedAt),
      FirestoreConstants.fcmToken: fcmToken,
      FirestoreConstants.age: age,
      FirestoreConstants.hydrationObjective: hydrationObjective,
      FirestoreConstants.activityLevel: activityLevel,
      FirestoreConstants.climate: isHotClimate,
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? displayName,
    String? photoUrl,
    double? weightKg,
    int? dailyWaterGoalMl,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fcmToken,
    int? age,
    String? hydrationObjective,
    String? activityLevel,
    bool? isHotClimate,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      weightKg: weightKg ?? this.weightKg,
      dailyWaterGoalMl: dailyWaterGoalMl ?? this.dailyWaterGoalMl,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fcmToken: fcmToken ?? this.fcmToken,
      age: age ?? this.age,
      hydrationObjective: hydrationObjective ?? this.hydrationObjective,
      activityLevel: activityLevel ?? this.activityLevel,
      isHotClimate: isHotClimate ?? this.isHotClimate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

