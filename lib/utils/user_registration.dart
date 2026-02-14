import 'package:shared_preferences/shared_preferences.dart';

class UserRegistration {
  static const String _isRegisteredKey = 'is_registered';
  static const String _hasAccountKey = 'has_account';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userPhoneKey = 'user_phone';
  static const String _userPasswordKey = 'user_password';
  static const String _isVerifiedKey = 'is_verified';
  static const String _tokenKey = 'auth_token';

  // Save registration details
  static Future<void> saveRegistration({
    required String name,
    required String email,
    required String phone,
    String? password,
    String? token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isRegisteredKey, true);
    await prefs.setBool(_hasAccountKey, true);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userPhoneKey, phone);
    if (password != null && password.isNotEmpty) {
      await prefs.setString(_userPasswordKey, password);
    }
    if (token != null && token.isNotEmpty) {
      await prefs.setString(_tokenKey, token);
    }
  }

  static Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(_isRegisteredKey) ?? false) && (prefs.getString(_tokenKey) != null);
  }

  // Check if an account already exists on this device
  static Future<bool> hasAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasAccountKey) ?? false;
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

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get stored password (for local auth only)
  static Future<String?> _getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPasswordKey);
  }

  // Simple local sign-in check
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final storedEmail = await getUserEmail();
    final storedPassword = await _getUserPassword();
    if (storedEmail == null || storedPassword == null) return false;
    return storedEmail == email && storedPassword == password;
  }

  // Verification helpers
  static Future<void> setVerified(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isVerifiedKey, value);
  }

  static Future<bool> isVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isVerifiedKey) ?? false;
  }

  static Future<void> updatePassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPasswordKey, newPassword);
  }

  // Sign out (clear registration)
  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isRegisteredKey, false);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_userPasswordKey);
    await prefs.remove(_isVerifiedKey);
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

