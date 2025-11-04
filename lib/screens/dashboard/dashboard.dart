import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/screens/dashboard/homepage.dart';
import 'package:newsapp/screens/dashboard/postnews.dart';
import 'package:newsapp/screens/dashboard/settings.dart';
import 'package:newsapp/screens/auth/registration_screen.dart';
import 'package:newsapp/utils/user_registration.dart';

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
    PostNews(key: ValueKey(_postNewsKey)),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.add_circle_outline,
                  label: 'Post',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  index: 2,
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
    // Check if user is registered
    final isRegistered = await UserRegistration.isRegistered();
    
    if (!isRegistered) {
      // Navigate to registration screen
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const RegistrationScreen(),
        ),
      );
      
      // After registration, navigate to Post News and refresh it
      if (result == true && mounted) {
        setState(() {
          _postNewsKey++; // Force PostNews to rebuild
          _currentIndex = 1;
        });
      }
    } else {
      // Already registered, directly show Post News
      setState(() {
        _currentIndex = 1;
      });
    }
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
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
            color: isActive ? AppColors.gradientStart : AppColors.textLightGrey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: FontUtils.regular(
              size: 12,
              color: isActive ? AppColors.gradientStart : AppColors.textLightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

