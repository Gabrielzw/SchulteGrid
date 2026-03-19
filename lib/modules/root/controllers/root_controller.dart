import 'dart:async';

import 'package:get/get.dart';

import '../../history/controllers/history_controller.dart';

class RootController extends GetxController {
  static const int _initialIndex = 0;
  static const int _historyTabIndex = 2;

  final RxInt currentIndex = _initialIndex.obs;

  void selectTab(int index) {
    currentIndex.value = index;
    if (index != _historyTabIndex || !Get.isRegistered<HistoryController>()) {
      return;
    }

    unawaited(Get.find<HistoryController>().refreshRecords());
  }
}
