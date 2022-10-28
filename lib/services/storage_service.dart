import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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

  Future<CachedNetworkImage> getUserImage(String userId) async {
    late CachedNetworkImage image;

    await storage.ref('Users').child(userId).getDownloadURL().then((value) {
      image = CachedNetworkImage(imageUrl: value.toString(), fit: BoxFit.cover);
    });

    return image;
  }
}
