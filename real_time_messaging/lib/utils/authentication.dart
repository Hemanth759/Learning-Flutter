import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BaseAuth {

  static BaseAuth _baseAuth;

  BaseAuth._createInstance();

  factory BaseAuth() {
    if (_baseAuth == null) {
      _baseAuth = BaseAuth._createInstance();
    }
    return _baseAuth;
  }

  Future<bool> isLoggedIn() async {
    FirebaseUser user = await getLoggedInUser();
    if(user == null) {
      return false;
    }
    return true;
  }
  

  /// returns logged in user
  Future<FirebaseUser> getLoggedInUser() async {
    return FirebaseAuth.instance.currentUser();
  }

  Future<FirebaseUser> handleGoogleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser = await firebaseAuth.signInWithCredential(credential);
    return firebaseUser;

  }
}