import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/models/training_preview_cell.dart';
import 'training_grid_preview.dart';

class TrainingSessionHero extends StatelessWidget {
  const TrainingSessionHero({
    required this.eyebrow,
    required this.timerLabel,
    required this.progressValue,
    required this.metaLabel,
    required this.progressLabel,
    super.key,
  });

  final String eyebrow;
  final String timerLabel;
  final double progressValue;
  final String metaLabel;
  final String progressLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        Text(
          eyebrow,
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.8,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          timerLabel,
          style: textTheme.displayLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: 132,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 3,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.seed),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          metaLabel,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          progressLabel,
          style: textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class TrainingSessionMetrics extends StatelessWidget {
  const TrainingSessionMetrics({
    required this.targetTitle,
    required this.targetValue,
    required this.accuracyLabel,
    super.key,
  });

  final String targetTitle;
  final String targetValue;
  final String accuracyLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _MetricBlock(
            title: targetTitle,
            value: targetValue,
            valueColor: AppColors.seed,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _MetricBlock(
              title: '准确率',
              value: accuracyLabel,
              valueColor: AppColors.textPrimary,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ),
        ),
      ],
    );
  }
}

class TrainingSessionBanner extends StatelessWidget {
  const TrainingSessionBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class TrainingBoardPanel extends StatelessWidget {
  const TrainingBoardPanel({
    required this.gridSize,
    required this.cells,
    required this.revealLabels,
    required this.isInteractionEnabled,
    required this.overlayLabel,
    required this.onCellTap,
    super.key,
  });

  final int gridSize;
  final List<TrainingPreviewCell> cells;
  final bool revealLabels;
  final bool isInteractionEnabled;
  final String? overlayLabel;
  final ValueChanged<String> onCellTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: TrainingGridPreview(
            gridSize: gridSize,
            cells: cells,
            revealLabels: revealLabels,
            isInteractionEnabled: isInteractionEnabled,
            onCellTap: onCellTap,
          ),
        ),
        if (overlayLabel != null) _BoardOverlay(label: overlayLabel!),
      ],
    );
  }
}

class TrainingSessionHint extends StatelessWidget {
  const TrainingSessionHint({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.title,
    required this.value,
    required this.valueColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final String title;
  final String value;
  final Color valueColor;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: textTheme.headlineLarge?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w800,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _BoardOverlay extends StatelessWidget {
  const _BoardOverlay({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
