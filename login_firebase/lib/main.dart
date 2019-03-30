import 'package:flutter/material.dart';

import 'package:login_firebase/screens/login.dart';
import 'package:login_firebase/screens/register.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase and Flutter login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginPage(),
    );
  }
}