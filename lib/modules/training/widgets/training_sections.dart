import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/metric_tile.dart';
import '../../../app/widgets/section_card.dart';
import '../../../domain/enums/training_session_status.dart';
import '../../../domain/models/training_config.dart';
import '../../../domain/models/training_preview_cell.dart';
import 'training_grid_preview.dart';

class TrainingHeader extends StatelessWidget {
  const TrainingHeader({required this.config, super.key});

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

class TrainingStatusSection extends StatelessWidget {
  const TrainingStatusSection({
    required this.config,
    required this.status,
    required this.statusLabel,
    required this.statusDescription,
    required this.nextTargetLabel,
    required this.timerLabel,
    required this.progressLabel,
    required this.errorCount,
    required this.targetSequencePreview,
    required this.actionLabel,
    required this.showGuideLabels,
    required this.resultSummary,
    required this.onPrimaryAction,
    required this.onToggleGuides,
    super.key,
  });

  final TrainingConfig config;
  final TrainingSessionStatus status;
  final String statusLabel;
  final String statusDescription;
  final String nextTargetLabel;
  final String timerLabel;
  final String progressLabel;
  final int errorCount;
  final String targetSequencePreview;
  final String actionLabel;
  final bool showGuideLabels;
  final String? resultSummary;
  final VoidCallback onPrimaryAction;
  final ValueChanged<bool> onToggleGuides;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '状态区',
      subtitle: statusDescription,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              MetricTile(
                label: '下一目标',
                value: nextTargetLabel,
                icon: Icons.flag_outlined,
                caption: config.orderLabel,
              ),
              MetricTile(
                label: '计时',
                value: timerLabel,
                icon: Icons.timer_outlined,
                caption: statusLabel,
              ),
              MetricTile(
                label: '进度',
                value: progressLabel,
                icon: Icons.checklist_rounded,
                caption: '共 ${config.totalCells} 格',
              ),
              MetricTile(
                label: '错误次数',
                value: '$errorCount',
                icon: Icons.error_outline_rounded,
                caption: '错误点击即时提示',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SequencePreview(sequencePreview: targetSequencePreview),
          const SizedBox(height: AppSpacing.sm),
          if (resultSummary != null) ...<Widget>[
            _CompletionBanner(message: resultSummary!),
            const SizedBox(height: AppSpacing.sm),
          ],
          FilledButton.icon(
            onPressed: onPrimaryAction,
            icon: Icon(_resolveActionIcon(status)),
            label: Text(actionLabel),
          ),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: showGuideLabels,
            onChanged: onToggleGuides,
            title: const Text('显示顺序辅助标签'),
            subtitle: const Text('开启后会显示每个格子在正确点击序列中的位次。'),
          ),
        ],
      ),
    );
  }
}

class TrainingBoardSection extends StatelessWidget {
  const TrainingBoardSection({
    required this.gridSize,
    required this.subtitle,
    required this.cells,
    required this.showGuideLabels,
    required this.isInteractionEnabled,
    required this.onCellTap,
    super.key,
  });

  final int gridSize;
  final String subtitle;
  final List<TrainingPreviewCell> cells;
  final bool showGuideLabels;
  final bool isInteractionEnabled;
  final ValueChanged<String> onCellTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '方格画布',
      subtitle: subtitle,
      child: TrainingGridPreview(
        gridSize: gridSize,
        cells: cells,
        showGuideLabels: showGuideLabels,
        isInteractionEnabled: isInteractionEnabled,
        onCellTap: onCellTap,
      ),
    );
  }
}

class _CompletionBanner extends StatelessWidget {
  const _CompletionBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.seed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.seed.withValues(alpha: 0.22)),
      ),
      child: Text(
        '训练完成。$message',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _SequencePreview extends StatelessWidget {
  const _SequencePreview({required this.sequencePreview});

  final String sequencePreview;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '目标顺序：$sequencePreview',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

IconData _resolveActionIcon(TrainingSessionStatus status) {
  switch (status) {
    case TrainingSessionStatus.ready:
      return Icons.play_arrow_rounded;
    case TrainingSessionStatus.running:
      return Icons.refresh_rounded;
    case TrainingSessionStatus.completed:
      return Icons.replay_rounded;
  }
}
