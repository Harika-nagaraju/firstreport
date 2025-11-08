import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/language_preference.dart';
import 'package:newsapp/widgets/news_card.dart';
import 'package:newsapp/widgets/category_chip.dart';
import 'package:newsapp/screens/quizzes/quizzes_screen.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/screens/dashboard/notifications_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _categoryKeys = [
    'yesterday',
    'india',
    'international',
    'current_affairs',
    'quiz',
  ];
  String selectedCategoryKey = 'india';
  String currentLanguageCode = 'en';
  String? currentLanguage;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final bool _hasNotifications = true;

  static final Map<String, Map<String, String>> _categoryLabels = {
    'en': {
      'yesterday': 'Yesterday',
      'india': 'India',
      'international': 'International',
      'current_affairs': 'Current Affairs',
      'quiz': 'Quiz',
    },
    'hi': {
      'yesterday': 'कल',
      'india': 'भारत',
      'international': 'अंतरराष्ट्रीय',
      'current_affairs': 'वर्तमान घटनाक्रम',
      'quiz': 'क्विज़',
    },
    'te': {
      'yesterday': 'నిన్న',
      'india': 'భారతదేశం',
      'international': 'అంతర్జాతీయ',
      'current_affairs': 'నేటి విషయాలు',
      'quiz': 'క్విజ్',
    },
    'ta': {
      'yesterday': 'நேற்று',
      'india': 'இந்தியா',
      'international': 'சர்வதேச',
      'current_affairs': 'நடப்பு நிகழ்வுகள்',
      'quiz': 'வினாடி வினா',
    },
    'kn': {
      'yesterday': 'ನಿನ್ನೆ',
      'india': 'ಭಾರತ',
      'international': 'ಅಂತರರಾಷ್ಟ್ರೀಯ',
      'current_affairs': 'ಪ್ರಸ್ತುತ ಘಟನೆಗಳು',
      'quiz': 'ಕ್ವಿಜ್',
    },
  };

  static final Map<String, Map<String, List<Map<String, String>>>>
  _newsContent = {
    'en': {
      'yesterday': [
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400',
          'title': 'Yesterday\'s Major Policy Changes Announced',
          'description':
              'Significant policy updates that were announced yesterday are now being implemented across various sectors.',
          'author': 'News Desk',
          'timeAgo': '1d ago',
          'fullContent':
              'Detailed coverage of the policy changes introduced yesterday and their expected impact across the country.',
        },
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=400',
          'title': 'Stock Market Updates from Yesterday',
          'description':
              'Market analysis shows interesting trends from yesterday\'s trading session with significant gains.',
          'author': 'Finance Reporter',
          'timeAgo': '1d ago',
          'fullContent':
              'A closer look at market movements, investor sentiment, and expert commentary from yesterday\'s trading.',
        },
      ],
      'india': [
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?w=400',
          'title': 'Major Infrastructure Development Announced in Mumbai',
          'description':
              'Government unveils ambitious plan to modernize urban infrastructure across major metropolitan areas in Mumbai.',
          'author': 'Rajesh Kumar',
          'timeAgo': '2h ago',
          'fullContent':
              'The infrastructure overhaul includes new transit lines, digital services, and sustainability commitments for Mumbai.',
        },
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=400',
          'title': 'Delhi Metro Expansion Project Approved',
          'description':
              'New metro lines approved for Delhi will connect suburban areas, reducing commute time significantly.',
          'author': 'Urban Affairs Reporter',
          'timeAgo': '3h ago',
          'fullContent':
              'Comprehensive coverage of the newly approved metro corridors and expected timelines for completion.',
        },
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
          'title': 'Indian Space Mission Achieves New Milestone',
          'description':
              'ISRO successfully completes another mission, demonstrating India\'s growing space capabilities.',
          'author': 'Science Editor',
          'timeAgo': '5h ago',
          'fullContent':
              'Mission highlights, achievements, and scientist reactions from the latest ISRO success.',
        },
      ],
      'international': [
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400',
          'title': 'Global Climate Summit Concludes with New Agreements',
          'description':
              'World leaders reach consensus on climate action goals for the next decade at the international summit.',
          'author': 'International Correspondent',
          'timeAgo': '1h ago',
          'fullContent':
              'Summary of the summit outcomes, pledges, and new collaborative efforts on climate change.',
        },
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=400',
          'title': 'Technology Summit Showcases AI Innovations',
          'description':
              'Leading tech companies from around the world showcase breakthrough innovations in artificial intelligence.',
          'author': 'Tech Reporter',
          'timeAgo': '4h ago',
          'fullContent':
              'Keynotes, product reveals, and expert opinions from the global technology summit.',
        },
      ],
      'current_affairs': [
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?w=400',
          'title': 'Breaking: Major Political Development Today',
          'description':
              'Significant political developments emerge as key leaders meet to discuss crucial policy matters.',
          'author': 'Political Analyst',
          'timeAgo': '30m ago',
          'fullContent':
              'In-depth look at the political developments and what they mean for upcoming policy decisions.',
        },
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1472289065668-ce650ac443d2?w=400',
          'title': 'Health Sector Updates: New Initiatives Launched',
          'description':
              'Government launches new health initiatives aimed at improving healthcare access in rural areas.',
          'author': 'Health Reporter',
          'timeAgo': '1h ago',
          'fullContent':
              'Details on the newly launched health programs and expected beneficiaries across rural regions.',
        },
      ],
      'quiz': [],
    },
    'hi': {
      'yesterday': [
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400',
          'title': 'कल घोषित हुई प्रमुख नीतियाँ',
          'description':
              'सरकार द्वारा कल जारी की गई नई नीतियाँ आज से विभिन्न क्षेत्रों में लागू हो गई हैं।',
          'author': 'समाचार डेस्क',
          'timeAgo': '1 दिन पहले',
          'fullContent':
              'इन नीतियों का विस्तृत विवरण और उनके प्रभाव की जानकारी पढ़ें।',
        },
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=400',
          'title': 'कल के शेयर बाजार की झलक',
          'description':
              'कल के कारोबार में शेयर बाजार ने मजबूती दिखाई और निवेशकों का मनोबल बढ़ा।',
          'author': 'वित्त संवाददाता',
          'timeAgo': '1 दिन पहले',
          'fullContent':
              'मार्केट विश्लेषण, सेक्टर प्रदर्शन और विशेषज्ञों की राय।',
        },
      ],
      'india': [
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?w=400',
          'title': 'मुंबई में बड़ा अवसंरचना अभियान',
          'description':
              'सरकार ने मुंबई और आसपास के शहरों को आधुनिक बनाने के लिए नई योजना शुरू की है।',
          'author': 'राजेश कुमार',
          'timeAgo': '2 घंटे पहले',
          'fullContent':
              'योजना के मुख्य बिंदु, निवेश और अपेक्षित लाभ का विश्लेषण।',
        },
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=400',
          'title': 'दिल्ली मेट्रो विस्तार को मंज़ूरी',
          'description':
              'नई मेट्रो लाइनों से उपनगरों को जोड़ा जाएगा जिससे यात्रा समय में कमी आएगी।',
          'author': 'शहरी मामलों के संवाददाता',
          'timeAgo': '3 घंटे पहले',
          'fullContent': 'नई लाइनों का रूट मैप और चरणबद्ध निर्माण की समयरेखा।',
        },
      ],
      'international': [
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400',
          'title': 'जलवायु शिखर सम्मेलन में नई सहमति',
          'description':
              'विश्व नेताओं ने अगले दशक के लिए जलवायु कार्रवाई पर नई रूपरेखा तैयार की है।',
          'author': 'अंतरराष्ट्रीय संवाददाता',
          'timeAgo': '1 घंटा पहले',
          'fullContent': 'सम्मेलन की मुख्य घोषणाएँ और देशों की प्रतिबद्धताएँ।',
        },
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=400',
          'title': 'टेक सम्मेलन में एआई की झलक',
          'description':
              'दुनिया की प्रमुख तकनीकी कंपनियों ने कृत्रिम बुद्धिमत्ता में नई उपलब्धियाँ पेश कीं।',
          'author': 'टेक रिपोर्टर',
          'timeAgo': '4 घंटे पहले',
          'fullContent':
              'प्रमुख घोषणाओं और विशेषज्ञों की टिप्पणियों का सारांश।',
        },
      ],
      'current_affairs': [
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?w=400',
          'title': 'ताज़ा राजनीतिक हलचल',
          'description':
              'महत्वपूर्ण नीति मसलों पर चर्चा के लिए शीर्ष नेता एक साथ आए।',
          'author': 'राजनीतिक विश्लेषक',
          'timeAgo': '30 मिनट पहले',
          'fullContent': 'मुलाकात के मुख्य बिंदु और संभावित राजनीतिक प्रभाव।',
        },
        {
          'imageUrl':
              'https://images.unsplash.com/photo-1472289065668-ce650ac443d2?w=400',
          'title': 'स्वास्थ्य क्षेत्र में नई पहल',
          'description':
              'ग्रामीण क्षेत्रों में स्वास्थ्य सेवाओं को मजबूत करने के लिए नई योजनाएँ शुरू की गईं।',
          'author': 'स्वास्थ्य संवाददाता',
          'timeAgo': '1 घंटा पहले',
          'fullContent':
              'यह योजनाएँ किन जिलों में लागू होंगी और लाभार्थियों की संख्या।',
        },
      ],
      'quiz': [],
    },
  };

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (locale.languageCode != currentLanguageCode) {
      setState(() {
        currentLanguageCode = locale.languageCode;
        currentLanguage = _getLanguageNameFromCode(locale.languageCode);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    final languageName = await LanguagePreference.getLanguageName();
    final languageCode = await LanguagePreference.getLanguageCode();
    setState(() {
      currentLanguage = languageName ?? 'English';
      currentLanguageCode = languageCode ?? 'en';
    });
  }

  // News data organized by category
  Map<String, List<Map<String, dynamic>>> getCategoryNews() {
    final englishData = _newsContent['en'] ?? {};
    final languageData = _newsContent[currentLanguageCode];

    final merged = <String, List<Map<String, dynamic>>>{};
    for (final entry in englishData.entries) {
      final fallbackList = entry.value;
      final localizedList = languageData?[entry.key] ?? fallbackList;
      merged[entry.key] = localizedList
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return merged;
  }

  List<Map<String, dynamic>> getNewsItems() {
    final categoryNews = getCategoryNews();
    return categoryNews[selectedCategoryKey] ?? categoryNews['india'] ?? [];
  }

  String _getCategoryLabel(String key) {
    final labels =
        _categoryLabels[currentLanguageCode] ?? _categoryLabels['en']!;
    return labels[key] ?? _categoryLabels['en']![key] ?? key;
  }

  String _getLanguageNameFromCode(String code) {
    for (final entry in LanguagePreference.languages.entries) {
      if (entry.value['code'] == code) {
        return entry.key;
      }
    }
    return 'English';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageLabel =
        localizations?.getLanguageName(currentLanguageCode) ??
        currentLanguage ??
        'English';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textDarkGrey;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textLightGrey;
    final shadowColor = Colors.black.withOpacity(isDark ? 0.4 : 0.05);
    final inputBackground = isDark
        ? AppColors.darkInputBackground
        : AppColors.backgroundLightGrey;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
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
                      Icon(Icons.article_rounded, size: 28, color: textPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'First Report',
                          style: FontUtils.bold(size: 20, color: textPrimary),
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
                            color: textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                size: 24,
                                color: textPrimary,
                              ),
                              if (_hasNotifications)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  // Search Bar (shown when searching)
                  if (_isSearching) ...[
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: inputBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search news...',
                          hintStyle: FontUtils.regular(
                            size: 14,
                            color: textSecondary,
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
                        style: FontUtils.regular(size: 14, color: textPrimary),
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
                        languageLabel,
                        style: FontUtils.regular(
                          size: 14,
                          color: textSecondary,
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
                      itemCount: _categoryKeys.length,
                      itemBuilder: (context, index) {
                        final categoryKey = _categoryKeys[index];
                        final label = _getCategoryLabel(categoryKey);
                        return CategoryChip(
                          label: label,
                          isActive: selectedCategoryKey == categoryKey,
                          onTap: () {
                            if (categoryKey == 'quiz') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const QuizzesScreen(),
                                ),
                              );
                            } else {
                              setState(() {
                                selectedCategoryKey = categoryKey;
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
                    fullContent: news['fullContent'] ?? news['description'],
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
