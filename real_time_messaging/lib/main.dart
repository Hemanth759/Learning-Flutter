import 'package:flutter/material.dart';

import 'package:real_time_messaging/pages/home/homePage.dart';
import 'package:real_time_messaging/pages/login/login.dart';
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
      routes: <String, WidgetBuilder> {
        '/' : (context) => HomePage(),
        '/login' : (context) => LoginPage(),
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
