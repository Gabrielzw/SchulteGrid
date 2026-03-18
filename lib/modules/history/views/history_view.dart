import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/empty_state_card.dart';
import '../../../app/widgets/section_card.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

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
            _HistoryHero(
              selectedFilterIndex: controller.selectedFilterIndex.value,
              onSelected: controller.selectFilter,
            ),
            const SizedBox(height: AppSpacing.lg),
            const _HistoryStateSection(),
            const SizedBox(height: AppSpacing.lg),
            const _HistoryStructureSection(),
          ],
        ),
      );
    });
  }
}

class _HistoryHero extends StatelessWidget {
  const _HistoryHero({
    required this.selectedFilterIndex,
    required this.onSelected,
  });

  final int selectedFilterIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '训练历史',
      subtitle: '列表页已预留筛选和记录结构，后续将直接读取本地 Isar 数据。',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: List<Widget>.generate(HistoryController.filters.length, (
          int index,
        ) {
          return ChoiceChip(
            label: Text(HistoryController.filters[index]),
            selected: selectedFilterIndex == index,
            onSelected: (_) => onSelected(index),
          );
        }),
      ),
    );
  }
}

class _HistoryStateSection extends StatelessWidget {
  const _HistoryStateSection();

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      title: '记录列表',
      subtitle: '当前没有真实训练记录，因此明确展示空态。',
      child: EmptyStateCard(
        title: '暂无历史成绩',
        message: '训练完成并写入本地数据库后，这里会按时间倒序展示历次模式、尺寸和用时。',
      ),
    );
  }
}

class _HistoryStructureSection extends StatelessWidget {
  const _HistoryStructureSection();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '预留字段',
      subtitle: '列表项布局已经按需求文档中的关键信息拆分。',
      child: Column(
        children: const <Widget>[
          _HistoryFieldTile(title: '完成时间', description: '用于时间倒序排序和回顾训练节奏。'),
          SizedBox(height: AppSpacing.sm),
          _HistoryFieldTile(title: '训练模式', description: '区分标准数字、倒序、字母与颜色模式。'),
          SizedBox(height: AppSpacing.sm),
          _HistoryFieldTile(
            title: '方格尺寸',
            description: '展示 N x N 配置，支持回看训练难度。',
          ),
          SizedBox(height: AppSpacing.sm),
          _HistoryFieldTile(title: '完成用时', description: '用于与统计页联动计算最佳成绩和平均值。'),
        ],
      ),
    );
  }
}

class _HistoryFieldTile extends StatelessWidget {
  const _HistoryFieldTile({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.border),
      ),
      title: Text(title),
      subtitle: Text(description),
    );
  }
}
