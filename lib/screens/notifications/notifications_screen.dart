import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif-1',
      'title': 'Morning briefing ready',
      'summary': 'Catch up on the headlines tailored to your interests.',
      'time': 'Just now',
      'isRead': false,
      'article': {
        'title': 'Morning Brief: Top Stories for Today',
        'imageUrl':
            'https://images.unsplash.com/photo-1529333166437-7750a6dd5a70?w=960',
        'content':
            'Stay ahead with the biggest developments this morning. From policy changes to market swings, we have curated the top five stories you need to know before you start your day. Tap any headline inside the brief to read the full coverage.',
      },
    },
    {
      'id': 'notif-2',
      'title': 'Quiz challenge live',
      'summary': 'Test your knowledge in today\'s current affairs quiz.',
      'time': '20 min ago',
      'isRead': false,
      'article': {
        'title': 'Today\'s Current Affairs Quiz',
        'imageUrl':
            'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=960',
        'content':
            'Five quick questions on global headlines, economics, and science. Earn streak points and compare scores with your friends. Ready to take the challenge?',
      },
    },
    {
      'id': 'notif-3',
      'title': 'Saved story updated',
      'summary': 'A story you saved has a new follow-up article.',
      'time': '1 hr ago',
      'isRead': false,
      'article': {
        'title': 'Infrastructure Overhaul: What\'s New',
        'imageUrl':
            'https://images.unsplash.com/photo-1501696461415-6bd6660c6741?w=960',
        'content':
            'The metro expansion project you bookmarked now has updated timelines and budget allocations. Explore the latest milestones and how commuters will benefit.',
      },
    },
    {
      'id': 'notif-4',
      'title': 'Welcome to First Report',
      'summary': 'Let’s personalise your feed by picking favourite categories.',
      'time': 'Yesterday',
      'isRead': true,
      'article': {
        'title': 'Personalise Your News Feed',
        'imageUrl':
            'https://images.unsplash.com/photo-1517638851339-4aa32003c11a?w=960',
        'content':
            'Follow topics such as Economy, Space, Education, and Culture to get a curated stream of updates. You can change your preferences anytime from Settings.',
      },
    },
  ];

  void _markAllRead() {
    setState(() {
      for (final notification in _notifications) {
        notification['isRead'] = true;
      }
    });
  }

  void _removeNotification(int index) {
    if (index < 0 || index >= _notifications.length) return;
    setState(() {
      _notifications.removeAt(index);
    });
  }

  Future<void> _openNotification(int index) async {
    final notification = _notifications[index];
    setState(() {
      notification['isRead'] = true;
    });

    final article = notification['article'] as Map<String, dynamic>?;
    if (article == null) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NotificationDetailScreen(article: article),
      ),
    );
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
          'Notifications',
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: FontUtils.bold(size: 14, color: AppColors.gradientStart),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState(textPrimary, textSecondary, cardColor)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                final isUnread = !(notification['isRead'] as bool);

                return Dismissible(
                  key: ValueKey(notification['id'] as String),
                  direction: DismissDirection.horizontal,
                  background: _buildSwipeBackground(Alignment.centerLeft),
                  secondaryBackground:
                      _buildSwipeBackground(Alignment.centerRight),
                  onDismissed: (_) => _removeNotification(index),
                  child: _NotificationTile(
                    title: notification['title'] as String,
                    summary: notification['summary'] as String,
                    time: notification['time'] as String,
                    isUnread: isUnread,
                    cardColor: cardColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onTap: () => _openNotification(index),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSwipeBackground(Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 24),
    );
  }

  Widget _buildEmptyState(
    Color textPrimary,
    Color textSecondary,
    Color cardColor,
  ) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              color: AppColors.gradientStart,
              size: 36,
            ),
            const SizedBox(height: 16),
            Text(
              'Nothing new right now',
              style: FontUtils.bold(size: 18, color: textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'When breaking stories arrive, you\'ll see them here instantly.',
              style: FontUtils.regular(size: 14, color: textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String summary;
  final String time;
  final bool isUnread;
  final Color cardColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.title,
    required this.summary,
    required this.time,
    required this.isUnread,
    required this.cardColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isUnread)
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(right: 8, top: 4),
                        decoration: const BoxDecoration(
                          color: AppColors.gradientStart,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: FontUtils.bold(size: 15, color: textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            summary,
                            style: FontUtils.regular(
                              size: 13,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      time,
                      style: FontUtils.regular(size: 12, color: textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  const NotificationDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          article['title'] as String? ?? 'Notification',
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
        backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
        iconTheme: IconThemeData(color: textPrimary),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['imageUrl'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article['imageUrl'] as String,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    width: double.infinity,
                    color: AppColors.backgroundLightGrey,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: AppColors.textLightGrey,
                      size: 48,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              article['title'] as String,
              style: FontUtils.bold(size: 24, color: textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              article['content'] as String,
              style: FontUtils.regular(size: 16, color: textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
