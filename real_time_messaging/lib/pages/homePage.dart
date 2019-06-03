import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:real_time_messaging/utils/authentication.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {

  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;

    

    super.initState();
  }

  Future<void> verifyLoginStatus() async {
    bool loginStatus = await BaseAuth().isLoggedIn();
    if (loginStatus) {
      Navigator.of(context).pushReplacementNamed('homePage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Home Page'),
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
      ) : Container() ,
    );
  }

  Future<void> handleSignIn() async {
    setState(() {
     _isLoading = true; 
    });

    FirebaseUser user = await BaseAuth().handleGoogleSignIn();
  }
}
