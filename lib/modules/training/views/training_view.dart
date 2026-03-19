import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../controllers/training_controller.dart';
import '../widgets/training_sections.dart';

class TrainingView extends GetView<TrainingController> {
  const TrainingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFFF0F2F6), AppColors.canvas],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: <Widget>[
                      TrainingSessionHero(
                        eyebrow: controller.sessionEyebrow,
                        timerLabel: controller.timerLabel,
                        progressValue: controller.progressValue,
                        metaLabel: controller.sessionMetaLabel,
                        progressLabel: controller.progressLabel,
                      ),
                      const SizedBox(height: 40),
                      TrainingSessionMetrics(
                        targetTitle: controller.targetLabelTitle,
                        targetValue: controller.displayNextTargetLabel,
                        accuracyLabel: controller.accuracyLabel,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (controller.isCompleted) ...<Widget>[
                        TrainingSessionBanner(
                          message: controller.completionSummary,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      TrainingBoardPanel(
                        gridSize: controller.config.gridSize,
                        cells: controller.cells,
                        isInteractionEnabled: controller.canInteract,
                        overlayLabel: controller.isPaused ? '已暂停' : null,
                        onCellTap: controller.handleCellTap,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TrainingSessionHint(message: controller.primaryHint),
                      const SizedBox(height: 28),
                      TrainingSessionActionBar(
                        status: controller.sessionStatus.value,
                        primaryLabel: controller.actionLabel,
                        onPrimaryAction: controller.handlePrimaryAction,
                        onRestart: controller.restartSession,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
