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
        appBar: AppBar(title: Text(controller.title)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TrainingHeader(config: controller.config),
              const SizedBox(height: AppSpacing.lg),
              TrainingStatusSection(
                config: controller.config,
                status: controller.sessionStatus.value,
                statusLabel: controller.statusLabel,
                statusDescription: controller.statusDescription,
                nextTargetLabel: controller.nextTargetLabel,
                timerLabel: controller.timerLabel,
                progressLabel: controller.progressLabel,
                errorCount: controller.errorCount.value,
                targetSequencePreview: controller.targetSequencePreview,
                actionLabel: controller.actionLabel,
                showGuideLabels: controller.showGuideLabels.value,
                resultSummary: controller.isCompleted
                    ? controller.resultSummary
                    : null,
                onPrimaryAction: controller.handlePrimaryAction,
                onToggleGuides: controller.setGuideLabels,
              ),
              const SizedBox(height: AppSpacing.lg),
              TrainingBoardSection(
                gridSize: controller.config.gridSize,
                subtitle: controller.boardSubtitle,
                cells: controller.cells,
                showGuideLabels: controller.showGuideLabels.value,
                isInteractionEnabled: controller.canInteract,
                onCellTap: controller.handleCellTap,
              ),
            ],
          ),
        ),
      );
    });
  }
}
