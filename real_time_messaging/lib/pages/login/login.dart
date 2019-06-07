import 'dart:async';
import 'dart:io';

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
    return WillPopScope(
      child: Scaffold(
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
    ),
    onWillPop: showExitAlertDialog,
    );
  }

  /// show alert dialogue when exiting the app
  Future<bool> showExitAlertDialog() async {
    SimpleDialog simpleDialog = SimpleDialog(
      contentPadding: EdgeInsets.all(0.0),
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          margin: EdgeInsets.all(0.0),
          padding: EdgeInsets.only(bottom: 10, top: 10),
          height: 100.0,
          child: Column(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.exit_to_app,
                  size: 30.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'Exit App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Are you sure to exit app?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.0,
                ),
              )
            ],
          ),
        ),
        SimpleDialogOption(
          child: Row(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(right: 10.0),
              ),
              Text(
                'CANCEL',
                style:
                    TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              )
            ],
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        SimpleDialogOption(
          child: Row(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.check_circle,
                ),
                margin: EdgeInsets.only(right: 10.0),
              ),
              Text(
                'Yes',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                )
              )
            ],
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        )
      ],
    );

    final bool _shouldExit = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return simpleDialog;
        });
    
    if(_shouldExit) {
      exit(0);
    }
    return false;
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
    if(_currentUser != null) {
      final FirebaseUser firebaseUser = await BaseAuth().handleSignInsilently();
      if(firebaseUser != null) {
        await saveToFirestore(firebaseUser);
        await updateLocalStorage(firebaseUser);
      }
    }
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

    final FirebaseUser firebaseUser = await BaseAuth().handleGoogleSignIn();
    await saveToFirestore(firebaseUser);
    await updateLocalStorage(firebaseUser);
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
