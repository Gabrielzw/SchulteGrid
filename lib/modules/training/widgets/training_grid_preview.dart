import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/models/training_preview_cell.dart';

const Duration _cellFeedbackAnimationDuration = Duration(milliseconds: 90);
const Curve _cellFeedbackAnimationCurve = Curves.easeOutCubic;

class TrainingGridPreview extends StatelessWidget {
  const TrainingGridPreview({
    required this.gridSize,
    required this.cells,
    required this.revealLabels,
    required this.isInteractionEnabled,
    required this.onCellTap,
    super.key,
  });

  final int gridSize;
  final List<TrainingPreviewCell> cells;
  final bool revealLabels;
  final bool isInteractionEnabled;
  final ValueChanged<String> onCellTap;

  @override
  Widget build(BuildContext context) {
    final cellGap = _resolveCellGap(gridSize);

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cells.length,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          crossAxisSpacing: cellGap,
          mainAxisSpacing: cellGap,
          childAspectRatio: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _GridCell(
            cell: cells[index],
            gridSize: gridSize,
            revealLabels: revealLabels,
            isInteractionEnabled: isInteractionEnabled,
            onTap: () => onCellTap(cells[index].label),
          );
        },
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({
    required this.cell,
    required this.gridSize,
    required this.revealLabels,
    required this.isInteractionEnabled,
    required this.onTap,
  });

  final TrainingPreviewCell cell;
  final int gridSize;
  final bool revealLabels;
  final bool isInteractionEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final colorScheme = Theme.of(context).colorScheme;
    final radius = _resolveCellRadius(gridSize);
    final backgroundColor = _resolveCellBackgroundColor(cell, palette);
    final foregroundColor = _resolveCellForegroundColor(
      cell,
      palette,
      colorScheme.primary,
    );
    final borderColor = _resolveCellBorderColor(cell, palette);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey<String>('training-cell-${cell.label}'),
        borderRadius: BorderRadius.circular(radius),
        onTap: isInteractionEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: _cellFeedbackAnimationDuration,
          curve: _cellFeedbackAnimationCurve,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor,
              width: cell.isCurrentTarget || cell.isError ? 2 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              revealLabels ? cell.displayLabel : '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w800,
                fontSize: _resolveFontSize(gridSize),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color _resolveCellBackgroundColor(
  TrainingPreviewCell cell,
  AppThemeColors palette,
) {
  if (cell.isError) {
    return palette.gridCellErrorBackground;
  }
  if (cell.isRecentCorrect) {
    return palette.gridCellHighlightBackground;
  }
  return palette.gridCellBackground;
}

Color _resolveCellForegroundColor(
  TrainingPreviewCell cell,
  AppThemeColors palette,
  Color primaryColor,
) {
  if (cell.isError) {
    return palette.gridCellErrorForeground;
  }
  if (cell.isCurrentTarget || cell.isRecentCorrect) {
    return primaryColor;
  }
  return palette.textPrimary;
}

Color _resolveCellBorderColor(
  TrainingPreviewCell cell,
  AppThemeColors palette,
) {
  if (cell.isError) {
    return palette.gridCellErrorForeground;
  }
  if (cell.isCurrentTarget || cell.isRecentCorrect) {
    return palette.gridCellHighlightBorder;
  }
  return Colors.transparent;
}

double _resolveFontSize(int gridSize) {
  if (gridSize >= 7) {
    return 18;
  }
  if (gridSize == 6) {
    return 22;
  }
  if (gridSize == 5) {
    return 28;
  }
  return 32;
}

double _resolveCellGap(int gridSize) {
  if (gridSize >= 6) {
    return 4;
  }
  if (gridSize == 5) {
    return 5;
  }
  return 6;
}

double _resolveCellRadius(int gridSize) {
  if (gridSize >= 6) {
    return 12;
  }
  if (gridSize == 5) {
    return 14;
  }
  return 16;
}
