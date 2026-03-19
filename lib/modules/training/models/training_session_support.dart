import 'dart:math';

import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../../../domain/models/training_config.dart';
import '../../../domain/models/training_preview_cell.dart';

const int _alphabetOffset = 65;
const Color _errorBackground = Color(0xFFFCE8E9);
const Color _errorForeground = Color(0xFFB3261E);
const Color _completedBackground = Color(0xFFE2F0EA);
const Color _completedBorder = Color(0xFF6A9A8D);

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
  required List<String> boardValues,
  required Map<String, int> targetOrderLookup,
  required Set<String> completedLabels,
  required String? errorLabel,
}) {
  return boardValues
      .map((String label) {
        return _buildCell(
          label: label,
          targetOrderLookup: targetOrderLookup,
          completedLabels: completedLabels,
          errorLabel: errorLabel,
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

TrainingPreviewCell _buildCell({
  required String label,
  required Map<String, int> targetOrderLookup,
  required Set<String> completedLabels,
  required String? errorLabel,
}) {
  final isCompleted = completedLabels.contains(label);
  final isError = errorLabel == label;

  return TrainingPreviewCell(
    label: label,
    targetOrderLabel: '${targetOrderLookup[label]!}',
    isCompleted: isCompleted,
    isError: isError,
    backgroundColor: _resolveBackgroundColor(
      isCompleted: isCompleted,
      isError: isError,
    ),
    foregroundColor: _resolveForegroundColor(
      isCompleted: isCompleted,
      isError: isError,
    ),
    borderColor: _resolveBorderColor(
      isCompleted: isCompleted,
      isError: isError,
    ),
  );
}

Color _resolveBackgroundColor({
  required bool isCompleted,
  required bool isError,
}) {
  if (isError) {
    return _errorBackground;
  }
  if (isCompleted) {
    return _completedBackground;
  }
  return Colors.white;
}

Color _resolveForegroundColor({
  required bool isCompleted,
  required bool isError,
}) {
  if (isError) {
    return _errorForeground;
  }
  return AppColors.seed;
}

Color _resolveBorderColor({required bool isCompleted, required bool isError}) {
  if (isError) {
    return _errorForeground;
  }
  if (isCompleted) {
    return _completedBorder;
  }
  return AppColors.border;
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
