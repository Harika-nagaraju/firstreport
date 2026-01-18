import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
        backgroundColor: cardColor,
        iconTheme: IconThemeData(color: textPrimary),
        elevation: 0,
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
                    ? Colors.black.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to First Report',
                style: FontUtils.bold(size: 18, color: textPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                'These Terms & Conditions govern your use of the First Report application. '
                'By accessing or using the app, you agree to be bound by these terms. '
                'Please read them carefully before proceeding.',
                style: FontUtils.regular(size: 14, color: textSecondary),
              ),
              const SizedBox(height: 20),
              _buildSection(
                title: '1. Acceptance of Terms',
                body:
                    'Your access to and use of First Report is conditioned on your acceptance of and '
                    'compliance with these terms. If you disagree with any part, you may not access the service.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: '2. Use of Content',
                body:
                    'The news articles and media in First Report are provided for informational purposes only. '
                    'You agree not to copy, distribute, or exploit any part of the content without permission.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: '3. User Accounts',
                body:
                    'When you create an account, you must provide accurate information. '
                    'It is your responsibility to safeguard your password and any activities under your account.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: '4. Privacy',
                body:
                    'Please review our Privacy Policy to understand how we collect and use your personal data. '
                    'By using the service, you consent to the collection and use of information as described.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: '5. Changes to Terms',
                body:
                    'We may revise these terms from time to time. The revised version will be effective at the time '
                    'it is posted. Continued use of the app constitutes acceptance of any modifications.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              const SizedBox(height: 12),
              Text(
                'If you have any questions about these Terms & Conditions, please reach out to support@firstreport.app.',
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
