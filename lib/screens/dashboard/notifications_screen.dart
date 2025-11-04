import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _breakingNews = true;
  bool _trendingNews = false;
  bool _quizReminders = true;
  bool _postUpdates = true;
  TimeOfDay? _quietHoursFrom;
  TimeOfDay? _quietHoursTo;

  @override
  void initState() {
    super.initState();
    // Set default quiet hours
    _quietHoursFrom = const TimeOfDay(hour: 22, minute: 0); // 10:00 PM
    _quietHoursTo = const TimeOfDay(hour: 7, minute: 0); // 7:00 AM
  }

  Future<void> _selectTime(BuildContext context, bool isFrom) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? (_quietHoursFrom ?? const TimeOfDay(hour: 22, minute: 0)) 
                          : (_quietHoursTo ?? const TimeOfDay(hour: 7, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _quietHoursFrom = picked;
        } else {
          _quietHoursTo = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour == 0 ? 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: FontUtils.bold(
                      size: 16,
                      color: textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: FontUtils.regular(
                      size: 12,
                      color: textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.gradientStart,
            ),
          ],
        ),
      ),
    );
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
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.backgroundLightGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: textPrimary,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Notifications',
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stay Updated Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stay Updated',
                          style: FontUtils.bold(
                            size: 18,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Customize your notification preferences to stay informed about the news that matters to you.',
                          style: FontUtils.regular(
                            size: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Notification Settings
            _buildNotificationCard(
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              value: _pushNotifications,
              onChanged: (value) => setState(() => _pushNotifications = value),
            ),
            _buildNotificationCard(
              icon: Icons.newspaper,
              title: 'Breaking News Alerts',
              subtitle: 'Get notified of breaking news',
              value: _breakingNews,
              onChanged: (value) => setState(() => _breakingNews = value),
            ),
            _buildNotificationCard(
              icon: Icons.trending_up,
              title: 'Trending News',
              subtitle: 'Daily trending news digest',
              value: _trendingNews,
              onChanged: (value) => setState(() => _trendingNews = value),
            ),
            _buildNotificationCard(
              icon: Icons.quiz,
              title: 'Quiz Reminders',
              subtitle: 'Daily quiz challenges',
              value: _quizReminders,
              onChanged: (value) => setState(() => _quizReminders = value),
            ),
            _buildNotificationCard(
              icon: Icons.article,
              title: 'Post Updates',
              subtitle: 'Updates on your posted news',
              value: _postUpdates,
              onChanged: (value) => setState(() => _postUpdates = value),
            ),
            // Quiet Hours Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiet Hours',
                    style: FontUtils.bold(
                      size: 16,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mute notifications during these hours',
                    style: FontUtils.regular(
                      size: 12,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTime(context, true),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkInputBackground : AppColors.inputBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From',
                                  style: FontUtils.regular(
                                    size: 12,
                                    color: textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _quietHoursFrom != null
                                      ? _formatTime(_quietHoursFrom!)
                                      : '10:00 PM',
                                  style: FontUtils.regular(
                                    size: 14,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTime(context, false),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkInputBackground : AppColors.inputBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'To',
                                  style: FontUtils.regular(
                                    size: 12,
                                    color: textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _quietHoursTo != null
                                      ? _formatTime(_quietHoursTo!)
                                      : '7:00 AM',
                                  style: FontUtils.regular(
                                    size: 14,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

