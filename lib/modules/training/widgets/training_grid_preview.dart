import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/models/training_preview_cell.dart';

class TrainingGridPreview extends StatelessWidget {
  const TrainingGridPreview({
    required this.gridSize,
    required this.cells,
    required this.showGuideLabels,
    required this.isInteractionEnabled,
    required this.onCellTap,
    super.key,
  });

  final int gridSize;
  final List<TrainingPreviewCell> cells;
  final bool showGuideLabels;
  final bool isInteractionEnabled;
  final ValueChanged<String> onCellTap;

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
        return _GridCell(
          cell: cells[index],
          showGuideLabels: showGuideLabels,
          isInteractionEnabled: isInteractionEnabled,
          onTap: () => onCellTap(cells[index].label),
        );
      },
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({
    required this.cell,
    required this.showGuideLabels,
    required this.isInteractionEnabled,
    required this.onTap,
  });

  final TrainingPreviewCell cell;
  final bool showGuideLabels;
  final bool isInteractionEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey<String>('training-cell-${cell.label}'),
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: isInteractionEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: cell.backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: cell.borderColor,
              width: cell.isError ? 2 : 1,
            ),
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
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: cell.isCompleted ? 0.72 : 1,
                  child: Text(
                    cell.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: cell.foregroundColor,
                      fontWeight: FontWeight.w700,
                    ),
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
              if (cell.isCompleted)
                const Positioned(
                  left: AppSpacing.xs,
                  bottom: AppSpacing.xs,
                  child: _CompletionBadge(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionBadge extends StatelessWidget {
  const _CompletionBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.seed,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: Icon(Icons.check_rounded, size: 14, color: Colors.white),
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
