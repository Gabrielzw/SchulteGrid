import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:schulte_grid/data/models/training_record.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/modules/stats/controllers/stats_controller.dart';
import 'package:schulte_grid/modules/stats/views/stats_view.dart';
import 'package:schulte_grid/modules/stats/widgets/stats_core_cards.dart';

import '../../../support/fakes/fake_training_record_repository.dart';
import '../../../support/test_app.dart';

void main() {
  testWidgets('成绩页会展示按模式拆分的基础统计、趋势和稳定性', (WidgetTester tester) async {
    final controller = StatsController(
      repository: FakeTrainingRecordRepository(_buildAnalysisRecords()),
      nowProvider: () => DateTime(2026, 3, 20, 12),
    );

    addTearDown(() {
      controller.onClose();
      Get.reset();
    });
    Get.put<StatsController>(controller);

    await tester.pumpWidget(buildTestApp(const StatsView()));
    await tester.pumpAndSettle();

    expect(find.text('训练成绩'), findsOneWidget);
    expect(find.text('时间范围'), findsOneWidget);
    expect(find.text('7天'), findsOneWidget);
    expect(find.text('30天'), findsOneWidget);
    expect(find.text('180天'), findsOneWidget);
    expect(find.text('所有时间'), findsWidgets);
    expect(find.text('内容模式'), findsOneWidget);
    expect(find.text('顺序模式'), findsOneWidget);
    expect(find.text('网格尺寸'), findsOneWidget);
    expect(find.text('3 × 3'), findsOneWidget);
    expect(find.text('5 × 5'), findsWidgets);
    expect(find.text('核心指标'), findsOneWidget);
    expect(find.byType(StatsMetricCard), findsNWidgets(3));
    expect(find.text('筛选范围内用时最短的一局'), findsNothing);
    expect(find.text('模式分析'), findsOneWidget);
    expect(find.text('基础统计'), findsWidgets);
    expect(find.text('趋势'), findsWidgets);
    expect(find.text('稳定性'), findsWidgets);
    expect(find.text('数字'), findsWidgets);
    expect(find.text('字母'), findsWidgets);
    expect(find.text('快 26%'), findsOneWidget);
    expect(find.text('基本持平'), findsOneWidget);
    expect(find.text('轻微波动'), findsOneWidget);
    expect(find.text('稳定'), findsOneWidget);

    final firstCardHeight = tester
        .getSize(find.byType(StatsMetricCard).at(0))
        .height;
    final secondCardHeight = tester
        .getSize(find.byType(StatsMetricCard).at(1))
        .height;
    final thirdCardHeight = tester
        .getSize(find.byType(StatsMetricCard).at(2))
        .height;

    expect(firstCardHeight, secondCardHeight);
    expect(secondCardHeight, thirdCardHeight);
  });
}

List<TrainingRecord> _buildAnalysisRecords() {
  return <TrainingRecord>[
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
