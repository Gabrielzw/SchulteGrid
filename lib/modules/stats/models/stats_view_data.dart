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

class StatsSessionHighlightData {
  const StatsSessionHighlightData({
    required this.title,
    required this.caption,
    required this.badgeLabel,
    required this.durationLabel,
    required this.metaLabel,
    required this.completedAtLabel,
    required this.primaryChipLabel,
    required this.secondaryChipLabel,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String caption;
  final String badgeLabel;
  final String durationLabel;
  final String metaLabel;
  final String completedAtLabel;
  final String primaryChipLabel;
  final String secondaryChipLabel;
  final IconData icon;
  final Color tone;
}

class StatsModeInsightData {
  const StatsModeInsightData({
    required this.label,
    required this.description,
    required this.sessionCountLabel,
    required this.bestDurationLabel,
    required this.averageDurationLabel,
    required this.icon,
    required this.tone,
  });

  final String label;
  final String description;
  final String sessionCountLabel;
  final String bestDurationLabel;
  final String averageDurationLabel;
  final IconData icon;
  final Color tone;
}
