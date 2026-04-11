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
    await _updateUserStats(log.amountMl);
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

  Future<void> _updateUserStats(int amountAddedMl) async {
     // Transactional update would be better here for production
     final docRef = _firestore.collection(FirestoreConstants.users).doc(_uid).collection(FirestoreConstants.achievements).doc('stats');
     
     return _firestore.runTransaction((transaction) async {
       final doc = await transaction.get(docRef);
       if (!doc.exists) {
         final initialAchievement = AchievementModel(
           userId: _uid,
           totalWaterMl: amountAddedMl,
         );
         transaction.set(docRef, initialAchievement.toFirestore());
       } else {
         final currentData = AchievementModel.fromFirestore(doc);
         transaction.update(docRef, {
           FirestoreConstants.totalWaterMl: currentData.totalWaterMl + amountAddedMl,
         });
       }
     });
  }
}
