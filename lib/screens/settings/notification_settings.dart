import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/services/language_service.dart';
import 'package:firstreport/models/language_api_model.dart';
import 'package:firstreport/utils/language_preference.dart';
import 'package:firstreport/services/auth_service.dart';
import 'package:firstreport/utils/user_registration.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  Translations? _translations;
  bool _isLoading = true;

  bool _pushNotifications = true;
  bool _breakingNews = true;
  bool _trendingNews = false;
  bool _quizReminders = true;
  bool _postUpdates = true;

  TimeOfDay _quietFrom = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietTo = const TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    final languageCode = await LanguagePreference.getLanguageCode() ?? 'en';
    final response = await LanguageService.getTranslations(languageCode);
    if (mounted) {
      setState(() {
        _translations = response.translations;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    final token = await UserRegistration.getToken();
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to save notification settings'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final notificationPreferences = {
      'allNotifications': _pushNotifications,
      'breakingNews': _breakingNews,
      'trendingNews': _trendingNews,
      'quizReminders': _quizReminders,
      'postUpdates': _postUpdates,
    };

    final quietHours = {
      'from': _quietFrom.format(context),
      'to': _quietTo.format(context),
    };

    final response = await AuthService.updateSettings(
      token: token,
      notificationPreferences: notificationPreferences,
      quietHours: quietHours,
    );

    if (mounted) {
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.screenBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final notificationsLabel = _translations?.notifications ?? 'Notifications';
    const stayUpdatedLabel = 'Stay Updated';
    const customizeLabel = 'Customize your notification preferences to stay informed about the news that matters to you.';
    final pushNotificationsLabel = _translations?.notifications ?? 'Push Notifications';
    const receivePushLabel = 'Receive push notifications';
    const breakingNewsLabel = 'Breaking News Alerts';
    const getNotifiedBreakingLabel = 'Get notified of breaking news';
    const trendingNewsLabel = 'Trending News';
    const dailyTrendingLabel = 'Daily trending news digest';
    const quizRemindersLabel = 'Quiz Reminders';
    const dailyQuizLabel = 'Daily quiz challenges';
    final postUpdatesLabel = _translations?.post ?? 'Post Updates';
    const updatesOnPostedLabel = 'Updates on your posted news';
    const quietHoursLabel = 'Quiet Hours';
    const muteNotificationsLabel = 'Mute notifications during these hours';
    const fromLabel = 'From';
    const toLabel = 'To';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          notificationsLabel,
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
                  stayUpdatedLabel,
                  style: FontUtils.bold(
                    size: 18,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  customizeLabel,
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
            title: pushNotificationsLabel,
            subtitle: receivePushLabel,
            value: _pushNotifications,
            onChanged: (v) {
              setState(() => _pushNotifications = v);
              _saveSettings();
            },
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _buildToggleCard(
            title: breakingNewsLabel,
            subtitle: getNotifiedBreakingLabel,
            value: _breakingNews,
            onChanged: (v) {
              setState(() => _breakingNews = v);
              _saveSettings();
            },
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _buildToggleCard(
            title: trendingNewsLabel,
            subtitle: dailyTrendingLabel,
            value: _trendingNews,
            onChanged: (v) {
              setState(() => _trendingNews = v);
              _saveSettings();
            },
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _buildToggleCard(
            title: quizRemindersLabel,
            subtitle: dailyQuizLabel,
            value: _quizReminders,
            onChanged: (v) {
              setState(() => _quizReminders = v);
              _saveSettings();
            },
            cardColor: cardColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _buildToggleCard(
            title: postUpdatesLabel,
            subtitle: updatesOnPostedLabel,
            value: _postUpdates,
            onChanged: (v) {
              setState(() => _postUpdates = v);
              _saveSettings();
            },
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
                  quietHoursLabel,
                  style: FontUtils.bold(size: 15, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  muteNotificationsLabel,
                  style: FontUtils.regular(size: 12, color: textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeField(
                        label: fromLabel,
                        time: _quietFrom,
                        onTap: () => _pickTime(isFrom: true),
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTimeField(
                        label: toLabel,
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
    _saveSettings();
  }
}
