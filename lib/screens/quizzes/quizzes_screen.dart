import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/widgets/quiz_card.dart';
import 'package:firstreport/widgets/category_chip.dart';
import 'package:firstreport/screens/quizzes/quiz_play_screen.dart';

class QuizzesScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const QuizzesScreen({super.key, this.onBack});

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

  // Sample quiz data - includes questions for each quiz
  List<Map<String, dynamic>> getQuizzes() {
    return [
      {
        'imageUrl':
            'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=900',
        'title': 'Indian History Quiz',
        'difficulty': 'Medium',
        'description': 'Test your knowledge about India\'s remarkable past.',
        'category': 'History',
        'questions': [
          {
            'question': 'Who is known as the Father of the Indian Constitution?',
            'options': [
              'Dr. B.R. Ambedkar',
              'Mahatma Gandhi',
              'Jawaharlal Nehru',
              'Sardar Patel',
            ],
            'answerIndex': 0,
          },
          {
            'question': 'The Battle of Plassey was fought in which year?',
            'options': ['1757', '1764', '1857', '1818'],
            'answerIndex': 0,
          },
          {
            'question': 'Which empire built the city of Fatehpur Sikri?',
            'options': [
              'Maratha Empire',
              'Gupta Empire',
              'Mughal Empire',
              'Maurya Empire',
            ],
            'answerIndex': 2,
          },
        ],
      },
      {
        'imageUrl':
            'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=900',
        'title': 'Sports Trivia',
        'difficulty': 'Easy',
        'description': 'How well do you know the world of sports?',
        'category': 'Sports',
        'questions': [
          {
            'question': 'How many players are there in a cricket team?',
            'options': ['9', '10', '11', '12'],
            'answerIndex': 2,
          },
          {
            'question': 'Which country hosts the Wimbledon Championships?',
            'options': ['USA', 'Australia', 'France', 'United Kingdom'],
            'answerIndex': 3,
          },
          {
            'question': 'Lionel Messi is associated with which sport?',
            'options': ['Basketball', 'Football', 'Tennis', 'Hockey'],
            'answerIndex': 1,
          },
        ],
      },
      {
        'imageUrl':
            'https://images.unsplash.com/photo-1521295121783-8a321d551ad2?w=900',
        'title': 'Current Affairs Pulse',
        'difficulty': 'Hard',
        'description': 'Stay updated with the latest national and global news.',
        'category': 'Current Affairs',
        'questions': [
          {
            'question': 'Which organisation recently launched the Chandrayaan mission?',
            'options': ['NASA', 'ISRO', 'SpaceX', 'Roscosmos'],
            'answerIndex': 1,
          },
          {
            'question': 'The COP27 climate summit was hosted in which country?',
            'options': ['India', 'Egypt', 'Germany', 'Brazil'],
            'answerIndex': 1,
          },
          {
            'question': 'Who is the current Chief Justice of India?',
            'options': [
              'N. V. Ramana',
              'Uday U. Lalit',
              'D. Y. Chandrachud',
              'Sharad Bobde',
            ],
            'answerIndex': 2,
          },
        ],
      },
      {
        'imageUrl':
            'https://images.unsplash.com/photo-1517697471339-4aa32003c11a?w=900',
        'title': 'Science Explorer',
        'difficulty': 'Medium',
        'description': 'Explore the fascinating world of science and technology.',
        'category': 'Science',
        'questions': [
          {
            'question': 'What is the chemical symbol for gold?',
            'options': ['Au', 'Ag', 'Pt', 'Fe'],
            'answerIndex': 0,
          },
          {
            'question': 'What planet is known as the Red Planet?',
            'options': ['Venus', 'Mars', 'Jupiter', 'Mercury'],
            'answerIndex': 1,
          },
          {
            'question': 'Which gas do plants absorb during photosynthesis?',
            'options': ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Helium'],
            'answerIndex': 2,
          },
        ],
      },
      {
        'imageUrl':
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900',
        'title': 'General Knowledge Challenge',
        'difficulty': 'Hard',
        'description': 'Test your general knowledge across various topics.',
        'category': 'General Knowledge',
        'questions': [
          {
            'question': 'Which is the largest ocean on Earth?',
            'options': [
              'Atlantic Ocean',
              'Indian Ocean',
              'Pacific Ocean',
              'Arctic Ocean',
            ],
            'answerIndex': 2,
          },
          {
            'question': 'Which country is known as the Land of the Rising Sun?',
            'options': ['China', 'Japan', 'Thailand', 'South Korea'],
            'answerIndex': 1,
          },
          {
            'question': 'Who wrote the play "Romeo and Juliet"?',
            'options': [
              'Charles Dickens',
              'William Shakespeare',
              'Mark Twain',
              'George Bernard Shaw',
            ],
            'answerIndex': 1,
          },
        ],
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
            // Category Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: dividerShadow,
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
                  final List<dynamic> questions = quiz['questions'] as List<dynamic>;
                  return QuizCard(
                    imageUrl: quiz['imageUrl'],
                    title: quiz['title'],
                    difficulty: quiz['difficulty'],
                    questionCount: questions.length,
                    description: quiz['description'],
                    onStartQuiz: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuizPlayScreen(
                            title: quiz['title'] as String,
                            questions: questions
                                .map(
                                  (item) => QuizQuestion(
                                    question: item['question'] as String,
                                    options: List<String>.from(item['options'] as List),
                                    answerIndex: item['answerIndex'] as int,
                                  ),
                                )
                                .toList(),
                          ),
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

