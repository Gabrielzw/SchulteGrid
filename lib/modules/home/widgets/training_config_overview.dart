import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/section_card.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';

class TrainingConfigHero extends StatelessWidget {
  const TrainingConfigHero({
    required this.selectedMode,
    required this.selectedOrder,
    required this.selectedGridSize,
    super.key,
  });

  final TrainingMode selectedMode;
  final TrainingOrder selectedOrder;
  final int? selectedGridSize;

  @override
  Widget build(BuildContext context) {
    final sizeLabel = selectedGridSize == null
        ? '等待输入尺寸'
        : '${selectedGridSize!} x ${selectedGridSize!}';

    return SectionCard(
      title: '训练参数配置',
      subtitle: '先选择模式、点击顺序和网格大小，再进入训练页。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              Chip(label: Text(selectedMode.label)),
              Chip(label: Text(selectedOrder.label)),
              Chip(label: Text(sizeLabel)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '当前阶段先落实需求文档中的训练参数配置，确保模式、顺序和尺寸选择能稳定传递到训练页。',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class ModeSelector extends StatelessWidget {
  const ModeSelector({
    required this.selectedMode,
    required this.onSelected,
    super.key,
  });

  final TrainingMode selectedMode;
  final ValueChanged<TrainingMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '训练模式',
      subtitle: '当前支持数字模式与字母模式。',
      child: Column(
        children: TrainingMode.values.map((TrainingMode mode) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _ModeOptionTile(
              mode: mode,
              isSelected: mode == selectedMode,
              onTap: () => onSelected(mode),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class OrderSelector extends StatelessWidget {
  const OrderSelector({
    required this.selectedOrder,
    required this.onSelected,
    super.key,
  });

  final TrainingOrder selectedOrder;
  final ValueChanged<TrainingOrder> onSelected;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '点击顺序',
      subtitle: '数字与字母模式都支持正序和倒序两种训练方向。',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: TrainingOrder.values.map((TrainingOrder order) {
          return ChoiceChip(
            label: Text(order.label),
            selected: order == selectedOrder,
            onSelected: (_) => onSelected(order),
          );
        }).toList(),
      ),
    );
  }
}

class _ModeOptionTile extends StatelessWidget {
  const _ModeOptionTile({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  final TrainingMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: mode.tone,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? colorScheme.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(mode.icon, color: colorScheme.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mode.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    mode.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
