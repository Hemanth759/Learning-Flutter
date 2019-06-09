import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageIO {
  // static instances
  static StorageIO _storageIO = StorageIO._createInstance();

  /// creates instance of the class
  StorageIO._createInstance();

  /// returns static singleton class
  factory StorageIO() => _storageIO;

  /// downloads the image file into temp directory with location
  /// as file location in temp directory
  Future<File> downloadImg(String imgName) async {
    print('downloading image with location: $imgName');
    final Directory tempDir = Directory.systemTemp;
    final File file = File('${tempDir.path}/$imgName');

    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Images/$imgName');
    final StorageFileDownloadTask task = storageReference.writeToFile(file);
    final int fileSize = (await task.future).totalByteCount;
    print('Downloaded image of size :$fileSize');

    return file;
  }

  /// uploads image to the firebase storage in directory image
  /// and returns download uri of that image
  Future<String> uploadImage(
      {@required File imageFile,
      @required String userId,
      String folder: 'ProfilePics'}) async {
    final RegExp regExp = RegExp('\\.[0-9a-z]+\$');
    final String format = regExp.stringMatch(imageFile.path);

    final fileName = userId + format;

    final StorageReference ref =
        FirebaseStorage.instance.ref().child('Images/$folder/$fileName');
    final StorageUploadTask task = ref.putFile(imageFile);
    final StorageTaskSnapshot snapshot = await task.onComplete;
    final String downloadUri = await snapshot.ref.getDownloadURL();
    print('Uploaded image.\n and its url is :$downloadUri');
    return downloadUri;
  }
}
