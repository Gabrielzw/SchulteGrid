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
  testWidgets('训练页可以自动开局并完成一轮暂停后恢复的闭环', (WidgetTester tester) async {
    final controller = TrainingController(
      config: TrainingConfig(
        gridSize: 2,
        mode: TrainingMode.numbers,
        order: TrainingOrder.ascending,
      ),
      random: Random(2),
      autostart: true,
      timerTickInterval: const Duration(milliseconds: 10),
      errorFlashDuration: const Duration(milliseconds: 20),
    );
    addTearDown(() {
      controller.onClose();
      Get.reset();
    });
    Get.put<TrainingController>(controller);

    await tester.pumpWidget(const GetMaterialApp(home: TrainingView()));
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.text('专注训练'), findsOneWidget);
    expect(find.text('当前目标'), findsOneWidget);
    expect(find.text('暂停训练'), findsOneWidget);

    await tester.ensureVisible(find.text('暂停训练'));
    await tester.tap(find.text('暂停训练'));
    await tester.pump();

    expect(find.text('继续训练'), findsOneWidget);
    expect(find.text('已暂停'), findsOneWidget);

    await tester.ensureVisible(find.text('继续训练'));
    await tester.tap(find.text('继续训练'));
    await tester.pump();

    for (final label in controller.targetSequence) {
      final cellFinder = find.byKey(ValueKey<String>('training-cell-$label'));
      await tester.ensureVisible(cellFinder);
      await tester.tap(cellFinder);
      await tester.pump();
    }

    await tester.pump(const Duration(milliseconds: 30));

    expect(find.text('本轮完成'), findsOneWidget);
    expect(find.text('再来一局'), findsOneWidget);
    expect(find.textContaining('用时'), findsOneWidget);
  });
}
