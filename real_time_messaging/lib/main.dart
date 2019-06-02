import 'package:flutter/material.dart';

import 'package:real_time_messaging/pages/homePage.dart';
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
        primarySwatch: Colors.red,
      ),
      routes: <String, WidgetBuilder> {
        '/' : (context) => HomePage(),
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
