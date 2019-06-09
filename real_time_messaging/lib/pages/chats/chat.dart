import 'package:flutter/material.dart';

import 'package:real_time_messaging/models/user.dart';
import 'package:real_time_messaging/services/loader.dart';

class ChatPage extends StatefulWidget {
  ChatPage({@required this.currentUser, @required this.friendUser});

  final Map<String, String> currentUser;
  final User friendUser;

  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}

class _ChatState extends State<ChatPage> {
  bool _isLoading;
  String friendName;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    friendName = widget.friendUser.name;

    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Chat'),
        ),
        body: _isLoading == true
            ? Loader()
            : Container(
                child: Text(friendName),
              ),
      ),
      onWillPop: _goBack,
    );
  }

  /// function to go back to previous page
  Future<bool> _goBack() {
    Navigator.of(context).pop();
    return Future.value(false);
  }
}
