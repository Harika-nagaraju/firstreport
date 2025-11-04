import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.buttonGradient : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isActive
              ? null
              : Border.all(
                  color: AppColors.borderUnselected,
                  width: 1,
                ),
        ),
        child: Text(
          label,
          style: FontUtils.regular(
            size: 14,
            color: isActive ? AppColors.white : AppColors.textDarkGrey,
          ),
        ),
      ),
    );
  }
}

