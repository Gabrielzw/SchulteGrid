import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../../../domain/models/training_config.dart';
import '../../../domain/models/training_preview_cell.dart';

class TrainingController extends GetxController {
  TrainingController({required this.config, Random? random})
    : _random = random ?? Random() {
    _initializeBoard();
  }

  static const int _alphabetOffset = 65;
  static const int _sequencePreviewCount = 6;

  final TrainingConfig config;
  final Random _random;
  final RxBool showGuideLabels = true.obs;
  late final List<TrainingPreviewCell> cells;
  late final List<String> targetSequence;

  String get title =>
      '${config.gridSize} x ${config.gridSize} ${config.mode.shortLabel}训练';

  String get nextTargetLabel => targetSequence.first;

  String get targetSequencePreview {
    final previewValues = targetSequence
        .take(_sequencePreviewCount)
        .join(' -> ');
    if (targetSequence.length <= _sequencePreviewCount) {
      return previewValues;
    }

    return '$previewValues -> ... -> ${targetSequence.last}';
  }

  void setGuideLabels(bool value) {
    showGuideLabels.value = value;
  }

  void _initializeBoard() {
    final orderedValues = _buildOrderedValues();
    final shuffledValues = List<String>.of(orderedValues)..shuffle(_random);
    targetSequence = _buildTargetSequence(orderedValues);
    final targetOrderLookup = _buildTargetOrderLookup();
    cells = _buildCells(
      shuffledValues: shuffledValues,
      targetOrderLookup: targetOrderLookup,
    );
  }

  List<TrainingPreviewCell> _buildCells({
    required List<String> shuffledValues,
    required Map<String, int> targetOrderLookup,
  }) {
    return shuffledValues
        .map((String label) {
          return TrainingPreviewCell(
            label: label,
            targetOrderLabel: '${targetOrderLookup[label]!}',
            backgroundColor: Colors.white,
            foregroundColor: AppColors.seed,
          );
        })
        .toList(growable: false);
  }

  List<String> _buildOrderedValues() {
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

  List<String> _buildTargetSequence(List<String> orderedValues) {
    if (config.order == TrainingOrder.ascending) {
      return List<String>.of(orderedValues, growable: false);
    }

    return orderedValues.reversed.toList(growable: false);
  }

  Map<String, int> _buildTargetOrderLookup() {
    final targetOrderLookup = <String, int>{};

    for (var index = 0; index < targetSequence.length; index++) {
      targetOrderLookup[targetSequence[index]] = index + 1;
    }

    return targetOrderLookup;
  }
}
