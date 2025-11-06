import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/language_preference.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/widgets/language_card.dart';
import 'package:newsapp/widgets/custom_button.dart';
import 'package:newsapp/screens/dashboard/dashboard.dart';
import 'package:newsapp/main.dart';

class LanguageSelection extends StatefulWidget {
  final bool fromSettings;

  const LanguageSelection({super.key, this.fromSettings = false});

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String selectedLanguage = 'English';
  AppLocalizations? _localizations;

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
    if (savedLanguage != null && languages.contains(savedLanguage)) {
      setState(() {
        selectedLanguage = savedLanguage;
      });
    }
  }

  Future<void> _saveAndContinue() async {
    // Save the selected language
    await LanguagePreference.saveLanguage(selectedLanguage);

    // Get the language code and country code
    final languageCode =
        LanguagePreference.languages[selectedLanguage]!['code']!;
    final countryCode =
        LanguagePreference.languages[selectedLanguage]!['country']!;

    // Update app locale immediately
    if (mounted) {
      // Update the locale in MyApp using the global key
      MyApp.instance?.setLocale(Locale(languageCode, countryCode));

      // Navigate based on where we came from
      if (widget.fromSettings) {
        // If from settings, just pop back
        Navigator.of(context).pop(true);
      } else {
        // If from splash, navigate to dashboard
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Dashboard()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Title
            Text(
              _localizations?.chooseLanguage ?? 'Choose Your Language',
              textAlign: TextAlign.center,
              style: FontUtils.bold(size: 24, color: AppColors.textDarkGrey),
            ),
            const SizedBox(height: 8),
            // Subtitle
            Text(
              _localizations?.selectLanguage ??
                  'Select your preferred language',
              textAlign: TextAlign.center,
              style: FontUtils.regular(
                size: 14,
                color: AppColors.textLightGrey,
              ),
            ),
            const SizedBox(height: 48),
            // Language Options List
            ...languages.map((language) {
              return LanguageCard(
                language: language,
                isSelected: selectedLanguage == language,
                onTap: () {
                  setState(() {
                    selectedLanguage = language;
                  });
                },
              );
            }).toList(),
            const Spacer(),
            // Continue Button
            CustomButton(
              text: _localizations?.continueText ?? 'Continue',
              onPressed: _saveAndContinue,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
