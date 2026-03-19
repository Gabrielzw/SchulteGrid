import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/domain/models/training_config.dart';
import 'package:schulte_grid/modules/training/controllers/training_controller.dart';

void main() {
  group('TrainingController', () {
    test('数字模式会按网格大小生成并随机打乱数字集合', () {
      final controller = TrainingController(
        config: TrainingConfig(
          gridSize: 4,
          mode: TrainingMode.numbers,
          order: TrainingOrder.ascending,
        ),
        random: Random(7),
      );

      final labels = controller.cells.map((cell) => cell.label).toList();
      final orderedLabels = List<String>.generate(
        16,
        (int index) => '${index + 1}',
        growable: false,
      );

      expect(labels, unorderedEquals(orderedLabels));
      expect(labels, isNot(equals(orderedLabels)));
      expect(controller.targetSequence, equals(orderedLabels));
      expect(controller.nextTargetLabel, '1');
    });

    test('字母倒序模式会计算正确的点击目标顺序', () {
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
      expect(controller.targetSequence, equals(descendingTargets));
      expect(controller.nextTargetLabel, 'P');
      expect(pCell.targetOrderLabel, '1');
      expect(aCell.targetOrderLabel, '16');
    });

    test('同一训练实例重复读取时不会重新生成板面', () {
      final controller = TrainingController(
        config: TrainingConfig(
          gridSize: 5,
          mode: TrainingMode.numbers,
          order: TrainingOrder.descending,
        ),
        random: Random(19),
      );

      final firstRead = controller.cells.map((cell) => cell.label).toList();
      final secondRead = controller.cells.map((cell) => cell.label).toList();

      expect(secondRead, equals(firstRead));
      expect(controller.nextTargetLabel, '25');
    });
  });
}
