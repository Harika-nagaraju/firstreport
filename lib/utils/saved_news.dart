import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SavedNews {
  static const String _savedNewsKey = 'saved_news';

  // Save a news item
  static Future<void> saveNews(Map<String, dynamic> news) async {
    final prefs = await SharedPreferences.getInstance();
    final savedNewsList = await getSavedNews();
    
    // Check if news already exists
    final exists = savedNewsList.any((item) => item['title'] == news['title']);
    if (!exists) {
      savedNewsList.add(news);
      final jsonString = jsonEncode(savedNewsList);
      await prefs.setString(_savedNewsKey, jsonString);
    }
  }

  // Get all saved news
  static Future<List<Map<String, dynamic>>> getSavedNews() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_savedNewsKey);
    
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  // Remove saved news
  static Future<void> removeNews(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final savedNewsList = await getSavedNews();
    savedNewsList.removeWhere((item) => item['title'] == title);
    
    final jsonString = jsonEncode(savedNewsList);
    await prefs.setString(_savedNewsKey, jsonString);
  }

  // Check if news is saved
  static Future<bool> isNewsSaved(String title) async {
    final savedNewsList = await getSavedNews();
    return savedNewsList.any((item) => item['title'] == title);
  }
}

