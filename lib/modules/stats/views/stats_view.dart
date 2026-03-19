import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/empty_state_card.dart';
import '../../../app/widgets/metric_tile.dart';
import '../../../app/widgets/section_card.dart';
import '../../../domain/enums/training_mode.dart';
import '../controllers/stats_controller.dart';

class StatsView extends GetView<StatsController> {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
            _StatsHero(
              selectedRangeIndex: controller.selectedRangeIndex.value,
              onSelected: controller.selectRange,
            ),
            const SizedBox(height: AppSpacing.lg),
            const _MetricsSection(),
            const SizedBox(height: AppSpacing.lg),
            const _ModeCoverageSection(),
            const SizedBox(height: AppSpacing.lg),
            const _StatsStatusSection(),
          ],
        ),
      );
    });
  }
}

class _StatsHero extends StatelessWidget {
  const _StatsHero({
    required this.selectedRangeIndex,
    required this.onSelected,
  });

  final int selectedRangeIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '成绩概览',
      subtitle: '统计页骨架已经就位，后续将由 Isar 训练记录驱动最佳成绩、平均用时和总次数。',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: List<Widget>.generate(StatsController.timeRanges.length, (
          int index,
        ) {
          return ChoiceChip(
            label: Text(StatsController.timeRanges[index]),
            selected: selectedRangeIndex == index,
            onSelected: (_) => onSelected(index),
          );
        }),
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '核心指标',
      subtitle: '数据尚未接入时使用占位符，避免展示伪造成绩。',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: const <Widget>[
          MetricTile(
            label: '最佳成绩',
            value: '--',
            caption: '接入记录后自动计算',
            icon: Icons.workspace_premium_outlined,
          ),
          MetricTile(
            label: '平均用时',
            value: '--',
            caption: '按筛选范围统计',
            icon: Icons.timer_outlined,
          ),
          MetricTile(
            label: '训练总次数',
            value: '0',
            caption: '等待首条记录写入',
            icon: Icons.repeat_rounded,
          ),
        ],
      ),
    );
  }
}

class _ModeCoverageSection extends StatelessWidget {
  const _ModeCoverageSection();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '统计维度',
      subtitle: '后续会按已支持的模式、尺寸和顺序做聚合统计。',
      child: Column(
        children: TrainingMode.values.map((TrainingMode mode) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              tileColor: mode.tone,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: const BorderSide(color: AppColors.border),
              ),
              leading: Icon(mode.icon),
              title: Text(mode.label),
              subtitle: Text(mode.description),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatsStatusSection extends StatelessWidget {
  const _StatsStatusSection();

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      title: '数据状态',
      subtitle: '当前版本尚未写入训练结果，因此统计页只展示布局与信息层级。',
      child: EmptyStateCard(
        title: '暂无训练成绩',
        message: '完成训练流程和 Isar 写入后，这里会展示最佳成绩、平均用时和训练总次数。',
      ),
    );
  }
}
