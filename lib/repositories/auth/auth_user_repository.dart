import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_ojt/config/logger.dart';
import 'package:flutter_ojt/models/user/user_data_model.dart';
import 'package:flutter_ojt/models/user/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuthUserRepository {
  Future<void> signup({required String email, required String password});
  Future<void> login({required String email, required String password});
  Future<void> logout();
  Future<void> googleSignIn();
  Stream<auth.User?> authUserStream();
  Future<void> createUserProfile({required String authUserId});
  Future<UserModel?> getUserFuture({required String authUserId});
  Future<void> updateUserProfile({
    required String authUserId,
    required Map<String, dynamic> updates,
  });
}

class AuthUserRepository implements BaseAuthUserRepository {
  final _auth = auth.FirebaseAuth.instance;
  final _userCollection = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> googleSignIn() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        logger.w("Google Sign In Cancelled");
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      logger.i("User Successfully Signed In");
    } catch (e) {
      logger.e("Error during Google Sign In: $e");
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      logger.i('User Successfully Logged In');
    } on auth.FirebaseAuthException catch (e) {
      logger.e('error during sign in: ${e.message}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        logger.w('User is already logged out.');
        return;
      }

      await _auth.signOut();
      logger.i('User successfully logged out.');
    } catch (e) {
      logger.e('⚡ ERROR in logout: $e');
      rethrow;
    }
  }

  @override
  Future<void> signup({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      logger.i("User Successfully Registered");
    } on auth.FirebaseAuthException catch (e) {
      logger.e("Error during signup: ${e.message}");
    }
  }

  @override
  Stream<auth.User?> authUserStream() {
    return _auth.authStateChanges();
  }

  @override
  Future<void> createUserProfile({required String authUserId}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;
    final userData = UserDataModel(
      uid: currentUser.providerData.first.uid!,
      name: currentUser.displayName ?? '',
      email: currentUser.email!,
      signInMethod: currentUser.providerData.first.providerId,
      profileImageUrl: currentUser.photoURL ?? '',
    );

    final newUser = UserModel(
      id: authUserId,
      userData: userData,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await _userCollection.doc(authUserId).set(newUser.toJson());
      logger.i('User Profile Created');
    } catch (e) {
      logger.e('Error during user profile creation: $e');
    }
  }

  @override
  Future<void> updateUserProfile({
    required String authUserId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      // Check if the user exists in Firestore
      final userDoc = await _userCollection.doc(authUserId).get();
      if (!userDoc.exists) {
        logger.e('User with ID $authUserId does not exist');
        return;
      }

      // Update the user profile with the provided fields
      await _userCollection.doc(authUserId).update(updates);

      // Log the updated fields for debugging
      logger.i('User Profile Updated: $updates');
    } catch (e) {
      logger.e('Error during user profile update: $e');
    }
  }

  @override
  Future<UserModel?> getUserFuture({required String authUserId}) async {
    final doc = await _userCollection.doc(authUserId).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    } else {
      return null;
    }
  }
}
