import 'dart:async';

import 'package:flutter/material.dart';

import 'package:real_time_messaging/utils/authentication.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {

  bool _isLoading;
  bool _isLoggedIn;

  @override
  void initState() {
    _isLoading = false;

    verifyLoginStatus();

    super.initState();
  }

  Future<void> verifyLoginStatus() async {
    bool loginStatus = await BaseAuth().isLoggedIn();
    if (loginStatus) {
      debugPrint('user has been logged in');
      _isLoggedIn = true;
      // Navigator.of(context).pushReplacementNamed('homePage');
    }
    else {
      debugPrint('no user logged in');
      _isLoggedIn = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn == false ? Scaffold(
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
      ) : Container(),
    ) : Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Home Page'),
        ),
      ),
      body: _isLoading == false ? Container(
        child: Center(
          child: RaisedButton(
            color: Colors.red,
            child: Text('Sign Out'),
            onPressed: handleSignOut,
          ),
        ),
      ) : Container(),
    );
  }

  Future<void> handleSignIn() async {
    setState(() {
     _isLoading = true; 
    });

    await BaseAuth().handleGoogleSignIn();
    _isLoggedIn = true;

    setState(() {
     _isLoading = false; 
    });
  }

  Future<void> handleSignOut() async {
    setState(() {
     _isLoading = true; 
    });

    await BaseAuth().signOut();
    _isLoggedIn = false;

    setState(() {
     _isLoading = false; 
    });
  }
}
