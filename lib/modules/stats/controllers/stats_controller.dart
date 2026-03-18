import 'package:get/get.dart';

class StatsController extends GetxController {
  static const List<String> timeRanges = <String>['最近 7 天', '最近 30 天', '全部记录'];

  final RxInt selectedRangeIndex = 2.obs;

  void selectRange(int index) {
    selectedRangeIndex.value = index;
  }
}
