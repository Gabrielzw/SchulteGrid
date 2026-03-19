import 'dart:math' as math;

import '../enums/training_mode.dart';
import '../enums/training_order.dart';

class TrainingConfig {
  TrainingConfig({
    required int gridSize,
    required this.mode,
    required this.order,
  }) : gridSize = _validateGridSize(gridSize: gridSize, mode: mode);

  static const int _alphabetOffset = 65;
  static const int maxLetterCellCount = 26;
  static final int maxLetterGridSize = math.sqrt(maxLetterCellCount).floor();

  final int gridSize;
  final TrainingMode mode;
  final TrainingOrder order;

  int get totalCells => gridSize * gridSize;

  static String? validationMessage({
    required int gridSize,
    required TrainingMode mode,
  }) {
    if (gridSize <= 0) {
      return '网格大小必须大于 0。';
    }

    final exceedsAlphabet =
        mode == TrainingMode.letters &&
        gridSize * gridSize > maxLetterCellCount;
    if (exceedsAlphabet) {
      return '字母模式最多支持 '
          '$maxLetterGridSize x $maxLetterGridSize，否则会超出 A-Z。';
    }

    return null;
  }

  String get orderLabel => order.label;

  String get nextTargetHint {
    final lastLetter = String.fromCharCode(_alphabetOffset + totalCells - 1);

    switch (mode) {
      case TrainingMode.numbers:
        return order == TrainingOrder.ascending ? '1' : '$totalCells';
      case TrainingMode.letters:
        return order == TrainingOrder.ascending ? 'A' : lastLetter;
    }
  }

  String get selectionInstruction {
    switch (mode) {
      case TrainingMode.numbers:
        return order == TrainingOrder.ascending
            ? '按 1 到 $totalCells 依次点击。'
            : '按 $totalCells 到 1 依次点击。';
      case TrainingMode.letters:
        final lastLetter = String.fromCharCode(
          _alphabetOffset + totalCells - 1,
        );
        return order == TrainingOrder.ascending
            ? '按 A 到 $lastLetter 依次点击。'
            : '按 $lastLetter 到 A 依次点击。';
    }
  }

  String get helperText {
    return '训练参数已配置完成，当前页面会按所选模式与尺寸展示训练版式。'
        '计时、随机打乱和点击判定将在后续接入。';
  }

  static int _validateGridSize({
    required int gridSize,
    required TrainingMode mode,
  }) {
    final message = validationMessage(gridSize: gridSize, mode: mode);
    if (message != null) {
      throw ArgumentError.value(gridSize, 'gridSize', message);
    }
    return gridSize;
  }
}
