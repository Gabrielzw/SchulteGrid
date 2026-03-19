import 'package:flutter/material.dart';

class HistorySummaryMetricData {
  const HistorySummaryMetricData({
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

class HistoryRecordViewData {
  const HistoryRecordViewData({
    required this.modeLabel,
    required this.orderLabel,
    required this.gridLabel,
    required this.durationLabel,
    required this.completedAtLabel,
    required this.accuracyLabel,
    required this.errorLabel,
    required this.icon,
    required this.tone,
  });

  final String modeLabel;
  final String orderLabel;
  final String gridLabel;
  final String durationLabel;
  final String completedAtLabel;
  final String accuracyLabel;
  final String errorLabel;
  final IconData icon;
  final Color tone;
}
