import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:real_time_messaging/services/authentication.dart';
import 'package:real_time_messaging/services/firestoreCRUD.dart';
import 'package:real_time_messaging/services/secureStorageCRUD.dart';
import 'package:real_time_messaging/services/loader.dart';


class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {

  Map<String, String> _currentUser;
  bool _isLoading;

  @override
  void initState() {
    verifyUserStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Login Page'),
        ),
      ),
      body: _isLoading == false ? Container(
        child: Center(
          child: RaisedButton(
            color: Colors.red,
            child: Text('Sign in with Google'),
            onPressed: handleSignIn,
          ),
        ),
      ) : Loader(),
    );
  }

  /// redirects to home page
  void navigateToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false, arguments: _currentUser);
    return;
  }

  /// verifies user login information and redirects to 
  /// home page if user is logged in
  Future<void> verifyUserStatus() async {
    setState(() {
     _isLoading = true; 
    });
    _currentUser = await SecureStorage().getAllValues();
    final bool userstatus = await BaseAuth().isLoggedIn();

    if(userstatus) {
      navigateToHome();
    }

    setState(() {
     _isLoading = false; 
    });
  }

  

  Future<void> handleSignIn() async {
    setState(() {
     _isLoading = true; 
    });

    FirebaseUser firebaseUser = await BaseAuth().handleGoogleSignIn();
    final bool _isFirstTime = await saveToFirestore(firebaseUser);
    if(_isFirstTime) {
      await updateLocalStorage(firebaseUser);
    }
    navigateToHome();
  }

  /// saves to firestore if user is first time user 
  /// and returns true or false if not a first time user
  Future<bool> saveToFirestore(FirebaseUser user) async {
    final bool _isFirstTime = await FireStoreCRUD().checkAndSave(user);
    return _isFirstTime;
  }

  /// updates the local shared variables
  Future<void> updateLocalStorage(FirebaseUser user) async {
    await SecureStorage().addData(firebaseUser: user);
    _currentUser = await SecureStorage().getAllValues();
  }
}
