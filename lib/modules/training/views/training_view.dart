import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/enums/training_session_status.dart';
import '../../../domain/models/training_preview_cell.dart';
import '../controllers/training_controller.dart';
import '../widgets/training_sections.dart';

class TrainingView extends GetView<TrainingController> {
  const TrainingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _TrainingViewport(
        controller: controller,
        sessionStatus: controller.sessionStatus.value,
        isReady: controller.isReady,
        isCompleted: controller.isCompleted,
        isPaused: controller.isPaused,
        sessionEyebrow: controller.sessionEyebrow,
        timerLabel: controller.timerLabel,
        progressValue: controller.progressValue,
        sessionMetaLabel: controller.sessionMetaLabel,
        progressLabel: controller.progressLabel,
        targetLabelTitle: controller.targetLabelTitle,
        targetValue: controller.displayNextTargetLabel,
        accuracyLabel: controller.accuracyLabel,
        completionSummary: controller.completionSummary,
        cells: controller.cells.toList(growable: false),
        revealLabels: controller.isBoardRevealed,
        canTapBoard: controller.canTapBoard,
        primaryHint: controller.primaryHint,
        actionLabel: controller.actionLabel,
      ),
    );
  }
}

class _TrainingViewport extends StatelessWidget {
  const _TrainingViewport({
    required this.controller,
    required this.sessionStatus,
    required this.isReady,
    required this.isCompleted,
    required this.isPaused,
    required this.sessionEyebrow,
    required this.timerLabel,
    required this.progressValue,
    required this.sessionMetaLabel,
    required this.progressLabel,
    required this.targetLabelTitle,
    required this.targetValue,
    required this.accuracyLabel,
    required this.completionSummary,
    required this.cells,
    required this.revealLabels,
    required this.canTapBoard,
    required this.primaryHint,
    required this.actionLabel,
  });

  static const double _actionBarHeight = 72;
  static const double _horizontalPadding = 8;
  static const double _topPadding = 8;
  static const double _bottomPadding = AppSpacing.lg;
  static const double _maxBoardDimension = 520;

  final TrainingController controller;
  final TrainingSessionStatus sessionStatus;
  final bool isReady;
  final bool isCompleted;
  final bool isPaused;
  final String sessionEyebrow;
  final String timerLabel;
  final double progressValue;
  final String sessionMetaLabel;
  final String progressLabel;
  final String targetLabelTitle;
  final String targetValue;
  final String accuracyLabel;
  final String completionSummary;
  final List<TrainingPreviewCell> cells;
  final bool revealLabels;
  final bool canTapBoard;
  final String primaryHint;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[palette.shellTop, palette.canvas],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              _horizontalPadding,
              _topPadding,
              _horizontalPadding,
              _bottomPadding,
            ),
            child: Column(
              children: <Widget>[
                TrainingSessionDashboard(
                  eyebrow: sessionEyebrow,
                  timerLabel: timerLabel,
                  progressValue: progressValue,
                  metaLabel: sessionMetaLabel,
                  progressLabel: progressLabel,
                  targetTitle: targetLabelTitle,
                  targetValue: targetValue,
                  accuracyLabel: accuracyLabel,
                ),
                const SizedBox(height: AppSpacing.sm),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isCompleted
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: TrainingSessionBanner(
                            key: const ValueKey<String>('completion-banner'),
                            message: completionSummary,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final boardDimension = _resolveBoardDimension(
                            constraints,
                          );
                          return Center(
                            child: SizedBox.square(
                              dimension: boardDimension,
                              child: TrainingBoardPanel(
                                gridSize: controller.config.gridSize,
                                cells: cells,
                                revealLabels: revealLabels,
                                isInteractionEnabled: canTapBoard,
                                overlayLabel: isPaused ? '已暂停' : null,
                                onCellTap: controller.handleCellTap,
                              ),
                            ),
                          );
                        },
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: TrainingSessionHint(message: primaryHint),
                ),
                const SizedBox(height: AppSpacing.lg),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Visibility(
                    visible: !isReady,
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainState: true,
                    child: SizedBox(
                      height: _actionBarHeight,
                      child: TrainingSessionActionBar(
                        status: sessionStatus,
                        primaryLabel: actionLabel,
                        onPrimaryAction: controller.handlePrimaryAction,
                        onRestart: controller.restartSession,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _resolveBoardDimension(BoxConstraints constraints) {
    return min(
      min(constraints.maxWidth, constraints.maxHeight),
      _maxBoardDimension,
    );
  }
}
