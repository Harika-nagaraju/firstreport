import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firstreport/models/language_api_model.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class LanguageService {
  static String get _baseUrl => ApiConfig.baseUrl;

  static Future<LanguageApiResponse> fetchLanguageData(String languageCode) async {
    try {
      final url = '$_baseUrl/api/language?code=$languageCode';
      debugPrint('Fetching language data from: $url');
      final response = await http.get(
        Uri.parse(url),
      ).timeout(const Duration(seconds: 30));

      debugPrint('Language Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return LanguageApiResponse.fromJson(jsonDecode(response.body));
      } else {
        debugPrint('Server error: ${response.statusCode} - ${response.body}');
        return _getFallbackData(languageCode);
      }
    } catch (e) {
      debugPrint('LanguageService connection error: $e. Using local fallback.');
      return _getFallbackData(languageCode);
    }
  }

  static Future<LanguageApiResponse> getTranslations(String languageCode) async {
    return fetchLanguageData(languageCode);
  }

  static LanguageApiResponse _getFallbackData(String code) {
    return LanguageApiResponse(
      success: true,
      language: code,
      translations: Translations(
        continueText: "Continue",
        selectLanguage: "Select your preferred language",
        chooseLanguage: "Choose Your Language",
        saveChanges: "Save Changes",
        retry: "Retry",
        loading: "Loading...",
        searchNews: "Search news...",
        noNewsFound: "No news found",
        login: "Login",
        signup: "Sign Up",
        emailLabel: "Email",
        emailHint: "Enter your email",
        passwordLabel: "Password",
        passwordHint: "Enter your password",
        fullNameLabel: "Full Name",
        fullNameHint: "Enter your full name",
        phoneNumberLabel: "Phone Number",
        phoneNumberHint: "Enter your phone number",
        forgotPassword: "Forgot Password?",
        dontHaveAccount: "Don't have an account? ",
        alreadyHaveAccount: "Already have an account? ",
        createAccount: "Create your account",
        continueWithGoogle: "Continue with Google",
        verifyOtp: "Verify OTP",
        enterOtp: "Enter OTP",
        resendOtp: "Resend OTP",
        resetPassword: "Reset Password",
        newPassword: "New Password",
        confirmPassword: "Confirm Password",
        home: "Home",
        post: "Post",
        quiz: "Quiz",
        settings: "Settings",
        readMore: "Read More",
        readLess: "Read Less",
        share: "Share",
        save: "Save",
        saved: "Saved",
        all: "All",
        yesterday: "Yesterday",
        india: "India",
        international: "International",
        currentAffairs: "Current Affairs",
        health: "Health",
        tech: "Tech",
        general: "General",
        account: "Account",
        support: "Support",
        language: "Language",
        darkMode: "Dark Mode",
        profileDetails: "Profile Details",
        notifications: "Notifications",
        savedOnes: "Saved Ones",
        privacyPolicy: "Privacy Policy",
        termsConditions: "Terms & Conditions",
        contactSupport: "Contact Support",
        memberSince: "Member since",
        verifiedReader: "Verified Reader",
        personalizedFeed: "Personalized Feed",
      ),
    );
  }

}
