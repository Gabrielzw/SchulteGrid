import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/data/models/training_record.dart';
import 'package:schulte_grid/domain/enums/record_mode_filter.dart';
import 'package:schulte_grid/domain/enums/record_order_filter.dart';
import 'package:schulte_grid/domain/enums/record_time_range.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/modules/history/controllers/history_controller.dart';

import '../../../support/fakes/fake_training_record_repository.dart';

void main() {
  group('HistoryController', () {
    test('会按时间范围、模式、尺寸和顺序组合筛选', () async {
      final now = DateTime(2026, 3, 20, 12);
      final repository = FakeTrainingRecordRepository(<TrainingRecord>[
        _buildRecord(
          mode: TrainingMode.letters,
          order: TrainingOrder.ascending,
          gridSize: 6,
          durationInMilliseconds: 14000,
          errorCount: 3,
          completedAt: DateTime(2025, 8, 1, 7, 45),
        ),
        _buildRecord(
          mode: TrainingMode.numbers,
          order: TrainingOrder.descending,
          gridSize: 3,
          durationInMilliseconds: 10000,
          errorCount: 0,
          completedAt: DateTime(2026, 2, 10, 21, 00),
        ),
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
      final controller = HistoryController(
        repository: repository,
        nowProvider: () => now,
      );

      addTearDown(controller.onClose);
      await controller.refreshRecords();

      expect(controller.recordCount, 4);
      expect(controller.bestDurationLabel, '00:09.20');
      expect(controller.latestCompletionValueLabel, '03/20');
      expect(controller.gridSizeOptions, containsAll(<int>[3, 4, 5, 6, 7]));

      controller.selectTimeRangeFilter(RecordTimeRange.last180Days);
      expect(controller.recordCount, 3);

      controller.selectTimeRangeFilter(RecordTimeRange.last30Days);
      expect(controller.recordCount, 2);
      expect(controller.recordsSectionSubtitle, contains('30天'));

      controller.selectModeFilter(RecordModeFilter.numbers);
      controller.selectOrderFilter(RecordOrderFilter.ascending);
      controller.selectGridSize(5);

      expect(controller.recordCount, 1);
      expect(controller.visibleRecords.single.modeLabel, '数字');
      expect(controller.visibleRecords.single.orderLabel, '正序');
      expect(controller.visibleRecords.single.gridLabel, '5 × 5');
      expect(controller.visibleRecords.single.accuracyLabel, '96%');
      expect(controller.recordsSectionSubtitle, contains('5 × 5'));

      controller.selectGridSize(4);

      expect(controller.recordCount, 0);
      expect(controller.emptyMessage, contains('当前筛选条件下'));
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
