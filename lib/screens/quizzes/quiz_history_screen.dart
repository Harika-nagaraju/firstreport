import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/services/quiz_service.dart';
import 'package:firstreport/models/quiz_model.dart';
import 'package:intl/intl.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  List<QuizAttempt> _attempts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final history = await QuizService.getQuizHistory();
      setState(() {
        _attempts = history;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching history: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.screenBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Quiz History',
          style: FontUtils.bold(size: 20, color: textPrimary),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _attempts.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _fetchHistory,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _attempts.length,
                    itemBuilder: (context, index) {
                      final attempt = _attempts[index];
                      final date = DateTime.parse(attempt.completedAt);
                      final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);
                      final score = attempt.score;
                      final total = attempt.totalQuestions;
                      final correct = attempt.correctAnswers;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    attempt.quiz['title'] ?? 'Quiz',
                                    style: FontUtils.bold(size: 16, color: textPrimary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _gradeColor(attempt.grade).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        attempt.grade,
                                        style: FontUtils.bold(size: 13, color: _gradeColor(attempt.grade)),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.gradientStart.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${score}%',
                                        style: FontUtils.bold(size: 13, color: AppColors.gradientStart),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.category_outlined, size: 14, color: textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  attempt.quiz['category'] ?? 'General',
                                  style: FontUtils.regular(size: 12, color: textSecondary),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.calendar_today_outlined, size: 14, color: textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  formattedDate,
                                  style: FontUtils.regular(size: 12, color: textSecondary),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStat('Correct', '$correct', Colors.green),
                                _buildStat('Total', '$total', Colors.blue),
                                _buildStat('Score', '$score%', AppColors.gradientStart),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'A+': return Colors.green;
      case 'A': return Colors.teal;
      case 'B': return Colors.blue;
      case 'C': return Colors.orange;
      default: return Colors.red;
    }
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: FontUtils.bold(size: 18, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: FontUtils.regular(size: 12, color: AppColors.textLightGrey),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: AppColors.textLightGrey.withOpacity(0.5)),
          const SizedBox(height: 24),
          Text(
            'No quiz attempts yet',
            style: FontUtils.bold(size: 18, color: AppColors.textDarkGrey),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep playing quizzes to track your progress!',
            style: FontUtils.regular(size: 14, color: AppColors.textLightGrey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gradientStart,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Go Back', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
