import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hydration_log.dart';
import '../models/user_model.dart';
import '../models/achievement_model.dart';
import '../models/reminder_model.dart';
import '../core/constants/firestore_constants.dart';
import 'auth_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return FirestoreService(authService);
});

final dailyHydrationProvider = StreamProvider.family<List<HydrationLog>, DateTime>((ref, date) {
  final service = ref.watch(firestoreServiceProvider);
  return service.getDailyHydrationLogs(date);
});

final userStatsProvider = StreamProvider((ref) {
  final service = ref.watch(firestoreServiceProvider);
  return service.getUserStats();
});

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService;

  FirestoreService(this._authService);

  String get _uid {
    final user = _authService.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  // --- Hydration Logs ---
  
  Future<void> addHydrationLog(HydrationLog log) async {
    final logRef = _firestore
        .collection(FirestoreConstants.users)
        .doc(_uid)
        .collection(FirestoreConstants.hydrationLogs)
        .doc(log.logId);
    
    final logWithUser = log.copyWith(userId: _uid);
    await logRef.set(logWithUser.toFirestore());
    
    // Also trigger update stats
    await _updateUserStats(log.amountMl, logTimestamp: log.timestamp);
  }

  Stream<List<HydrationLog>> getDailyHydrationLogs(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    return _firestore
        .collection(FirestoreConstants.users)
        .doc(_uid)
        .collection(FirestoreConstants.hydrationLogs)
        .where(FirestoreConstants.timestamp, isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where(FirestoreConstants.timestamp, isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HydrationLog.fromFirestore(doc)).toList());
  }

  Stream<List<HydrationLog>> getDailyLogs(DateTime date) {
    return getDailyHydrationLogs(date);
  }

  Stream<List<HydrationLog>> getAllHydrationLogs() {
    return _firestore
        .collection(FirestoreConstants.users)
        .doc(_uid)
        .collection(FirestoreConstants.hydrationLogs)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HydrationLog.fromFirestore(doc)).toList());
  }

  // --- User Profile ---

  Stream<UserModel?> getUserProfile() {
    return _firestore
        .collection(FirestoreConstants.users)
        .doc(_uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  Future<void> updateUserGoal(int newGoalMl) async {
    await _firestore
        .collection(FirestoreConstants.users)
        .doc(_uid)
        .update({FirestoreConstants.dailyWaterGoalMl: newGoalMl});
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    await _firestore
        .collection(FirestoreConstants.users)
        .doc(_uid)
        .update(updatedUser.toFirestore());
  }

  // --- Reminders ---

  Future<void> updateReminders(ReminderModel reminder) async {
    await _firestore
        .collection(FirestoreConstants.users)
        .doc(_uid)
        .collection(FirestoreConstants.reminders)
        .doc(reminder.reminderId)
        .set(reminder.toFirestore());
  }

  // --- Achievements & Stats ---

  Future<void> _updateUserStats(int amountAddedMl, {DateTime? logTimestamp}) async {
    final userDocRef = _firestore.collection(FirestoreConstants.users).doc(_uid);
    final statsDocRef = userDocRef.collection(FirestoreConstants.achievements).doc('stats');
    
    final operationDate = logTimestamp ?? DateTime.now();
    final String targetDateKey = _getDateKey(operationDate);

    return _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userDocRef);
      if (!userDoc.exists) return;

      final userData = userDoc.data()!;
      final dailyGoal = userData[FirestoreConstants.dailyWaterGoalMl] as int? ?? 2000;

      // Get current stats
      final statsDoc = await transaction.get(statsDocRef);
      AchievementModel currentStats;
      
      if (!statsDoc.exists) {
        currentStats = AchievementModel(userId: _uid);
      } else {
        currentStats = AchievementModel.fromFirestore(statsDoc);
      }

      // Calculate total for the specific target date
      final logsSnapshot = await userDocRef.collection(FirestoreConstants.hydrationLogs)
          .where(FirestoreConstants.timestamp, isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(operationDate.year, operationDate.month, operationDate.day)))
          .where(FirestoreConstants.timestamp, isLessThan: Timestamp.fromDate(DateTime(operationDate.year, operationDate.month, operationDate.day).add(const Duration(days: 1))))
          .get();
      
      int dayTotal = 0;
      for (var doc in logsSnapshot.docs) {
        dayTotal += (doc.data()[FirestoreConstants.amountMl] as int? ?? 0);
      }

      int newStreak = currentStats.streakDays;
      int newLongestStreak = currentStats.longestStreak;
      int newTotalGoals = currentStats.totalGoalsCompleted;
      DateTime? newUnlockedAt = currentStats.unlockedAt;

      // Check if crossing the goal for the first time on THIS target date
      if (dayTotal >= dailyGoal && (dayTotal - amountAddedMl) < dailyGoal) {
        newTotalGoals++;
        
        final yesterdayKey = _getDateKey(operationDate.subtract(const Duration(days: 1)));
        final lastMetKey = currentStats.unlockedAt != null ? _getDateKey(currentStats.unlockedAt!) : null;

        if (lastMetKey == yesterdayKey) {
          newStreak++;
        } else if (lastMetKey == targetDateKey) {
          // Already counted for this specific day
        } else {
          newStreak = 1;
        }

        if (newStreak > newLongestStreak) {
          newLongestStreak = newStreak;
        }
        newUnlockedAt = operationDate;
      }

      final updatedStats = currentStats.copyWith(
        totalWaterMl: currentStats.totalWaterMl + amountAddedMl,
        streakDays: newStreak,
        longestStreak: newLongestStreak,
        totalGoalsCompleted: newTotalGoals,
        unlockedAt: newUnlockedAt,
      );

      transaction.set(statsDocRef, updatedStats.toFirestore());
    });
  }

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Stream<AchievementModel?> getUserStats() {
    return _firestore
        .collection(FirestoreConstants.users)
        .doc(_uid)
        .collection(FirestoreConstants.achievements)
        .doc('stats')
        .snapshots()
        .map((doc) => doc.exists ? AchievementModel.fromFirestore(doc) : null);
  }
}

