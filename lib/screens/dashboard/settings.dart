import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/language_preference.dart';
import 'package:newsapp/utils/theme_preference.dart';
import 'package:newsapp/utils/user_registration.dart';
import 'package:newsapp/screens/auth/language_selection_new.dart';
import 'package:newsapp/screens/dashboard/profile_details.dart';
import 'package:newsapp/screens/dashboard/notifications_screen.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? currentLanguage;
  bool _darkMode = false;
  Map<String, String?> userDetails = {};

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadUserDetails();
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final isDark = await ThemePreference.isDarkMode();
    if (mounted) {
      setState(() {
        _darkMode = isDark;
      });
    }
  }

  Future<void> _loadLanguage() async {
    final languageCode = await LanguagePreference.getLanguageCode();
    final localizations = AppLocalizations(Locale(languageCode ?? 'en', 'US'));
    final languageName = await LanguagePreference.getLanguageName();
    if (mounted) {
      setState(() {
        // Get localized language name
        if (languageName != null) {
          final langMap = LanguagePreference.languages[languageName];
          if (langMap != null) {
            currentLanguage = localizations.getLanguageName(langMap['code']!);
          } else {
            currentLanguage = languageName;
          }
        } else {
          currentLanguage = localizations.getLanguageName(languageCode ?? 'en');
        }
      });
    }
  }

  Future<void> _loadUserDetails() async {
    final details = await UserRegistration.getUserDetails();
    setState(() {
      userDetails = details;
    });
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
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
                if (trailing != null)
                  trailing
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: textSecondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLanguageTap() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LanguageSelectionScreenNew(fromSettings: true),
      ),
    );
    
    if (mounted && result == true) {
      _loadLanguage();
      final languageCode = await LanguagePreference.getLanguageCode();
      final countryCode = await LanguagePreference.getCountryCode();
      MyApp.instance?.setLocale(Locale(languageCode ?? 'en', countryCode ?? 'US'));
    }
  }

  void _handleProfileDetailsTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ProfileDetailsScreen(),
      ),
    );
  }

  void _handleNotificationsTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const NotificationsScreen(),
      ),
    );
  }

  void _handleDarkModeToggle(bool value) async {
    await ThemePreference.setDarkMode(value);
    MyApp.instance?.setThemeMode(value);
    if (mounted) {
      setState(() {
        _darkMode = value;
      });
    }
  }

  void _handlePrivacyPolicyTap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Privacy Policy',
          style: FontUtils.bold(size: 18),
        ),
        content: SingleChildScrollView(
          child: Text(
            'This is the Privacy Policy for First Report. '
            'We are committed to protecting your privacy and personal information. '
            'This policy explains how we collect, use, and safeguard your data.\n\n'
            'Information We Collect:\n'
            '- Personal details (name, email, phone) when you register\n'
            '- News articles you save\n'
            '- Language preferences\n\n'
            'How We Use Your Information:\n'
            '- To provide personalized news content\n'
            '- To save your preferences\n'
            '- To improve our services\n\n'
            'We do not share your personal information with third parties.',
            style: FontUtils.regular(size: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: FontUtils.regular(
                size: 14,
                color: AppColors.textDarkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
        automaticallyImplyLeading: false,
        title: Text(
          localizations?.settings ?? 'Settings',
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  // Language Setting
                  _buildSettingCard(
                    icon: Icons.language,
                    title: localizations?.language ?? 'Language',
                    subtitle: currentLanguage ?? localizations?.getLanguageName('en') ?? 'English',
                    onTap: _handleLanguageTap,
                  ),
                  
                  // Profile Details Setting
                  _buildSettingCard(
                    icon: Icons.person,
                    title: localizations?.profileDetails ?? 'Profile Details',
                    subtitle: localizations?.manageYourProfile ?? 'Manage your profile',
                    onTap: _handleProfileDetailsTap,
                  ),
                  
                  // Notifications Setting
                  _buildSettingCard(
                    icon: Icons.notifications,
                    title: localizations?.notifications ?? 'Notifications',
                    subtitle: localizations?.manageNotificationSettings ?? 'Manage notification settings',
                    onTap: _handleNotificationsTap,
                  ),
                  
                  // Dark Mode Setting
                  _buildSettingCard(
                    icon: Icons.dark_mode,
                    title: localizations?.darkMode ?? 'Dark Mode',
                    subtitle: localizations?.switchToDarkTheme ?? 'Switch to dark theme',
                    onTap: () => _handleDarkModeToggle(!_darkMode),
                    trailing: Switch(
                      value: _darkMode,
                      onChanged: _handleDarkModeToggle,
                      activeColor: AppColors.gradientStart,
                    ),
                  ),
                  
                  // Privacy Policy Setting
                  _buildSettingCard(
                    icon: Icons.privacy_tip,
                    title: localizations?.privacyPolicy ?? 'Privacy Policy',
                    subtitle: localizations?.readOurPrivacyPolicy ?? 'Read our privacy policy',
                    onTap: _handlePrivacyPolicyTap,
                  ),
                ],
              ),
            ),
          ),
          
          // Footer
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'First Report v1.0.0',
                  style: FontUtils.regular(
                    size: 14,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          localizations?.madeWithLove ?? 'Made with ❤️ in India',
                          style: FontUtils.regular(
                            size: 14,
                            color: textSecondary,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
