class TrainingPreviewCell {
  const TrainingPreviewCell({
    required this.label,
    required this.displayLabel,
    required this.targetOrderLabel,
    required this.isCompleted,
    required this.isError,
    required this.isCurrentTarget,
    required this.isRecentCorrect,
  });

  final String label;
  final String displayLabel;
  final String targetOrderLabel;
  final bool isCompleted;
  final bool isError;
  final bool isCurrentTarget;
  final bool isRecentCorrect;
}
