import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:real_time_messaging/models/message.dart';
import 'package:real_time_messaging/models/user.dart';
import 'package:real_time_messaging/utils/groupChatId.dart';

class FireStoreCRUD {
  // static variables
  static FireStoreCRUD _fireStoreCRUD;
  static Firestore _database = Firestore.instance;

  FireStoreCRUD._createInstance();
  factory FireStoreCRUD() {
    if (_fireStoreCRUD == null) {
      _fireStoreCRUD = FireStoreCRUD._createInstance();
    }
    return _fireStoreCRUD;
  }

  /// checks if the user is first time logging in or not
  /// If user is first time user the it saves to firestore database
  /// and returns true if user is first time user else false
  Future<bool> checkAndSave(FirebaseUser firebaseUser) async {
    final QuerySnapshot result = await _database
        .collection('Users')
        .where('id', isEqualTo: firebaseUser.uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      // first time logged in user
      await _database
          .collection('Users')
          .document(firebaseUser.uid)
          .setData(User.fromFirebaseAuth(firebaseUser).toMap());
      return true;
    }
    return false;
  }

  /// function to update user info in firestore
  /// with the given user info
  Future<void> updateUserInfo(User user) async {
    await _database
        .collection('Users')
        .document(user.userId)
        .setData(user.toMap());
  }

  Future<DocumentSnapshot> getUsersByDocumentId(String documentId) async {
    final DocumentSnapshot documentSnapshot =
        await _database.collection('Users').document(documentId).get();
    if (documentSnapshot.exists) {
      return documentSnapshot;
    }
    debugPrint('requested document doesn\'t exist');
    return null;
  }

  /// returns list of users with given parameters
  Future<List<User>> getDocuments(
      {String collectionName: 'Users',
      int limit,
      String orderBy,
      String afterDocumentID}) async {
    if (afterDocumentID == null) {
      if (limit == null && orderBy == null) {
        // gets all the users
        final QuerySnapshot querySnapshot =
            await _database.collection(collectionName).getDocuments();
        final List<User> users = List<User>();
        for (DocumentSnapshot snap in querySnapshot.documents) {
          users.add(User.fromFireStoreCloud(snap.data));
        }

        return users;
      }

      if (limit == null) {
        // only limit isn't specified
        final QuerySnapshot querySnapshot = await _database
            .collection(collectionName)
            .orderBy(orderBy)
            .getDocuments();
        final List<User> users = List<User>();
        for (DocumentSnapshot snap in querySnapshot.documents) {
          users.add(User.fromFireStoreCloud(snap.data));
        }

        return users;
      }

      if (limit <= 0) {
        // limit can't be null
        debugPrint('limit can\'t be null');
        return null;
      }

      if (orderBy == null) {
        final QuerySnapshot querySnapshot = await _database
            .collection(collectionName)
            .limit(limit)
            .getDocuments();
        final List<User> users = List<User>();
        for (DocumentSnapshot snap in querySnapshot.documents) {
          users.add(User.fromFireStoreCloud(snap.data));
        }

        return users;
      } else {
        final QuerySnapshot querySnapshot = await _database
            .collection(collectionName)
            .orderBy(orderBy)
            .limit(limit)
            .getDocuments();
        final List<User> users = List<User>();
        for (DocumentSnapshot snap in querySnapshot.documents) {
          users.add(User.fromFireStoreCloud(snap.data));
        }

        return users;
      }
    }

    // if afterdocument is not given

    else {
      final DocumentSnapshot lastSnap = await _database
          .collection(collectionName)
          .document(afterDocumentID)
          .get();

      if (limit == null && orderBy == null) {
        // gets all the users
        final QuerySnapshot querySnapshot = await _database
            .collection(collectionName)
            .startAfterDocument(lastSnap)
            .getDocuments();
        final List<User> users = List<User>();
        for (DocumentSnapshot snap in querySnapshot.documents) {
          users.add(User.fromFireStoreCloud(snap.data));
        }

        return users;
      }

      if (limit == null) {
        // only limit isn't specified
        final QuerySnapshot querySnapshot = await _database
            .collection(collectionName)
            .orderBy(orderBy)
            .startAfterDocument(lastSnap)
            .getDocuments();
        final List<User> users = List<User>();
        for (DocumentSnapshot snap in querySnapshot.documents) {
          users.add(User.fromFireStoreCloud(snap.data));
        }

        return users;
      }

      if (limit <= 0) {
        // limit can't be null
        debugPrint('limit can\'t be null');
        return null;
      }

      if (orderBy == null) {
        final QuerySnapshot querySnapshot = await _database
            .collection(collectionName)
            .limit(limit)
            .startAfterDocument(lastSnap)
            .getDocuments();
        final List<User> users = List<User>();
        for (DocumentSnapshot snap in querySnapshot.documents) {
          users.add(User.fromFireStoreCloud(snap.data));
        }

        return users;
      } else {
        final QuerySnapshot querySnapshot = await _database
            .collection(collectionName)
            .orderBy(orderBy)
            .limit(limit)
            .startAfterDocument(lastSnap)
            .getDocuments();
        final List<User> users = List<User>();
        for (DocumentSnapshot snap in querySnapshot.documents) {
          users.add(User.fromFireStoreCloud(snap.data));
        }

        return users;
      }
    }
  }

  /// sends the image download uri to database storage as a message
  Future<void> sendImageMessage({@required Message message, @required User sender, @required User recevier}) async {
    final String messageAddress = getGroupChatId(recevier: recevier, sender: sender);
    await _database
        .collection('Messages')
        .document(messageAddress)
        .collection(messageAddress)
        .add(message.toMap());
  }

  /// sends message as a sticker
  Future<void> sendSticker({@required String stickerAddress,
        @required User sender, 
        @required User recevier}) async {
    final String messageAddress = getGroupChatId(recevier: recevier, sender: sender);

    final Message messageObj = Message(
      message: stickerAddress,
      messageType: 2,
      datetime: DateTime.now(),
      senderId: sender.userId,
      receiverId: recevier.userId
    );

    await _database
        .collection('Messages')
        .document(messageAddress)
        .collection(messageAddress)
        .add(messageObj.toMap());
  }

  /// sends the message to firestore database
  Future<void> sendMessage(
      {@required String message,
      @required User sender,
      @required User recevier}) async {
    final String messageAddress = getGroupChatId(recevier: recevier, sender: sender);

    final Message messageObj = Message(
        message: message,
        messageType: 1,
        datetime: DateTime.now(),
        senderId: sender.userId,
        receiverId: recevier.userId
      );

    await _database
        .collection('Messages')
        .document(messageAddress)
        .collection(messageAddress)
        .add(messageObj.toMap());
  }
}
