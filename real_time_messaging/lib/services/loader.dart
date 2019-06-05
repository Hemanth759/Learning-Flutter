import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoaderState();
  }
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
