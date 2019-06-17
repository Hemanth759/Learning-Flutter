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
                sendFunction(
                  address: 'assets/stickers/mimi1.gif',
                );
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 15.0,
                width: SizeConfig.blockSizeHorizontal * 20.0,
                child: Image.asset(
                  'assets/stickers/mimi1.gif',
                  height: SizeConfig.blockSizeVertical * 15.0,
                  width: SizeConfig.blockSizeHorizontal * 20.0,
                  fit: BoxFit.fill,
                ),
              )
            ),
            FlatButton(
              onPressed: () {
                sendFunction(
                  address: 'assets/stickers/mimi2.gif',
                );
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 15.0,
                width: SizeConfig.blockSizeHorizontal * 20.0,
                child: Image.asset(
                  'assets/stickers/mimi2.gif',
                  height: SizeConfig.blockSizeVertical * 15.0,
                  width: SizeConfig.blockSizeHorizontal * 20.0,
                  fit: BoxFit.fill,
                ),
              )
            ),
            FlatButton(
              onPressed: () {
                sendFunction(
                  address: 'assets/stickers/mimi3.gif',
                );
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 15.0,
                width: SizeConfig.blockSizeHorizontal * 20.0,
                child: Image.asset(
                  'assets/stickers/mimi3.gif',
                  height: SizeConfig.blockSizeVertical * 15.0,
                  width: SizeConfig.blockSizeHorizontal * 20.0,
                  fit: BoxFit.fill,
                ),
              )
            ),
          ],
        ),

        // second row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                sendFunction(
                  address: 'assets/stickers/mimi4.gif',
                );
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 15.0,
                width: SizeConfig.blockSizeHorizontal * 20.0,
                child: Image.asset(
                  'assets/stickers/mimi4.gif',
                  height: SizeConfig.blockSizeVertical * 15.0,
                  width: SizeConfig.blockSizeHorizontal * 20.0,
                  fit: BoxFit.fill,
                ),
              )
            ),
            FlatButton(
              onPressed: () {
                sendFunction(
                  address: 'assets/stickers/mimi5.gif',
                );
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 15.0,
                width: SizeConfig.blockSizeHorizontal * 20.0,
                child: Image.asset(
                  'assets/stickers/mimi5.gif',
                  height: SizeConfig.blockSizeVertical * 15.0,
                  width: SizeConfig.blockSizeHorizontal * 20.0,
                  fit: BoxFit.fill,
                ),
              )
            ),
            FlatButton(
              onPressed: () {
                sendFunction(
                  address: 'assets/stickers/mimi6.gif',
                );
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 15.0,
                width: SizeConfig.blockSizeHorizontal * 20.0,
                child: Image.asset(
                  'assets/stickers/mimi6.gif',
                  height: SizeConfig.blockSizeVertical * 15.0,
                  width: SizeConfig.blockSizeHorizontal * 20.0,
                  fit: BoxFit.fill,
                ),
              )
            ),
          ],
        ),

        // third row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                sendFunction(
                  address: 'assets/stickers/mimi7.gif',
                );
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 15.0,
                width: SizeConfig.blockSizeHorizontal * 20.0,
                child: Image.asset(
                  'assets/stickers/mimi7.gif',
                  height: SizeConfig.blockSizeVertical * 15.0,
                  width: SizeConfig.blockSizeHorizontal * 20.0,
                  fit: BoxFit.fill,
                ),
              )
            ),
            FlatButton(
              onPressed: () {
                sendFunction(
                  address: 'assets/stickers/mimi8.gif',
                );
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 15.0,
                width: SizeConfig.blockSizeHorizontal * 20.0,
                child: Image.asset(
                  'assets/stickers/mimi8.gif',
                  height: SizeConfig.blockSizeVertical * 15.0,
                  width: SizeConfig.blockSizeHorizontal * 20.0,
                  fit: BoxFit.fill,
                ),
              )
            ),
            FlatButton(
              onPressed: () {
                sendFunction(
                  address: 'assets/stickers/mimi9.gif',
                );
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 15.0,
                width: SizeConfig.blockSizeHorizontal * 20.0,
                child: Image.asset(
                  'assets/stickers/mimi9.gif',
                  height: SizeConfig.blockSizeVertical * 15.0,
                  width: SizeConfig.blockSizeHorizontal * 20.0,
                  fit: BoxFit.fill,
                ),
              )
            ),
          ],
        ),
      ],
    ),
  );
}

/// builds the layout for the keypad
Widget buildInputLayout(
    {@required FocusNode focusNode,
    @required TextEditingController messageController,
    @required Function showStickers,
    @required Function showKeyboard,
    @required Function sendMessage}) {
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
            child: Container(
              child: TextField(
                controller: messageController,
                onTap: showKeyboard,
                focusNode: focusNode,
                style: TextStyle(color: Colors.amber, fontSize: 20.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  filled: true,
                ),
              ),
            ),
          ),
        ),

        // send button
        Material(
          child: Container(
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: sendMessage,
            ),
          ),
        ),
      ],
    ),
  );
}
