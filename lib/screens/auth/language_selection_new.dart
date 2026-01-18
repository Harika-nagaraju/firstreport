import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/language_preference.dart';
import 'package:newsapp/screens/dashboard/dashboard.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/main.dart';

class LanguageSelectionScreenNew extends StatefulWidget {
  final bool fromSettings;

  const LanguageSelectionScreenNew({super.key, this.fromSettings = false});

  @override
  State<LanguageSelectionScreenNew> createState() =>
      _LanguageSelectionScreenNewState();
}

class _LanguageSelectionScreenNewState
    extends State<LanguageSelectionScreenNew> {
  String? selectedLanguage;

  final List<String> languages = [
    'English',
    'Hindi',
    'Telugu',
    'Tamil',
    'Kannada',
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLanguage = await LanguagePreference.getLanguageName();
    if (mounted) {
      setState(() {
        selectedLanguage = savedLanguage ?? 'English';
      });
    }
  }

  Future<void> _onLanguageSelected(String language) async {
    await LanguagePreference.saveLanguage(language);
    final languageCode = LanguagePreference.languages[language]!['code']!;
    final countryCode = LanguagePreference.languages[language]!['country']!;

    if (mounted) {
      setState(() {
        selectedLanguage = language;
      });

      MyApp.instance?.setLocale(Locale(languageCode, countryCode));

      if (widget.fromSettings) {
        Navigator.of(context).pop(true);
      } else {
        // Navigate to dashboard if from splash
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Dashboard()));
      }
    }
  }

  Color _getBackgroundColor(bool isSelected, bool isDark) {
    if (isDark) {
      return isSelected ? AppColors.darkCard : AppColors.darkSurface;
    }
    return isSelected ? AppColors.selectedLanguageBg : AppColors.white;
  }

  Color _getTextColor(bool isSelected, bool isDark) {
    if (isDark) {
      return AppColors.darkTextPrimary;
    }
    return isSelected ? AppColors.selectedLanguageText : AppColors.textDarkGrey;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
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
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface
                  : AppColors.backgroundLightGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: textPrimary, size: 20),
          ),
        ),
        title: Text(
          localizations?.language ?? 'Language',
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.language,
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
                          localizations?.language ?? 'Language',
                          style: FontUtils.bold(size: 18, color: textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedLanguage ??
                              localizations?.getLanguageName('en') ??
                              'English',
                          style: FontUtils.regular(
                            size: 14,
                            color: textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: textSecondary),
                ],
              ),
            ),
            const Divider(height: 1),
            // Language List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: languages.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final language = languages[index];
                  final isSelected = selectedLanguage == language;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onLanguageSelected(language),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _getBackgroundColor(isSelected, isDark),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected && !isDark
                              ? Border.all(
                                  color: AppColors.selectedLanguageText
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Text(
                          language,
                          style: FontUtils.regular(
                            size: 16,
                            color: _getTextColor(isSelected, isDark),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
