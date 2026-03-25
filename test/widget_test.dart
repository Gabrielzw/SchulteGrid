import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:schulte_grid/app/app.dart';
import 'package:schulte_grid/app/theme/app_theme_controller.dart';
import 'package:schulte_grid/app/theme/app_theme_mode.dart';
import 'package:schulte_grid/data/repositories/training_record_repository.dart';
import 'package:schulte_grid/modules/training/views/training_view.dart';

import 'support/fakes/fake_training_record_repository.dart';
import 'support/test_app.dart';

void main() {
  setUp(() async {
    Get.put<TrainingRecordRepository>(
      FakeTrainingRecordRepository(),
      permanent: true,
    );
    await registerTestThemeController();
  });

  tearDown(Get.reset);

  testWidgets('renders training parameter configuration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SchulteGridApp());

    expect(find.text('训练设置'), findsOneWidget);
    expect(find.text('网格尺寸'), findsOneWidget);
    expect(find.text('推荐：5 × 5'), findsOneWidget);
    expect(find.text('内容模式'), findsOneWidget);
    expect(find.text('顺序模式'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
    expect(find.text('主题模式'), findsNothing);
    expect(find.text('数字'), findsWidgets);
    expect(find.text('字母'), findsWidgets);
    expect(find.text('正序'), findsWidgets);
    expect(find.text('倒序'), findsWidgets);
    expect(find.text('开始训练'), findsOneWidget);
  });

  testWidgets(
    'settings tab shows theme mode selector and updates app theme mode',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SchulteGridApp());

      await tester.tap(find.text('设置'));
      await tester.pumpAndSettle();

      expect(find.text('主题模式'), findsOneWidget);
      expect(find.text('跟随系统'), findsWidgets);
      expect(find.text('浅色'), findsOneWidget);
      expect(find.text('深色'), findsOneWidget);

      await tester.tap(find.text('深色'));
      await tester.pumpAndSettle();

      expect(
        Get.find<AppThemeController>().selectedMode.value,
        AppThemeMode.dark,
      );
      expect(
        tester.widget<GetMaterialApp>(find.byType(GetMaterialApp)).themeMode,
        ThemeMode.dark,
      );
    },
  );

  testWidgets(
    'invalid letter setup blocks start until grid size is corrected',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SchulteGridApp());

      final sevenOption = find.text('7').first;
      await tester.ensureVisible(sevenOption);
      await tester.tap(sevenOption);
      await tester.pumpAndSettle();
      final letterOption = find.text('字母').first;
      await tester.ensureVisible(letterOption);
      await tester.tap(letterOption);
      await tester.pumpAndSettle();

      expect(find.text('字母模式最多支持 5 x 5，否则会超出 A-Z。'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      final fiveOption = find.text('5').first;
      await tester.ensureVisible(fiveOption);
      await tester.tap(fiveOption);
      await tester.pumpAndSettle();

      expect(find.text('字母模式最多支持 5 x 5，否则会超出 A-Z。'), findsNothing);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );

      await tester.ensureVisible(find.text('开始训练'));
      await tester.tap(find.text('开始训练'));
      await tester.pumpAndSettle();

      expect(find.byType(TrainingView), findsOneWidget);
      expect(find.text('准备开始'), findsOneWidget);
      expect(find.text('当前目标'), findsOneWidget);
      expect(find.text('准确率'), findsOneWidget);
      expect(find.text('暂停训练'), findsNothing);
    },
  );
}
