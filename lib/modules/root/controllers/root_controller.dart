import 'package:get/get.dart';

class RootController extends GetxController {
  static const int _initialIndex = 0;

  final RxInt currentIndex = _initialIndex.obs;

  void selectTab(int index) {
    currentIndex.value = index;
  }
}
