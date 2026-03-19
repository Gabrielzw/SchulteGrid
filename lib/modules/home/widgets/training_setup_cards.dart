import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

class TrainingGridSizeCard extends StatelessWidget {
  const TrainingGridSizeCard({
    required this.size,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final int size;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 92,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isSelected ? AppColors.seed : Colors.transparent,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? <BoxShadow>[
                BoxShadow(
                  color: AppColors.seed.withValues(alpha: 0.14),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$size',
                  style: textTheme.headlineSmall?.copyWith(
                    color: isSelected ? AppColors.seed : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$size × $size',
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrainingSegmentOptionCard extends StatelessWidget {
  const TrainingSegmentOptionCard({
    required this.label,
    required this.caption,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final String caption;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md - 4),
        border: Border.all(
          color: isSelected
              ? AppColors.seed.withValues(alpha: 0.22)
              : Colors.transparent,
        ),
        boxShadow: isSelected
            ? <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md - 4),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  label,
                  style: textTheme.titleMedium?.copyWith(
                    color: isSelected ? AppColors.seed : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  caption,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
