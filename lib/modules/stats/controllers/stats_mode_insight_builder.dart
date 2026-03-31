import 'dart:math';

import '../../../data/models/training_record.dart';
import '../models/stats_view_data.dart';
import 'stats_analysis_utils.dart';

const int _trendMinimumSampleSize = 2;
const int _trendMaximumSampleSize = 3;
const int _trendChartPointLimit = 6;
const double _neutralTrendThreshold = 0.03;
const double _stableVariationThreshold = 0.08;
const double _moderateVariationThreshold = 0.18;
const double _minimumTrendIntensity = 0.32;
const double _trendIntensityRange = 0.68;

StatsTrendInsightData buildTrendInsight(List<TrainingRecord> records) {
  final points = _buildTrendPoints(records);
  final sampleSize = min(_trendMaximumSampleSize, records.length ~/ 2);

  if (records.isEmpty) {
    return StatsTrendInsightData(
      deltaLabel: '暂无趋势',
      summary: '完成训练后，这里会对比最近表现与更早表现。',
      caption: '最近 6 次训练会按时间顺序显示在下方。',
      points: points,
    );
  }

  if (sampleSize < _trendMinimumSampleSize) {
    return StatsTrendInsightData(
      deltaLabel: '记录不足',
      summary: '至少 4 次训练后，才会输出最近表现的变化方向。',
      caption: '当前已记录 ${records.length} 次训练。',
      points: points,
    );
  }

  final recentRecords = records.take(sampleSize).toList(growable: false);
  final previousRecords = records
      .skip(sampleSize)
      .take(sampleSize)
      .toList(growable: false);
  final recentAverage = averageMilliseconds(recentRecords);
  final previousAverage = averageMilliseconds(previousRecords);
  final deltaRatio = previousAverage == 0
      ? 0.0
      : (previousAverage - recentAverage) / previousAverage;

  return StatsTrendInsightData(
    deltaLabel: _buildTrendDeltaLabel(deltaRatio),
    summary: _buildTrendSummary(
      sampleSize: sampleSize,
      recentLabel: formatDurationFromMilliseconds(recentAverage),
      previousLabel: formatDurationFromMilliseconds(previousAverage),
      deltaRatio: deltaRatio,
    ),
    caption: '最近 ${points.length} 次训练，柱高越高表示完成越快。',
    points: points,
  );
}

StatsStabilityInsightData buildStabilityInsight(List<TrainingRecord> records) {
  if (records.isEmpty) {
    return const StatsStabilityInsightData(
      badgeLabel: '暂无分析',
      summary: '完成训练后，这里会根据用时波动判断稳定性。',
      metrics: <StatsMetricValueData>[
        StatsMetricValueData(label: '波动幅度', value: '--'),
        StatsMetricValueData(label: '最好/最差差值', value: '--'),
        StatsMetricValueData(label: '中位用时', value: '--'),
      ],
      chips: <String>['平均错误 --'],
    );
  }

  if (records.length < 2) {
    return StatsStabilityInsightData(
      badgeLabel: '记录不足',
      summary: '至少 2 次训练后，才能判断这一模式是否稳定。',
      metrics: <StatsMetricValueData>[
        const StatsMetricValueData(label: '波动幅度', value: '--'),
        const StatsMetricValueData(label: '最好/最差差值', value: '--'),
        StatsMetricValueData(
          label: '中位用时',
          value: formatDurationLabel(averageDuration(records)),
        ),
      ],
      chips: <String>['平均错误 ${formatDecimal(averageErrors(records))} 次'],
    );
  }

  final average = averageMilliseconds(records);
  final deviation = standardDeviationMilliseconds(records, average);
  final variationRatio = average == 0 ? 0.0 : deviation / average;

  return StatsStabilityInsightData(
    badgeLabel: _buildStabilityBadge(variationRatio),
    summary: _buildStabilitySummary(
      count: records.length,
      variationRatio: variationRatio,
      spreadLabel: formatDurationFromMilliseconds(spreadMilliseconds(records)),
    ),
    metrics: <StatsMetricValueData>[
      StatsMetricValueData(
        label: '波动幅度',
        value: formatDurationFromMilliseconds(deviation),
      ),
      StatsMetricValueData(
        label: '最好/最差差值',
        value: formatDurationFromMilliseconds(spreadMilliseconds(records)),
      ),
      StatsMetricValueData(
        label: '中位用时',
        value: formatDurationFromMilliseconds(medianMilliseconds(records)),
      ),
    ],
    chips: <String>['平均错误 ${formatDecimal(averageErrors(records))} 次'],
  );
}

List<StatsTrendPointData> _buildTrendPoints(List<TrainingRecord> records) {
  final recentRecords = records
      .take(_trendChartPointLimit)
      .toList(growable: false)
      .reversed
      .toList(growable: false);

  if (recentRecords.isEmpty) {
    return const <StatsTrendPointData>[];
  }

  final durations = recentRecords
      .map((TrainingRecord record) => record.durationInMilliseconds)
      .toList(growable: false);
  final fastest = durations.reduce(min);
  final slowest = durations.reduce(max);

  return recentRecords.asMap().entries.map((entry) {
    final index = entry.key;
    final record = entry.value;
    return StatsTrendPointData(
      label: formatShortDate(record.completedAt),
      valueLabel: formatDurationFromMilliseconds(
        record.durationInMilliseconds.toDouble(),
      ),
      intensity: _resolveTrendIntensity(
        duration: record.durationInMilliseconds,
        fastest: fastest,
        slowest: slowest,
      ),
      isLatest: index == recentRecords.length - 1,
    );
  }).toList(growable: false);
}

double _resolveTrendIntensity({
  required int duration,
  required int fastest,
  required int slowest,
}) {
  if (fastest == slowest) {
    return _minimumTrendIntensity + (_trendIntensityRange / 2);
  }

  final normalized = (slowest - duration) / (slowest - fastest);
  return _minimumTrendIntensity + (normalized * _trendIntensityRange);
}

String _buildTrendDeltaLabel(double deltaRatio) {
  if (deltaRatio.abs() < _neutralTrendThreshold) {
    return '基本持平';
  }

  final percentage = (deltaRatio.abs() * 100).round();
  return deltaRatio > 0 ? '快 $percentage%' : '慢 $percentage%';
}

String _buildTrendSummary({
  required int sampleSize,
  required String recentLabel,
  required String previousLabel,
  required double deltaRatio,
}) {
  if (deltaRatio.abs() < _neutralTrendThreshold) {
    return '最近 $sampleSize 次平均用时 $recentLabel，与更早 $sampleSize 次的 '
        '$previousLabel 基本持平。';
  }

  final percentage = (deltaRatio.abs() * 100).round();
  final direction = deltaRatio > 0 ? '更快' : '更慢';

  return '最近 $sampleSize 次平均用时 $recentLabel，比更早 $sampleSize 次的 '
      '$previousLabel $direction $percentage%。';
}

String _buildStabilityBadge(double variationRatio) {
  if (variationRatio <= _stableVariationThreshold) {
    return '稳定';
  }

  if (variationRatio <= _moderateVariationThreshold) {
    return '轻微波动';
  }

  return '波动较大';
}

String _buildStabilitySummary({
  required int count,
  required double variationRatio,
  required String spreadLabel,
}) {
  final badgeLabel = _buildStabilityBadge(variationRatio);
  return '最近 $count 次训练整体为“$badgeLabel”，最好与最差相差 $spreadLabel。';
}
