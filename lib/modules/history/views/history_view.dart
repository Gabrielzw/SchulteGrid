import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../controllers/history_controller.dart';
import '../widgets/history_sections.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

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
                const HistoryHeader(),
                const SizedBox(height: 40),
                HistorySummarySection(metrics: controller.summaryMetrics),
                const SizedBox(height: 28),
                HistorySegmentedFilterSection(
                  title: '时间范围',
                  options: controller.timeRangeFilters,
                  selectedOption: controller.selectedTimeRangeFilter.value,
                  labelBuilder: (filter) => filter.label,
                  onSelected: controller.selectTimeRangeFilter,
                ),
                const SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: HistorySegmentedFilterSection(
                        title: '内容模式',
                        options: controller.modeFilters,
                        selectedOption: controller.selectedModeFilter.value,
                        labelBuilder: (filter) => filter.label,
                        onSelected: controller.selectModeFilter,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: HistorySegmentedFilterSection(
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
                HistoryWrapFilterSection<int?>(
                  title: '网格尺寸',
                  trailing: '3 × 3 到 7 × 7',
                  options: <int?>[null, ...controller.gridSizeOptions],
                  selectedOption: controller.selectedGridSize.value,
                  labelBuilder: controller.gridSizeLabel,
                  onSelected: controller.selectGridSize,
                ),
                const SizedBox(height: 28),
                HistoryRecordsSection(
                  title: controller.recordsSectionTitle,
                  subtitle: controller.recordsSectionSubtitle,
                  records: controller.visibleRecords,
                  isLoading: controller.isLoading.value,
                  errorMessage: controller.loadError.value,
                  emptyMessage: controller.emptyMessage,
                  onRetry: controller.refreshRecords,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
