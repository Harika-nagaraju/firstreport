import 'package:flutter/material.dart';
import 'package:firstreport/models/news_model.dart';
import 'package:firstreport/services/news_service.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/services/language_service.dart';
import 'package:firstreport/models/language_api_model.dart';
import 'package:firstreport/utils/language_preference.dart';
import 'package:firstreport/widgets/news_card.dart';
import 'package:firstreport/widgets/category_chip.dart';
import 'package:firstreport/screens/notifications/notifications_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _categoryKeys = [
    'all',
    'previous',
    'india',
    'international',
    'current_affairs',
    'health',
    'tech',
  ];
  String selectedCategoryKey = 'all';
  String currentLanguageCode = 'en';
  String? currentLanguage;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _hasNotifications = true;
  bool _isLoading = true;
  List<NewsModel> _allNews = [];
  String _errorMessage = '';

  static final Map<String, Map<String, String>> _categoryLabels = {
    'en': {
      'all': 'All',
      'previous': 'Previous',
      'india': 'India',
      'international': 'International',
      'current_affairs': 'Current Affairs',
      'health': 'Health',
      'tech': 'Tech',
    },
    'hi': {
      'all': 'सभी',
      'previous': 'पिछला',
      'india': 'भारत',
      'international': 'अंतरराष्ट्रीय',
      'current_affairs': 'वर्तमान घटनाक्रम',
      'health': 'स्वास्थ्य',
      'tech': 'टेक',
    },
    'te': {
      'all': 'అన్నీ',
      'previous': 'మునుపటి',
      'india': 'భారతదేశం',
      'international': 'అంతర్జాతీయ',
      'current_affairs': 'నేటి విషయాలు',
      'health': 'ఆరోగ్యం',
      'tech': 'టెక్',
    },
    'ta': {
      'all': 'அனைத்தும்',
      'previous': 'முந்தைய',
      'india': 'இந்தியா',
      'international': 'சர்வதேச',
      'current_affairs': 'நடப்பு நிகழ்வுகள்',
      'health': 'சுகாதார',
      'tech': 'தொழில்நுட்பம்',
    },
    'kn': {
      'all': 'ಎಲ್ಲಾ',
      'previous': 'ಹಿಂದಿನ',
      'india': 'ಭಾರತ',
      'international': 'ಅಂತರರಾಷ್ಟ್ರೀಯ',
      'current_affairs': 'ಪ್ರಸ್ತುತ ಘಟನೆಗಳು',
      'health': 'ఆరోగ్య',
      'tech': 'ತಂತ್ರಜ್ಞಾನ',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _fetchNewsData();
  }

  Future<void> _fetchNewsData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final news = await NewsService.getAllNews(category: selectedCategoryKey);
      if (mounted) {
        setState(() {
          _allNews = news;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load news. Please try again.';
          _isLoading = false;
        });
      }
    }
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

  Translations? _translations;

  Future<void> _loadLanguage() async {
    final languageName = await LanguagePreference.getLanguageName();
    final languageCode = await LanguagePreference.getLanguageCode() ?? 'en';
    
    // Fetch dynamic translations from API or Fallback
    final response = await LanguageService.getTranslations(languageCode);
    
    if (!mounted) return;
    
    setState(() {
      currentLanguage = languageName ?? 'English';
      currentLanguageCode = languageCode;
      _translations = response.translations;
    });
  }

  List<NewsModel> getNewsItems() {
    List<NewsModel> filtered = List.from(_allNews);

    // Sort by newest first (latest date first)
    filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    // Filter by Search
    if (_isSearching && _searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((news) => 
        news.title.toLowerCase().contains(query) || 
        (news.description?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    return filtered;
  }

  String _getCategoryLabel(String key) {
    if (_translations != null) {
      switch (key) {
        case 'all': return _translations!.all ?? 'All';
        case 'previous': return 'Previous';
        case 'india': return _translations!.india;
        case 'international': return _translations!.international;
        case 'current_affairs': return _translations!.currentAffairs;
        case 'health': return _translations!.health;
        case 'tech': return _translations!.tech;
      }
    }
    final labels = _categoryLabels[currentLanguageCode] ?? _categoryLabels['en']!;
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

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final languageLabel = currentLanguage ?? 'English';
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

    final displayNews = getNewsItems();

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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          width: 44,
                          height: 44,
                        ),
                      ),
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
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                          if (mounted) {
                            setState(() {
                              _hasNotifications = false;
                            });
                          }
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
                          hintText: _translations?.searchNews ?? 'Search news...',
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
                            setState(() {
                              selectedCategoryKey = categoryKey;
                            });
                            _fetchNewsData();
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
              child: RefreshIndicator(
                onRefresh: _fetchNewsData,
                child: _isLoading 
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(_translations?.loading ?? 'Loading...', style: FontUtils.regular(color: textSecondary)),
                      ],
                    ),
                  )
                : _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage, style: FontUtils.regular(color: textSecondary)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchNewsData,
                          child: Text(_translations?.retry ?? 'Retry'),
                        ),
                      ],
                    ),
                  )
                : displayNews.isEmpty
                ? Center(child: Text(_translations?.noNewsFound ?? 'No news found', style: FontUtils.regular(color: textSecondary)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: displayNews.length,
                    itemBuilder: (context, index) {
                      final news = displayNews[index];
                      return NewsCard(
                        imageUrl: news.image ?? '', // Removed hardcoded Unsplash link
                        title: news.title,
                        description: news.description ?? news.content ?? '',
                        fullContent: news.content ?? news.description ?? '',
                        author: news.category?.toUpperCase() ?? 'NEWS', // Better author/tag display
                        timeAgo: _getTimeAgo(news.publishedAt),
                        publishedAt: news.publishedAt,
                        sourceUrl: news.sourceUrl,
                        initialLikes: news.likes,
                        initialShares: news.shares,
                        onLike: () => NewsService.likeNews(news.id),
                        onShare: () => NewsService.shareNews(news.id),
                        onSave: () async {
                          await NewsService.saveNews(news.id);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('News saved!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
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
