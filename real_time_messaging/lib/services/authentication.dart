import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BaseAuth {
  
  // static variables
  static BaseAuth _baseAuth;
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  BaseAuth._createInstance();

  factory BaseAuth() {
    if (_baseAuth == null) {
      _baseAuth = BaseAuth._createInstance();
    }
    return _baseAuth;
  }

  /// getters functions
  FirebaseAuth get firebaseAuth => _firebaseAuth;
  GoogleSignIn get googleSignIn => _googleSignIn;

  /// returns true if logged in
  Future<bool> isLoggedIn() async {
    final FirebaseUser user = await getLoggedInUser();
    final GoogleSignInAccount googleSignInAccount = googleSignIn.currentUser;
    debugPrint('google account user is: $googleSignInAccount');
    if (user == null || googleSignInAccount == null) {
      return false;
    }
    return true;
  }

  /// signs out of firebase and googlesignin
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }

  /// returns logged in user
  Future<FirebaseUser> getLoggedInUser() async {
    return firebaseAuth.currentUser();
  }

  /// handles google signin and logins to
  /// firebase and returns firebase user
  Future<FirebaseUser> handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    // debugPrint('got google user ${googleUser.email}');
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    debugPrint('google user is: ${googleSignIn.currentUser}');

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser firebaseUser =
        await firebaseAuth.signInWithCredential(credential);

    return firebaseUser;
  }

  /// sends email verification to mail
  Future<void> sendEmailVerification() async {
    final bool userStatus = await isLoggedIn();
    if (userStatus) {
      final FirebaseUser firebaseUser = await firebaseAuth.currentUser();
      if (firebaseUser.isEmailVerified) {
        debugPrint(
            'User ${firebaseUser.email} email has been verified already');
        return;
      }
      await firebaseUser.sendEmailVerification();
      debugPrint('Email verification sent to email: ${firebaseUser.email}');
      return;
    }
    debugPrint('No User has been logged in');
    return;
  }

  /// returns true if email is verified
  /// and null if no user is logged in
  Future<bool> isEmailVerified() async {
    final bool userStatus = await isLoggedIn();
    if (userStatus) {
      final FirebaseUser firebaseUser = await firebaseAuth.currentUser();
      final bool emailVerificationStatus = firebaseUser.isEmailVerified;
      return emailVerificationStatus;
    }
    debugPrint('No User has been logged in');
    return null;
  }

  /// returns the previously signed google user if not logged out
  /// in the previous session
  Future<FirebaseUser> handleSignInsilently() async {
    final GoogleSignInAccount googleSignInAccount =
        await googleSignIn.signInSilently(suppressErrors: true);
    debugPrint('Google user account is: ${googleSignInAccount.email}');
    if (googleSignInAccount == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final FirebaseUser firebaseUser =
        await firebaseAuth.signInWithCredential(credential);
    return firebaseUser;
  }
}
