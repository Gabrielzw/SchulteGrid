import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/app/app.dart';

void main() {
  testWidgets('renders training parameter configuration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SchulteGridApp());

    expect(find.text('训练参数配置'), findsOneWidget);
    expect(find.text('数字模式'), findsWidgets);
    expect(find.text('字母模式'), findsWidgets);
    expect(find.text('正序'), findsWidgets);
    expect(find.text('倒序'), findsWidgets);
    expect(find.text('网格大小'), findsOneWidget);
    expect(find.text('进入训练页'), findsOneWidget);
    expect(find.text('颜色模式'), findsNothing);
  });
}
