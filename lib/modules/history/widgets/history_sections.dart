import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_adaptive_grid.dart';
import '../models/history_record_view_data.dart';
import 'history_cards.dart';
import 'history_record_cards.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '训练历史',
          style: textTheme.displaySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '按时间范围、模式、尺寸和顺序回看每一条训练成绩。',
          style: textTheme.titleMedium?.copyWith(
            color: palette.textSecondary,
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
        const _SectionHeader(title: '记录概览'),
        const SizedBox(height: AppSpacing.md),
        AppAdaptiveGrid(
          itemCount: metrics.length,
          minChildWidth: 116,
          maxColumns: 3,
          itemBuilder: (BuildContext context, int index) {
            return HistoryMetricCard(metric: metrics[index]);
          },
        ),
      ],
    );
  }
}

class HistorySegmentedFilterSection<T> extends StatelessWidget {
  const HistorySegmentedFilterSection({
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.labelBuilder,
    required this.onSelected,
    super.key,
  });

  final String title;
  final List<T> options;
  final T selectedOption;
  final String Function(T option) labelBuilder;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionHeader(title: title),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: palette.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: options
                .map(
                  (T option) => Expanded(
                    child: HistoryFilterCard(
                      label: labelBuilder(option),
                      isSelected: option == selectedOption,
                      onTap: () => onSelected(option),
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

class HistoryWrapFilterSection<T> extends StatelessWidget {
  const HistoryWrapFilterSection({
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.labelBuilder,
    required this.onSelected,
    this.trailing,
    super.key,
  });

  final String title;
  final List<T> options;
  final T selectedOption;
  final String Function(T option) labelBuilder;
  final ValueChanged<T> onSelected;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionHeader(title: title, trailing: trailing),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: options
              .map(
                (T option) => HistoryFilterChipCard(
                  label: labelBuilder(option),
                  isSelected: option == selectedOption,
                  onTap: () => onSelected(option),
                ),
              )
              .toList(growable: false),
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
            color: context.appColors.textSecondary,
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
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}
