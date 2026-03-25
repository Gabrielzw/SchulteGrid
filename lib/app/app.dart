import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_controller.dart';

class SchulteGridApp extends GetView<AppThemeController> {
  const SchulteGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: '舒尔特方格',
        debugShowCheckedModeBanner: false,
        locale: const Locale('zh', 'CN'),
        fallbackLocale: const Locale('zh', 'CN'),
        supportedLocales: const <Locale>[Locale('zh', 'CN')],
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: controller.selectedMode.value.materialMode,
        initialRoute: AppPages.initial,
        getPages: AppPages.pages,
      ),
    );
  }
}
