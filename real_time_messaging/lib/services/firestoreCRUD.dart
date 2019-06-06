import 'dart:async';

import 'package:flutter/material.dart';
import 'package:real_time_messaging/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreCRUD {
  static FireStoreCRUD _fireStoreCRUD;
  static Firestore _database = Firestore.instance;
  
  FireStoreCRUD._createInstance();
  factory FireStoreCRUD() {
    if(_fireStoreCRUD == null) {
      _fireStoreCRUD = FireStoreCRUD._createInstance();
    }
    return _fireStoreCRUD;
  }

  /// checks if the user is first time logging in or not
  /// If user is first time user the it saves to firestore database
  /// and returns true if user is first time user else false
  Future<bool> checkAndSave(FirebaseUser firebaseUser) async {
    final QuerySnapshot result = await _database.collection('Users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length == 0) {
      // first time logged in user
      await _database.collection('Users').document(firebaseUser.uid).setData(User.fromFirebaseAuth(firebaseUser).toMap());
      return true;
    }
    return false;
  }

  Future<DocumentSnapshot> getDocumentById(String documentId) async {
    final DocumentSnapshot documentSnapshot = await _database.collection('Users').document(documentId).get();
    if(documentSnapshot.exists) {
      return documentSnapshot;
    }
    debugPrint('requested document doesn\'t exist');
    return null;
  }
}