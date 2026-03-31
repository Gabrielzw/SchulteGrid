export 'stats_mode_analysis_builder.dart' show buildStatsModeAnalyses;

import 'package:flutter/material.dart';

import '../../../data/models/training_record.dart';
import '../models/stats_view_data.dart';
import 'stats_analysis_utils.dart';

List<StatsSummaryMetricData> buildStatsSummaryMetrics(
  List<TrainingRecord> records,
) {
  final count = records.length;

  return <StatsSummaryMetricData>[
    StatsSummaryMetricData(
      label: '最佳成绩',
      value: formatDurationLabel(fastestDuration(records)),
      caption: count == 0 ? '当前范围还没有成绩' : '筛选范围内用时最短的一局',
      icon: Icons.workspace_premium_outlined,
    ),
    StatsSummaryMetricData(
      label: '平均用时',
      value: formatDurationLabel(averageDuration(records)),
      caption: count == 0 ? '暂无可计算成绩' : '已汇总 $count 次完成记录',
      icon: Icons.timer_outlined,
    ),
    StatsSummaryMetricData(
      label: '训练总次数',
      value: '$count',
      caption: count == 0 ? '完成首轮训练后自动更新' : '本地记录实时读取',
      icon: Icons.repeat_rounded,
    ),
  ];
}
