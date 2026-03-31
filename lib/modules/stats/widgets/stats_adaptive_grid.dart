import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

class StatsAdaptiveGrid extends StatelessWidget {
  const StatsAdaptiveGrid({
    required this.itemCount,
    required this.itemBuilder,
    required this.minChildWidth,
    required this.maxColumns,
    this.spacing = AppSpacing.sm,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double minChildWidth;
  final int maxColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final columns = _resolveColumnCount(constraints.maxWidth);
        final itemWidth = _resolveItemWidth(
          maxWidth: constraints.maxWidth,
          columns: columns,
        );

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List<Widget>.generate(itemCount, (int index) {
            return SizedBox(
              width: itemWidth,
              child: itemBuilder(context, index),
            );
          }),
        );
      },
    );
  }

  int _resolveColumnCount(double maxWidth) {
    final calculated = ((maxWidth + spacing) / (minChildWidth + spacing))
        .floor();
    return calculated.clamp(1, maxColumns);
  }

  double _resolveItemWidth({required double maxWidth, required int columns}) {
    final totalSpacing = spacing * (columns - 1);
    return (maxWidth - totalSpacing) / columns;
  }
}
