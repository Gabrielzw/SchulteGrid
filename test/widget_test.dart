import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/app/app.dart';
import 'package:schulte_grid/modules/training/views/training_view.dart';

void main() {
  testWidgets('renders training parameter configuration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SchulteGridApp());

    expect(find.text('训练设置'), findsOneWidget);
    expect(find.text('网格尺寸'), findsOneWidget);
    expect(find.text('推荐：5 × 5'), findsOneWidget);
    expect(find.text('内容模式'), findsOneWidget);
    expect(find.text('顺序模式'), findsOneWidget);
    expect(find.text('数字'), findsWidgets);
    expect(find.text('字母'), findsWidgets);
    expect(find.text('正序'), findsWidgets);
    expect(find.text('倒序'), findsWidgets);
    expect(find.text('开始训练'), findsOneWidget);
    expect(find.text('颜色模式'), findsNothing);
  });

  testWidgets(
    'invalid letter setup blocks start until grid size is corrected',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SchulteGridApp());

      await tester.tap(find.text('7'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('字母'));
      await tester.pumpAndSettle();

      expect(find.text('字母模式最多支持 5 x 5，否则会超出 A-Z。'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      await tester.tap(find.text('5'));
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
      expect(find.text('5 x 5 字母训练'), findsOneWidget);
    },
  );
}
