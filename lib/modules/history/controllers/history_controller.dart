import 'package:get/get.dart';

class HistoryController extends GetxController {
  static const List<String> filters = <String>['全部', '数字', '字母', '颜色'];

  final RxInt selectedFilterIndex = 0.obs;

  void selectFilter(int index) {
    selectedFilterIndex.value = index;
  }
}
