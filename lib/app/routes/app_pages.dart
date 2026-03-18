import 'package:get/get.dart';

import '../../modules/root/bindings/root_binding.dart';
import '../../modules/root/views/root_view.dart';
import '../../modules/training/bindings/training_binding.dart';
import '../../modules/training/views/training_view.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static const String initial = AppRoutes.shell;

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.shell,
      page: () => const RootView(),
      binding: RootBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.training,
      page: () => const TrainingView(),
      binding: TrainingBinding(),
    ),
  ];
}
