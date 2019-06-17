import 'package:flutter/material.dart';
import 'package:real_time_messaging/utils/sizeconfig.dart';

Widget buildChatList() {
  return Column(
    children: <Widget>[
      // TODO: display the chat here
      Container(),
    ],
  );
}

Widget buildStickers() {
  // TODO: display stickers
  return Container();
}

/// builds the layout for the keypad
Widget buildInputLayout() {
  return Container(
    height: SizeConfig.blockSizeVertical * 5,
    width: SizeConfig.blockSizeHorizontal * 100.0,
    child: Row(
      children: <Widget>[
        // image icon
        Material(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                // TODO: get the image from the gallery app
              },
              color: Colors.amber,
            ),
          ),
        ),

        // sticker icon
        Material(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            child: IconButton(
              icon: Icon(Icons.insert_emoticon),
              onPressed: () {
                // TODO: get the stickers to display
              },
              color: Colors.amber,
            ),
          ),
        ),

        // text message input
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Container(
            // height: 50,
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.amber, fontSize: 20.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  filled: true,
                  // fillColor: Colors.black,
                ),
              ),
              // color: Colors.black,
            ),
          ),
        ),

        // send button
        Material(
          child: Container(
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // TODO: do the send process
              },
            ),
          ),
        ),
      ],
    ),
  );
}
