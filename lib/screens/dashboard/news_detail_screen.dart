import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String content;
  final String author;
  final DateTime publishedAt;
  final String? sourceUrl;

  const NewsDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.author,
    required this.publishedAt,
    this.sourceUrl,
  });

  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  String _cleanText(String text) {
    return text.replaceAll(RegExp(r'\[\+\d+ chars\]'), '').trim();
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
      body: CustomScrollView(
        slivers: [
          // Premium Sliver AppBar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.gradientStart,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  String cleanContent = _cleanText(content);
                  String shareText = '$title\n\n$cleanContent';
                  
                  if (sourceUrl != null && sourceUrl!.isNotEmpty) {
                    shareText += '\n\nRead more at: $sourceUrl';
                  }
                  
                  shareText += '\n\nShared via First Report App';
                  
                  Share.share(shareText);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  imageUrl.isEmpty
                      ? Center(
                          child: Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                              'assets/images/app_icon.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Opacity(
                              opacity: 0.5,
                              child: Image.asset(
                                'assets/images/app_icon.png',
                                width: 150,
                                height: 150,
                              ),
                            ),
                          ),
                        ),
                  // Gradient Overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category/Author Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gradientStart.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      author.toUpperCase(),
                      style: FontUtils.bold(size: 12, color: AppColors.gradientStart),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    title,
                    style: FontUtils.bold(size: 24, color: textPrimary),
                  ),
                  const SizedBox(height: 12),
                  
                  // Date and Time
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('MMM dd, yyyy • hh:mm a').format(publishedAt),
                        style: FontUtils.regular(size: 13, color: textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  
                  // Content
                  Text(
                    _cleanText(content),
                    style: FontUtils.regular(size: 16, color: textPrimary, height: 1.6),
                  ),
                  
                  // Read Full Article Primary Button
                  if ((content.endsWith('...') || content.length < 300) && sourceUrl != null && sourceUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: AppColors.buttonGradient,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gradientStart.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => _launchURL(sourceUrl),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                'Read Full Article on Website',
                                style: FontUtils.bold(size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'The free news API provides a summary. Tap above to read the full story on the official website.',
                            textAlign: TextAlign.center,
                            style: FontUtils.regular(size: 12, color: textSecondary),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 32),
                  
                  const SizedBox(height: 32),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
