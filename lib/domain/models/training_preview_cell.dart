import 'package:flutter/material.dart';

class TrainingPreviewCell {
  const TrainingPreviewCell({
    required this.label,
    required this.targetOrderLabel,
    required this.isCompleted,
    required this.isError,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final String label;
  final String targetOrderLabel;
  final bool isCompleted;
  final bool isError;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
}
