import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BaseAuth {

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
    FirebaseUser user = await getLoggedInUser();
    GoogleSignInAccount googleSignInAccount = googleSignIn.currentUser;
    debugPrint('google account user is: $googleSignInAccount');
    if(user == null || googleSignInAccount == null ) {
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

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    // debugPrint('got google user ${googleUser.email}');
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    debugPrint('google user is: ${googleSignIn.currentUser}');

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser = await firebaseAuth.signInWithCredential(credential);

    return firebaseUser;
  }


  /// sends email verification to mail
  Future<void> sendEmailVerification() async {
    bool userStatus = await isLoggedIn();
    if(userStatus) {
      FirebaseUser firebaseUser = await firebaseAuth.currentUser();
      if(firebaseUser.isEmailVerified) {
        debugPrint('User ${firebaseUser.email} email has been verified already'); 
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
    bool userStatus = await isLoggedIn();
    if(userStatus) {
      FirebaseUser firebaseUser = await firebaseAuth.currentUser();
      bool emailVerificationStatus = firebaseUser.isEmailVerified;
      return emailVerificationStatus;
    }
    debugPrint('No User has been logged in');
    return null;
  } 
}