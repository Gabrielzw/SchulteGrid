import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/data/models/training_record.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/modules/history/controllers/history_controller.dart';
import 'package:schulte_grid/modules/history/models/history_filter.dart';

import '../../../support/fakes/fake_training_record_repository.dart';

void main() {
  group('HistoryController', () {
    test('会加载历史记录并按模式筛选', () async {
      final repository = FakeTrainingRecordRepository(<TrainingRecord>[
        _buildRecord(
          mode: TrainingMode.letters,
          order: TrainingOrder.descending,
          gridSize: 4,
          durationInMilliseconds: 12800,
          errorCount: 2,
          completedAt: DateTime(2026, 3, 19, 20, 10),
        ),
        _buildRecord(
          mode: TrainingMode.numbers,
          order: TrainingOrder.ascending,
          gridSize: 5,
          durationInMilliseconds: 9200,
          errorCount: 1,
          completedAt: DateTime(2026, 3, 20, 8, 30),
        ),
      ]);
      final controller = HistoryController(repository: repository);

      addTearDown(controller.onClose);
      await controller.refreshRecords();

      expect(controller.recordCount, 2);
      expect(controller.bestDurationLabel, '00:09.20');
      expect(controller.latestCompletionValueLabel, '03/20');
      expect(controller.visibleRecords.first.modeLabel, '数字');
      expect(controller.visibleRecords.first.errorLabel, '错误 1 次');

      controller.selectFilter(HistoryFilter.letters);

      expect(controller.recordCount, 1);
      expect(controller.visibleRecords.single.modeLabel, '字母');
      expect(controller.visibleRecords.single.orderLabel, '倒序');
      expect(controller.visibleRecords.single.gridLabel, '4 × 4');
      expect(controller.visibleRecords.single.accuracyLabel, '89%');
    });
  });
}

TrainingRecord _buildRecord({
  required TrainingMode mode,
  required TrainingOrder order,
  required int gridSize,
  required int durationInMilliseconds,
  required int errorCount,
  required DateTime completedAt,
}) {
  return TrainingRecord()
    ..mode = mode.storageValue
    ..order = order.storageValue
    ..gridSize = gridSize
    ..durationInMilliseconds = durationInMilliseconds
    ..errorCount = errorCount
    ..completedAt = completedAt;
}
