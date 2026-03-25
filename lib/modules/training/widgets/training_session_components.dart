import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/models/training_preview_cell.dart';
import 'training_grid_preview.dart';

class TrainingSessionBanner extends StatelessWidget {
  const TrainingSessionBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: palette.textPrimary,
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
    final palette = context.appColors;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: palette.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: palette.border),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: palette.shadowColor,
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: TrainingGridPreview(
              gridSize: gridSize,
              cells: cells,
              revealLabels: revealLabels,
              isInteractionEnabled: isInteractionEnabled,
              onCellTap: onCellTap,
            ),
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
    final palette = context.appColors;

    return Text(
      message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: palette.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _BoardOverlay extends StatelessWidget {
  const _BoardOverlay({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.cardBackground.withValues(alpha: 0.9),
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
            color: palette.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
