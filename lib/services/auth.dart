import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_tracker_application/models/custom_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map((user) => user != null
        ? CustomUser(uid: user.uid, email: user.email as String)
        : null);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user as User;

      print('${user.displayName} ${user.email}');

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
