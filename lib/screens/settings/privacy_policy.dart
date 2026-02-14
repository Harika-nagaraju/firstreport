import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/services/language_service.dart';
import 'package:firstreport/models/language_api_model.dart';
import 'package:firstreport/utils/language_preference.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  Translations? _translations;
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark
        ? AppColors.darkBackground
        : AppColors.screenBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textDarkGrey;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textLightGrey;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final privacyTitle = _translations?.privacyPolicy ?? 'Privacy Policy';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          privacyTitle,
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
        backgroundColor: cardColor,
        iconTheme: IconThemeData(color: textPrimary),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.35)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Privacy Matters',
                style: FontUtils.bold(size: 18, color: textPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                'This Privacy Policy explains how First Report collects, uses, and safeguards your personal information. '
                'We are committed to maintaining your trust and protecting your data.',
                style: FontUtils.regular(size: 14, color: textSecondary),
              ),
              const SizedBox(height: 20),
              _buildSection(
                title: 'Information We Collect',
                body: '''
• Profile details such as name, email, phone, and location when you register.
• Preferences like language selections and notification choices.
• Usage data including saved articles and in-app interactions.''',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: 'How We Use Information',
                body: '''
• To personalize the news experience and surface relevant content.
• To communicate updates, quizzes, and alerts based on your preferences.
• To improve app performance, troubleshoot issues, and analyze trends.''',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: 'Data Protection',
                body:
                    'We use encryption, secure storage, and access controls to protect your data. '
                    'Only authorized team members can access personal information when necessary.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: 'Your Choices',
                body:
                    'You can update your profile, manage notification settings, and change language preferences at any time. '
                    'You may request data deletion by contacting support@firstreport.app.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: 'Policy Updates',
                body:
                    'We may update this policy to reflect new features or legal requirements. '
                    'Changes will be posted in-app, and continued use constitutes acceptance.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              const SizedBox(height: 12),
              Text(
                'If you have any questions about privacy or data protection, please contact support@firstreport.app.',
                style: FontUtils.regular(size: 14, color: textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String body,
    required Color color,
    required Color subtitleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: FontUtils.bold(size: 16, color: color)),
          const SizedBox(height: 8),
          Text(body, style: FontUtils.regular(size: 14, color: subtitleColor)),
        ],
      ),
    );
  }
}
