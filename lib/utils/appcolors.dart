import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary gradient colors (blue to orange as per mock)
  static const Color gradientStart = Color(0xFF0F67FF);
  static const Color gradientEnd = Color(0xFFFB7A00);

  // Neutrals
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFEAEAEA);

  // Language Selection Screen Colors
  static const Color backgroundLightGrey = Color(0xFFF5F5F5);
  static const Color textDarkGrey = Color(0xFF333333);
  static const Color textLightGrey = Color(0xFF666666);
  static const Color borderSelected = Color(0xFF0F67FF);
  static const Color borderUnselected = Color(0xFFE0E0E0);
  static const Color checkmarkCircle = Color(0xFF0F67FF);
  
  // News Feed Colors
  static const Color categoryInactive = Color(0xFFE0E0E0);
  static const Color newsBackground = Color(0xFFFAFAFA);
  
  // Screen Background - Smoky Light Grey (almost white)
  static const Color screenBackground = Color(0xFFF7F7F7);
  
  // Quiz Colors
  static const Color difficultyEasy = Color(0xFF4CAF50);
  static const Color difficultyMedium = Color(0xFFFF9800);
  static const Color difficultyHard = Color(0xFFF44336);
  
  // Post News Colors
  static const Color uploadAreaBackground = Color(0xFFE3F2FD);
  static const Color uploadAreaBorder = Color(0xFF0F67FF);
  static const Color verificationBanner = Color(0xFFE3F2FD);
  static const Color verificationText = Color(0xFF0F67FF);
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color disabledButton = Color(0xFFCCCCCC);

  // Language Selection - Selected Language Colors
  static const Color selectedLanguageBg = Color(0xFFE3F2FD);
  static const Color selectedLanguageText = Color(0xFF0F67FF);

  static const LinearGradient primaryBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gradientStart, gradientEnd],
  );

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkInputBackground = Color(0xFF2D2D2D);
  static const Color darkBorder = Color(0xFF404040);
}


