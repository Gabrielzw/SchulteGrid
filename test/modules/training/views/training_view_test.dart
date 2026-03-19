import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/domain/models/training_config.dart';
import 'package:schulte_grid/modules/training/controllers/training_controller.dart';
import 'package:schulte_grid/modules/training/views/training_view.dart';

import '../../../support/fakes/fake_training_record_repository.dart';

void main() {
  testWidgets('训练页首次点击格子后才显示数字并开始训练', (WidgetTester tester) async {
    final controller = TrainingController(
      config: TrainingConfig(
        gridSize: 2,
        mode: TrainingMode.numbers,
        order: TrainingOrder.ascending,
      ),
      recordRepository: FakeTrainingRecordRepository(),
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
    await tester.pump();

    final targetLabel = controller.displayNextTargetLabel;

    expect(find.text('准备开始'), findsOneWidget);
    expect(find.text('暂停训练'), findsNothing);
    expect(find.text('先点任意格子显示数字，再开始计时。'), findsOneWidget);
    expect(find.text(targetLabel), findsOneWidget);

    final firstCell = find.byKey(
      ValueKey<String>('training-cell-${controller.cells.first.label}'),
    );
    await tester.tap(firstCell);
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.text('专注训练'), findsOneWidget);
    expect(find.text('暂停训练'), findsOneWidget);
    expect(find.text(targetLabel), findsNWidgets(2));
    expect(controller.completedCount.value, 0);

    await tester.ensureVisible(find.text('暂停训练'));
    await tester.tap(find.text('暂停训练'));
    await tester.pump();

    expect(find.text('继续训练'), findsOneWidget);
    expect(find.text('已暂停'), findsOneWidget);
  });
}
