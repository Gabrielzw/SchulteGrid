import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/metric_tile.dart';
import '../../../app/widgets/section_card.dart';
import '../../../domain/models/training_config.dart';
import '../../../domain/models/training_preview_cell.dart';
import '../controllers/training_controller.dart';
import '../widgets/training_grid_preview.dart';

class TrainingView extends GetView<TrainingController> {
  const TrainingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(title: Text(controller.title)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _TrainingHeader(config: controller.config),
              const SizedBox(height: AppSpacing.lg),
              _TrainingStatusSection(
                config: controller.config,
                showGuideLabels: controller.showGuideLabels.value,
                onToggleGuides: controller.setGuideLabels,
              ),
              const SizedBox(height: AppSpacing.lg),
              _TrainingBoardSection(
                config: controller.config,
                cells: controller.cells,
                showGuideLabels: controller.showGuideLabels.value,
              ),
              const SizedBox(height: AppSpacing.lg),
              _TrainingNoticeSection(message: controller.config.helperText),
            ],
          ),
        ),
      );
    });
  }
}

class _TrainingHeader extends StatelessWidget {
  const _TrainingHeader({required this.config});

  final TrainingConfig config;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '训练参数',
      subtitle: '当前页面已按首页选择的模式、顺序和尺寸生成训练版式。',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: <Widget>[
          Chip(label: Text(config.mode.label)),
          Chip(label: Text('${config.gridSize} x ${config.gridSize}')),
          Chip(label: Text(config.orderLabel)),
        ],
      ),
    );
  }
}

class _TrainingStatusSection extends StatelessWidget {
  const _TrainingStatusSection({
    required this.config,
    required this.showGuideLabels,
    required this.onToggleGuides,
  });

  final TrainingConfig config;
  final bool showGuideLabels;
  final ValueChanged<bool> onToggleGuides;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '状态区',
      subtitle: '这里会显示当前顺序、起始目标和后续训练状态。',
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              MetricTile(
                label: '下一目标',
                value: config.nextTargetHint,
                icon: Icons.flag_outlined,
                caption: config.orderLabel,
              ),
              MetricTile(
                label: '总格数',
                value: '${config.totalCells}',
                icon: Icons.grid_view_rounded,
              ),
              MetricTile(
                label: '点击规则',
                value: config.orderLabel,
                caption: config.selectionInstruction,
                icon: Icons.swap_vert_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: showGuideLabels,
            onChanged: onToggleGuides,
            title: const Text('显示顺序辅助标签'),
            subtitle: const Text('仅用于当前布局预览，真实训练时可关闭。'),
          ),
        ],
      ),
    );
  }
}

class _TrainingBoardSection extends StatelessWidget {
  const _TrainingBoardSection({
    required this.config,
    required this.cells,
    required this.showGuideLabels,
  });

  final TrainingConfig config;
  final List<TrainingPreviewCell> cells;
  final bool showGuideLabels;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '方格画布',
      subtitle: '方格内容已按所选模式生成，真实训练时会在这里承载随机布局和点击反馈。',
      child: TrainingGridPreview(
        gridSize: config.gridSize,
        cells: cells,
        showGuideLabels: showGuideLabels,
      ),
    );
  }
}

class _TrainingNoticeSection extends StatelessWidget {
  const _TrainingNoticeSection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '当前实现范围',
      subtitle: '训练参数配置已经打通，下面这些真实训练能力仍待接入。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          const _BulletLine(text: '随机生成训练内容'),
          const _BulletLine(text: '自动计时与完成判定'),
          const _BulletLine(text: '错误点击反馈与振动'),
          const _BulletLine(text: '训练记录写入 Isar 并联动统计页'),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: AppSpacing.xs),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
