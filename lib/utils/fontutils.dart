import 'package:flutter/material.dart';

class FontUtils {
  static const String _fontFamily = 'Poppins';
  // static const String _fontFamily = 'AguafinaScript';

  // Regular font style
  static TextStyle regular({double size = 14, Color color = Colors.black, double? height}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: size,
      color: color,
      height: height,
    );
  }

  // Bold font style
  static TextStyle bold({double size = 14, Color color = Colors.black, double? height}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.bold,
      fontSize: size,
      color: color,
      height: height,
    );
  }

  // Semi-bold style
  static TextStyle semiBold({double size = 14, Color color = Colors.black, double? height}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: size,
      color: color,
      height: height,
    );
  }

  // Medium style
  static TextStyle medium({double size = 14, Color color = Colors.black, double? height}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: size,
      color: color,
      height: height,
    );
  }

  // italic style
  static TextStyle italic({double size = 14, Color color = Colors.black, double? height}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: size,
      fontStyle: FontStyle.italic,
      color: color,
      height: height,
    );
  }

  // light style
  static TextStyle light({double size = 14, Color color = Colors.black, double? height}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w300,
      fontSize: size,
      color: color,
      height: height,
    );
  }
}
