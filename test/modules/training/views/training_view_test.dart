import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/domain/models/training_config.dart';
import 'package:schulte_grid/modules/training/controllers/training_controller.dart';
import 'package:schulte_grid/modules/training/views/training_view.dart';

void main() {
  testWidgets('训练页可以完成一轮从开始到结束的交互闭环', (WidgetTester tester) async {
    final controller = TrainingController(
      config: TrainingConfig(
        gridSize: 2,
        mode: TrainingMode.numbers,
        order: TrainingOrder.ascending,
      ),
      random: Random(2),
      timerTickInterval: const Duration(milliseconds: 10),
      errorFlashDuration: const Duration(milliseconds: 20),
    );
    addTearDown(() {
      controller.onClose();
      Get.reset();
    });
    Get.put<TrainingController>(controller);

    await tester.pumpWidget(const GetMaterialApp(home: TrainingView()));

    expect(find.text('开始训练'), findsOneWidget);

    final startFinder = find.text('开始训练');
    await tester.ensureVisible(startFinder);
    await tester.tap(startFinder);
    await tester.pump(const Duration(milliseconds: 20));

    for (final label in controller.targetSequence) {
      final cellFinder = find.byKey(ValueKey<String>('training-cell-$label'));
      await tester.ensureVisible(cellFinder);
      await tester.tap(cellFinder);
      await tester.pump();
    }

    await tester.pump(const Duration(milliseconds: 30));

    expect(find.textContaining('训练完成。'), findsOneWidget);
    expect(find.text('再来一局'), findsOneWidget);
    expect(find.text('4/4'), findsOneWidget);
  });
}
