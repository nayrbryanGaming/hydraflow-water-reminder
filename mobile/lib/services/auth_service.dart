import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../core/constants/firestore_constants.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(firebaseAuthProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthService(this._auth);

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required double weightKg,
    required int dailyGoalMl,
    required int age,
    required String hydrationObjective,
    required String activityLevel,
    required bool isHotClimate,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user != null) {
      final userModel = UserModel(
        userId: user.uid,
        email: email,
        displayName: displayName,
        weightKg: weightKg,
        dailyWaterGoalMl: dailyGoalMl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        age: age,
        hydrationObjective: hydrationObjective,
        activityLevel: activityLevel,
        isHotClimate: isHotClimate,
      );

      await _firestore
          .collection(FirestoreConstants.users)
          .doc(user.uid)
          .set(userModel.toFirestore());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> reauthenticate(String email, String password) async {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    }
  }

  Future<void> deleteUserAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      final userDoc = _firestore.collection(FirestoreConstants.users).doc(uid);

      // Recursive deletion of known subcollections for compliance
      final subcollections = [
        FirestoreConstants.hydrationLogs,
        FirestoreConstants.reminders,
        FirestoreConstants.achievements,
      ];

      for (final sub in subcollections) {
        final collectionRef = userDoc.collection(sub);
        final snippets = await collectionRef.get();
        for (final doc in snippets.docs) {
          await doc.reference.delete();
        }
      }

      await userDoc.delete();
      
      try {
        await user.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          throw Exception('Security requirement: Please log out and log back in to delete your account.');
        }
        rethrow;
      }
    }
  }
}


