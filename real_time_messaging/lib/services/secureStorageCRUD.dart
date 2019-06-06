import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:real_time_messaging/models/secureStorage.dart';

class SecureStorageCRUD {
  // static variables
  static SecureStorageCRUD _secureStorage;
  static FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
  SecureStorageCRUD._createInstance();

  factory SecureStorageCRUD() {
    if(_secureStorage == null) {
      _secureStorage = SecureStorageCRUD._createInstance();
    }
    return _secureStorage;
  }

  // getter functions
  FlutterSecureStorage get flutterSecureStorage => _flutterSecureStorage;

  /// returns all the securely stored values as 
  /// list of securestorageitems
  Future<List<SecureStorageItem>> getAllValues() async {
    final all = await flutterSecureStorage.readAll();
    return all.keys.map((key) => SecureStorageItem(key: key, value: all[key])).toList(growable: false);
  }

  /// deletes all the securely stored items
  Future<void> deleteAll() async {
    await flutterSecureStorage.deleteAll();
  }

  /// adds a securestorageitem to the secure storage
  Future<void> addItem({@required SecureStorageItem item}) async {
    await flutterSecureStorage.write(key: item.key, value: item.value);
    return;
  }

  /// returns a securestorageitem with given key
  Future<SecureStorageItem> readItemWithKey({@required String key}) async {
    String value = await flutterSecureStorage.read(key: key);
    return SecureStorageItem(key: key, value: value);
  }
}