import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../models/stats_view_data.dart';

class StatsSessionHighlightCard extends StatelessWidget {
  const StatsSessionHighlightCard({required this.data, super.key});

  final StatsSessionHighlightData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _ModeBadge(
                icon: data.icon,
                label: data.badgeLabel,
                tone: data.tone,
              ),
              const Spacer(),
              Text(
                data.completedAtLabel,
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            data.caption,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.durationLabel,
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            data.metaLabel,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              _InfoChip(label: data.primaryChipLabel),
              _InfoChip(label: data.secondaryChipLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsModeInsightCard extends StatelessWidget {
  const StatsModeInsightCard({required this.data, super.key});

  final StatsModeInsightData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _ModeBadge(icon: data.icon, label: data.label, tone: data.tone),
              const Spacer(),
              Text(
                data.sessionCountLabel,
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.description,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatColumn(
                  label: '最佳成绩',
                  value: data.bestDurationLabel,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatColumn(
                  label: '平均用时',
                  value: data.averageDurationLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeBadge extends StatelessWidget {
  const _ModeBadge({
    required this.icon,
    required this.label,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: AppColors.textPrimary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

final BoxDecoration _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(AppRadius.md),
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ],
);
