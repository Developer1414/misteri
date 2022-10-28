import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserData {
  static String userName = '';
  static String myToken = '';
  static String storysLanguage = '';
  static String appLanguage = '';
  static List<String> myInterests = ['love'];
  static String storysCount = '0';
  static String subscribersCount = '0';
  static CachedNetworkImage? userImage;
  static File? userImageFile;
  static bool isVerifiedAccount = false;
}
