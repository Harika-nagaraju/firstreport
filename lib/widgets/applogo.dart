import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';

class AppLogo extends StatelessWidget {
  final double iconSize;
  final double titleSize;
  final double subtitleSize;

  const AppLogo({super.key, this.iconSize = 96, this.titleSize = 36, this.subtitleSize = 14});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize * 1.25,
          height: iconSize * 1.25,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(Icons.article_rounded, size: iconSize, color: AppColors.white),
        ),
        const SizedBox(height: 32),
        Text('First Report', style: FontUtils.bold(size: titleSize, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text(
          'Your Voice. Your News. Your World.',
          style: FontUtils.regular(size: subtitleSize, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}


