import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String content;
  final String author;
  final DateTime publishedAt;

  const NewsDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.author,
    required this.publishedAt,
  });

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
                  String shareText = '$title\n\n$cleanContent\n\nShared via First Report App';
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: content
                        .split('\n\n')
                        .map((paragraph) => Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: Text(
                                paragraph.trim(),
                                textAlign: TextAlign.justify,
                                style: FontUtils.regular(
                                  size: 17,
                                  height: 1.8,
                                  color: textPrimary,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  
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
