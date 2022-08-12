import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  late Locale _locale;

  final all = [
    const Locale("en", "US"),
    const Locale("ru", "RU"),
  ];

  Locale get locale => _locale;
  void setLocale(Locale locale) {
    if (all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}
