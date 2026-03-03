import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/widgets/quiz_card.dart';
import 'package:firstreport/screens/quizzes/quiz_play_screen.dart';
import 'package:firstreport/services/quiz_service.dart';
import 'package:firstreport/models/quiz_model.dart';

class QuizzesScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const QuizzesScreen({super.key, this.onBack});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  List<Quiz> _allQuizzes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    setState(() => _isLoading = true);
    try {
      final quizzes = await QuizService.getAllQuizzes();
      if (mounted) {
        setState(() {
          _allQuizzes = quizzes;
          _isLoading = false;
        });
        debugPrint('QuizzesScreen: Loaded ${_allQuizzes.length} quizzes');
      }
    } catch (e) {
      debugPrint('QuizzesScreen: Error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }


  Future<void> _startQuiz(Quiz quiz) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final quizDetails = await QuizService.getQuizById(quiz.id);
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading

      if (quizDetails != null &&
          quizDetails.questions != null &&
          quizDetails.questions!.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QuizPlayScreen(
              quizId: quizDetails.id,
              title: quizDetails.title,
              questions: quizDetails.questions!,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load quiz questions.')),
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizzes = _allQuizzes;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.darkBackground : AppColors.screenBackground;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final dividerShadow = Colors.black.withOpacity(isDark ? 0.25 : 0.05);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: dividerShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: textPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  Text(
                    'Quizzes',
                    style: FontUtils.bold(
                      size: 24,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // Quizzes List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : quizzes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.quiz_outlined, size: 64, color: AppColors.textLightGrey),
                              const SizedBox(height: 16),
                              Text(
                                _allQuizzes.isEmpty && !_isLoading 
                                  ? 'No quizzes found. Please log in or check connection.' 
                                  : 'Nothing found here',
                                style: FontUtils.medium(size: 16, color: AppColors.textLightGrey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchQuizzes,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gradientStart,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Refresh', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchQuizzes,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: quizzes.length,
                            itemBuilder: (context, index) {
                              final quiz = quizzes[index];
                                return QuizCard(
                                  imageUrl: quiz.imageUrl ?? quiz.newsId?['imageUrl'] ?? 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=900',
                                title: quiz.title,
                                difficulty: quiz.difficulty,
                                questionCount: quiz.questionCount ?? 5,
                                description: quiz.description,
                                onStartQuiz: () => _startQuiz(quiz),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}


