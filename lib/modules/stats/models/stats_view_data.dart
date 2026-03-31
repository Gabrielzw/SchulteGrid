import 'package:flutter/material.dart';

class StatsSummaryMetricData {
  const StatsSummaryMetricData({
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
  });

  final String label;
  final String value;
  final String caption;
  final IconData icon;
}

class StatsMetricValueData {
  const StatsMetricValueData({required this.label, required this.value});

  final String label;
  final String value;
}

class StatsTrendPointData {
  const StatsTrendPointData({
    required this.label,
    required this.valueLabel,
    required this.intensity,
    required this.isLatest,
  });

  final String label;
  final String valueLabel;
  final double intensity;
  final bool isLatest;
}

class StatsTrendInsightData {
  const StatsTrendInsightData({
    required this.deltaLabel,
    required this.summary,
    required this.caption,
    required this.points,
  });

  final String deltaLabel;
  final String summary;
  final String caption;
  final List<StatsTrendPointData> points;
}

class StatsStabilityInsightData {
  const StatsStabilityInsightData({
    required this.badgeLabel,
    required this.summary,
    required this.metrics,
    required this.chips,
  });

  final String badgeLabel;
  final String summary;
  final List<StatsMetricValueData> metrics;
  final List<String> chips;
}

class StatsModeAnalysisData {
  const StatsModeAnalysisData({
    required this.label,
    required this.description,
    required this.sessionCountLabel,
    required this.icon,
    required this.tone,
    required this.basicMetrics,
    required this.trend,
    required this.stability,
  });

  final String label;
  final String description;
  final String sessionCountLabel;
  final IconData icon;
  final Color tone;
  final List<StatsSummaryMetricData> basicMetrics;
  final StatsTrendInsightData trend;
  final StatsStabilityInsightData stability;
}
