import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/language_preference.dart';
import 'package:newsapp/widgets/news_card.dart';
import 'package:newsapp/widgets/category_chip.dart';
import 'package:newsapp/screens/quizzes/quizzes_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'India';
  String? currentLanguage;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _hasNotifications = true; // Set to false when no notifications

  final List<String> categories = [
    'Yesterday',
    'India',
    'International',
    'Current Affairs',
    'Quiz',
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    final language = await LanguagePreference.getLanguageName();
    setState(() {
      currentLanguage = language ?? 'English';
    });
  }

  // News data organized by category
  Map<String, List<Map<String, dynamic>>> getCategoryNews() {
    return {
      'Yesterday': [
        {
          'imageUrl': 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400',
          'title': 'Yesterday\'s Major Policy Changes Announced',
          'description': 'Significant policy updates that were announced yesterday are now being implemented across various sectors.',
          'author': 'News Desk',
          'timeAgo': '1d ago',
        },
        {
          'imageUrl': 'https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=400',
          'title': 'Stock Market Updates from Yesterday',
          'description': 'Market analysis shows interesting trends from yesterday\'s trading session with significant gains.',
          'author': 'Finance Reporter',
          'timeAgo': '1d ago',
        },
        {
          'imageUrl': 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400',
          'title': 'Educational Reforms Implemented Yesterday',
          'description': 'New educational policies that came into effect yesterday will benefit millions of students nationwide.',
          'author': 'Education Correspondent',
          'timeAgo': '1d ago',
        },
      ],
      'India': [
        {
          'imageUrl': 'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?w=400',
          'title': 'Major Infrastructure Development Announced in Mumbai',
          'description': 'Government unveils ambitious plan to modernize urban infrastructure across major metropolitan areas in Mumbai.',
          'author': 'Rajesh Kumar',
          'timeAgo': '2h ago',
        },
        {
          'imageUrl': 'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=400',
          'title': 'Delhi Metro Expansion Project Approved',
          'description': 'New metro lines approved for Delhi will connect suburban areas, reducing commute time significantly.',
          'author': 'Urban Affairs Reporter',
          'timeAgo': '3h ago',
        },
        {
          'imageUrl': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
          'title': 'Indian Space Mission Achieves New Milestone',
          'description': 'ISRO successfully completes another mission, demonstrating India\'s growing space capabilities.',
          'author': 'Science Editor',
          'timeAgo': '5h ago',
        },
        {
          'imageUrl': 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?w=400',
          'title': 'Agricultural Reforms Boost Farmer Income',
          'description': 'New agricultural policies show positive results with increased farmer income across several states.',
          'author': 'Rural Affairs Desk',
          'timeAgo': '6h ago',
        },
      ],
      'International': [
        {
          'imageUrl': 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400',
          'title': 'Global Climate Summit Concludes with New Agreements',
          'description': 'World leaders reach consensus on climate action goals for the next decade at the international summit.',
          'author': 'International Correspondent',
          'timeAgo': '1h ago',
        },
        {
          'imageUrl': 'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=400',
          'title': 'Technology Summit Showcases AI Innovations',
          'description': 'Leading tech companies from around the world showcase breakthrough innovations in artificial intelligence.',
          'author': 'Tech Reporter',
          'timeAgo': '4h ago',
        },
        {
          'imageUrl': 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400',
          'title': 'Economic Forum Discusses Global Trade',
          'description': 'International economic forum addresses challenges and opportunities in global trade relationships.',
          'author': 'Business Editor',
          'timeAgo': '7h ago',
        },
      ],
      'Current Affairs': [
        {
          'imageUrl': 'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?w=400',
          'title': 'Breaking: Major Political Development Today',
          'description': 'Significant political developments emerge as key leaders meet to discuss crucial policy matters.',
          'author': 'Political Analyst',
          'timeAgo': '30m ago',
        },
        {
          'imageUrl': 'https://images.unsplash.com/photo-1472289065668-ce650ac443d2?w=400',
          'title': 'Health Sector Updates: New Initiatives Launched',
          'description': 'Government launches new health initiatives aimed at improving healthcare access in rural areas.',
          'author': 'Health Reporter',
          'timeAgo': '1h ago',
        },
        {
          'imageUrl': 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=400',
          'title': 'Social Welfare Programs Expanded',
          'description': 'Expansion of social welfare programs announced to benefit millions of underprivileged citizens.',
          'author': 'Social Affairs Desk',
          'timeAgo': '2h ago',
        },
        {
          'imageUrl': 'https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=400',
          'title': 'Cultural Events Celebrated Nationwide',
          'description': 'Various cultural celebrations take place across the country, showcasing rich heritage and traditions.',
          'author': 'Culture Correspondent',
          'timeAgo': '3h ago',
        },
      ],
    };
  }

  List<Map<String, dynamic>> getNewsItems() {
    final categoryNews = getCategoryNews();
    return categoryNews[selectedCategory] ?? categoryNews['India']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              child: Column(
                children: [
                  // App Logo, Title, Search and Notifications
                  Row(
                    children: [
                      const Icon(
                        Icons.article_rounded,
                        size: 28,
                        color: AppColors.textDarkGrey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'First Report',
                          style: FontUtils.bold(
                            size: 20,
                            color: AppColors.textDarkGrey,
                          ),
                        ),
                      ),
                      // Search Icon
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSearching = !_isSearching;
                            if (!_isSearching) {
                              _searchController.clear();
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            _isSearching ? Icons.close : Icons.search,
                            size: 24,
                            color: AppColors.textDarkGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Notifications Icon with Badge
                      GestureDetector(
                        onTap: () {
                          // Handle notifications
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifications'),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(
                                Icons.notifications_outlined,
                                size: 24,
                                color: AppColors.textDarkGrey,
                              ),
                              // Red dot badge (show when there are notifications)
                              if (_hasNotifications)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Search Bar (shown when searching)
                  if (_isSearching) ...[
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLightGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search news...',
                          hintStyle: FontUtils.regular(
                            size: 14,
                            color: AppColors.textLightGrey,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.textLightGrey,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: FontUtils.regular(
                          size: 14,
                          color: AppColors.textDarkGrey,
                        ),
                        onChanged: (value) {
                          setState(() {
                            // Filter news based on search
                          });
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Language Display
                  Row(
                    children: [
                      Text(
                        currentLanguage ?? 'English',
                        style: FontUtils.regular(
                          size: 14,
                          color: AppColors.textLightGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Category Bar
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryChip(
                          label: category,
                          isActive: selectedCategory == category,
                          onTap: () {
                            if (category == 'Quiz') {
                              // Navigate to Quizzes Screen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const QuizzesScreen(),
                                ),
                              );
                            } else {
                              setState(() {
                                selectedCategory = category;
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // News Feed
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: getNewsItems().length,
                itemBuilder: (context, index) {
                  final news = getNewsItems()[index];
                  return NewsCard(
                    imageUrl: news['imageUrl'],
                    title: news['title'],
                    description: news['description'],
                    fullContent: news['description'] +
                        '\n\n' +
                        'This is the full content of the news article. ' +
                        'In a real implementation, this would be the complete article text ' +
                        'fetched from the server. The article continues with more detailed ' +
                        'information about the topic discussed in the headline and summary.',
                    author: news['author'],
                    timeAgo: news['timeAgo'],
                    onReadMore: () {
                      // Expand/collapse handled internally
                    },
                    onSave: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('News saved!'),
                          duration: Duration(seconds: 1),
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


