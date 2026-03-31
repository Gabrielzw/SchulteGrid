import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../models/stats_view_data.dart';
import 'stats_adaptive_grid.dart';
import 'stats_mode_analysis_parts.dart';

class StatsModeAnalysisCard extends StatelessWidget {
  const StatsModeAnalysisCard({required this.data, super.key});

  final StatsModeAnalysisData data;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              StatsModeBadge(
                icon: data.icon,
                label: data.label,
                tone: data.tone,
              ),
              const Spacer(),
              Text(
                data.sessionCountLabel,
                style: textTheme.labelLarge?.copyWith(
                  color: palette.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.description,
            style: textTheme.bodyMedium?.copyWith(
              color: palette.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _StatsModeSubsectionLabel(title: '基础统计'),
          const SizedBox(height: AppSpacing.sm),
          StatsAdaptiveGrid(
            itemCount: data.basicMetrics.length,
            minChildWidth: 148,
            maxColumns: 2,
            itemBuilder: (BuildContext context, int index) {
              return StatsModeMetricTile(metric: data.basicMetrics[index]);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          const _StatsModeSubsectionLabel(title: '趋势'),
          const SizedBox(height: AppSpacing.sm),
          StatsModeInsightPanel(child: _TrendContent(data: data.trend)),
          const SizedBox(height: AppSpacing.lg),
          const _StatsModeSubsectionLabel(title: '稳定性'),
          const SizedBox(height: AppSpacing.sm),
          StatsModeInsightPanel(child: _StabilityContent(data: data.stability)),
        ],
      ),
    );
  }
}

class _TrendContent extends StatelessWidget {
  const _TrendContent({required this.data});

  final StatsTrendInsightData data;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          data.deltaLabel,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          data.summary,
          style: textTheme.bodyMedium?.copyWith(
            color: palette.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (data.points.isNotEmpty)
          _TrendBars(points: data.points)
        else
          StatsModeEmptyStrip(label: data.caption),
        if (data.points.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Text(
            data.caption,
            style: textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _StabilityContent extends StatelessWidget {
  const _StabilityContent({required this.data});

  final StatsStabilityInsightData data;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StatsModeBadgeChip(label: data.badgeLabel),
        const SizedBox(height: AppSpacing.sm),
        Text(
          data.summary,
          style: textTheme.bodyMedium?.copyWith(
            color: palette.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        StatsAdaptiveGrid(
          itemCount: data.metrics.length,
          minChildWidth: 108,
          maxColumns: 3,
          itemBuilder: (BuildContext context, int index) {
            return StatsModeValuePill(metric: data.metrics[index]);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: data.chips
              .map((String label) => StatsModeBadgeChip(label: label))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _TrendBars extends StatelessWidget {
  const _TrendBars({required this.points});

  final List<StatsTrendPointData> points;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final selectedColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 132,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: points
            .map((StatsTrendPointData point) {
              final barColor = point.isLatest
                  ? selectedColor
                  : selectedColor.withValues(
                      alpha: 0.22 + (point.intensity * 0.5),
                    );
              final barHeight = 24 + (point.intensity * 60);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Tooltip(
                        message: '${point.label} · ${point.valueLabel}',
                        child: Container(
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        point.label,
                        style: textTheme.labelSmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _StatsModeSubsectionLabel extends StatelessWidget {
  const _StatsModeSubsectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }
}

BoxDecoration _cardDecoration(BuildContext context) {
  final palette = context.appColors;

  return BoxDecoration(
    color: palette.cardBackground,
    borderRadius: BorderRadius.circular(AppRadius.md),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: palette.shadowColor,
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
