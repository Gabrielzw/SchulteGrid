import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/data/models/training_record.dart';
import 'package:schulte_grid/domain/enums/record_mode_filter.dart';
import 'package:schulte_grid/domain/enums/record_order_filter.dart';
import 'package:schulte_grid/domain/enums/record_time_range.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/modules/stats/controllers/stats_controller.dart';

import '../../../support/fakes/fake_training_record_repository.dart';

void main() {
  group('StatsController', () {
    test('会按训练模式构建基础统计、趋势和稳定性', () async {
      final controller = StatsController(
        repository: FakeTrainingRecordRepository(_buildAnalysisRecords()),
        nowProvider: () => DateTime(2026, 3, 20, 12),
      );

      addTearDown(controller.onClose);
      await controller.refreshRecords();

      expect(controller.recordCount, 9);
      expect(controller.summaryMetrics[0].value, '00:08.00');
      expect(controller.summaryMetrics[1].value, '00:10.44');
      expect(controller.summaryMetrics[2].value, '9');

      final numbersAnalysis = controller.modeAnalyses.firstWhere(
        (analysis) => analysis.label == '数字',
      );
      final lettersAnalysis = controller.modeAnalyses.firstWhere(
        (analysis) => analysis.label == '字母',
      );

      expect(numbersAnalysis.basicMetrics[0].value, '00:08.00');
      expect(numbersAnalysis.basicMetrics[2].value, '4');
      expect(numbersAnalysis.basicMetrics[3].value, '1 次');
      expect(numbersAnalysis.trend.deltaLabel, '快 26%');
      expect(numbersAnalysis.stability.badgeLabel, '轻微波动');

      expect(lettersAnalysis.basicMetrics[2].value, '5');
      expect(lettersAnalysis.trend.deltaLabel, '基本持平');
      expect(lettersAnalysis.stability.badgeLabel, '轻微波动');
    });

    test('组合筛选后只基于筛选结果进行成绩分析', () async {
      final controller = StatsController(
        repository: FakeTrainingRecordRepository(_buildAnalysisRecords()),
        nowProvider: () => DateTime(2026, 3, 20, 12),
      );

      addTearDown(controller.onClose);
      await controller.refreshRecords();
      controller.selectTimeRange(RecordTimeRange.last30Days);
      controller.selectModeFilter(RecordModeFilter.numbers);
      controller.selectOrderFilter(RecordOrderFilter.ascending);
      controller.selectGridSize(5);

      expect(controller.recordCount, 3);
      expect(controller.summaryMetrics[0].value, '00:08.00');
      expect(controller.summaryMetrics[1].value, '00:09.66');
      expect(controller.modeAnalyses, hasLength(1));

      final analysis = controller.modeAnalyses.single;

      expect(analysis.label, '数字');
      expect(analysis.sessionCountLabel, '3 次训练');
      expect(analysis.basicMetrics[2].value, '3');
      expect(analysis.trend.deltaLabel, '记录不足');

      controller.selectGridSize(4);

      expect(controller.recordCount, 0);
      expect(controller.emptyMessage, contains('当前筛选条件下'));
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
      expect(controller.emptyMessage, contains('各训练模式'));
      expect(controller.modeAnalyses, hasLength(2));
      expect(controller.modeAnalyses.first.trend.deltaLabel, '暂无趋势');
    });
  });
}

List<TrainingRecord> _buildAnalysisRecords() {
  return <TrainingRecord>[
    _buildRecord(
      mode: TrainingMode.letters,
      order: TrainingOrder.ascending,
      gridSize: 6,
      durationInMilliseconds: 14000,
      errorCount: 3,
      completedAt: DateTime(2025, 8, 1, 7, 45),
    ),
    _buildRecord(
      mode: TrainingMode.letters,
      order: TrainingOrder.ascending,
      gridSize: 5,
      durationInMilliseconds: 10000,
      errorCount: 0,
      completedAt: DateTime(2026, 3, 11, 8),
    ),
    _buildRecord(
      mode: TrainingMode.letters,
      order: TrainingOrder.descending,
      gridSize: 5,
      durationInMilliseconds: 10000,
      errorCount: 0,
      completedAt: DateTime(2026, 3, 12, 8),
    ),
    _buildRecord(
      mode: TrainingMode.letters,
      order: TrainingOrder.ascending,
      gridSize: 5,
      durationInMilliseconds: 10200,
      errorCount: 1,
      completedAt: DateTime(2026, 3, 17, 8),
    ),
    _buildRecord(
      mode: TrainingMode.letters,
      order: TrainingOrder.descending,
      gridSize: 5,
      durationInMilliseconds: 9800,
      errorCount: 0,
      completedAt: DateTime(2026, 3, 18, 8),
    ),
    _buildRecord(
      mode: TrainingMode.numbers,
      order: TrainingOrder.ascending,
      gridSize: 5,
      durationInMilliseconds: 12000,
      errorCount: 2,
      completedAt: DateTime(2026, 3, 10, 8, 30),
    ),
    _buildRecord(
      mode: TrainingMode.numbers,
      order: TrainingOrder.descending,
      gridSize: 5,
      durationInMilliseconds: 11000,
      errorCount: 1,
      completedAt: DateTime(2026, 3, 15, 8, 30),
    ),
    _buildRecord(
      mode: TrainingMode.numbers,
      order: TrainingOrder.ascending,
      gridSize: 5,
      durationInMilliseconds: 9000,
      errorCount: 1,
      completedAt: DateTime(2026, 3, 19, 20, 10),
    ),
    _buildRecord(
      mode: TrainingMode.numbers,
      order: TrainingOrder.ascending,
      gridSize: 5,
      durationInMilliseconds: 8000,
      errorCount: 0,
      completedAt: DateTime(2026, 3, 20, 8, 30),
    ),
  ];
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
