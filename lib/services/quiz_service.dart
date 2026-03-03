import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firstreport/models/quiz_model.dart';
import 'package:firstreport/utils/user_registration.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class QuizService {
  static String get _base => ApiConfig.baseUrl;

  // ─────────────────────────────────────────────
  // Shared helper to build headers (no auth needed for public routes)
  // ─────────────────────────────────────────────
  static Future<Map<String, String>> _headers({bool requireAuth = false}) async {
    final token = await UserRegistration.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ─────────────────────────────────────────────
  // GET /api/quiz/all   →   List of published quizzes
  // Optional: ?category=sports&difficulty=easy&page=1&limit=20
  // ─────────────────────────────────────────────
  static Future<List<Quiz>> getAllQuizzes({
    String? category,
    String? difficulty,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final params = {
        'page': '$page',
        'limit': '$limit',
        if (category != null) 'category': category,
        if (difficulty != null) 'difficulty': difficulty,
        if (search != null) 'search': search,
      };

      final uri = Uri.parse('$_base/api/quiz/all').replace(queryParameters: params);
      debugPrint('QuizService: GET $uri');

      final response = await http
          .get(uri, headers: await _headers())
          .timeout(const Duration(seconds: 20));

      debugPrint('QuizService getAllQuizzes: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // 'quizzes' is the key returned by the backend /all endpoint
        final dataList = data['quizzes'] ?? data['data'] ?? [];
        if (dataList is List) {
          return dataList.map((json) => Quiz.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('QuizService getAllQuizzes error: $e');
      return [];
    }
  }

  // ─────────────────────────────────────────────
  // GET /api/quiz/:id   →   Single quiz with questions
  // ─────────────────────────────────────────────
  static Future<Quiz?> getQuizById(String quizId) async {
    try {
      final uri = Uri.parse('$_base/api/quiz/$quizId');
      debugPrint('QuizService: GET $uri');

      final response = await http
          .get(uri, headers: await _headers())
          .timeout(const Duration(seconds: 20));

      debugPrint('QuizService getQuizById: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final quizData = data['quiz'] ?? data['data'] ?? data;
        if (quizData != null) {
          return Quiz.fromJson(quizData);
        }
      }
      return null;
    } catch (e) {
      debugPrint('QuizService getQuizById error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // POST /api/quiz/submit
  // Image 5 specifies /api/quiz/submit
  // ─────────────────────────────────────────────
  static Future<QuizSubmitResponse?> submitQuiz(
    String quizId,
    List<int> answers,
  ) async {
    try {
      // Trying the /submit endpoint as per Image 5
      final uri = Uri.parse('$_base/api/quiz/submit');
      debugPrint('QuizService: POST $uri with quizId: $quizId');

      final response = await http
          .post(
            uri,
            headers: await _headers(),
            body: jsonEncode({
              'quizId': quizId, // Pass quizId in body if endpoint is generic
              'answers': answers,
            }),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('QuizService submitQuiz: ${response.statusCode}');

      // If generic /submit fails (maybe it's 404), fallback to /:id/submit
      if (response.statusCode == 404 || response.statusCode == 405) {
         return _submitQuizLegacy(quizId, answers);
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuizSubmitResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('QuizService submitQuiz error: $e. Falling back to ID route.');
      return _submitQuizLegacy(quizId, answers);
    }
  }

  static Future<QuizSubmitResponse?> _submitQuizLegacy(String quizId, List<int> answers) async {
    try {
      final uri = Uri.parse('$_base/api/quiz/$quizId/submit');
      final response = await http.post(
        uri,
        headers: await _headers(),
        body: jsonEncode({'answers': answers}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuizSubmitResponse.fromJson(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // GET /api/quiz/history/me  →  User's quiz history (login required)
  // ─────────────────────────────────────────────
  static Future<List<QuizAttempt>> getQuizHistory() async {
    try {
      final token = await UserRegistration.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('QuizService: No token — cannot fetch history');
        return [];
      }

      final uri = Uri.parse('$_base/api/quiz/history/me');
      debugPrint('QuizService: GET $uri');

      final response = await http
          .get(uri, headers: await _headers(requireAuth: true))
          .timeout(const Duration(seconds: 20));

      debugPrint('QuizService getQuizHistory: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List attemptsJson = data['attempts'] ?? [];
          return attemptsJson.map((json) => QuizAttempt.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('QuizService getQuizHistory error: $e');
      return [];
    }
  }
}
