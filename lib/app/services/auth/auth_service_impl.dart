import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/user_min.dart';
import 'auth_service.dart';

class AuthServiceImpl implements IAuthService {
  final FirebaseAuth _auth;

  AuthServiceImpl() : _auth = FirebaseAuth.instance;

  @override
  UserMin? getAuthUser() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    return UserMin(
      name: currentUser.displayName ?? '',
      email: currentUser.email ?? '',
    );
  }

  @override
  Future<UserMin?> signIn() async {
    try {
      final userCredential = await _auth.signInWithPopup(GoogleAuthProvider());
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();

        if (idToken != null) {
          return UserMin(
            name: user.displayName ?? '',
            email: user.email ?? '',
          );
        }
      }
    } on FirebaseException catch (error) {
      debugPrint('error, $error');
    }
    return null;
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
