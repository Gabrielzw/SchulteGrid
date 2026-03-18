import '../enums/training_mode.dart';
import '../enums/training_order.dart';

class TrainingConfig {
  const TrainingConfig({
    required this.gridSize,
    required this.mode,
    required this.order,
  });

  static const int _alphabetOffset = 65;

  final int gridSize;
  final TrainingMode mode;
  final TrainingOrder order;

  int get totalCells => gridSize * gridSize;

  String get orderLabel {
    if (!mode.supportsReverse) {
      return '由浅到深';
    }
    return order.label;
  }

  String get nextTargetHint {
    switch (mode) {
      case TrainingMode.numbers:
        return order == TrainingOrder.ascending ? '1' : '$totalCells';
      case TrainingMode.letters:
        return order == TrainingOrder.ascending
            ? 'A'
            : String.fromCharCode(_alphabetOffset + totalCells - 1);
      case TrainingMode.colors:
        return '最浅色块';
    }
  }

  String get helperText {
    if (mode == TrainingMode.colors) {
      return '颜色模式当前仅完成视觉布局，点击顺序规则后续接入。';
    }
    return '当前页面仅展示训练布局，计时、随机打乱和点击判断尚未实现。';
  }
}
