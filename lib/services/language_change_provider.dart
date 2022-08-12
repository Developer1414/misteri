import 'dart:io';
import 'package:flutter/material.dart';

class LanguageChangeProvider with ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
