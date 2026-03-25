import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:schulte_grid/data/models/training_record.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/modules/history/controllers/history_controller.dart';
import 'package:schulte_grid/modules/history/views/history_view.dart';

import '../../../support/fakes/fake_training_record_repository.dart';
import '../../../support/test_app.dart';

void main() {
  testWidgets('历史页会展示新增筛选项', (WidgetTester tester) async {
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
    final controller = HistoryController(
      repository: repository,
      nowProvider: () => DateTime(2026, 3, 20, 12),
    );

    addTearDown(() {
      controller.onClose();
      Get.reset();
    });
    Get.put<HistoryController>(controller);

    await tester.pumpWidget(buildTestApp(const HistoryView()));
    await tester.pump();

    expect(find.text('时间范围'), findsOneWidget);
    expect(find.text('7天'), findsOneWidget);
    expect(find.text('30天'), findsOneWidget);
    expect(find.text('180天'), findsOneWidget);
    expect(find.text('所有时间'), findsOneWidget);
    expect(find.text('内容模式'), findsOneWidget);
    expect(find.text('顺序模式'), findsOneWidget);
    expect(find.text('网格尺寸'), findsOneWidget);
    expect(find.text('3 × 3'), findsOneWidget);
    expect(find.text('5 × 5'), findsWidgets);
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
