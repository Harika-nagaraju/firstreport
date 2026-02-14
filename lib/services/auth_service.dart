import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firstreport/models/auth_model.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/api_config.dart';

class AuthService {
  static String get _baseUrl => ApiConfig.baseUrl;

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<RegistrationResponse> signInWithGoogle() async {
    try {
      // 1. Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return RegistrationResponse(success: false, message: 'Google sign in cancelled');
      }

      // 2. Get credentials
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        return RegistrationResponse(success: false, message: 'Firebase authentication failed');
      }

      // 4. Send to our backend to get JWT Token
      // As per the specification: Just send the idToken
      final url = '$_baseUrl/api/auth/google-login';
      debugPrint('Syncing Google User with backend: $url');
      
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'idToken': googleAuth.idToken,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegistrationResponse.fromJson(jsonDecode(response.body));
      } else {
        // Fallback: If backend fails but Firebase succeeded (useful for testing if backend not ready)
        // However, in production we need the backend JWT for other APIs.
        debugPrint('Backend sync failed: ${response.statusCode} - ${response.body}');
        return RegistrationResponse(
          success: false,
          message: 'Backend sync failed. Please try again later.',
        );
      }
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return RegistrationResponse(success: false, message: 'Google Sign-In failed: $e');
    }
  }

  static Future<RegistrationResponse> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final url = '$_baseUrl/api/auth/signup';
      debugPrint('Signing up at: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'fullName': fullName,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegistrationResponse.fromJson(jsonDecode(response.body));
      } else {
        debugPrint('Signup failed: ${response.statusCode} - ${response.body}');
        final errorData = jsonDecode(response.body);
        return RegistrationResponse(
          success: false,
          message: errorData['message'] ?? 'Signup failed (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('AuthService signup error: $e');
      return RegistrationResponse(
        success: false,
        message: 'Connection error: $e',
      );
    }
  }

  // Keeping register alias for backward compatibility or updating later
  static Future<RegistrationResponse> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) => signup(fullName: name, email: email, phone: phone, password: password);

  static Future<RegistrationResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = '$_baseUrl/api/auth/login';
      debugPrint('Logging in at: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 30));

      debugPrint('Login Status: ${response.statusCode}');
      debugPrint('Login Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegistrationResponse.fromJson(jsonDecode(response.body));
      } else {
        final data = jsonDecode(response.body);
        return RegistrationResponse(
          success: false,
          message: data['message'] ?? 'Login failed (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('AuthService login error: $e');
      return RegistrationResponse(
        success: false,
        message: 'Connection error: $e',
      );
    }
  }

  static Future<RegistrationResponse> forgotPassword({
    required String email,
  }) async {
    try {
      final url = '$_baseUrl/api/auth/forgot-password'; // Correct hyphenated route
      debugPrint('Forgot Password at: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email, // Back to 'email' as expected by backend
        }),
      ).timeout(const Duration(seconds: 30));

      debugPrint('Forgot Password Status: ${response.statusCode}');
      debugPrint('Forgot Password Response: ${response.body}');

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegistrationResponse.fromJson(data);
      } else {
        return RegistrationResponse(
          success: false,
          message: data['message'] ?? 'Forgot Password failed (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('AuthService forgotPassword error: $e');
      return RegistrationResponse(
        success: false,
        message: 'Connection error: $e',
      );
    }
  }

  static Future<RegistrationResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final url = '$_baseUrl/api/auth/verify-otp';
      debugPrint('Verify OTP at: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'otp': otp,
        }),
      ).timeout(const Duration(seconds: 30));

      debugPrint('Verify OTP Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        return RegistrationResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        return RegistrationResponse(
          success: false,
          message: errorData['message'] ?? 'OTP verification failed (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('AuthService verifyOtp error: $e');
      return RegistrationResponse(
        success: false,
        message: 'Connection error: $e',
      );
    }
  }

  static Future<RegistrationResponse> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final url = '$_baseUrl/api/auth/reset-password';
      debugPrint('Resetting password at: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'newPassword': newPassword,
        }),
      ).timeout(const Duration(seconds: 30));

      debugPrint('Reset Password Status: ${response.statusCode}');
      debugPrint('Reset Password Response: ${response.body}');

      if (response.statusCode == 200) {
        return RegistrationResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        return RegistrationResponse(
          success: false,
          message: errorData['message'] ?? 'Password reset failed (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('AuthService resetPassword error: $e');
      return RegistrationResponse(
        success: false,
        message: 'Connection error: $e',
      );
    }
  }

  static Future<RegistrationResponse> getProfile(String token) async {
    try {
      final url = '$_baseUrl/api/auth/profile';
      debugPrint('Fetching profile from: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return RegistrationResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        return RegistrationResponse(
          success: false,
          message: errorData['message'] ?? 'Failed to load profile (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('AuthService getProfile error: $e');
      return RegistrationResponse(
        success: false,
        message: 'Connection error: $e',
      );
    }
  }

  static Future<RegistrationResponse> updateProfile({
    required String token,
    required String fullName,
    required String phone,
    required String location,
  }) async {
    try {
      final url = '$_baseUrl/api/auth/update';
      debugPrint('Updating profile at: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'fullName': fullName,
          'phone': phone,
          'location': location,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return RegistrationResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        return RegistrationResponse(
          success: false,
          message: errorData['message'] ?? 'Profile update failed (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('AuthService updateProfile error: $e');
      return RegistrationResponse(
        success: false,
        message: 'Connection error: $e',
      );
    }
  }

  static Future<RegistrationResponse> updateSettings({
    required String token,
    required Map<String, dynamic> notificationPreferences,
    required Map<String, String> quietHours,
  }) async {
    try {
      final url = '$_baseUrl/api/auth/settings/update';
      debugPrint('Updating settings at: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'notificationPreferences': notificationPreferences,
          'quietHours': quietHours,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return RegistrationResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        return RegistrationResponse(
          success: false,
          message: errorData['message'] ?? 'Settings update failed (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('AuthService updateSettings error: $e');
      return RegistrationResponse(
        success: false,
        message: 'Connection error: $e',
      );
    }
  }
}
