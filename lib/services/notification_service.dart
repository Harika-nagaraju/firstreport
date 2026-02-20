import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firstreport/models/notification_model.dart';
import 'package:firstreport/utils/user_registration.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class NotificationService {
  static String get _baseUrl => ApiConfig.baseUrl;

  static Future<List<NotificationModel>> getNotifications() async {
    try {
      final token = await UserRegistration.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('NotificationService: No auth token found. User might not be logged in.');
      }
      
      final url = '$_baseUrl/api/notifications/user';
      debugPrint('Fetching notifications from: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      debugPrint('NotificationService: getNotifications status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final results = NotificationResponse.fromJson(data).notifications;
          debugPrint('NotificationService: Successfully fetched ${results.length} notifications');
          return results;
        } else {
          debugPrint('NotificationService: API returned success=false: ${data['message']}');
        }
      } else if (response.statusCode == 401) {
        debugPrint('NotificationService: Unauthorized! Token might be invalid or expired.');
      }
      return [];
    } catch (e) {
      debugPrint('NotificationService: Error fetching notifications: $e');
      return [];
    }
  }

  static Future<int> getUnreadCount() async {
    try {
      final token = await UserRegistration.getToken();
      if (token == null || token.isEmpty) return 0;
      
      final url = '$_baseUrl/api/notifications/user/unread-count';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['unreadCount'] ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('Error fetching unread count: $e');
      return 0;
    }
  }

  static Future<bool> markAsRead(String notificationId) async {
    try {
      final token = await UserRegistration.getToken();
      final url = '$_baseUrl/api/notifications/$notificationId/user-read';
      
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }
}
