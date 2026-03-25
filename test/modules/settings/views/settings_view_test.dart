import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:schulte_grid/app/theme/app_theme_controller.dart';
import 'package:schulte_grid/app/theme/app_theme_mode.dart';
import 'package:schulte_grid/modules/settings/views/settings_view.dart';

import '../../../support/test_app.dart';

void main() {
  setUp(() async {
    await registerTestSettingsController();
  });

  tearDown(Get.reset);

  testWidgets('设置页展示主题模式切换入口', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(const SettingsView()));

    expect(find.text('设置'), findsOneWidget);
    expect(find.text('主题模式'), findsOneWidget);
    expect(find.text('数据备份与恢复'), findsOneWidget);
    expect(find.text('导出备份'), findsOneWidget);
    expect(find.text('恢复备份'), findsOneWidget);
    expect(find.text('跟随系统'), findsWidgets);
    expect(find.text('浅色'), findsOneWidget);
    expect(find.text('深色'), findsOneWidget);
  });

  testWidgets('设置页切换主题模式会更新全局主题状态', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(const SettingsView()));

    await tester.tap(find.text('浅色'));
    await tester.pumpAndSettle();

    expect(
      Get.find<AppThemeController>().selectedMode.value,
      AppThemeMode.light,
    );
  });
}
