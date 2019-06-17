import 'package:flutter/material.dart';

Widget buildChatList() {
  return Column(
    children: <Widget>[
      // TODO: display the chat here
    ],
  );
}

Widget buildStickers() {
  // TODO: display stickers
  return Container();
}

Widget buildInputLayout() {
  return Positioned(
    bottom: 5,
    width: double.infinity,
    child: Container(
      child: Text('chat bar'),
    ),
  );
}
