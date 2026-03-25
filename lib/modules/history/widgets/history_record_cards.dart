import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../models/history_record_view_data.dart';

class HistoryRecordCard extends StatelessWidget {
  const HistoryRecordCard({required this.record, super.key});

  final HistoryRecordViewData record;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

    return Container(
      width: double.infinity,
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
          _HistoryRecordHeader(record: record),
          const SizedBox(height: AppSpacing.md),
          _HistoryRecordContent(record: record),
        ],
      ),
    );
  }
}

class _HistoryRecordHeader extends StatelessWidget {
  const _HistoryRecordHeader({required this.record});

  final HistoryRecordViewData record;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: palette.textSecondary,
      fontWeight: FontWeight.w600,
    );

    return Row(
      children: <Widget>[
        _ModeBadge(
          icon: record.icon,
          label: record.modeLabel,
          tone: record.tone,
        ),
        const Spacer(),
        Text(record.completedAtLabel, style: labelStyle),
      ],
    );
  }
}

class _HistoryRecordContent extends StatelessWidget {
  const _HistoryRecordContent({required this.record});

  final HistoryRecordViewData record;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          record.durationLabel,
          style: textTheme.headlineMedium?.copyWith(
            color: palette.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${record.orderLabel} · ${record.gridLabel}',
          style: textTheme.titleMedium?.copyWith(
            color: palette.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: <Widget>[
            _InfoChip(label: '准确率 ${record.accuracyLabel}'),
            _InfoChip(label: record.errorLabel),
          ],
        ),
      ],
    );
  }
}

class HistoryStateCard extends StatelessWidget {
  const HistoryStateCard({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.border),
      ),
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

class HistoryErrorCard extends StatelessWidget {
  const HistoryErrorCard({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

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
            '历史记录读取失败',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: palette.errorForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    final palette = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: resolveAdaptiveTone(context, tone),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: palette.textPrimary),
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: palette.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
