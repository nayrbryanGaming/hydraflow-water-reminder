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

  Future<void> deleteUserAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      // 1. Delete Firestore user document and subcollections
      // In production, you might use a Cloud Function for recursive deletion
      await _firestore
          .collection(FirestoreConstants.users)
          .doc(user.uid)
          .delete();
      
      // 2. Delete the Auth account
      await user.delete();
    }
  }
}
