import 'package:flutter/material.dart';

class TrainingPreviewCell {
  const TrainingPreviewCell({
    required this.label,
    required this.targetOrderLabel,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final String targetOrderLabel;
  final Color backgroundColor;
  final Color foregroundColor;
}
