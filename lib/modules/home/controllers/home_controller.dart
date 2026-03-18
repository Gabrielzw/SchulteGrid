import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../../../domain/models/training_config.dart';

class HomeController extends GetxController {
  static const int _defaultGridSize = 5;
  static const List<int> availableGridSizes = <int>[3, 4, 5, 6, 7];

  final RxInt selectedGridSize = _defaultGridSize.obs;
  final Rx<TrainingMode> selectedMode = TrainingMode.numbers.obs;
  final Rx<TrainingOrder> selectedOrder = TrainingOrder.ascending.obs;

  TrainingConfig get currentConfig {
    return TrainingConfig(
      gridSize: selectedGridSize.value,
      mode: selectedMode.value,
      order: selectedOrder.value,
    );
  }

  void selectGridSize(int gridSize) {
    selectedGridSize.value = gridSize;
  }

  void selectMode(TrainingMode mode) {
    selectedMode.value = mode;
    if (!mode.supportsReverse) {
      selectedOrder.value = TrainingOrder.ascending;
    }
  }

  void selectOrder(TrainingOrder order) {
    if (!selectedMode.value.supportsReverse) {
      return;
    }
    selectedOrder.value = order;
  }

  void openTrainingPreview() {
    Get.toNamed(AppRoutes.training, arguments: currentConfig);
  }
}
