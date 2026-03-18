import 'package:flutter/material.dart';
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
      theme: AppTheme.light(),
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
    );
  }
}
