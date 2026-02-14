import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/utils/language_preference.dart';
import 'package:firstreport/screens/dashboard/dashboard.dart';
import 'package:firstreport/main.dart';
import 'package:firstreport/models/language_api_model.dart';
import 'package:firstreport/services/language_service.dart';
import 'package:firstreport/providers/language_provider.dart';

class LanguageSelection extends StatefulWidget {
  final bool fromSettings;

  const LanguageSelection({super.key, this.fromSettings = false});

  @override
  State<LanguageSelection> createState() =>
      _LanguageSelectionState();
}

class _LanguageSelectionState
    extends State<LanguageSelection> {
  String? selectedLanguage;
  Translations? apiTranslations;
  bool isLoading = true;
  String? errorMessage;

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
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final savedLanguage = await LanguagePreference.getLanguageName();
    final initialLanguage = savedLanguage ?? 'English';
    
    if (mounted) {
      setState(() {
        selectedLanguage = initialLanguage;
      });
      await _fetchApiTranslations(initialLanguage);
    }
  }

  Future<void> _fetchApiTranslations(String languageName) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final code = LanguagePreference.languages[languageName]?['code'] ?? 'en';
      final response = await LanguageService.fetchLanguageData(code);
      
      if (mounted) {
        setState(() {
          apiTranslations = response.translations;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching translations: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load language data. Please check your connection.';
        });
      }
    }
  }

  void _onLanguageSelected(String language) {
    setState(() {
      selectedLanguage = language;
    });
    _fetchApiTranslations(language);
  }

  Future<void> _onContinue() async {
    if (selectedLanguage == null) return;

    await LanguagePreference.saveLanguage(selectedLanguage!);
    final languageCode = LanguagePreference.languages[selectedLanguage!]!['code']!;

    if (mounted) {
      // Use Provider to change language instantly
      Provider.of<LanguageProvider>(context, listen: false)
          .changeLanguage(languageCode);

      if (widget.fromSettings) {
        Navigator.of(context).pop(true);
      } else {
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

    // Show loading screen while fetching API data
    if (isLoading && apiTranslations == null) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.gradientStart),
        ),
      );
    }

    // Show error screen if API failed
    if (errorMessage != null && apiTranslations == null) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: FontUtils.regular(size: 16, color: textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _loadInitialData(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gradientStart,
                ),
                child: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

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
          apiTranslations!.chooseLanguage,
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                                "Language", // This is static or could be from API if added to model
                                style: FontUtils.bold(size: 18, color: textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                apiTranslations!.selectLanguage,
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
                        if (isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Icon(Icons.keyboard_arrow_down, size: 20, color: textSecondary),
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
                              child: Row(
                                children: [
                                  Expanded(
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
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle, 
                                      color: AppColors.gradientStart, 
                                      size: 20
                                    ),
                                ],
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
          ),
          
          // Continue Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (isLoading || apiTranslations == null) ? null : _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gradientStart,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  apiTranslations!.continueText,
                  style: FontUtils.bold(size: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
