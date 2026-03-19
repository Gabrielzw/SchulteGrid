import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../models/history_filter.dart';
import '../models/history_record_view_data.dart';
import 'history_cards.dart';
import 'history_record_cards.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '训练历史',
          style: textTheme.displaySmall?.copyWith(
            color: AppColors.seed,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '回看最近的训练节奏，按模式筛选每一条成绩。',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class HistorySummarySection extends StatelessWidget {
  const HistorySummarySection({required this.metrics, super.key});

  final List<HistorySummaryMetricData> metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader(title: '记录概览', trailing: '实时读取本地数据'),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: metrics
              .map(
                (HistorySummaryMetricData metric) =>
                    HistoryMetricCard(metric: metric),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class HistoryFilterSection extends StatelessWidget {
  const HistoryFilterSection({
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
    super.key,
  });

  final List<HistoryFilter> filters;
  final HistoryFilter selectedFilter;
  final ValueChanged<HistoryFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader(title: '筛选模式'),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: filters
                .map(
                  (HistoryFilter filter) => Expanded(
                    child: HistoryFilterCard(
                      label: filter.label,
                      isSelected: filter == selectedFilter,
                      onTap: () => onSelected(filter),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class HistoryRecordsSection extends StatelessWidget {
  const HistoryRecordsSection({
    required this.title,
    required this.subtitle,
    required this.records,
    required this.isLoading,
    required this.errorMessage,
    required this.emptyMessage,
    required this.onRetry,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<HistoryRecordViewData> records;
  final bool isLoading;
  final String? errorMessage;
  final String emptyMessage;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionHeader(title: title, trailing: '按时间倒序'),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (isLoading)
          const HistoryStateCard(
            title: '正在读取历史记录',
            message: '本地数据加载完成后会立即展示在这里。',
          )
        else if (errorMessage != null)
          HistoryErrorCard(message: errorMessage!, onRetry: onRetry)
        else if (records.isEmpty)
          HistoryStateCard(title: '暂无历史成绩', message: emptyMessage)
        else
          Column(
            children: records
                .map(
                  (HistoryRecordViewData record) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: HistoryRecordCard(record: record),
                  ),
                )
                .toList(growable: false),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: textTheme.labelLarge?.copyWith(
              color: AppColors.seed,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}
