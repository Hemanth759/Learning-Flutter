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

Widget buildStickers({@required Function sendFunction}) {
  return Container(
    height: SizeConfig.blockSizeVertical * 45.0,
    width: SizeConfig.blockSizeHorizontal * 100.0,
    child: Column(
      children: <Widget>[
        // first row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                // TODO: function for inserting the image to messages
              },
              child: Image.asset(
                'assets/stickers/mimi1.gif',
                height: SizeConfig.blockSizeVertical * 15.0,
                width: SizeConfig.blockSizeHorizontal * 33.3,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// builds the layout for the keypad
Widget buildInputLayout({@required FocusNode focusNode,@required Function showStickers, @required Function showKeyboard}) {
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
              onPressed: showStickers,
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
                onTap: showKeyboard,
                focusNode: focusNode,
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
