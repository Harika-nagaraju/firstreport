import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const String _darkModeKey = 'dark_mode_enabled';

  // Save dark mode preference
  static Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, enabled);
  }

  // Get dark mode preference
  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }
}

