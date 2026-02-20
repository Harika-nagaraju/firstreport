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
        if (data['success'] == true) {
          final List quizzesJson = data['quizzes'] ?? [];
          debugPrint('QuizService: Fetched ${quizzesJson.length} quizzes');
          return quizzesJson.map((json) => Quiz.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('QuizService getAllQuizzes error: $e');
      return [];
    }
  }

  // ─────────────────────────────────────────────
  // GET /api/quiz/:id   →   Single quiz with questions (answers hidden)
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
        if (data['success'] == true && data['quiz'] != null) {
          return Quiz.fromJson(data['quiz']);
        }
      }
      return null;
    } catch (e) {
      debugPrint('QuizService getQuizById error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // POST /api/quiz/:id/submit
  // Body: { "answers": [0, 2, 1, 3, 2] }
  // Returns score, grade, and per-question feedback
  // ─────────────────────────────────────────────
  static Future<QuizSubmitResponse?> submitQuiz(
    String quizId,
    List<int> answers,
  ) async {
    try {
      final uri = Uri.parse('$_base/api/quiz/$quizId/submit');
      debugPrint('QuizService: POST $uri with ${answers.length} answers');

      final response = await http
          .post(
            uri,
            headers: await _headers(),
            body: jsonEncode({'answers': answers}),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('QuizService submitQuiz: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return QuizSubmitResponse.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      debugPrint('QuizService submitQuiz error: $e');
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
