import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/widgets/quiz_card.dart';
import 'package:newsapp/widgets/category_chip.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  String selectedCategory = 'All';

  final List<String> quizCategories = [
    'All',
    'History',
    'Sports',
    'Current Affairs',
    'Science',
    'General Knowledge',
  ];

  // Sample quiz data - this would be filtered by category
  List<Map<String, dynamic>> getQuizzes() {
    return [
      {
        'imageUrl': 'https://via.placeholder.com/400x200?text=Indian+History',
        'title': 'Indian History Quiz',
        'difficulty': 'Medium',
        'questionCount': 5,
        'description': 'Test your knowledge about Indian history',
        'category': 'History',
      },
      {
        'imageUrl': 'https://via.placeholder.com/400x200?text=Sports',
        'title': 'Sports Trivia',
        'difficulty': 'Easy',
        'questionCount': 5,
        'description': 'How well do you know your sports?',
        'category': 'Sports',
      },
      {
        'imageUrl': 'https://via.placeholder.com/400x200?text=Current+Affairs',
        'title': 'Current Affairs',
        'difficulty': 'Hard',
        'questionCount': 5,
        'description': 'Stay updated with current events and news',
        'category': 'Current Affairs',
      },
      {
        'imageUrl': 'https://via.placeholder.com/400x200?text=Science',
        'title': 'Science Quiz',
        'difficulty': 'Medium',
        'questionCount': 5,
        'description': 'Explore the world of science and technology',
        'category': 'Science',
      },
      {
        'imageUrl': 'https://via.placeholder.com/400x200?text=General+Knowledge',
        'title': 'General Knowledge Challenge',
        'difficulty': 'Hard',
        'questionCount': 5,
        'description': 'Test your general knowledge across various topics',
        'category': 'General Knowledge',
      },
    ];
  }

  List<Map<String, dynamic>> getFilteredQuizzes() {
    if (selectedCategory == 'All') {
      return getQuizzes();
    }
    return getQuizzes()
        .where((quiz) => quiz['category'] == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final quizzes = getFilteredQuizzes();

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textDarkGrey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  Text(
                    'Quizzes',
                    style: FontUtils.bold(
                      size: 24,
                      color: AppColors.textDarkGrey,
                    ),
                  ),
                ],
              ),
            ),
            // Category Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: quizCategories.length,
                  itemBuilder: (context, index) {
                    final category = quizCategories[index];
                    return CategoryChip(
                      label: category,
                      isActive: selectedCategory == category,
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            // Quizzes List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return QuizCard(
                    imageUrl: quiz['imageUrl'],
                    title: quiz['title'],
                    difficulty: quiz['difficulty'],
                    questionCount: quiz['questionCount'],
                    description: quiz['description'],
                    onStartQuiz: () {
                      // Handle start quiz action
                      // Navigate to quiz detail or start quiz screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Starting ${quiz['title']}...'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

