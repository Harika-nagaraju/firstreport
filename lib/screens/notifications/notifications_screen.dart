import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/services/notification_service.dart';
import 'package:firstreport/models/notification_model.dart';
import 'package:firstreport/config/api_config.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firstreport/providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final notifications = await NotificationService.getNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
      // Also update the provider count while we're at it
      if (mounted) {
        final unreadCount = _notifications.where((n) => !n.isRead).length;
        context.read<NotificationProvider>().setCount(unreadCount);
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllRead() async {
    // This might need a backend endpoint if available, but for now we can do it locally or per-id
    // If there's no bulk mark-as-read, we can iterate
    for (var notif in _notifications.where((n) => !n.isRead)) {
      await NotificationService.markAsRead(notif.id);
    }
    _fetchNotifications();
  }

  void _removeNotification(int index) {
    // Backend doesn't seem to have a delete endpoint in the prompt, but we can do it locally
    setState(() {
      _notifications.removeAt(index);
    });
  }

  Future<void> _openNotification(int index) async {
    final notification = _notifications[index];
    
    if (!notification.isRead) {
      final success = await NotificationService.markAsRead(notification.id);
      if (success && mounted) {
        context.read<NotificationProvider>().decrementCount();
        setState(() {
          // Update local state without re-fetching everything
          _notifications[index] = NotificationModel(
            id: notification.id,
            title: notification.title,
            message: notification.message,
            type: notification.type,
            image: notification.image,
            isRead: true,
            readBy: [...notification.readBy],
            createdAt: notification.createdAt,
          );
        });
      }
    }

    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => NotificationDetailScreen(notification: _notifications[index]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

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
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: FontUtils.bold(size: 14, color: AppColors.gradientStart),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyState(textPrimary, textSecondary, cardColor)
              : RefreshIndicator(
                  onRefresh: _fetchNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      final isUnread = !notification.isRead;

                      return Dismissible(
                        key: ValueKey(notification.id),
                        direction: DismissDirection.horizontal,
                        background: _buildSwipeBackground(Alignment.centerLeft),
                        secondaryBackground: _buildSwipeBackground(Alignment.centerRight),
                        onDismissed: (_) => _removeNotification(index),
                        child: _NotificationTile(
                          title: notification.title,
                          summary: notification.message,
                          time: _getTimeAgo(notification.createdAt),
                          isUnread: isUnread,
                          cardColor: cardColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          onTap: () => _openNotification(index),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
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

  Widget _buildEmptyState(Color textPrimary, Color textSecondary, Color cardColor) {
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
  final NotificationModel notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    String? imageUrl = notification.image;
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = '${ApiConfig.baseUrl}$imageUrl';
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Notification Detail',
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
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 250,
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
            const SizedBox(height: 24),
            Text(
              notification.title,
              style: FontUtils.bold(size: 24, color: textPrimary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: textSecondary),
                const SizedBox(width: 6),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a').format(notification.createdAt),
                  style: FontUtils.regular(size: 14, color: textSecondary),
                ),
              ],
            ),
            const Divider(height: 48),
            Text(
              notification.message,
              style: FontUtils.regular(size: 16, color: textPrimary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
