import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreference {
  static const String _languageKey = 'selected_language';
  static const String _languageCodeKey = 'language_code';
  static const String _countryCodeKey = 'country_code';

  // Language mappings
  static const Map<String, Map<String, String>> languages = {
    'English': {'code': 'en', 'country': 'US'},
    'Hindi': {'code': 'hi', 'country': 'IN'},
    'Telugu': {'code': 'te', 'country': 'IN'},
    'Tamil': {'code': 'ta', 'country': 'IN'},
    'Kannada': {'code': 'kn', 'country': 'IN'},
  };

  // Save selected language
  static Future<void> saveLanguage(String languageName) async {
    final prefs = await SharedPreferences.getInstance();
    final languageData = languages[languageName];
    
    if (languageData != null) {
      await prefs.setString(_languageKey, languageName);
      await prefs.setString(_languageCodeKey, languageData['code']!);
      await prefs.setString(_countryCodeKey, languageData['country']!);
    }
  }

  // Get saved language name
  static Future<String?> getLanguageName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  // Get saved language code
  static Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCodeKey) ?? 'en';
  }

  // Get saved country code
  static Future<String?> getCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_countryCodeKey) ?? 'US';
  }

  // Check if language is already selected
  static Future<bool> isLanguageSelected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_languageKey);
  }
}

