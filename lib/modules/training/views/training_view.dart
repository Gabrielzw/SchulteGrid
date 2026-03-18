import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/metric_tile.dart';
import '../../../app/widgets/section_card.dart';
import '../../../domain/enums/training_mode.dart';
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
      title: '训练界面骨架',
      subtitle: '当前只展示布局和视觉层级，方便后续接入真实训练逻辑。',
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
      subtitle: '后续这里会显示计时器、下一目标和错误反馈。',
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
              ),
              MetricTile(
                label: '总格数',
                value: '${config.totalCells}',
                icon: Icons.grid_view_rounded,
              ),
              const MetricTile(
                label: '计时状态',
                value: '待接入',
                icon: Icons.timer_outlined,
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
      subtitle: _resolveSubtitle(config.mode),
      child: TrainingGridPreview(
        gridSize: config.gridSize,
        cells: cells,
        showGuideLabels: showGuideLabels,
      ),
    );
  }

  String _resolveSubtitle(TrainingMode mode) {
    if (mode == TrainingMode.colors) {
      return '颜色模式当前展示色阶布局，深浅判断逻辑后续接入。';
    }
    return '当前仅按顺序渲染占位内容，不执行随机打乱。';
  }
}

class _TrainingNoticeSection extends StatelessWidget {
  const _TrainingNoticeSection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '待接入功能',
      subtitle: '这里明确列出还没有实现的部分，避免把占位布局误当成真实能力。',
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
