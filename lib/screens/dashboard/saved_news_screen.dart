import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/saved_news.dart';
import 'package:newsapp/widgets/news_card.dart';

class SavedNewsScreen extends StatefulWidget {
  const SavedNewsScreen({super.key});

  @override
  State<SavedNewsScreen> createState() => _SavedNewsScreenState();
}

class _SavedNewsScreenState extends State<SavedNewsScreen> {
  List<Map<String, dynamic>> _savedNews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedNews();
  }

  Future<void> _loadSavedNews() async {
    final items = await SavedNews.getSavedNews();
    if (!mounted) return;
    setState(() {
      _savedNews = items;
      _isLoading = false;
    });
  }

  Future<void> _refreshSavedNews() async {
    await _loadSavedNews();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        title: Text(
          'Saved Ones',
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedNews.isEmpty
              ? _buildEmptyState(textPrimary, textSecondary)
              : RefreshIndicator(
                  color: AppColors.gradientStart,
                  onRefresh: _refreshSavedNews,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _savedNews.length,
                    itemBuilder: (context, index) {
                      final news = _savedNews[index];
                      return NewsCard(
                        imageUrl: news['imageUrl'] as String? ?? '',
                        title: news['title'] as String? ?? 'Untitled',
                        description:
                            news['description'] as String? ?? 'No description',
                        fullContent:
                            news['fullContent'] as String? ?? 'No details',
                        author: news['author'] as String? ?? 'Unknown',
                        timeAgo: news['timeAgo'] as String? ?? '',
                        onSaveToggle: (isSaved) {
                          if (!isSaved) {
                            _loadSavedNews();
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState(Color textPrimary, Color textSecondary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: 56,
              color: AppColors.gradientStart,
            ),
            const SizedBox(height: 16),
            Text(
              'No saved stories yet',
              style: FontUtils.bold(size: 18, color: textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the bookmark icon on any article to keep it here for quick access.',
              style: FontUtils.regular(size: 14, color: textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

