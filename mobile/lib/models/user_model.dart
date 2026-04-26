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
    required this.age,
    required this.hydrationObjective,
    required this.activityLevel,
    required this.isHotClimate,
  });

  factory UserModel.fromMap(Map<dynamic, dynamic> data) {
    return UserModel(
      userId: data['userId'] as String? ?? 'local_user',
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'User',
      photoUrl: data['photoUrl'] as String?,
      weightKg: (data['weightKg'] as num?)?.toDouble() ?? 70.0,
      dailyWaterGoalMl: data['dailyWaterGoalMl'] as int? ?? 2000,
      isPremium: data['isPremium'] as bool? ?? false,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : DateTime.now(),
      age: data['age'] as int? ?? 25,
      hydrationObjective: data['hydrationObjective'] as String? ?? 'general',
      activityLevel: data['activityLevel'] as String? ?? 'moderate',
      isHotClimate: data['climate'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'weightKg': weightKg,
      'dailyWaterGoalMl': dailyWaterGoalMl,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'age': age,
      'hydrationObjective': hydrationObjective,
      'activityLevel': activityLevel,
      'climate': isHotClimate,
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
