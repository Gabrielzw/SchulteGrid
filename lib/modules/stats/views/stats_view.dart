import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../controllers/stats_controller.dart';
import '../widgets/stats_sections.dart';

class StatsView extends GetView<StatsController> {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          40,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const StatsHeader(),
                const SizedBox(height: 40),
                StatsRangeFilterSection(
                  options: controller.timeRangeFilters,
                  selectedOption: controller.selectedTimeRange.value,
                  onSelected: controller.selectTimeRange,
                ),
                const SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: StatsSegmentedFilterSection(
                        title: '内容模式',
                        options: controller.modeFilters,
                        selectedOption: controller.selectedModeFilter.value,
                        labelBuilder: (filter) => filter.label,
                        onSelected: controller.selectModeFilter,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: StatsSegmentedFilterSection(
                        title: '顺序模式',
                        options: controller.orderFilters,
                        selectedOption: controller.selectedOrderFilter.value,
                        labelBuilder: (filter) => filter.label,
                        onSelected: controller.selectOrderFilter,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                StatsWrapFilterSection<int?>(
                  title: '网格尺寸',
                  trailing: '3 × 3 到 7 × 7',
                  options: <int?>[null, ...controller.gridSizeOptions],
                  selectedOption: controller.selectedGridSize.value,
                  labelBuilder: controller.gridSizeLabel,
                  onSelected: controller.selectGridSize,
                ),
                const SizedBox(height: 28),
                if (controller.isLoading.value)
                  const StatsFeedbackSection(
                    title: '正在汇总训练成绩',
                    message: '本地训练记录读取完成后，会自动展示筛选后的核心指标与模式分析。',
                  )
                else if (controller.loadError.value != null)
                  StatsErrorSection(
                    message: controller.loadError.value!,
                    onRetry: controller.refreshRecords,
                  )
                else ...<Widget>[
                  StatsSummarySection(
                    metrics: controller.summaryMetrics,
                    trailing: controller.selectedTimeRange.value.label,
                  ),
                  const SizedBox(height: 28),
                  if (controller.recordCount == 0)
                    StatsFeedbackSection(
                      title: '当前范围暂无成绩',
                      message: controller.emptyMessage,
                    )
                  else ...<Widget>[
                    StatsModeAnalysisSection(
                      analyses: controller.modeAnalyses,
                      trailing: '${controller.recordCount} 次训练',
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}
