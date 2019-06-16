import 'package:flutter/material.dart';

import 'package:real_time_messaging/models/user.dart';
import 'package:real_time_messaging/services/loader.dart';

import 'package:real_time_messaging/pages/chats/widgets.dart';

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
  bool _showStickers;

  @override
  void initState() {
    _isLoading = false;
    _showStickers = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.friendUser.name),
        ),
        body: _isLoading == true
            ? Loader()
            : Stack(
              children: <Widget>[
                // lists all the messages
                buildChatList(),

                // stickers

              ],
            )
      ),
      onWillPop: _goBack,
    );
  }

  /// function to go back to previous page
  Future<bool> _goBack() {
    // if the display is on stickers
    if(_showStickers) {
      setState(() {
       _showStickers = false; 
      });
    } else {
      Navigator.of(context).pop();
    }

    return Future.value(false);
  }

  /// changes the focus out of keyboard and displays the 
  /// stickers instead of keyboard
  void _getStickers() {
    // TODO: function to toggle stickers and reset the app
  }
}
