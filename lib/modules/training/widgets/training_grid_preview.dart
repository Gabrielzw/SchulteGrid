import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/models/training_preview_cell.dart';

class TrainingGridPreview extends StatelessWidget {
  const TrainingGridPreview({
    required this.gridSize,
    required this.cells,
    required this.showGuideLabels,
    super.key,
  });

  final int gridSize;
  final List<TrainingPreviewCell> cells;
  final bool showGuideLabels;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cells.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _GridCell(cell: cells[index], showGuideLabels: showGuideLabels);
      },
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.cell, required this.showGuideLabels});

  final TrainingPreviewCell cell;
  final bool showGuideLabels;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: cell.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              cell.label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: cell.foregroundColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.xs,
            right: AppSpacing.xs,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: showGuideLabels ? 1 : 0,
              child: _GuideBadge(label: cell.targetOrderLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideBadge extends StatelessWidget {
  const _GuideBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.seed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.seed.withValues(alpha: 0.24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 4,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.seed,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
