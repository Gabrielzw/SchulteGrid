import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:schulte_grid/data/models/training_record.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/modules/stats/controllers/stats_controller.dart';
import 'package:schulte_grid/modules/stats/views/stats_view.dart';

import '../../../support/fakes/fake_training_record_repository.dart';
import '../../../support/test_app.dart';

void main() {
  testWidgets('成绩页会展示真实统计区块和时间筛选', (WidgetTester tester) async {
    final repository = FakeTrainingRecordRepository(<TrainingRecord>[
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
    expect(find.text('核心指标'), findsOneWidget);
    expect(find.text('00:09.20'), findsWidgets);
    expect(find.text('最佳一局'), findsOneWidget);
    expect(find.text('最近完成'), findsOneWidget);
    expect(find.text('模式表现'), findsOneWidget);
    expect(find.text('数字'), findsWidgets);
    expect(find.text('字母'), findsWidgets);
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
