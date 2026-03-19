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
      final sessionStatus = controller.sessionStatus.value;
      final isReady = controller.isReady;
      final isCompleted = controller.isCompleted;
      final isPaused = controller.isPaused;
      final sessionEyebrow = controller.sessionEyebrow;
      final timerLabel = controller.timerLabel;
      final progressValue = controller.progressValue;
      final sessionMetaLabel = controller.sessionMetaLabel;
      final progressLabel = controller.progressLabel;
      final targetLabelTitle = controller.targetLabelTitle;
      final targetValue = controller.displayNextTargetLabel;
      final accuracyLabel = controller.accuracyLabel;
      final completionSummary = controller.completionSummary;
      final cells = controller.cells.toList(growable: false);
      final revealLabels = controller.isBoardRevealed;
      final canTapBoard = controller.canTapBoard;
      final primaryHint = controller.primaryHint;
      final actionLabel = controller.actionLabel;

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
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight - AppSpacing.md - AppSpacing.xl,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TrainingSessionHero(
                              eyebrow: sessionEyebrow,
                              timerLabel: timerLabel,
                              progressValue: progressValue,
                              metaLabel: sessionMetaLabel,
                              progressLabel: progressLabel,
                            ),
                            const SizedBox(height: 28),
                            TrainingSessionMetrics(
                              targetTitle: targetLabelTitle,
                              targetValue: targetValue,
                              accuracyLabel: accuracyLabel,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            if (isCompleted) ...<Widget>[
                              TrainingSessionBanner(message: completionSummary),
                              const SizedBox(height: AppSpacing.md),
                            ],
                            TrainingBoardPanel(
                              gridSize: controller.config.gridSize,
                              cells: cells,
                              revealLabels: revealLabels,
                              isInteractionEnabled: canTapBoard,
                              overlayLabel: isPaused ? '已暂停' : null,
                              onCellTap: controller.handleCellTap,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TrainingSessionHint(message: primaryHint),
                            if (!isReady) ...<Widget>[
                              const SizedBox(height: AppSpacing.lg),
                              TrainingSessionActionBar(
                                status: sessionStatus,
                                primaryLabel: actionLabel,
                                onPrimaryAction: controller.handlePrimaryAction,
                                onRestart: controller.restartSession,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
