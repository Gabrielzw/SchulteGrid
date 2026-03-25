import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/enums/record_time_range.dart';
import '../models/stats_view_data.dart';
import 'stats_cards.dart';

class StatsHeader extends StatelessWidget {
  const StatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '训练成绩',
          style: textTheme.displaySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '按时间范围查看最佳成绩、平均用时和不同模式下的完成表现。',
          style: textTheme.titleMedium?.copyWith(
            color: palette.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class StatsRangeFilterSection extends StatelessWidget {
  const StatsRangeFilterSection({
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    super.key,
  });

  final List<RecordTimeRange> options;
  final RecordTimeRange selectedOption;
  final ValueChanged<RecordTimeRange> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader(title: '时间范围', trailing: '本地数据实时汇总'),
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
                  (RecordTimeRange option) => Expanded(
                    child: StatsFilterCard(
                      label: option.label,
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

class StatsSummarySection extends StatelessWidget {
  const StatsSummarySection({
    required this.metrics,
    required this.trailing,
    super.key,
  });

  final List<StatsSummaryMetricData> metrics;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionHeader(title: '核心指标', trailing: trailing),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: metrics
              .map(
                (StatsSummaryMetricData metric) =>
                    StatsMetricCard(metric: metric),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class StatsHighlightsSection extends StatelessWidget {
  const StatsHighlightsSection({
    required this.bestRecord,
    required this.latestRecord,
    super.key,
  });

  final StatsSessionHighlightData bestRecord;
  final StatsSessionHighlightData latestRecord;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader(title: '成绩亮点', trailing: '当前范围内'),
        const SizedBox(height: AppSpacing.md),
        StatsSessionHighlightCard(data: bestRecord),
        const SizedBox(height: AppSpacing.sm),
        StatsSessionHighlightCard(data: latestRecord),
      ],
    );
  }
}

class StatsModeInsightsSection extends StatelessWidget {
  const StatsModeInsightsSection({
    required this.insights,
    required this.trailing,
    super.key,
  });

  final List<StatsModeInsightData> insights;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionHeader(title: '模式表现', trailing: trailing),
        const SizedBox(height: AppSpacing.md),
        Column(
          children: insights
              .map(
                (StatsModeInsightData insight) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: StatsModeInsightCard(data: insight),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class StatsFeedbackSection extends StatelessWidget {
  const StatsFeedbackSection({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader(title: '数据状态'),
        const SizedBox(height: AppSpacing.md),
        StatsStateCard(title: title, message: message),
      ],
    );
  }
}

class StatsErrorSection extends StatelessWidget {
  const StatsErrorSection({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader(title: '数据状态'),
        const SizedBox(height: AppSpacing.md),
        StatsErrorCard(message: message, onRetry: onRetry),
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
