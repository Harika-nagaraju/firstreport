import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firstreport/models/news_model.dart';
import 'package:firstreport/utils/user_registration.dart'; // For token
import 'package:firstreport/services/upload_service.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class NewsService {
  static String get _baseUrl => ApiConfig.baseUrl;

  static final http.Client _client = http.Client();

  static Future<List<NewsModel>> getAllNews({required String tab}) async {
    try {
      // Correct API endpoint as per production requirements
      final url = '$_baseUrl/api/news?tab=$tab';
      
      debugPrint('Fetching news from: $url');
      final response = await _client.get(
        Uri.parse(url),
      ).timeout(const Duration(seconds: 30));

      debugPrint('News Status Code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle both Map with 'news' key and direct List response
        final List<dynamic> newsList = (data is Map && data.containsKey('news')) 
            ? data['news'] 
            : (data is List ? data : []);

        return newsList.map((json) => NewsModel.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load news: (Status: ${response.statusCode}) ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching news: $e');
      return [];
    }
  }

  static Future<void> triggerFetchNews() async {
    // Temporarily disabled as requested for testing
    /*
    try {
      await http.get(Uri.parse('$_baseUrl/fetch-news'));
    } catch (e) {
      // Ignore errors for this trigger
    }
    */
  }

  static Future<void> likeNews(String newsId) async {
    try {
      await http.post(Uri.parse('$_baseUrl/api/news/$newsId/like'))
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      debugPrint('Error liking news: $e');
    }
  }

  static Future<void> shareNews(String newsId) async {
    try {
      await http.post(Uri.parse('$_baseUrl/api/news/$newsId/share'))
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      debugPrint('Error sharing news: $e');
    }
  }

  static Future<void> saveNews(String newsId) async {
    try {
      await http.post(Uri.parse('$_baseUrl/api/news/$newsId/save'))
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      debugPrint('Error saving news: $e');
    }
  }

  static Future<Map<String, dynamic>> postNews({
    required String title,
    required String content,
    required String category,
    required String language,
    required String imagePath,
  }) async {
    try {
      final token = await UserRegistration.getToken();
      final url = '$_baseUrl/api/news/create';
      
      var request = http.MultipartRequest('POST', Uri.parse(url));
      
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['title'] = title;
      request.fields['content'] = content;
      request.fields['category'] = category;
      request.fields['language'] = language;

      request.files.add(
        await http.MultipartFile.fromPath(
          'image', 
          imagePath,
          filename: imagePath.split('/').last,
        ),
      );

      var streamedResponse = await request.send().timeout(const Duration(seconds: 45));
      var response = await http.Response.fromStream(streamedResponse);

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': data['message'] ?? 'News posted successfully'};
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return {
          'success': false, 
          'message': data['message'] ?? 'You already have a pending news',
          'hasPending': true
        };
      } else {
        return {'success': false, 'message': 'Failed to post news'};
      }
    } catch (e) {
      print("❌ Connection error: $e");
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<bool> checkPendingStatus() async {
    try {
      final token = await UserRegistration.getToken();
      final response = await http.get(
        Uri.parse("$_baseUrl/api/news/my-status"),
        headers: {
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["hasPending"] == true;
      }
      return false;
    } catch (e) {
      debugPrint("Error checking pending status: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> submitNews({
    required String title,
    required String description,
    required String category,
    String? image,
  }) async {
    try {
      final token = await UserRegistration.getToken();
      
      final response = await http.post(
        Uri.parse('$_baseUrl/api/news/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'category': category,
          'image': image,
        }),
      ).timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': data['message'] ?? 'News submitted successfully'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Failed with status ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  /// Upload image to backend and return the public URL
  static Future<String?> uploadImage(String filePath) async {
    return await UploadService.uploadImage(filePath);
  }
}
