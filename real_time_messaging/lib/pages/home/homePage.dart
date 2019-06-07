import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:real_time_messaging/services/authentication.dart';
import 'package:real_time_messaging/services/secureStorageCRUD.dart';
import 'package:real_time_messaging/utils/sizeconfig.dart';
import 'package:real_time_messaging/services/loader.dart';

import 'package:real_time_messaging/pages/home/widgets.dart';

class HomePage extends StatefulWidget {
  final Map<String, String> currentUser;
  HomePage({Key key, this.currentUser});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  bool _isLoading;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    verifyLoginStatus();

    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  Future<void> verifyLoginStatus() async {
    bool loginStatus = await BaseAuth().isLoggedIn();
    if (loginStatus) {
      debugPrint('user has been logged in');
      setState(() {});
    } else {
      debugPrint('no user logged in');
      setState(() {});
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
        onWillPop: showExitAlertDialog,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Home Page'),
            centerTitle: true,
          ),
          drawer: buildDrawerWidget(
            context: context,
            handleSignout: _handleSignOut,
            currentUser: widget.currentUser,
          ),
          body: _isLoading == false
              ? Container(
                  child: Center(
                    child: Text('Home Page'),
                  ),
                )
              : Loader(),
        ));
  }

  Future<void> _handleSignOut() async {
    setState(() {
      _isLoading = true;
    });

    await BaseAuth().signOut();
    await SecureStorage().deleteAll();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
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
          height: 100,
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
}
