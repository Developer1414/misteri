import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadImage(String id, String filePath) async {
    File file = File(filePath);

    try {
      await storage.ref('Users').child(id).putFile(file);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('StorageError: ${e.message}');
      }
    }
  }

  Future<Image> getUserImage(String userId) async {
    late Image image;

    await storage.ref('Users').child(userId).getDownloadURL().then((value) {
      image = Image.network(value.toString(), fit: BoxFit.cover);
    });

    return image;
  }
}
