import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:schulte_grid/app/widgets/app_toast.dart';

import '../../support/test_app.dart';

void main() {
  tearDown(() {
    AppToast.dismissAll();
    Get.reset();
  });

  testWidgets('AppToast 展示成功、同步和错误三种状态样式', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestApp(const Scaffold(body: SizedBox.expand())),
    );

    AppToast.showSuccess(
      title: 'Session Saved',
      message: 'Focal metrics recorded to your history.',
      duration: null,
    );
    AppToast.showSync(
      title: 'Synching Data',
      message: 'Updating academic records...',
      duration: null,
    );
    AppToast.showError(
      title: 'Selection Error',
      message: 'Sequence interrupted. Retry vessel focus.',
      duration: null,
    );
    await tester.pump();

    expect(find.text('Session Saved'), findsOneWidget);
    expect(find.text('Synching Data'), findsOneWidget);
    expect(find.text('Selection Error'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.byIcon(Icons.sync_rounded), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    expect(find.byTooltip('关闭提示'), findsNWidgets(3));
  });

  testWidgets('AppToast 支持单条关闭并带退出动画', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestApp(const Scaffold(body: SizedBox.expand())),
    );

    final AppToastHandle successToast = AppToast.showSuccess(
      title: 'Session Saved',
      message: 'Focal metrics recorded to your history.',
      duration: null,
    );
    AppToast.showError(
      title: 'Selection Error',
      message: 'Sequence interrupted. Retry vessel focus.',
      duration: null,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    successToast.close();
    await tester.pump();

    expect(find.text('Session Saved'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(find.text('Session Saved'), findsNothing);
    expect(find.text('Selection Error'), findsOneWidget);
  });
}
