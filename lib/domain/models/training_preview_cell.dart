import 'package:flutter/material.dart';

class TrainingPreviewCell {
  const TrainingPreviewCell({
    required this.label,
    required this.displayLabel,
    required this.targetOrderLabel,
    required this.isCompleted,
    required this.isError,
    required this.isCurrentTarget,
    required this.isRecentCorrect,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final String label;
  final String displayLabel;
  final String targetOrderLabel;
  final bool isCompleted;
  final bool isError;
  final bool isCurrentTarget;
  final bool isRecentCorrect;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
}
