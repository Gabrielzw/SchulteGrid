import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/app/app.dart';

void main() {
  testWidgets('renders shell page', (WidgetTester tester) async {
    await tester.pumpWidget(const SchulteGridApp());

    expect(find.text('舒尔特方格'), findsOneWidget);
    expect(find.text('进入训练页'), findsOneWidget);
  });
}
