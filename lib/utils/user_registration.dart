import 'package:shared_preferences/shared_preferences.dart';

class UserRegistration {
  static const String _isRegisteredKey = 'is_registered';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userPhoneKey = 'user_phone';

  // Save registration details
  static Future<void> saveRegistration({
    required String name,
    required String email,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isRegisteredKey, true);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userPhoneKey, phone);
  }

  // Check if user is registered
  static Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isRegisteredKey) ?? false;
  }

  // Get registered user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Get registered user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Get registered user phone
  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhoneKey);
  }

  // Sign out (clear registration)
  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isRegisteredKey, false);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPhoneKey);
  }

  // Get all user details
  static Future<Map<String, String?>> getUserDetails() async {
    return {
      'name': await getUserName(),
      'email': await getUserEmail(),
      'phone': await getUserPhone(),
    };
  }
}

