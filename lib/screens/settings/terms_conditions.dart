import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/services/language_service.dart';
import 'package:firstreport/models/language_api_model.dart';
import 'package:firstreport/utils/language_preference.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
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

    final termsTitle = _translations?.termsConditions ?? 'Terms & Conditions';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          termsTitle,
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
                'Acceptance of Terms',
                style: FontUtils.bold(size: 18, color: textPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                'By using First Report, you agree to these Terms & Conditions. If you do not agree, please discontinue use of the application.',
                style: FontUtils.regular(size: 14, color: textSecondary),
              ),
              const SizedBox(height: 20),
              _buildSection(
                title: 'Use of Content',
                body:
                    'All news content, images, and brand assets are the property of First Report or its content providers. '
                    'You may view, share, and save content for personal, non-commercial use only.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: 'User Conduct',
                body:
                    'Users are prohibited from using the app for any illegal activities, '
                    'harassment, or attempts to disrupt service. Misuse may result in account termination.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: 'Data Accuracy',
                body:
                    'While we strive for accuracy, First Report does not guarantee the absolute correctness of all news items. '
                    'Content is provided for informational purposes only.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: 'Intellectual Property',
                body:
                    'The First Report name, logo, and app design are protected under intellectual property laws. '
                    'Unauthorized reproduction or redistribution is strictly prohibited.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              _buildSection(
                title: 'Limitation of Liability',
                body:
                    'First Report is not liable for any direct or indirect damages arising from the use of the application '
                    'or reliance on its content.',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              const SizedBox(height: 12),
              Text(
                'Terms are subject to change. Continued use after updates signifies acceptance of the new terms.',
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
