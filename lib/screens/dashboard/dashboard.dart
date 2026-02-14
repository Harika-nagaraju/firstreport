import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/screens/dashboard/homepage.dart';
import 'package:firstreport/screens/dashboard/postnews.dart';
import 'package:firstreport/screens/dashboard/settings.dart';
import 'package:firstreport/screens/dashboard/pending_screen.dart';
import 'package:firstreport/services/news_service.dart';
import 'package:firstreport/screens/quizzes/quizzes_screen.dart';
import 'package:firstreport/screens/auth/registration_screen.dart';
import 'package:firstreport/screens/auth/login.dart';
import 'package:firstreport/utils/user_registration.dart';
import 'package:firstreport/l10n/app_localizations.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  int _postNewsKey = 0;

  List<Widget> get _screens => [
    const HomePage(),
    PostNews(
      key: ValueKey(_postNewsKey),
      onSubmitted: () {
        setState(() {
          _currentIndex = 0;
        });
      },
    ),
    QuizzesScreen(
      onBack: () {
        setState(() {
          _currentIndex = 0;
        });
      },
    ),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldColor = theme.scaffoldBackgroundColor;
    final navColor = isDark ? AppColors.darkCard : AppColors.white;
    final navShadow = Colors.black.withOpacity(isDark ? 0.35 : 0.05);
    final inactiveColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;
    final activeColor = AppColors.gradientStart;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scaffoldColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navColor,
          boxShadow: [
            BoxShadow(
              color: navShadow,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: localizations.home,
                  index: 0,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                _buildNavItem(
                  icon: Icons.add_circle_outline,
                  label: localizations.post,
                  index: 1,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                _buildNavItem(
                  icon: Icons.quiz_outlined,
                  label: localizations.quiz,
                  index: 2,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                _buildNavItem(
                  icon: Icons.settings,
                  label: localizations.settings,
                  index: 3,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradientStart.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _handlePostTab();
                    },
                    borderRadius: BorderRadius.circular(28),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _handlePostTab() async {
    // 1. Check if user is currently logged in (has token)
    final isLoggedIn = await UserRegistration.isRegistered();
    
    if (isLoggedIn) {
      // 3. Already logged in, check for pending status before showing Post News
      final hasPending = await NewsService.checkPendingStatus();
      
      if (hasPending && mounted) {
        // Navigate to Pending screen
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PendingScreen()),
        );
        return;
      }

      // No pending news, directly show Post News
      setState(() {
        _currentIndex = 1;
      });
      return;
    }

    // 2. Not logged in, check if an account "already exists" on this device
    final alreadyExist = await UserRegistration.hasAccount();
    
    Widget targetScreen;
    if (alreadyExist) {
      // Returning user who signed out - show Login
      targetScreen = const LoginScreen();
    } else {
      // Brand new install - show Sign Up
      targetScreen = const RegistrationScreen();
    }

    if (mounted) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => targetScreen,
        ),
      );
      
      // After successful authentication (returned true), navigate to Post News
      if (result == true && mounted) {
        setState(() {
          _postNewsKey++; // Force PostNews to rebuild
          _currentIndex = 1;
        });
      }
    }
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          // Post tab - check registration first
          _handlePostTab();
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: FontUtils.regular(
              size: 12,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

