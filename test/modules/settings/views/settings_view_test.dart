import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:schulte_grid/app/theme/app_theme_controller.dart';
import 'package:schulte_grid/app/theme/app_theme_mode.dart';
import 'package:schulte_grid/app/widgets/app_toast.dart';
import 'package:schulte_grid/modules/settings/views/settings_view.dart';

import '../../../support/fakes/fake_backup_file_access.dart';
import '../../../support/test_app.dart';

void main() {
  tearDown(() {
    AppToast.dismissAll();
    Get.reset();
  });

  testWidgets('设置页展示主题模式切换入口', (WidgetTester tester) async {
    await registerTestSettingsController();
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
    await registerTestSettingsController();
    await tester.pumpWidget(buildTestApp(const SettingsView()));

    await tester.tap(find.text('浅色'));
    await tester.pumpAndSettle();

    expect(
      Get.find<AppThemeController>().selectedMode.value,
      AppThemeMode.light,
    );
  });

  testWidgets('恢复备份遇到读取失败时会提示错误', (WidgetTester tester) async {
    await registerTestSettingsController(
      backupFileAccess: FakeBackupFileAccess(
        pickBackupFileError: Exception('读取失败'),
      ),
    );
    await tester.pumpWidget(buildTestApp(const SettingsView()));

    await tester.tap(find.text('恢复备份'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('读取备份文件失败'), findsOneWidget);
    expect(find.textContaining('读取备份文件失败：'), findsOneWidget);
    expect(find.text('恢复备份'), findsOneWidget);

    AppToast.dismissAll();
  });
}
