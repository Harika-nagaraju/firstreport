import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/models/quiz_model.dart' as model;
import 'package:firstreport/services/quiz_service.dart';

class QuizPlayScreen extends StatefulWidget {
  final String quizId;
  final String title;
  final List<model.QuizQuestion> questions;

  const QuizPlayScreen({
    super.key,
    required this.quizId,
    required this.title,
    required this.questions,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  List<int> userAnswers = [];
  int? selectedOption;
  bool isSubmitting = false;
  model.QuizSubmitResponse? submitResult;
  int currentScore = 0; // Local score for immediate feedback UI

  // For animations
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  model.QuizQuestion get currentQuestion => widget.questions[currentIndex];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<double>(begin: 0.05, end: 0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _selectOption(int index) {
    if (selectedOption != null || isSubmitting) return;
    
    setState(() {
      selectedOption = index;
      // If correct index is available, update local score for UI
      if (currentQuestion.correctOptionIndex != null && index == currentQuestion.correctOptionIndex) {
        currentScore++;
      }
    });

    // Automatically navigate after a short delay so user sees the result
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && selectedOption != null) {
        _goToNext();
      }
    });
  }

  Future<void> _goToNext() async {
    if (selectedOption == null) return;
    userAnswers.add(selectedOption!);

    if (currentIndex == widget.questions.length - 1) {
      _submitQuiz();
      return;
    }

    setState(() {
      currentIndex++;
      selectedOption = null;
    });
    _slideController.reset();
    _slideController.forward();
  }

  Future<void> _submitQuiz() async {
    setState(() => isSubmitting = true);
    try {
      // 1. Fire and forget to the backend (for analytics/history)
      QuizService.submitQuiz(widget.quizId, userAnswers).catchError((_) => null);
      
      // 2. Compute local result so UI ALWAYS shows the completion correctly
      int correct = 0;
      List<model.QuizResult> results = [];
      for (int i = 0; i < widget.questions.length; i++) {
        final q = widget.questions[i];
        final ans = i < userAnswers.length ? userAnswers[i] : -1;
        final isCorrect = q.correctOptionIndex != null && ans == q.correctOptionIndex;
        if (isCorrect) correct++;
        
        results.add(model.QuizResult(
          questionNumber: i + 1,
          questionText: q.questionText,
          options: q.options,
          selectedOptionIndex: ans,
          selectedOptionText: (ans >= 0 && ans < q.options.length) ? q.options[ans] : null,
          correctOptionIndex: q.correctOptionIndex ?? 0,
          correctOptionText: (q.correctOptionIndex != null && q.correctOptionIndex! < q.options.length) ? q.options[q.correctOptionIndex!] : '',
          isCorrect: isCorrect,
          explanation: '',
        ));
      }
      
      final total = widget.questions.length;
      final percentage = total > 0 ? ((correct / total) * 100).round() : 0;
      
      final localResult = model.QuizSubmitResponse(
        success: true,
        quizTitle: widget.title,
        score: correct,
        grade: percentage >= 80 ? 'A' : percentage >= 60 ? 'B' : 'C',
        percentage: '$percentage%',
        correctCount: correct,
        totalQuestions: total,
        results: results,
        message: 'Completed',
      );

      if (mounted) {
        setState(() {
          submitResult = localResult;
          isSubmitting = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.screenBackground;
    final card = isDark ? AppColors.darkCard : AppColors.white;
    final text = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final subText = isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // HEADER (Image 2 style)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showExitDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: card,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                        ],
                      ),
                      child: Icon(Icons.arrow_back, color: text, size: 20),
                    ),
                  ),
                  Text(
                    'Question ${currentIndex + 1} of ${widget.questions.length}',
                    style: FontUtils.medium(size: 16, color: text),
                  ),
                  Text(
                    'Score: $currentScore',
                    style: FontUtils.bold(size: 16, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // PROGRESS BAR (Image 2 style)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / widget.questions.length,
                  minHeight: 4,
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.backgroundLightGrey,
                  valueColor: const AlwaysStoppedAnimation(Colors.blue),
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: isSubmitting
                    ? _buildSubmitting()
                    : submitResult != null
                        ? _buildResult(card, text, subText, isDark)
                        : _buildQuestion(card, text, subText, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Question UI (Image 2 & 3 style)
  Widget _buildQuestion(Color card, Color text, Color subText, bool isDark) {
    final surface = isDark ? AppColors.darkSurface : AppColors.backgroundLightGrey;

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
          .animate(_slideAnimation.drive(CurveTween(curve: Curves.easeOut))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Card (White with big shadow)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              currentQuestion.questionText,
              style: FontUtils.bold(size: 20, color: text),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Options (Large rounded cards)
          Expanded(
            child: ListView.builder(
              itemCount: currentQuestion.options.length,
              itemBuilder: (ctx, i) {
                final isSelected = selectedOption == i;
                final isAnswerRevealed = selectedOption != null;
                final isCorrect = currentQuestion.correctOptionIndex == i;
                final isWrongSelection = isSelected && !isCorrect;

                // Border/Background Color based on State (Image 3)
                Color containerColor = card;
                Color borderColor = isDark ? AppColors.darkBorder : Colors.transparent;
                Widget? trait;

                if (isAnswerRevealed) {
                  if (isCorrect) {
                    containerColor = const Color(0xFFE8F5E9); // Light green
                    borderColor = const Color(0xFF4CAF50);    // Green border
                    trait = Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(Icons.check, color: Colors.white, size: 16),
                    );
                  } else if (isWrongSelection) {
                    containerColor = const Color(0xFFFFEBEE); // Light red
                    borderColor = const Color(0xFFF44336);    // Red border
                    trait = Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF44336),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    );
                  }
                }

                return GestureDetector(
                  onTap: () => _selectOption(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isAnswerRevealed && (isCorrect || isWrongSelection) 
                              ? borderColor 
                              : isDark ? AppColors.darkBorder : Colors.transparent, 
                          width: 1.0),
                      boxShadow: [
                        if (!isAnswerRevealed)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            currentQuestion.options[i],
                            style: FontUtils.medium(
                              size: 16,
                              color: isAnswerRevealed && (isCorrect || isWrongSelection)
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : text,
                            ),
                          ),
                        ),
                        if (trait != null) trait,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Loading ───────────────────────────────────
  Widget _buildSubmitting() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Submitting your answers...',
            style: FontUtils.bold(size: 18, color: AppColors.textDarkGrey),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we calculate your score',
            style: FontUtils.regular(size: 14, color: AppColors.textLightGrey),
          ),
        ],
      ),
    );
  }

  // ─── Result (Image 4 style) ─────────────────────
  Widget _buildResult(Color card, Color text, Color subText, bool isDark) {
    if (submitResult == null) return const SizedBox.shrink();

    final percentage = int.tryParse(submitResult!.percentage.replaceAll('%', '')) ?? 0;
    final correct = submitResult!.correctCount;
    final total = submitResult!.totalQuestions;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gradient Circle Score
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A72D6), // Blue
                    Color(0xFFE58052), // Orange
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$correct',
                style: FontUtils.bold(size: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Quiz Complete!',
              style: FontUtils.medium(size: 18, color: text),
            ),
            const SizedBox(height: 12),
            
            Text(
              'You scored $correct out of $total',
              style: FontUtils.medium(size: 16, color: subText),
            ),
            const SizedBox(height: 12),
            
            Text(
              'Keep learning!',
              style: FontUtils.medium(size: 16, color: const Color(0xFF4A72D6)),
            ),
            const SizedBox(height: 32),
            
            // Back to Quizzes Button
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF1E5CCC), // Deeper blue
                      Color(0xFFDB7130), // Deeper orange
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Back to Quizzes',
                  style: FontUtils.medium(size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultStatTile(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: FontUtils.bold(size: 20, color: AppColors.textDarkGrey)),
        Text(label, style: FontUtils.regular(size: 12, color: AppColors.textLightGrey)),
      ],
    );
  }

  Future<void> _showExitDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quit Quiz?'),
        content: const Text('Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Quit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) Navigator.of(context).pop();
  }
}
