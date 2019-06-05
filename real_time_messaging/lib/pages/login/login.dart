import 'dart:async';

import 'package:flutter/material.dart';

import 'package:real_time_messaging/services/authentication.dart';
import 'package:real_time_messaging/services/loader.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {

  bool _isLoading;

  @override
  void initState() {
    setState(() {
     _isLoading = false; 
    });
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

  Future<void> handleSignIn() async {
    setState(() {
     _isLoading = true; 
    });

    await BaseAuth().handleGoogleSignIn();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}
