import 'dart:async';

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
  Future<void> checkAndSave(FirebaseUser firebaseUser) async {
    final QuerySnapshot result = await _database.collection('Users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length == 0) {
      // first time logged in user
      await _database.collection('Users').document(firebaseUser.uid).setData(User.fromFirebaseAuth(firebaseUser).toMap());
    }
  }
}