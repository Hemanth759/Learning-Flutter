import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:real_time_messaging/models/message.dart';
import 'package:real_time_messaging/models/user.dart';
import 'package:real_time_messaging/services/loader.dart';
import 'package:real_time_messaging/utils/sizeconfig.dart';

Widget buildChatList({
  @required String groupChatId,
  @required ScrollController messageScrollController,
  @required User currentUser,
}) {
  return Container(
    child: groupChatId == ''
        ? Loader()
        : StreamBuilder(
            stream: Firestore.instance
                .collection('Messages')
                .document(groupChatId)
                .collection(groupChatId)
                .orderBy('dateTime', descending: true)
                .limit(20)
                .snapshots(),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return Loader();
              } else {
                List<DocumentSnapshot> listMessage = snapshots.data.documents;
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: listMessage.length,
                  reverse: true,
                  controller: messageScrollController,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return buildMessage(listMessage[index],
                          currentUser: currentUser, isLastmessage: true);
                    }
                    return buildMessage(listMessage[index],
                        currentUser: currentUser);
                  },
                );
              }
            },
          ),
  );
}

/// builds the basic message tile
Widget buildMessage(
  DocumentSnapshot doc, {
  @required User currentUser,
  bool isLastmessage: false,
}) {
  Message message = Message.fromFirestoreCloud(map: doc.data);
  if (message.senderId == currentUser.userId) {
    // should be in right side of the screen
    return Row(
      children: <Widget>[
        message.messageType == 1
            ? Container(
                alignment: Alignment.centerRight,
                child: Text(
                  message.message,
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: SizeConfig.blockSizeHorizontal * 45,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(
                    bottom: isLastmessage
                        ? SizeConfig.blockSizeVertical * 6
                        : SizeConfig.blockSizeVertical * 1,
                    left: SizeConfig.blockSizeHorizontal * 45),
              )
            : message.messageType == 2
                ? Container(
                    // sticker here
                    padding: EdgeInsets.only(
                        bottom: isLastmessage
                            ? SizeConfig.blockSizeVertical * 5
                            : 0.0),
                    width: SizeConfig.blockSizeHorizontal * 85,
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      message.message,
                      fit: BoxFit.fill,
                      width: SizeConfig.blockSizeHorizontal * 20,
                      height: SizeConfig.blockSizeVertical * 15,
                    ),
                  )
                : Container(
                    // a image from the internet
                    width: SizeConfig.blockSizeHorizontal * 89,
                    height: SizeConfig.blockSizeVertical * 25.0,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(
                        bottom: isLastmessage
                            ? SizeConfig.blockSizeVertical * 5
                            : 0.0,
                      ),
                    child: CachedNetworkImage(
                      imageUrl: message.message,
                      placeholder: (context, l) => Loader(),
                      fit: BoxFit.fill,
                    ),
                  ),
      ],
    );
  } else {
    return Row(
      children: <Widget>[
        message.messageType == 1
            ? Container(
                child: Text(
                  message.message,
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(
                    bottom: isLastmessage
                        ? SizeConfig.blockSizeVertical * 6
                        : SizeConfig.blockSizeVertical * 1,
                    left: 10.0),
              )
            : message.messageType == 2
                ? Container(
                    // sticker here
                    padding: EdgeInsets.only(
                        bottom: isLastmessage
                            ? SizeConfig.blockSizeVertical * 5
                            : 0.0),
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      message.message,
                      width: SizeConfig.blockSizeHorizontal * 20,
                      height: SizeConfig.blockSizeVertical * 15,
                    ),
                  )
                : Container(
                    // a image from the internet
                    width: SizeConfig.blockSizeHorizontal * 89,
                    height: SizeConfig.blockSizeVertical * 25.0,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                        bottom: isLastmessage
                            ? SizeConfig.blockSizeVertical * 5
                            : 0.0,
                      ),
                    child: CachedNetworkImage(
                      imageUrl: message.message,
                      placeholder: (context, l) => Loader(),
                      fit: BoxFit.fill,
                    ),
                  ),
      ],
    );
  }
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
                )),
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
                )),
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
                )),
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
                )),
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
                )),
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
                )),
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
                )),
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
                )),
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
                )),
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
    @required Function sendMessage,
    @required Function sendImage}) {
  return Container(
    height: SizeConfig.blockSizeVertical * 7,
    width: SizeConfig.blockSizeHorizontal * 100.0,
    child: Row(
      children: <Widget>[
        // image icon
        Material(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: sendImage,
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
