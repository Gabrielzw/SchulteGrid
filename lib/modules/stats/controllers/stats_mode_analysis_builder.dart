import 'package:flutter/material.dart';

import '../../../data/models/training_record.dart';
import '../../../domain/enums/training_mode.dart';
import '../models/stats_view_data.dart';
import 'stats_analysis_utils.dart';
import 'stats_mode_insight_builder.dart';

List<StatsModeAnalysisData> buildStatsModeAnalyses(
  List<TrainingRecord> records, {
  required List<TrainingMode> modes,
}) {
  return modes
      .map(
        (TrainingMode mode) => _buildModeAnalysis(
          mode: mode,
          records: _recordsForMode(records, mode),
        ),
      )
      .toList(growable: false);
}

StatsModeAnalysisData _buildModeAnalysis({
  required TrainingMode mode,
  required List<TrainingRecord> records,
}) {
  final description = records.isEmpty ? '当前时间范围暂无完成记录。' : mode.description;

  return StatsModeAnalysisData(
    label: mode.shortLabel,
    description: description,
    sessionCountLabel: '${records.length} 次训练',
    icon: mode.icon,
    tone: mode.tone,
    basicMetrics: _buildModeBasicMetrics(records),
    trend: buildTrendInsight(records),
    stability: buildStabilityInsight(records),
  );
}

List<StatsSummaryMetricData> _buildModeBasicMetrics(
  List<TrainingRecord> records,
) {
  final count = records.length;

  return <StatsSummaryMetricData>[
    StatsSummaryMetricData(
      label: '最佳成绩',
      value: formatDurationLabel(fastestDuration(records)),
      caption: count == 0 ? '当前范围还没有成绩' : '本模式下完成最快的一局',
      icon: Icons.workspace_premium_outlined,
    ),
    StatsSummaryMetricData(
      label: '平均用时',
      value: formatDurationLabel(averageDuration(records)),
      caption: count == 0 ? '暂无可计算成绩' : '当前模式的平均完成用时',
      icon: Icons.timer_outlined,
    ),
    StatsSummaryMetricData(
      label: '训练次数',
      value: '$count',
      caption: count == 0 ? '完成后自动累计' : '当前范围内的完成局数',
      icon: Icons.repeat_rounded,
    ),
    StatsSummaryMetricData(
      label: '平均错误',
      value: count == 0 ? '--' : '${formatDecimal(averageErrors(records))} 次',
      caption: count == 0 ? '完成后自动统计' : '每局平均误触次数',
      icon: Icons.error_outline_rounded,
    ),
  ];
}

List<TrainingRecord> _recordsForMode(
  List<TrainingRecord> records,
  TrainingMode mode,
) {
  return records
      .where((TrainingRecord record) => record.mode == mode.storageValue)
      .toList(growable: false);
}
