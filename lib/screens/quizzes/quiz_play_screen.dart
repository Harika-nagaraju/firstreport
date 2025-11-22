import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int answerIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
  });
}

class QuizPlayScreen extends StatefulWidget {
  final String title;
  final List<QuizQuestion> questions;

  const QuizPlayScreen({
    super.key,
    required this.title,
    required this.questions,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int currentIndex = 0;
  int score = 0;
  int? selectedOption;
  bool showResult = false;

  QuizQuestion get currentQuestion => widget.questions[currentIndex];

  void _selectOption(int index) {
    if (selectedOption != null) return;

    setState(() {
      selectedOption = index;
      if (index == currentQuestion.answerIndex) {
        score++;
      }
    });
  }

  void _goToNext() {
    if (currentIndex == widget.questions.length - 1) {
      setState(() {
        showResult = true;
      });
      return;
    }

    setState(() {
      currentIndex++;
      selectedOption = null;
    });
  }

  Color _optionColor(int index, bool isDark) {
    if (selectedOption == null) {
      return isDark ? AppColors.darkSurface : AppColors.white;
    }
    if (index == currentQuestion.answerIndex) {
      return isDark ? const Color(0xFF1B5E20) : const Color(0xFFD0F2DC);
    }
    if (index == selectedOption) {
      return isDark ? const Color(0xFF5D1F1F) : const Color(0xFFFAD4D4);
    }
    return isDark ? AppColors.darkSurface : AppColors.white;
  }

  IconData? _optionIcon(int index) {
    if (selectedOption == null) return null;
    if (index == currentQuestion.answerIndex) {
      return Icons.check_circle_outline;
    }
    if (index == selectedOption) {
      return Icons.highlight_off;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.screenBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final primaryText = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final secondaryText = isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: FontUtils.bold(size: 18, color: primaryText),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: showResult
            ? _buildResult(cardColor, primaryText, secondaryText)
            : _buildQuestion(cardColor, primaryText, secondaryText, isDark),
      ),
    );
  }

  Widget _buildQuestion(
    Color cardColor,
    Color primaryText,
    Color secondaryText,
    bool isDark,
  ) {
    final total = widget.questions.length;
    final progress = (currentIndex + 1) / total;
    final progressBackground =
        isDark ? AppColors.darkSurface : AppColors.backgroundLightGrey;
    final defaultBorderColor =
        isDark ? AppColors.darkBorder : AppColors.backgroundLightGrey;
    final boxShadowColor =
        isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${currentIndex + 1} of $total',
          style: FontUtils.regular(size: 14, color: secondaryText),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: progressBackground,
            valueColor: AlwaysStoppedAnimation(AppColors.gradientStart),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: boxShadowColor,
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            currentQuestion.question,
            style: FontUtils.bold(size: 18, color: primaryText),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: currentQuestion.options.length,
            itemBuilder: (context, index) {
              final option = currentQuestion.options[index];
              final optionIcon = _optionIcon(index);
              return GestureDetector(
                onTap: () => _selectOption(index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: _optionColor(index, isDark),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selectedOption == null
                          ? defaultBorderColor
                          : index == currentQuestion.answerIndex
                              ? const Color(0xFF4CAF50)
                              : index == selectedOption
                                  ? const Color(0xFFF44336)
                                  : defaultBorderColor,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: FontUtils.regular(size: 15, color: primaryText),
                        ),
                      ),
                      if (optionIcon != null)
                        Icon(
                          optionIcon,
                          color: optionIcon == Icons.check_circle_outline
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: selectedOption == null ? null : _goToNext,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColors.gradientStart,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  isDark ? AppColors.darkSurface : AppColors.backgroundLightGrey,
              disabledForegroundColor:
                  isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey,
            ),
            child: Text(
              currentIndex == widget.questions.length - 1 ? 'Finish Quiz' : 'Next Question',
              style: FontUtils.bold(size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult(Color cardColor, Color primaryText, Color secondaryText) {
    final total = widget.questions.length;
    final percentage = ((score / total) * 100).round();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percentage >= 70 ? Icons.emoji_events : Icons.flag,
              color: AppColors.gradientStart,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Quiz Complete!',
              style: FontUtils.bold(size: 22, color: primaryText),
            ),
            const SizedBox(height: 12),
            Text(
              'You scored $score out of $total',
              style: FontUtils.regular(size: 15, color: secondaryText),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage%',
              style: FontUtils.bold(size: 36, color: AppColors.gradientStart),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppColors.gradientStart,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Return to Quizzes',
                  style: FontUtils.bold(size: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() {
                  showResult = false;
                  currentIndex = 0;
                  selectedOption = null;
                  score = 0;
                });
              },
              child: Text(
                'Retake quiz',
                style: FontUtils.bold(size: 14, color: primaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

