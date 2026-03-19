import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/domain/enums/training_session_status.dart';
import 'package:schulte_grid/domain/models/training_config.dart';
import 'package:schulte_grid/modules/training/controllers/training_controller.dart';

void main() {
  group('TrainingController', () {
    test('会按模式和尺寸生成随机板面及目标顺序', () {
      final controller = TrainingController(
        config: TrainingConfig(
          gridSize: 4,
          mode: TrainingMode.letters,
          order: TrainingOrder.descending,
        ),
        random: Random(11),
      );

      final labels = controller.cells.map((cell) => cell.label).toList();
      final orderedLabels = List<String>.generate(
        16,
        (int index) => String.fromCharCode(65 + index),
        growable: false,
      );
      final descendingTargets = orderedLabels.reversed.toList(growable: false);
      final pCell = controller.cells.firstWhere((cell) => cell.label == 'P');
      final aCell = controller.cells.firstWhere((cell) => cell.label == 'A');

      expect(labels, unorderedEquals(orderedLabels));
      expect(labels, isNot(equals(orderedLabels)));
      expect(controller.targetSequence, equals(descendingTargets));
      expect(controller.nextTargetLabel, 'P');
      expect(pCell.targetOrderLabel, '1');
      expect(aCell.targetOrderLabel, '16');
    });

    test('开始训练后会进入进行中并推进计时', () async {
      final controller = TrainingController(
        config: TrainingConfig(
          gridSize: 3,
          mode: TrainingMode.numbers,
          order: TrainingOrder.ascending,
        ),
        random: Random(7),
        timerTickInterval: const Duration(milliseconds: 10),
      );
      addTearDown(controller.onClose);

      controller.handlePrimaryAction();
      await Future<void>.delayed(const Duration(milliseconds: 35));

      expect(controller.sessionStatus.value, TrainingSessionStatus.running);
      expect(controller.elapsedMilliseconds.value, greaterThan(0));
      expect(controller.progressLabel, '0/9');
    });

    test('错误点击会触发错误提示并在短暂延迟后清除', () async {
      final controller = TrainingController(
        config: TrainingConfig(
          gridSize: 3,
          mode: TrainingMode.numbers,
          order: TrainingOrder.ascending,
        ),
        random: Random(5),
        errorFlashDuration: const Duration(milliseconds: 20),
      );
      addTearDown(controller.onClose);

      controller.handlePrimaryAction();
      final wrongLabel = controller.cells
          .firstWhere((cell) => cell.label != controller.nextTargetLabel)
          .label;

      controller.handleCellTap(wrongLabel);

      expect(controller.errorCount.value, 1);
      expect(
        controller.cells.firstWhere((cell) => cell.label == wrongLabel).isError,
        isTrue,
      );

      await Future<void>.delayed(const Duration(milliseconds: 40));

      expect(
        controller.cells.firstWhere((cell) => cell.label == wrongLabel).isError,
        isFalse,
      );
    });

    test('按正确顺序完成后会停止计时并进入完成态', () async {
      final controller = TrainingController(
        config: TrainingConfig(
          gridSize: 2,
          mode: TrainingMode.numbers,
          order: TrainingOrder.ascending,
        ),
        random: Random(3),
        timerTickInterval: const Duration(milliseconds: 10),
      );
      addTearDown(controller.onClose);

      controller.handlePrimaryAction();
      await Future<void>.delayed(const Duration(milliseconds: 30));

      for (final label in controller.targetSequence) {
        controller.handleCellTap(label);
      }

      final completedElapsed = controller.elapsedMilliseconds.value;
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(controller.sessionStatus.value, TrainingSessionStatus.completed);
      expect(controller.nextTargetLabel, '完成');
      expect(controller.completedCount.value, 4);
      expect(controller.progressLabel, '4/4');
      expect(controller.elapsedMilliseconds.value, completedElapsed);
      expect(controller.cells.every((cell) => cell.isCompleted), isTrue);
    });
  });
}
