import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../controllers/home_controller.dart';
import '../widgets/training_config_sections.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TrainingConfigHero(
              selectedMode: controller.selectedMode.value,
              selectedOrder: controller.selectedOrder.value,
              selectedGridSize: controller.parsedGridSize,
            ),
            const SizedBox(height: AppSpacing.lg),
            ModeSelector(
              selectedMode: controller.selectedMode.value,
              onSelected: controller.selectMode,
            ),
            const SizedBox(height: AppSpacing.lg),
            OrderSelector(
              selectedOrder: controller.selectedOrder.value,
              onSelected: controller.selectOrder,
            ),
            const SizedBox(height: AppSpacing.lg),
            GridSizeSelector(
              commonGridSizes: HomeController.commonGridSizes,
              selectedMode: controller.selectedMode.value,
              selectedGridSize: controller.parsedGridSize,
              gridSizeInput: controller.gridSizeInput.value,
              validationMessage: controller.gridSizeValidationMessage,
              onQuickSelected: controller.selectGridSize,
              onInputChanged: controller.updateGridSizeInput,
            ),
            const SizedBox(height: AppSpacing.lg),
            ConfigSummaryCard(
              config: controller.previewConfig,
              validationMessage: controller.gridSizeValidationMessage,
              onPressed: controller.openTrainingPreview,
            ),
          ],
        ),
      );
    });
  }
}
