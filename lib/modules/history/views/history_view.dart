import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../data/models/training_record.dart';
import '../controllers/history_controller.dart';
import '../widgets/history_record_cards.dart';
import '../widgets/history_sections.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  static const double _topSpacing = 40;
  static const double _sectionSpacing = 28;
  static const PageStorageKey<String> _scrollKey = PageStorageKey<String>(
    'history-scroll-view',
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final records = controller.filteredRecords;
      return CustomScrollView(key: _scrollKey, slivers: _buildSlivers(records));
    });
  }

  List<Widget> _buildSlivers(List<TrainingRecord> records) {
    return <Widget>[
      const HistoryGapSliver(height: _topSpacing),
      const HistoryConstrainedSliver(child: HistoryHeader()),
      const HistoryGapSliver(height: _topSpacing),
      HistoryConstrainedSliver(
        child: HistorySummarySection(metrics: controller.summaryMetrics),
      ),
      ..._buildFilterSlivers(),
      const HistoryGapSliver(height: _sectionSpacing),
      HistoryConstrainedSliver(
        child: HistoryRecordsHeader(
          title: controller.recordsSectionTitle,
          subtitle: controller.recordsSectionSubtitle,
        ),
      ),
      const HistoryGapSliver(height: AppSpacing.md),
      ..._buildRecordSlivers(records),
      const HistoryGapSliver(height: AppSpacing.xl),
    ];
  }

  List<Widget> _buildFilterSlivers() {
    return <Widget>[
      const HistoryGapSliver(height: _sectionSpacing),
      HistoryConstrainedSliver(
        child: HistorySegmentedFilterSection(
          title: '时间范围',
          options: controller.timeRangeFilters,
          selectedOption: controller.selectedTimeRangeFilter.value,
          labelBuilder: (filter) => filter.label,
          onSelected: controller.selectTimeRangeFilter,
        ),
      ),
      const HistoryGapSliver(height: _sectionSpacing),
      HistoryConstrainedSliver(
        child: Row(
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
      ),
      const HistoryGapSliver(height: _sectionSpacing),
      HistoryConstrainedSliver(
        child: HistoryWrapFilterSection<int?>(
          title: '网格尺寸',
          trailing: '3 × 3 到 7 × 7',
          options: <int?>[null, ...controller.gridSizeOptions],
          selectedOption: controller.selectedGridSize.value,
          labelBuilder: controller.gridSizeLabel,
          onSelected: controller.selectGridSize,
        ),
      ),
    ];
  }

  List<Widget> _buildRecordSlivers(List<TrainingRecord> records) {
    if (controller.isLoading.value) {
      return const <Widget>[
        HistoryConstrainedSliver(
          child: HistoryStateCard(
            title: '正在读取历史记录',
            message: '本地数据加载完成后会立即展示在这里。',
          ),
        ),
      ];
    }

    final errorMessage = controller.loadError.value;
    if (errorMessage != null) {
      return <Widget>[
        HistoryConstrainedSliver(
          child: HistoryErrorCard(
            message: errorMessage,
            onRetry: controller.refreshRecords,
          ),
        ),
      ];
    }

    if (records.isEmpty) {
      return <Widget>[
        HistoryConstrainedSliver(
          child: HistoryStateCard(
            title: '暂无历史成绩',
            message: controller.emptyMessage,
          ),
        ),
      ];
    }

    return <Widget>[
      HistoryRecordListSliver(
        records: records,
        recordBuilder: controller.buildRecordViewData,
      ),
    ];
  }
}
