import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed: null,
              child: Text('Sign In'),
              color: Colors.green,
            ),
            RaisedButton(
              onPressed: null,
              child: Text('Sign Out'),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}