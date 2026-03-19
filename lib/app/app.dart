import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'theme/app_theme.dart';

class SchulteGridApp extends StatelessWidget {
  const SchulteGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
    );
  }
}
