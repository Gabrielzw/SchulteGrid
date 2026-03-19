import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/models/training_config.dart';
import '../../../domain/models/training_preview_cell.dart';

class TrainingController extends GetxController {
  TrainingController({required this.config});

  static const int _alphabetOffset = 65;

  final TrainingConfig config;
  final RxBool showGuideLabels = true.obs;

  List<TrainingPreviewCell> get cells {
    switch (config.mode) {
      case TrainingMode.numbers:
        return _buildNumberCells();
      case TrainingMode.letters:
        return _buildLetterCells();
    }
  }

  String get title =>
      '${config.gridSize} x ${config.gridSize} ${config.mode.shortLabel}训练';

  void setGuideLabels(bool value) {
    showGuideLabels.value = value;
  }

  List<TrainingPreviewCell> _buildLetterCells() {
    return List<TrainingPreviewCell>.generate(config.totalCells, (int index) {
      final label = String.fromCharCode(_alphabetOffset + index);

      return TrainingPreviewCell(
        label: label,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.seed,
      );
    });
  }

  List<TrainingPreviewCell> _buildNumberCells() {
    return List<TrainingPreviewCell>.generate(config.totalCells, (int index) {
      final label = '${index + 1}';

      return TrainingPreviewCell(
        label: label,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.seed,
      );
    });
  }
}
