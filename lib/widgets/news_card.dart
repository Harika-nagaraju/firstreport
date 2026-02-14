import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/utils/saved_news.dart';
import 'package:firstreport/screens/dashboard/news_detail_screen.dart';

class NewsCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String fullContent; 
  final String author;
  final String timeAgo;
  final DateTime publishedAt;
  final String? sourceUrl;
  final int initialLikes;
  final int initialShares;
  final VoidCallback? onSave;
  final VoidCallback? onLike;
  final VoidCallback? onShare;
  final ValueChanged<bool>? onSaveToggle;

  const NewsCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.fullContent,
    required this.author,
    required this.timeAgo,
    required this.publishedAt,
    this.sourceUrl,
    this.initialLikes = 0,
    this.initialShares = 0,
    this.onSave,
    this.onLike,
    this.onShare,
    this.onSaveToggle,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  final FlutterTts flutterTts = FlutterTts();
  bool isMicEnabled = false;
  bool isSpeaking = false;
  bool isExpanded = false;
  bool isSaved = false;
  bool isLiked = false;
  late int likesCount;
  late int sharesCount;

  @override
  void initState() {
    super.initState();
    likesCount = widget.initialLikes;
    sharesCount = widget.initialShares;
    _initializeTts();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final saved = await SavedNews.isNewsSaved(widget.title);
    setState(() {
      isSaved = saved;
    });
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future<void> _toggleMic() async {
    setState(() {
      isMicEnabled = !isMicEnabled;
    });

    if (isMicEnabled) {
      await _speakNews();
    } else {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    }
  }

  Future<void> _speakNews() async {
    if (!isMicEnabled) return;
    final fullText = '${widget.title}. ${widget.description}';
    setState(() {
      isSpeaking = true;
    });
    await flutterTts.speak(fullText);
  }

  Future<void> _shareNews() async {
    String cleanContent = _cleanText(widget.fullContent);
    String shareText = '${widget.title}\n\n$cleanContent';
    
    if (widget.sourceUrl != null && widget.sourceUrl!.isNotEmpty) {
      shareText += '\n\nRead more at: ${widget.sourceUrl}';
    }
    
    shareText += '\n\nShared via First Report App';
    
    await Share.share(shareText);
    setState(() {
      sharesCount++;
    });
    if (widget.onShare != null) {
      widget.onShare!();
    }
  }

  void _navigateToDetail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewsDetailScreen(
          imageUrl: widget.imageUrl,
          title: widget.title,
          content: widget.fullContent,
          author: widget.author,
          publishedAt: widget.publishedAt,
          sourceUrl: widget.sourceUrl,
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  String _cleanText(String text) {
    // Removes the "[+227 chars]" or similar suffix often added by NewsAPI
    return text.replaceAll(RegExp(r'\[\+\d+ chars\]'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;
    final chipBackground =
        isDark ? AppColors.darkInputBackground : AppColors.backgroundLightGrey;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // News Image
          GestureDetector(
            onTap: _navigateToDetail,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 200,
                width: double.infinity,
                color: chipBackground,
                child: widget.imageUrl.isEmpty 
                  ? Center(
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        width: 120, // Medium size for placeholder
                        height: 120,
                        opacity: const AlwaysStoppedAnimation(0.3), // Subtly branded
                      ),
                    )
                  : Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Image.asset(
                            'assets/images/app_icon.png',
                            width: 120,
                            height: 120,
                            opacity: const AlwaysStoppedAnimation(0.3),
                          ),
                        );
                      },
                    ),
              ),
            ),
          ),
          // News Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with Volume Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _navigateToDetail,
                        child: Text(
                          widget.title,
                          style: FontUtils.bold(
                            size: 18,
                            color: textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Volume/Mic Icon
                    GestureDetector(
                      onTap: _toggleMic,
                      child: Icon(
                        isMicEnabled ? Icons.volume_up : Icons.volume_off,
                        size: 24,
                        color: isMicEnabled
                            ? AppColors.gradientStart
                            : textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Description with Expansion Logic
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Text(
                    _cleanText(widget.description),
                    style: FontUtils.regular(
                      size: 14,
                      color: textSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondChild: Text(
                    _cleanText(widget.fullContent),
                    style: FontUtils.regular(
                      size: 14,
                      color: textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Author and Time
                Row(
                  children: [
                    Text(
                      '${widget.author} • ${widget.timeAgo}',
                      style: FontUtils.regular(
                        size: 12,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action Buttons Row
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    // Like Button with Counter
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!isLiked) {
                            isLiked = true;
                            likesCount++;
                            if (widget.onLike != null) {
                              widget.onLike!();
                            }
                          } else {
                            isLiked = false;
                            likesCount--;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: chipBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: isLiked ? Colors.red : textSecondary,
                            ),
                            if (likesCount > 0) ...[
                              const SizedBox(width: 6),
                              Text(
                                '$likesCount',
                                style: FontUtils.regular(
                                  size: 12,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    // Share Button with Counter
                    GestureDetector(
                      onTap: () {
                        String cleanContent = _cleanText(widget.fullContent);
                        String shareText = '${widget.title}\n\n$cleanContent';
                        
                        if (widget.sourceUrl != null && widget.sourceUrl!.isNotEmpty) {
                          shareText += '\n\nRead more at: ${widget.sourceUrl}';
                        }
                        
                        shareText += '\n\nShared via First Report App';
                        
                        Share.share(shareText);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: chipBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.share,
                              size: 18,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              sharesCount > 0 ? '$sharesCount' : 'Share',
                              style: FontUtils.regular(
                                size: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Save Button
                    GestureDetector(
                      onTap: () async {
                        bool newSavedState;
                        if (isSaved) {
                          await SavedNews.removeNews(widget.title);
                          newSavedState = false;
                        } else {
                          await SavedNews.saveNews({
                            'imageUrl': widget.imageUrl,
                            'title': widget.title,
                            'description': widget.description,
                            'fullContent': widget.fullContent,
                            'author': widget.author,
                            'timeAgo': widget.timeAgo,
                            'publishedAt': widget.publishedAt.toIso8601String(),
                            'sourceUrl': widget.sourceUrl,
                          });
                          if (widget.onSave != null) {
                            widget.onSave!();
                          }
                          newSavedState = true;
                        }
                        setState(() {
                          isSaved = newSavedState;
                        });
                        widget.onSaveToggle?.call(newSavedState);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSaved
                              ? AppColors.gradientStart.withOpacity(0.12)
                              : chipBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: isSaved
                              ? Border.all(
                                  color: AppColors.gradientStart,
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              size: 18,
                              color: isSaved
                                  ? AppColors.gradientStart
                                  : textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Save',
                              style: FontUtils.regular(
                                size: 12,
                                color: isSaved
                                    ? AppColors.gradientStart
                                    : textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


