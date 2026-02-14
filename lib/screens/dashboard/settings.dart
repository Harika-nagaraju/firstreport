import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/utils/language_preference.dart';
import 'package:firstreport/utils/theme_preference.dart';
import 'package:firstreport/utils/user_registration.dart';
import 'package:firstreport/screens/auth/language_selection.dart';
import 'package:firstreport/screens/profie/profile_details.dart';
import 'package:firstreport/screens/settings/privacy_policy.dart';
import 'package:firstreport/screens/settings/terms_conditions.dart';
import 'package:firstreport/screens/settings/notification_settings.dart';
import 'package:firstreport/services/language_service.dart';
import 'package:firstreport/models/language_api_model.dart';
import 'package:firstreport/screens/dashboard/saved_news_screen.dart';
import 'package:firstreport/main.dart';

import 'package:firstreport/services/auth_service.dart';
import 'package:firstreport/models/auth_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? currentLanguage;
  bool _darkMode = false;
  Map<String, String?> userDetails = {};
  UserData? _profileData;

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

  Translations? _translations;

  Future<void> _loadLanguage() async {
    final languageName = await LanguagePreference.getLanguageName();
    final languageCode = await LanguagePreference.getLanguageCode() ?? 'en';
    
    final response = await LanguageService.getTranslations(languageCode);
    
    if (mounted) {
      setState(() {
        currentLanguage = languageName ?? 'English';
        _translations = response.translations;
      });
    }
  }

  Future<void> _loadUserDetails() async {
    // Try to get details from API first
    final token = await UserRegistration.getToken();
    if (token != null && token.isNotEmpty) {
      final profileResponse = await AuthService.getProfile(token);
      if (profileResponse.success && profileResponse.user != null) {
        if (mounted) {
          setState(() {
            _profileData = profileResponse.user;
            userDetails = {
              'fullName': _profileData!.name,
              'email': _profileData!.email,
              'phone': _profileData!.phone,
              'location': _profileData!.location,
            };
          });
        }
        // Sync local storage with API data
        await UserRegistration.saveRegistration(
          name: _profileData!.name,
          email: _profileData!.email,
          phone: _profileData!.phone,
          token: token,
        );
        return;
      }
    }

    // Fallback to local storage
    final details = await UserRegistration.getUserDetails();
    if (mounted) {
      setState(() {
        userDetails = details;
      });
    }
  }

  Future<void> _handleLanguageTap() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LanguageSelection(fromSettings: true),
      ),
    );

    if (mounted && result == true) {
      _loadLanguage();
      // Language is already updated by LanguageProvider in language_selection.dart
      // Just reload the translations for this screen
      setState(() {});
    }
  }

  void _handleProfileDetailsTap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfileDetailsScreen()));
  }

  void _handleTermsTap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const TermsConditionsScreen()));
  }

  void _handleSavedOnesTap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SavedNewsScreen()));
  }

  void _handleNotificationsTap() {
    Navigator.of(
      context,
    ).push(
      MaterialPageRoute(
        builder: (_) => const NotificationSettingsScreen(),
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
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
  }

  void _handleContactSupportTap() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textDarkGrey;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textLightGrey;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Support',
                style: FontUtils.bold(size: 18, color: textPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                'Need help? Reach out to us and we will get back shortly.',
                style: FontUtils.regular(size: 14, color: textSecondary),
              ),
              const SizedBox(height: 20),
              _buildSupportRow(
                icon: Icons.mail_outline,
                title: 'Email Us',
                value: 'support@firstreport.app',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              const SizedBox(height: 16),
              _buildSupportRow(
                icon: Icons.phone_outlined,
                title: 'Call',
                value: '+91 98765 43210',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              const SizedBox(height: 16),
              _buildSupportRow(
                icon: Icons.chat_bubble_outline,
                title: 'Chat with Us',
                value: 'We are here 9am - 6pm IST',
                color: textPrimary,
                subtitleColor: textSecondary,
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSupportRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color subtitleColor,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.white, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: FontUtils.bold(size: 15, color: color)),
              const SizedBox(height: 4),
              Text(
                value,
                style: FontUtils.regular(size: 13, color: subtitleColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _refreshData() async {
    await Future.wait([_loadLanguage(), _loadUserDetails(), _loadDarkMode()]);
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

    final languageLabel = _translations?.language ?? 'Language';
    final profileLabel = _translations?.profileDetails ?? 'Profile Details';
    final manageProfile = _translations?.account ?? 'Manage your profile';
    final darkModeLabel = _translations?.darkMode ?? 'Dark Mode';
    final switchToDark = _translations?.general ?? 'Switch to dark theme';
    final privacyLabel = _translations?.privacyPolicy ?? 'Privacy Policy';
    final readPrivacy = _translations?.support ?? 'Read our privacy policy';
    final settingsTitle = _translations?.settings ?? 'Settings';
    const madeWithLove = 'Made with ❤️ in India';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          settingsTitle,
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.gradientStart,
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildProfileHeader(
                cardColor: cardColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: _translations?.general ?? 'General',
              children: [
                _buildSettingTile(
                  icon: Icons.language,
                  title: languageLabel,
                  subtitle: currentLanguage ?? 'English',
                  onTap: _handleLanguageTap,
                  trailingText: currentLanguage ?? 'English',
                ),
                _buildSettingTile(
                  icon: Icons.dark_mode,
                  title: darkModeLabel,
                  subtitle: switchToDark,
                  onTap: () => _handleDarkModeToggle(!_darkMode),
                  trailing: Switch(
                    value: _darkMode,
                    onChanged: _handleDarkModeToggle,
                    activeColor: AppColors.gradientStart,
                  ),
                  showChevron: false,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: _translations?.account ?? 'Account',
              children: [
                _buildSettingTile(
                  icon: Icons.person,
                  title: profileLabel,
                  subtitle: manageProfile,
                  onTap: _handleProfileDetailsTap,
                ),
                _buildSettingTile(
                  icon: Icons.notifications,
                  title: _translations?.notifications ?? 'Notifications',
                  subtitle: 'Review your unread alerts',
                  onTap: _handleNotificationsTap,
                ),
                _buildSettingTile(
                  icon: Icons.bookmark_outline,
                  title: _translations?.savedOnes ?? 'Saved Ones',
                  subtitle: 'View and manage saved stories',
                  onTap: _handleSavedOnesTap,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: _translations?.support ?? 'Support',
              children: [
                _buildSettingTile(
                  icon: Icons.privacy_tip,
                  title: privacyLabel,
                  subtitle: readPrivacy,
                  onTap: _handlePrivacyPolicyTap,
                ),
                _buildSettingTile(
                  icon: Icons.article_outlined,
                  title: _translations?.termsConditions ?? 'Terms & Conditions',
                  subtitle: 'Understand our usage policy',
                  onTap: _handleTermsTap,
                ),
                _buildSettingTile(
                  icon: Icons.support_agent,
                  title: _translations?.contactSupport ?? 'Contact Support',
                  subtitle: 'We are happy to help',
                  onTap: _handleContactSupportTap,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'First Report v1.0.0',
                    style: FontUtils.bold(size: 14, color: textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    madeWithLove,
                    style: FontUtils.regular(size: 13, color: textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader({
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final name = (userDetails['fullName']?.trim().isNotEmpty ?? false)
        ? userDetails['fullName']!.trim()
        : 'Guest User';
    final email = (userDetails['email']?.trim().isNotEmpty ?? false)
        ? userDetails['email']!.trim()
        : 'Add your email to stay updated';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.06,
            ),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'F',
                style: FontUtils.bold(size: 30, color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: FontUtils.bold(size: 18, color: textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            email,
            style: FontUtils.regular(size: 13, color: textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_profileData?.isVerified ?? false)
                _buildInfoChip(
                  icon: Icons.check_circle,
                  label: _translations?.verifiedReader ?? 'Verified Reader',
                )
              else
                _buildInfoChip(
                  icon: Icons.info_outline,
                  label: 'General Reader',
                ),
              _buildInfoChip(
                icon: Icons.auto_awesome,
                label: _translations?.personalizedFeed ?? 'Personalised Feed',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gradientStart.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.gradientStart),
          const SizedBox(width: 6),
          Text(
            label,
            style: FontUtils.bold(size: 12, color: AppColors.gradientStart),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textDarkGrey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: FontUtils.bold(size: 16, color: textPrimary)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    String? trailingText,
    Widget? trailing,
    bool showChevron = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textDarkGrey;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textLightGrey;

    final trailingWidget =
        trailing ??
        (trailingText != null
            ? Text(
                trailingText,
                style: FontUtils.bold(size: 13, color: textPrimary),
              )
            : (showChevron
                  ? Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: textSecondary,
                    )
                  : null));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.28 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.buttonGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: AppColors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: FontUtils.bold(size: 15, color: textPrimary),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: FontUtils.regular(
                            size: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailingWidget != null) ...[
                  const SizedBox(width: 16),
                  trailingWidget,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
