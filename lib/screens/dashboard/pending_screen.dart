import 'package:flutter/material.dart';
import '../../utils/appcolors.dart';
import '../../utils/fontutils.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.darkBackground : AppColors.screenBackground;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Pending News",
          style: FontUtils.bold(size: 18, color: textColor),
        ),
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hourglass_top,
                size: 120,
                color: Colors.orange,
              ),
              const SizedBox(height: 30),
              Text(
                "News Under Review",
                style: FontUtils.bold(
                  size: 24,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Your previously submitted news is waiting for admin approval.",
                textAlign: TextAlign.center,
                style: FontUtils.regular(
                  size: 16,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Waiting for Approval",
                    style: FontUtils.bold(size: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Go Back",
                  style: FontUtils.bold(size: 16, color: AppColors.gradientStart),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
