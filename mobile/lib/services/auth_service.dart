import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class LocalUser {
  final String uid;
  final String? email;
  final String? displayName;
  LocalUser({required this.uid, this.email, this.displayName});
}

class AuthService {
  static const String _userBoxName = 'hydraflow_user';

  LocalUser? get currentUser {
    if (!Hive.isBoxOpen(_userBoxName)) return null;
    final box = Hive.box(_userBoxName);
    final data = box.get('profile');
    if (data != null) {
      final user = UserModel.fromMap(Map<String, dynamic>.from(data));
      return LocalUser(uid: user.userId, email: user.email, displayName: user.displayName);
    }
    return null;
  }

  Future<void> registerLocally({
    required String displayName,
    required String email,
    required double weightKg,
    required int dailyGoalMl,
    required int age,
    required String activityLevel,
    required String hydrationObjective,
    required bool isHotClimate,
  }) async {
    final box = Hive.box(_userBoxName);
    final user = UserModel(
      userId: 'local_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
      weightKg: weightKg,
      dailyWaterGoalMl: dailyGoalMl,
      age: age,
      activityLevel: activityLevel,
      hydrationObjective: hydrationObjective,
      isHotClimate: isHotClimate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await box.put('profile', user.toMap());
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // Mock sign in for offline app
    return;
  }
  
  Future<void> signOut() async {
    // In local-only, we might just want to clear the profile
    final box = Hive.box(_userBoxName);
    await box.delete('profile');
  }

  Future<void> deleteUserAccount() async {
    final box = Hive.box(_userBoxName);
    await box.clear();
    await Hive.box('hydraflow_logs').clear();
    await Hive.box('hydraflow_stats').clear();
  }
}
