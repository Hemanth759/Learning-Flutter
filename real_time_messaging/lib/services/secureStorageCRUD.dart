import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:real_time_messaging/services/firestoreCRUD.dart';

class SecureStorage {
  // static variables
  static SecureStorage _secureStorage;
  static FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
  static FireStoreCRUD _fireStoreCRUD = FireStoreCRUD();
  SecureStorage._createInstance();

  factory SecureStorage() {
    if(_secureStorage == null) {
      _secureStorage = SecureStorage._createInstance();
    }
    return _secureStorage;
  }

  // getter functions
  FlutterSecureStorage get flutterSecureStorage => _flutterSecureStorage;
  FireStoreCRUD get firestoreCRUD => _fireStoreCRUD;

  /// returns all the securely stored values as 
  /// list of securestorageitems
  Future<Map<String,String>> getAllValues() async {
    final all = await flutterSecureStorage.readAll();
    // debugPrint('all local storage values are: $all');
    if(all.length == 0) {
      return null;
    }
    return all;
  }

  /// deletes all the securely stored items
  Future<void> deleteAll() async {
    await flutterSecureStorage.deleteAll();
  }

  /// adds a securestorageitem to the secure storage
  Future<void> _addItem({@required key, @required value}) async {
    await flutterSecureStorage.write(key: key, value: value);
    return;
  }

  Future<void> addData({@required String userId}) async {
    // gets the document using document id
    final DocumentSnapshot doc = await firestoreCRUD.getDocumentById(userId);
    doc.data.forEach((key, value) async { return await SecureStorage()._addItem(key: key, value: value); });
  }

  /// returns a securestorageitem with given key
  Future<String> readItemWithKey({@required String key}) async {
    final String value = await flutterSecureStorage.read(key: key);
    return value;
  }
}