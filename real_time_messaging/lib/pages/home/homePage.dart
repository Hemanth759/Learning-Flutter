import 'dart:async';

import 'package:flutter/material.dart';

import 'package:real_time_messaging/services/authentication.dart';
import 'package:real_time_messaging/services/secureStorageCRUD.dart';
import 'package:real_time_messaging/utils/sizeconfig.dart';
import 'package:real_time_messaging/services/loader.dart';

class HomePage extends StatefulWidget {

  final Map<String, String> currentUser;
  HomePage({Key key,this.currentUser});

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
      setState(() {

      });
    }
    else {
      debugPrint('no user logged in');
      setState(() {
       
      });
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () {
        /// TODO: code for the exit app here
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          centerTitle: true,
          ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
              ),
              ListTile(
                title: Text('Signout'),
                onTap: _handleSignOut,
              )
            ],
          ),
        ),
        body: _isLoading == false ? Container(
          child: Center(
            child: Text('Home Page'),
          ),
        ) : Loader(),
      )
    );
  }

  Future<void> _handleSignOut() async {
    setState(() {
     _isLoading = true; 
    });

    await BaseAuth().signOut();
    await SecureStorage().deleteAll();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}
