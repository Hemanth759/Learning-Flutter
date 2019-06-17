import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:real_time_messaging/models/user.dart';
import 'package:real_time_messaging/services/firestoreCRUD.dart';
import 'package:real_time_messaging/services/loader.dart';

import 'package:real_time_messaging/pages/chats/widgets.dart';
import 'package:real_time_messaging/utils/sizeconfig.dart';

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

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FireStoreCRUD _fireStoreCRUD = FireStoreCRUD();

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
                    // lists all the messages
                    Positioned(
                      child: buildChatList(),
                    ),

                    // stickers
                    Positioned(
                      bottom: SizeConfig.blockSizeVertical * 5,
                      child: _showStickers
                          ? buildStickers(
                              sendFunction: _sendSticker,
                            )
                          : Container(),
                    ),

                    // shows the input layout
                    Positioned(
                      bottom: 0.0,
                      child: buildInputLayout(
                        focusNode: _focusNode,
                        messageController: _messageController,
                        showStickers: _getStickers,
                        showKeyboard: _onFocusChange,
                        sendMessage: _sendMessage,
                      ),
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
    // hides the stickers
    setState(() {
      _showStickers = false;
    });
  }

  /// sends the selected sticker as message
  Future<void> _sendSticker({@required String address}) async {
    // TODO: implement the send sticker methods
    debugPrint('sending sticker with addres: $address');
    return Future.value(false);
  }

  /// sends the typed message to the firestore
  Future<void> _sendMessage() async {
    final String message = _messageController.text;
    debugPrint('sending message : $message');

    await _fireStoreCRUD.sendMessage();
  }
}
