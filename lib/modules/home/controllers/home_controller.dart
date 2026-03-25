import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/widgets/app_toast.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../../../domain/models/training_config.dart';

class HomeController extends GetxController {
  static const String _defaultGridSizeInput = '5';
  static const List<int> commonGridSizes = <int>[3, 4, 5, 6, 7];

  final RxString gridSizeInput = _defaultGridSizeInput.obs;
  final Rx<TrainingMode> selectedMode = TrainingMode.numbers.obs;
  final Rx<TrainingOrder> selectedOrder = TrainingOrder.ascending.obs;

  int? get parsedGridSize => int.tryParse(gridSizeInput.value);

  String? get gridSizeValidationMessage {
    final gridSize = parsedGridSize;
    if (gridSize == null) {
      return '请输入有效的正整数网格大小。';
    }

    return TrainingConfig.validationMessage(
      gridSize: gridSize,
      mode: selectedMode.value,
    );
  }

  TrainingConfig? get previewConfig {
    final gridSize = parsedGridSize;
    if (gridSize == null || gridSizeValidationMessage != null) {
      return null;
    }

    return TrainingConfig(
      gridSize: gridSize,
      mode: selectedMode.value,
      order: selectedOrder.value,
    );
  }

  void selectGridSize(int gridSize) {
    gridSizeInput.value = '$gridSize';
  }

  void selectMode(TrainingMode mode) {
    selectedMode.value = mode;
  }

  void selectOrder(TrainingOrder order) {
    selectedOrder.value = order;
  }

  void openTrainingPreview() {
    final config = previewConfig;
    if (config == null) {
      AppToast.showError(
        title: '参数无效',
        message: gridSizeValidationMessage ?? '请检查训练参数后重试。',
      );
      return;
    }

    Get.toNamed(AppRoutes.training, arguments: config);
  }
}
