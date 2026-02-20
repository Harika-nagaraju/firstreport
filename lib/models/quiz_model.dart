// ===================================================
// 📋 QUIZ MODELS — Matches backend API response exactly
// ===================================================

class Quiz {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String? status;
  final int? timerMinutes;
  final int? questionCount; // From /all endpoint (questions hidden)
  final List<QuizQuestion>? questions; // From /:id endpoint
  final String? createdAt;
  final Map<String, dynamic>? newsId; // Linked news article

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    this.status,
    this.timerMinutes,
    this.questionCount,
    this.questions,
    this.createdAt,
    this.newsId,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'general',
      difficulty: json['difficulty'] ?? 'medium',
      status: json['status'],
      timerMinutes: json['timerMinutes'],
      questionCount: (json['questions'] as List?)?.length,
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((i) => QuizQuestion.fromJson(i))
              .toList()
          : null,
      createdAt: json['createdAt'],
      newsId: json['newsId'] is Map ? json['newsId'] : null,
    );
  }
}

class QuizQuestion {
  final String id;
  final int questionNumber;
  final String questionText;
  final List<String> options;

  QuizQuestion({
    required this.id,
    required this.questionNumber,
    required this.questionText,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['_id'] ?? '',
      questionNumber: json['questionNumber'] ?? 0,
      questionText: json['questionText'] ?? '',
      options: List<String>.from(json['options'] ?? []),
    );
  }
}

// ===================================================
// 🏆 SUBMIT RESPONSE — Returned after POST /:id/submit
// ===================================================

class QuizSubmitResponse {
  final bool success;
  final String quizTitle;
  final int score;
  final String grade;       // A+, A, B, C, D, F
  final String percentage;  // "80%"
  final int correctCount;
  final int totalQuestions;
  final List<QuizResult> results;
  final String? attemptId;
  final String message;

  QuizSubmitResponse({
    required this.success,
    required this.quizTitle,
    required this.score,
    required this.grade,
    required this.percentage,
    required this.correctCount,
    required this.totalQuestions,
    required this.results,
    this.attemptId,
    required this.message,
  });

  factory QuizSubmitResponse.fromJson(Map<String, dynamic> json) {
    return QuizSubmitResponse(
      success: json['success'] ?? false,
      quizTitle: json['quizTitle'] ?? 'Quiz Result',
      score: (json['score'] as num?)?.round() ?? 0,
      grade: json['grade'] ?? 'F',
      percentage: json['percentage'] ?? '0%',
      correctCount: json['correctCount'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      results: json['results'] != null
          ? (json['results'] as List).map((i) => QuizResult.fromJson(i)).toList()
          : [],
      attemptId: json['attemptId'],
      message: json['message'] ?? '',
    );
  }
}

// ===================================================
// 🔍 QUIZ RESULT — Per-question feedback after submit
// ===================================================

class QuizResult {
  final int questionNumber;
  final String questionText;
  final List<String> options;
  final int? selectedOptionIndex;
  final String? selectedOptionText;  // What user picked
  final int correctOptionIndex;
  final String correctOptionText;    // The right answer text
  final bool isCorrect;
  final String explanation;

  QuizResult({
    required this.questionNumber,
    required this.questionText,
    required this.options,
    this.selectedOptionIndex,
    this.selectedOptionText,
    required this.correctOptionIndex,
    required this.correctOptionText,
    required this.isCorrect,
    required this.explanation,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      questionNumber: json['questionNumber'] ?? 0,
      questionText: json['questionText'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      selectedOptionIndex: json['selectedOptionIndex'],
      selectedOptionText: json['selectedOptionText'],
      correctOptionIndex: json['correctOptionIndex'] ?? 0,
      correctOptionText: json['correctOptionText'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      explanation: json['explanation'] ?? 'No explanation provided.',
    );
  }
}

// ===================================================
// 📅 QUIZ ATTEMPT — Returned from /history/me
// ===================================================

class QuizAttempt {
  final String id;
  final Map<String, dynamic> quiz;
  final int score;
  final String grade;
  final int totalQuestions;
  final int correctAnswers;
  final String completedAt;

  QuizAttempt({
    required this.id,
    required this.quiz,
    required this.score,
    required this.grade,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completedAt,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['_id'] ?? '',
      quiz: json['quiz'] is Map ? json['quiz'] : {},
      score: (json['score'] as num?)?.round() ?? 0,
      grade: json['grade'] ?? 'F',
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      completedAt: json['completedAt'] ?? json['createdAt'] ?? '',
    );
  }
}
