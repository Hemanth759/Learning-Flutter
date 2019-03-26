import 'package:flutter/material.dart';
import 'package:todo_app/screens/note_list.dart';
import 'package:todo_app/screens/note_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Keeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.yellow,
      ),
      home: NoteDetail(),
    );
  }  
}