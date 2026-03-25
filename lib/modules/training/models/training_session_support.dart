import 'dart:math';

import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../../../domain/models/training_config.dart';
import '../../../domain/models/training_preview_cell.dart';

const int _alphabetOffset = 65;

class TrainingBoardSnapshot {
  const TrainingBoardSnapshot({
    required this.orderedValues,
    required this.boardValues,
    required this.targetSequence,
    required this.targetOrderLookup,
  });

  final List<String> orderedValues;
  final List<String> boardValues;
  final List<String> targetSequence;
  final Map<String, int> targetOrderLookup;
}

TrainingBoardSnapshot buildTrainingBoardSnapshot({
  required TrainingConfig config,
  required Random random,
}) {
  final orderedValues = _buildOrderedValues(config);
  final targetSequence = _buildTargetSequence(config.order, orderedValues);

  return TrainingBoardSnapshot(
    orderedValues: orderedValues,
    boardValues: reshuffleBoardValues(orderedValues, random),
    targetSequence: targetSequence,
    targetOrderLookup: _buildTargetOrderLookup(targetSequence),
  );
}

List<String> reshuffleBoardValues(List<String> orderedValues, Random random) {
  return List<String>.of(orderedValues, growable: false)..shuffle(random);
}

List<TrainingPreviewCell> buildTrainingCells({
  required TrainingConfig config,
  required List<String> boardValues,
  required Map<String, int> targetOrderLookup,
  required Set<String> completedLabels,
  required String? errorLabel,
  required String? currentTargetLabel,
  required String? recentCorrectLabel,
  required bool highlightCompletedTrail,
  required bool revealLabels,
}) {
  return boardValues
      .map((String label) {
        return _buildCell(
          config: config,
          label: label,
          targetOrderLookup: targetOrderLookup,
          completedLabels: completedLabels,
          errorLabel: errorLabel,
          currentTargetLabel: currentTargetLabel,
          recentCorrectLabel: recentCorrectLabel,
          highlightCompletedTrail: highlightCompletedTrail,
          revealLabels: revealLabels,
        );
      })
      .toList(growable: false);
}

String formatTrainingDuration(Duration duration) {
  final totalMilliseconds = duration.inMilliseconds;
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  final centiseconds = ((totalMilliseconds % 1000) ~/ 10).toString().padLeft(
    2,
    '0',
  );

  return '$minutes:$seconds.$centiseconds';
}

String formatTrainingLabel(String label) => label;

TrainingPreviewCell _buildCell({
  required TrainingConfig config,
  required String label,
  required Map<String, int> targetOrderLookup,
  required Set<String> completedLabels,
  required String? errorLabel,
  required String? currentTargetLabel,
  required String? recentCorrectLabel,
  required bool highlightCompletedTrail,
  required bool revealLabels,
}) {
  final isCompleted = completedLabels.contains(label);
  final isError = errorLabel == label;
  final isCurrentTarget = currentTargetLabel == label;
  final isRecentCorrect = highlightCompletedTrail
      ? isCompleted
      : recentCorrectLabel == label;

  return TrainingPreviewCell(
    label: label,
    displayLabel: revealLabels ? formatTrainingLabel(label) : '',
    targetOrderLabel: '${targetOrderLookup[label]!}',
    isCompleted: isCompleted,
    isError: isError,
    isCurrentTarget: isCurrentTarget,
    isRecentCorrect: isRecentCorrect,
  );
}

List<String> _buildOrderedValues(TrainingConfig config) {
  switch (config.mode) {
    case TrainingMode.numbers:
      return List<String>.generate(
        config.totalCells,
        (int index) => '${index + 1}',
        growable: false,
      );
    case TrainingMode.letters:
      return List<String>.generate(
        config.totalCells,
        (int index) => String.fromCharCode(_alphabetOffset + index),
        growable: false,
      );
  }
}

List<String> _buildTargetSequence(
  TrainingOrder order,
  List<String> orderedValues,
) {
  if (order == TrainingOrder.ascending) {
    return List<String>.of(orderedValues, growable: false);
  }

  return orderedValues.reversed.toList(growable: false);
}

Map<String, int> _buildTargetOrderLookup(List<String> targetSequence) {
  final targetOrderLookup = <String, int>{};

  for (var index = 0; index < targetSequence.length; index++) {
    targetOrderLookup[targetSequence[index]] = index + 1;
  }

  return targetOrderLookup;
}
