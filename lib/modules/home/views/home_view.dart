import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/metric_tile.dart';
import '../../../app/widgets/section_card.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../../../domain/models/training_config.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final config = controller.currentConfig;
      final selectedMode = controller.selectedMode.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _HeroCard(config: config),
            const SizedBox(height: AppSpacing.lg),
            _GridSizeSelector(
              selectedGridSize: config.gridSize,
              onSelected: controller.selectGridSize,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ModeSelector(
              selectedMode: selectedMode,
              onSelected: controller.selectMode,
            ),
            const SizedBox(height: AppSpacing.lg),
            _OrderSelector(
              selectedMode: selectedMode,
              selectedOrder: controller.selectedOrder.value,
              onSelected: controller.selectOrder,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ConfigSummaryCard(
              config: config,
              onPressed: controller.openTrainingPreview,
            ),
          ],
        ),
      );
    });
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.config});

  final TrainingConfig config;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '舒尔特方格',
      subtitle: '先完成应用骨架和布局，后续再接入真实训练流程与成绩统计。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              Chip(label: Text('${config.gridSize} x ${config.gridSize}')),
              Chip(label: Text(config.mode.label)),
              Chip(label: Text(config.orderLabel)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '当前配置将展示训练页布局预览，计时、正确性判断、振动反馈和成绩落库还未接入。',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _GridSizeSelector extends StatelessWidget {
  const _GridSizeSelector({
    required this.selectedGridSize,
    required this.onSelected,
  });

  final int selectedGridSize;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '方格尺寸',
      subtitle: 'V1 支持自由设定 N x N，当前先提供 3 到 7 的常用尺寸。',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: HomeController.availableGridSizes.map((int gridSize) {
          return ChoiceChip(
            label: Text('$gridSize x $gridSize'),
            selected: gridSize == selectedGridSize,
            onSelected: (_) => onSelected(gridSize),
          );
        }).toList(),
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({required this.selectedMode, required this.onSelected});

  final TrainingMode selectedMode;
  final ValueChanged<TrainingMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '训练模式',
      subtitle: '按照需求文档预埋数字、字母、颜色三种模式。',
      child: Column(
        children: TrainingMode.values.map((TrainingMode mode) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _ModeOptionTile(
              mode: mode,
              isSelected: selectedMode == mode,
              onTap: () => onSelected(mode),
            ),
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
    final selectedBorder = colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: mode.tone,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? selectedBorder : AppColors.border,
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

class _OrderSelector extends StatelessWidget {
  const _OrderSelector({
    required this.selectedMode,
    required this.selectedOrder,
    required this.onSelected,
  });

  final TrainingMode selectedMode;
  final TrainingOrder selectedOrder;
  final ValueChanged<TrainingOrder> onSelected;

  @override
  Widget build(BuildContext context) {
    if (!selectedMode.supportsReverse) {
      return SectionCard(
        title: '点击顺序',
        subtitle: '颜色模式将默认按色阶递进，具体规则后续接入。',
        child: Text(
          '当前只保留顺序说明，不开放倒序切换。',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return SectionCard(
      title: '点击顺序',
      subtitle: '数字与字母模式支持正序和倒序两种训练方向。',
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

class _ConfigSummaryCard extends StatelessWidget {
  const _ConfigSummaryCard({required this.config, required this.onPressed});

  final TrainingConfig config;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '当前骨架范围',
      subtitle: '页面、导航、状态管理和本地数据库入口已准备，训练逻辑暂不实现。',
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              MetricTile(
                label: '总格数',
                value: '${config.totalCells}',
                icon: Icons.apps_rounded,
              ),
              MetricTile(
                label: '模式',
                value: config.mode.shortLabel,
                icon: config.mode.icon,
              ),
              MetricTile(
                label: '起始目标',
                value: config.nextTargetHint,
                icon: Icons.flag_outlined,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              config.helperText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('进入训练页'),
          ),
        ],
      ),
    );
  }
}
