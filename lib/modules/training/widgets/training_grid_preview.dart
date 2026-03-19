import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/models/training_preview_cell.dart';

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
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cells.length,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
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
              width: cell.isCurrentTarget || cell.isError ? 2 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              revealLabels ? cell.displayLabel : '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: cell.foregroundColor,
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

double _resolveFontSize(int gridSize) {
  if (gridSize >= 7) {
    return 16;
  }
  if (gridSize == 6) {
    return 18;
  }
  if (gridSize == 5) {
    return 20;
  }
  return 24;
}
