import 'package:get/get.dart';

import '../../history/controllers/history_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../stats/controllers/stats_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(RootController.new);
    Get.lazyPut<HomeController>(HomeController.new);
    Get.lazyPut<StatsController>(StatsController.new);
    Get.lazyPut<HistoryController>(HistoryController.new);
  }
}
