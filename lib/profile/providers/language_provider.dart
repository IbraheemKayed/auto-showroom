import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('locale');
    if (saved == 'en') {
      _locale = const Locale('en');
      notifyListeners();
    }
  }

  void setEnglish() async {
    _locale = const Locale('en');
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', 'en');
  }

  void setArabic() async {
    _locale = const Locale('ar');
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', 'ar');
  }

  bool get isEnglish => _locale.languageCode == 'en';
}
