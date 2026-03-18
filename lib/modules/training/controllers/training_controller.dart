import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../../../domain/models/training_config.dart';
import '../../../domain/models/training_preview_cell.dart';

class TrainingController extends GetxController {
  TrainingController({required this.config});

  static const int _alphabetOffset = 65;
  static const Color _colorStart = Color(0xFFF8F1AF);
  static const Color _colorEnd = Color(0xFF29504A);

  final TrainingConfig config;
  final RxBool showGuideLabels = true.obs;

  List<TrainingPreviewCell> get cells {
    switch (config.mode) {
      case TrainingMode.numbers:
        return _buildNumberCells();
      case TrainingMode.letters:
        return _buildLetterCells();
      case TrainingMode.colors:
        return _buildColorCells();
    }
  }

  String get title => '${config.gridSize} x ${config.gridSize} 训练页';

  void setGuideLabels(bool value) {
    showGuideLabels.value = value;
  }

  List<TrainingPreviewCell> _buildColorCells() {
    final lastIndex = config.totalCells - 1;

    return List<TrainingPreviewCell>.generate(config.totalCells, (int index) {
      final ratio = lastIndex == 0 ? 0.0 : index / lastIndex;
      final backgroundColor = Color.lerp(_colorStart, _colorEnd, ratio)!;
      final foregroundColor = ratio > 0.55 ? Colors.white : AppColors.seed;

      return TrainingPreviewCell(
        label: '${index + 1}',
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      );
    });
  }

  List<TrainingPreviewCell> _buildLetterCells() {
    return List<TrainingPreviewCell>.generate(config.totalCells, (int index) {
      final position = _resolvePosition(index);
      final label = String.fromCharCode(_alphabetOffset + position);

      return TrainingPreviewCell(
        label: label,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.seed,
      );
    });
  }

  List<TrainingPreviewCell> _buildNumberCells() {
    return List<TrainingPreviewCell>.generate(config.totalCells, (int index) {
      final label = '${_resolvePosition(index) + 1}';

      return TrainingPreviewCell(
        label: label,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.seed,
      );
    });
  }

  int _resolvePosition(int index) {
    if (config.order == TrainingOrder.descending) {
      return config.totalCells - index - 1;
    }
    return index;
  }
}
