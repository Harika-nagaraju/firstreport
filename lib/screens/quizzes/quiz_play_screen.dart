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
    setState(() => selectedOption = index);
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
      final result = await QuizService.submitQuiz(widget.quizId, userAnswers);
      setState(() {
        submitResult = result;
        isSubmitting = false;
      });
    } catch (e) {
      setState(() => isSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit quiz: $e')),
      );
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
      appBar: AppBar(
        backgroundColor: card,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: text),
          onPressed: () => _showExitDialog(context),
        ),
        title: Text(
          widget.title,
          style: FontUtils.bold(size: 17, color: text),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isSubmitting
            ? _buildSubmitting()
            : submitResult != null
                ? _buildResult(card, text, subText, isDark)
                : _buildQuestion(card, text, subText, isDark),
      ),
    );
  }

  // ─── Loading ───────────────────────────────────
  Widget _buildSubmitting() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Calculating your score...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // ─── Question ───────────────────────────────────
  Widget _buildQuestion(Color card, Color text, Color subText, bool isDark) {
    final total = widget.questions.length;
    final progress = (currentIndex + 1) / total;
    final surface = isDark ? AppColors.darkSurface : AppColors.backgroundLightGrey;
    final border = isDark ? AppColors.darkBorder : AppColors.backgroundLightGrey;

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
          .animate(_slideAnimation.drive(CurveTween(curve: Curves.easeOut))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Row(
            children: [
              Text(
                'Q ${currentIndex + 1} / $total',
                style: FontUtils.medium(size: 13, color: subText),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: surface,
                    valueColor: AlwaysStoppedAnimation(AppColors.gradientStart),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              currentQuestion.questionText,
              style: FontUtils.bold(size: 18, color: text),
            ),
          ),
          const SizedBox(height: 20),

          // Options
          Expanded(
            child: ListView.builder(
              itemCount: currentQuestion.options.length,
              itemBuilder: (ctx, i) {
                final isSelected = selectedOption == i;
                final optionLabel = ['A', 'B', 'C', 'D'][i];

                return GestureDetector(
                  onTap: () => _selectOption(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.gradientStart.withOpacity(isDark ? 0.2 : 0.1)
                          : (isDark ? AppColors.darkSurface : AppColors.white),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.gradientStart : border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Option label circle
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.gradientStart
                                : (isDark ? AppColors.darkCard : AppColors.backgroundLightGrey),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            optionLabel,
                            style: FontUtils.bold(
                              size: 13,
                              color: isSelected ? Colors.white : subText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            currentQuestion.options[i],
                            style: FontUtils.regular(
                              size: 15,
                              color: isSelected ? AppColors.gradientStart : text,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: AppColors.gradientStart, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Next / Finish button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedOption == null ? null : _goToNext,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: AppColors.gradientStart,
                foregroundColor: Colors.white,
                disabledBackgroundColor: isDark ? AppColors.darkSurface : AppColors.backgroundLightGrey,
                disabledForegroundColor: subText,
              ),
              child: Text(
                currentIndex == widget.questions.length - 1 ? '🏁  Finish Quiz' : 'Next  →',
                style: FontUtils.bold(size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Result ───────────────────────────────────
  Widget _buildResult(Color card, Color text, Color subText, bool isDark) {
    if (submitResult == null) return const SizedBox.shrink();

    final score = submitResult!.score;
    final grade = submitResult!.grade;
    final correct = submitResult!.correctCount;
    final total = submitResult!.totalQuestions;

    // Grade color
    Color gradeColor;
    IconData gradeIcon;
    String gradeMessage;
    if (score >= 90) {
      gradeColor = Colors.green;
      gradeIcon = Icons.emoji_events;
      gradeMessage = 'Outstanding! 🌟';
    } else if (score >= 75) {
      gradeColor = Colors.teal;
      gradeIcon = Icons.star;
      gradeMessage = 'Great job! 🎉';
    } else if (score >= 60) {
      gradeColor = Colors.blue;
      gradeIcon = Icons.thumb_up;
      gradeMessage = 'Well done! 👍';
    } else if (score >= 45) {
      gradeColor = Colors.orange;
      gradeIcon = Icons.trending_up;
      gradeMessage = 'Keep it up! 💪';
    } else {
      gradeColor = Colors.red;
      gradeIcon = Icons.refresh;
      gradeMessage = 'Keep practicing! 📚';
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Score Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(gradeIcon, color: gradeColor, size: 56),
                const SizedBox(height: 12),
                Text(gradeMessage, style: FontUtils.bold(size: 20, color: text)),
                const SizedBox(height: 4),
                Text(
                  submitResult!.quizTitle,
                  style: FontUtils.medium(size: 14, color: subText),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),

                // Score + Grade row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _scoreStat('Score', '${submitResult!.percentage}', gradeColor),
                    _scoreStat('Grade', grade, gradeColor),
                    _scoreStat('Correct', '$correct / $total', Colors.blue),
                  ],
                ),
                const SizedBox(height: 20),

                // Return button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.gradientStart,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Back to Quizzes', style: FontUtils.bold(size: 15, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Per-question feedback
          Text(
            'Review Answers',
            style: FontUtils.bold(size: 18, color: text),
          ),
          const SizedBox(height: 12),

          ...submitResult!.results.asMap().entries.map((entry) {
            final i = entry.key;
            final result = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: result.isCorrect
                      ? Colors.green.withOpacity(0.4)
                      : Colors.red.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: result.isCorrect
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              result.isCorrect ? Icons.check_circle : Icons.cancel,
                              size: 14,
                              color: result.isCorrect ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              result.isCorrect ? 'Correct' : 'Incorrect',
                              style: FontUtils.bold(
                                size: 12,
                                color: result.isCorrect ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Q${i + 1}',
                        style: FontUtils.medium(size: 12, color: subText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Question text
                  Text(result.questionText, style: FontUtils.medium(size: 14, color: text)),
                  const SizedBox(height: 10),

                  // Your answer
                  if (result.selectedOptionText != null)
                    _answerRow(
                      label: 'Your answer:',
                      value: result.selectedOptionText!,
                      color: result.isCorrect ? Colors.green : Colors.red,
                    ),

                  // Correct answer (always shown)
                  if (!result.isCorrect) ...[
                    const SizedBox(height: 4),
                    _answerRow(
                      label: 'Correct answer:',
                      value: result.correctOptionText,
                      color: Colors.green,
                    ),
                  ],

                  // Explanation
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.backgroundLightGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline,
                            size: 16, color: AppColors.gradientStart),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            result.explanation,
                            style: FontUtils.regular(size: 13, color: subText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _scoreStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: FontUtils.bold(size: 22, color: color)),
        const SizedBox(height: 2),
        Text(label, style: FontUtils.regular(size: 12, color: AppColors.textLightGrey)),
      ],
    );
  }

  Widget _answerRow({required String label, required String value, required Color color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FontUtils.medium(size: 12, color: AppColors.textLightGrey)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(value, style: FontUtils.bold(size: 13, color: color)),
        ),
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
