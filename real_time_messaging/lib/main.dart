import 'package:flutter/material.dart';

import 'package:real_time_messaging/pages/home/homePage.dart';
import 'package:real_time_messaging/pages/login/login.dart';
import 'package:real_time_messaging/pages/editProfile/editprofile.dart';
import 'package:real_time_messaging/pages/notFoundPage.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Box',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red[400],
        accentColor: Colors.teal,
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/home':
            Map<String, String> currentUser = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => HomePage(currentUser: currentUser,),
            );
            break;
          case '/':
            return MaterialPageRoute(
              builder: (context) => LoginPage(),
            );
            break;
          case '/editProfile':
            Map<String,String> user = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => EditProfilePage(currentUser: user,),
            );
            break;
        }
      },
      onUnknownRoute: (RouteSettings settings) {
        String unknownRoute = settings.name;
        debugPrint('Route of $unknownRoute not found');
        return MaterialPageRoute(
          builder: (context) => NotFoundPage(),
        );
      },
    );
  }
}
