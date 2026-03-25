import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../models/stats_view_data.dart';

class StatsMetricCard extends StatelessWidget {
  const StatsMetricCard({required this.metric, super.key});

  final StatsSummaryMetricData metric;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 136,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration(context),
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

class StatsFilterCard extends StatelessWidget {
  const StatsFilterCard({
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

class StatsStateCard extends StatelessWidget {
  const StatsStateCard({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: palette.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class StatsErrorCard extends StatelessWidget {
  const StatsErrorCard({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.errorSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.errorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '成绩汇总读取失败',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: palette.errorForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: palette.errorForeground,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () => unawaited(onRetry()),
            child: const Text('重新加载'),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration(BuildContext context) {
  final palette = context.appColors;

  return BoxDecoration(
    color: palette.cardBackground,
    borderRadius: BorderRadius.circular(AppRadius.md),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: palette.shadowColor,
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
