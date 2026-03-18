import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../history/views/history_view.dart';
import '../../home/views/home_view.dart';
import '../../stats/views/stats_view.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  static const List<Widget> _pages = <Widget>[
    HomeView(),
    StatsView(),
    HistoryView(),
  ];

  static const List<NavigationDestination> _destinations =
      <NavigationDestination>[
        NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: '训练'),
        NavigationDestination(icon: Icon(Icons.insights_outlined), label: '成绩'),
        NavigationDestination(icon: Icon(Icons.history_rounded), label: '历史'),
      ];

  static const BoxDecoration _backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[AppColors.shellTop, AppColors.shellBottom],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = controller.currentIndex.value;

      return Scaffold(
        body: DecoratedBox(
          decoration: _backgroundDecoration,
          child: SafeArea(
            child: IndexedStack(index: currentIndex, children: _pages),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          destinations: _destinations,
          onDestinationSelected: controller.selectTab,
        ),
      );
    });
  }
}
