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
                HistoryFilterSection(
                  filters: controller.filters,
                  selectedFilter: controller.selectedFilter.value,
                  onSelected: controller.selectFilter,
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
