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

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _isLoading = false;
    _showStickers = false;
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
                    Positioned(
                      child: Column(
                        children: <Widget>[
                          // lists all the messages
                          buildChatList(),

                          // stickers
                          _showStickers ? buildStickers() : Container(),
                        ],
                      ),
                    ),

                    // shows the input layout
                    Positioned(
                      bottom: 5,
                      child: buildInputLayout(),
                    )
                  ],
                )),
      onWillPop: _goBack,
    );
  }

  /// function to go back to previous page
  Future<bool> _goBack() {
    // if the display is on stickers
    if (_showStickers) {
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
    _focusNode.unfocus();
    setState(() {
      _showStickers = true;
    });
  }

  /// when focus changes hides the sticker display
  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // hides the stickers
      setState(() {
        _showStickers = false;
      });
    }
  }
}
