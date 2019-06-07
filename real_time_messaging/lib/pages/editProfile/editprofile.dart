import 'package:flutter/material.dart';

import 'package:real_time_messaging/services/loader.dart';

import 'package:real_time_messaging/pages/editProfile/widgets.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditState();
  }
}

class _EditState extends State<EditProfilePage> {
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Edit Profile'),
        ),
        drawer: buildDrawerWidget(),
        body: _isLoading == true
            ? Loader()
            : Container(
                child: Text('Edit profile page'),
              ),
      ),
      onWillPop: goBack,
    );
  }

  Future<bool> goBack() async {
    return Navigator.of(context).pop();
  }
}
