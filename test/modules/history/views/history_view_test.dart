import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:schulte_grid/data/models/training_record.dart';
import 'package:schulte_grid/domain/enums/training_mode.dart';
import 'package:schulte_grid/domain/enums/training_order.dart';
import 'package:schulte_grid/modules/history/controllers/history_controller.dart';
import 'package:schulte_grid/modules/history/models/history_record_view_data.dart';
import 'package:schulte_grid/modules/history/views/history_view.dart';
import 'package:schulte_grid/modules/history/widgets/history_cards.dart';
import 'package:schulte_grid/modules/history/widgets/history_sections.dart';

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
    expect(find.text('实时读取本地数据'), findsNothing);
    expect(find.byType(HistoryMetricCard), findsNWidgets(3));

    final firstCardHeight = tester
        .getSize(find.byType(HistoryMetricCard).at(0))
        .height;
    final secondCardHeight = tester
        .getSize(find.byType(HistoryMetricCard).at(1))
        .height;
    final thirdCardHeight = tester
        .getSize(find.byType(HistoryMetricCard).at(2))
        .height;

    expect(firstCardHeight, secondCardHeight);
    expect(secondCardHeight, thirdCardHeight);
  });

  testWidgets('记录概览会按可用宽度自适应分列', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestApp(
        Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: HistorySummarySection(metrics: _buildSummaryMetrics()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final firstCardWidth = tester
        .getSize(find.byType(HistoryMetricCard).at(0))
        .width;
    final secondCardWidth = tester
        .getSize(find.byType(HistoryMetricCard).at(1))
        .width;

    expect(firstCardWidth, closeTo(154, 0.1));
    expect(secondCardWidth, closeTo(154, 0.1));
  });
}

List<HistorySummaryMetricData> _buildSummaryMetrics() {
  return const <HistorySummaryMetricData>[
    HistorySummaryMetricData(
      label: '训练次数',
      value: '12',
      caption: '当前筛选范围',
      icon: Icons.layers_outlined,
    ),
    HistorySummaryMetricData(
      label: '最佳成绩',
      value: '00:09.20',
      caption: '用时最短的一局',
      icon: Icons.bolt_rounded,
    ),
    HistorySummaryMetricData(
      label: '最近完成',
      value: '03/20',
      caption: '08:30 · 数字',
      icon: Icons.schedule_rounded,
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
