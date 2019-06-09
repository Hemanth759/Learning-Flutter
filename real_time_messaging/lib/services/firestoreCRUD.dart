import 'dart:async';

import 'package:flutter/material.dart';
import 'package:real_time_messaging/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<DocumentSnapshot> getDocumentById(String documentId) async {
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
      DocumentSnapshot afterDocument}) async {
    if (afterDocument == null) {
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
      if (limit == null && orderBy == null) {
        // gets all the users
        final QuerySnapshot querySnapshot = await _database
            .collection(collectionName)
            .startAfterDocument(afterDocument)
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
            .startAfterDocument(afterDocument)
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
            .startAfterDocument(afterDocument)
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
            .startAfterDocument(afterDocument)
            .getDocuments();
        final List<User> users = List<User>();
        for (DocumentSnapshot snap in querySnapshot.documents) {
          users.add(User.fromFireStoreCloud(snap.data));
        }

        return users;
      }
    }
  }
}
