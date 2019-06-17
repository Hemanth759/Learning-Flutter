import 'package:flutter/material.dart';

class Message {
  // message variables
  String _message;
  DateTime _dateTime;
  String _senderId;
  String _receiverId;
  int _messageType;

  // getters for variables
  get message => _message;
  get datetime => _dateTime;
  get senderId => _senderId;
  get recevierId => _receiverId;
  get messageType => _messageType;

  /// returns a message model object
  Message(
      {@required String message,
      @required DateTime datetime,
      @required String senderId,
      @required String receiverId,
      @required int messageType})
      : this._message = message,
        this._messageType = messageType,
        this._dateTime = datetime,
        this._senderId = senderId,
        this._receiverId = receiverId;

  /// returns a message model from the data of firestore 
  Message.fromFirestoreCloud({@required Map<String,dynamic> map}) {
    this._message = map['message'];
    this._messageType = map['messageType'];
    this._dateTime = map['dateTime'];
    this._senderId = map['senderId'];
    this._receiverId = map['receiverId'];
  }

  /// returns a map with message object data
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['message'] = this._message;
    map['messageType'] = this._messageType;
    map['dateTime'] = this._dateTime;
    map['senderId'] = this._senderId;
    map['receiverId'] = this._receiverId;

    return map;
  }
}
