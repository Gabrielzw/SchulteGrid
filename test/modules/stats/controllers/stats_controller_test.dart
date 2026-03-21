import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/data/models/training_record.dart';
import 'package:schulte_grid/domain/enums/record_time_range.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/modules/stats/controllers/stats_controller.dart';

import '../../../support/fakes/fake_training_record_repository.dart';

void main() {
  group('StatsController', () {
    test('会按时间范围聚合核心指标和模式表现', () async {
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
      final controller = StatsController(
        repository: repository,
        nowProvider: () => now,
      );

      addTearDown(controller.onClose);
      await controller.refreshRecords();

      expect(controller.recordCount, 4);
      expect(controller.summaryMetrics[0].value, '00:09.20');
      expect(controller.summaryMetrics[1].value, '00:11.50');
      expect(controller.summaryMetrics[2].value, '4');
      expect(controller.bestRecordHighlight?.durationLabel, '00:09.20');
      expect(controller.bestRecordHighlight?.metaLabel, '正序 · 5 × 5');
      expect(
        controller.latestRecordHighlight?.completedAtLabel,
        '2026/03/20 08:30',
      );

      final numbersInsight = controller.modeInsights.firstWhere(
        (insight) => insight.label == '数字',
      );
      expect(numbersInsight.sessionCountLabel, '2 次训练');
      expect(numbersInsight.bestDurationLabel, '00:09.20');

      controller.selectTimeRange(RecordTimeRange.last30Days);

      expect(controller.recordCount, 2);
      expect(controller.summaryMetrics[0].value, '00:09.20');
      expect(controller.summaryMetrics[1].value, '00:11.00');

      final filteredNumbersInsight = controller.modeInsights.firstWhere(
        (insight) => insight.label == '数字',
      );
      final filteredLettersInsight = controller.modeInsights.firstWhere(
        (insight) => insight.label == '字母',
      );

      expect(filteredNumbersInsight.averageDurationLabel, '00:09.20');
      expect(filteredLettersInsight.bestDurationLabel, '00:12.80');
      expect(filteredLettersInsight.sessionCountLabel, '1 次训练');
    });

    test('没有任何记录时会返回空态文案', () async {
      final controller = StatsController(
        repository: FakeTrainingRecordRepository(),
        nowProvider: () => DateTime(2026, 3, 20, 12),
      );

      addTearDown(controller.onClose);
      await controller.refreshRecords();

      expect(controller.recordCount, 0);
      expect(controller.summaryMetrics[0].value, '--');
      expect(controller.summaryMetrics[1].value, '--');
      expect(controller.summaryMetrics[2].value, '0');
      expect(controller.emptyMessage, contains('完成至少一局训练后'));
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
