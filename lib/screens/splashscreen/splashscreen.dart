import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/language_preference.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/widgets/applogo.dart';
import 'package:newsapp/screens/auth/language_selection.dart';
import 'package:newsapp/screens/dashboard/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _goNext(BuildContext context) async {
    final isLanguageSelected = await LanguagePreference.isLanguageSelected();

    if (mounted) {
      if (isLanguageSelected) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Dashboard()));
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LanguageSelection()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _goNext(context),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryBackgroundGradient,
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogo(
                      iconSize: 80,
                      titleSize: 32,
                      subtitleSize: 13,
                    ),
                    const SizedBox(height: 48),
                    GestureDetector(
                      onTap: () => _goNext(context),
                      child: Text(
                        AppLocalizations.of(context)?.tapToContinue ??
                            'Tap anywhere to continue',
                        style: FontUtils.regular(
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
