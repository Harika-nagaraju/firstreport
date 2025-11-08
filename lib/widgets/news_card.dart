import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/saved_news.dart';

class NewsCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String fullContent; // Full news content for expansion
  final String author;
  final String timeAgo;
  final VoidCallback? onReadMore;
  final VoidCallback? onSave;
  final ValueChanged<bool>? onSaveToggle;

  const NewsCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.fullContent,
    required this.author,
    required this.timeAgo,
    this.onReadMore,
    this.onSave,
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

  @override
  void initState() {
    super.initState();
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
      // Start speaking
      await _speakNews();
    } else {
      // Stop speaking
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
    final text = '${widget.title}\n\n${widget.description}\n\nRead more on First Report';
    await Share.share(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 200,
              width: double.infinity,
              color: chipBackground,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: chipBackground,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: textSecondary,
                    ),
                  );
                },
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
                // Description (collapsible)
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Text(
                    widget.description,
                    style: FontUtils.regular(
                      size: 14,
                      color: textSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondChild: Text(
                    widget.fullContent,
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
                    // Like Button (Icon Only)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: chipBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isLiked ? Colors.red : textSecondary,
                        ),
                      ),
                    ),
                    // Share Button
                    GestureDetector(
                      onTap: _shareNews,
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
                              'Share',
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
                    // Read More Button (no gradient)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                        if (widget.onReadMore != null) {
                          widget.onReadMore!();
                        }
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
                        child: Text(
                          isExpanded ? 'Read Less' : 'Read More',
                          style: FontUtils.regular(
                            size: 12,
                            color: textPrimary,
                          ),
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

