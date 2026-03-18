import 'package:get/get.dart';

import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../../../domain/models/training_config.dart';
import '../controllers/training_controller.dart';

class TrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainingController>(
      () => TrainingController(config: _resolveConfig()),
    );
  }

  TrainingConfig _resolveConfig() {
    final arguments = Get.arguments;
    if (arguments is TrainingConfig) {
      return arguments;
    }

    return const TrainingConfig(
      gridSize: 5,
      mode: TrainingMode.numbers,
      order: TrainingOrder.ascending,
    );
  }
}
