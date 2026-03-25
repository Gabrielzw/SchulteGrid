import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../models/history_record_view_data.dart';

class HistoryMetricCard extends StatelessWidget {
  const HistoryMetricCard({required this.metric, super.key});

  final HistorySummaryMetricData metric;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 136,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(metric.icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            metric.value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            metric.label,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            metric.caption,
            style: textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryFilterCard extends StatelessWidget {
  const HistoryFilterCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final selectedColor = Theme.of(context).colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isSelected ? palette.cardBackground : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md - 4),
        border: Border.all(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.22)
              : Colors.transparent,
        ),
        boxShadow: isSelected
            ? <BoxShadow>[
                BoxShadow(
                  color: palette.shadowColor,
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
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: isSelected ? selectedColor : palette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryFilterChipCard extends StatelessWidget {
  const HistoryFilterChipCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final selectedColor = Theme.of(context).colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isSelected ? palette.cardBackground : palette.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.22)
              : Colors.transparent,
        ),
        boxShadow: isSelected
            ? <BoxShadow>[
                BoxShadow(
                  color: palette.shadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                color: isSelected ? selectedColor : palette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
