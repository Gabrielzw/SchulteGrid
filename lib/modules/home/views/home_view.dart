import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../controllers/home_controller.dart';
import '../widgets/training_config_sections.dart';

const List<TrainingChoice<TrainingMode>> _modeChoices =
    <TrainingChoice<TrainingMode>>[
      TrainingChoice<TrainingMode>(
        value: TrainingMode.numbers,
        label: '数字',
        caption: '1-25',
      ),
      TrainingChoice<TrainingMode>(
        value: TrainingMode.letters,
        label: '字母',
        caption: 'A-Z',
      ),
    ];

const List<TrainingChoice<TrainingOrder>> _orderChoices =
    <TrainingChoice<TrainingOrder>>[
      TrainingChoice<TrainingOrder>(
        value: TrainingOrder.ascending,
        label: '正序',
        caption: '从小到大',
      ),
      TrainingChoice<TrainingOrder>(
        value: TrainingOrder.descending,
        label: '倒序',
        caption: '从大到小',
      ),
    ];

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final validationMessage = controller.gridSizeValidationMessage;
      final previewConfig = controller.previewConfig;

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          40,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const TrainingSetupHeader(),
                const SizedBox(height: 28),
                const ThemeModeSection(),
                const SizedBox(height: 28),
                TrainingGridSizeSelector(
                  gridSizes: HomeController.commonGridSizes,
                  selectedGridSize: controller.parsedGridSize,
                  onSelected: controller.selectGridSize,
                ),
                const SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: TrainingOptionSelector<TrainingMode>(
                        title: '内容模式',
                        choices: _modeChoices,
                        selectedValue: controller.selectedMode.value,
                        onSelected: controller.selectMode,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TrainingOptionSelector<TrainingOrder>(
                        title: '顺序模式',
                        choices: _orderChoices,
                        selectedValue: controller.selectedOrder.value,
                        onSelected: controller.selectOrder,
                      ),
                    ),
                  ],
                ),
                if (validationMessage != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  TrainingValidationBanner(message: validationMessage),
                ],
                const SizedBox(height: 88),
                TrainingSetupPrimaryButton(
                  enabled: previewConfig != null,
                  onPressed: controller.openTrainingPreview,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
