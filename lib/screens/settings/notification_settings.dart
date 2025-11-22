import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/l10n/app_localizations.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _breakingNews = true;
  bool _trendingNews = false;
  bool _quizReminders = true;
  bool _postUpdates = true;

  TimeOfDay _quietFrom = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietTo = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.screenBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          loc.notifications,
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gradient header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: AppColors.buttonGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.stayUpdated,
                  style: FontUtils.bold(
                    size: 18,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.customizeNotificationPreferences,
                  style: FontUtils.regular(
                    size: 13,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildToggleCard(
            title: loc.pushNotifications,
            subtitle: loc.receivePushNotifications,
            value: _pushNotifications,
            onChanged: (v) => setState(() => _pushNotifications = v),
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _buildToggleCard(
            title: loc.breakingNewsAlerts,
            subtitle: loc.getNotifiedBreakingNews,
            value: _breakingNews,
            onChanged: (v) => setState(() => _breakingNews = v),
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _buildToggleCard(
            title: loc.trendingNews,
            subtitle: loc.dailyTrendingDigest,
            value: _trendingNews,
            onChanged: (v) => setState(() => _trendingNews = v),
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _buildToggleCard(
            title: loc.quizReminders,
            subtitle: loc.dailyQuizChallenges,
            value: _quizReminders,
            onChanged: (v) => setState(() => _quizReminders = v),
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _buildToggleCard(
            title: loc.postUpdates,
            subtitle: loc.updatesOnPostedNews,
            value: _postUpdates,
            onChanged: (v) => setState(() => _postUpdates = v),
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 24),
          // Quiet hours
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.quietHours,
                  style: FontUtils.bold(size: 15, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.muteNotificationsDuringHours,
                  style: FontUtils.regular(size: 12, color: textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeField(
                        label: loc.from,
                        time: _quietFrom,
                        onTap: () => _pickTime(isFrom: true),
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTimeField(
                        label: loc.to,
                        time: _quietTo,
                        onTap: () => _pickTime(isFrom: false),
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
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

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontUtils.bold(size: 15, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: FontUtils.regular(size: 12, color: textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.gradientStart,
          ),
        ],
      ),
    );
  }
 
  Widget _buildTimeField({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: FontUtils.regular(size: 12, color: textSecondary),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(context),
                  style: FontUtils.bold(size: 14, color: textPrimary),
                ),
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime({required bool isFrom}) async {
    final initialTime = isFrom ? _quietFrom : _quietTo;
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _quietFrom = picked;
      } else {
        _quietTo = picked;
      }
    });
  }
}
