import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/metric_tile.dart';
import '../../../app/widgets/section_card.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/models/training_config.dart';

class GridSizeSelector extends StatelessWidget {
  const GridSizeSelector({
    required this.commonGridSizes,
    required this.selectedMode,
    required this.selectedGridSize,
    required this.gridSizeInput,
    required this.validationMessage,
    required this.onQuickSelected,
    required this.onInputChanged,
    super.key,
  });

  final List<int> commonGridSizes;
  final TrainingMode selectedMode;
  final int? selectedGridSize;
  final String gridSizeInput;
  final String? validationMessage;
  final ValueChanged<int> onQuickSelected;
  final ValueChanged<String> onInputChanged;

  @override
  Widget build(BuildContext context) {
    final helperText = selectedMode == TrainingMode.letters
        ? '字母模式使用单个大写字母，当前最大支持 '
              '${TrainingConfig.maxLetterGridSize} x ${TrainingConfig.maxLetterGridSize}。'
        : '数字模式支持自定义正整数 N，训练页将按 N x N 展示。';

    return SectionCard(
      title: '网格大小',
      subtitle: '可直接选择常用尺寸，也可以输入自定义 N。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: commonGridSizes.map((int gridSize) {
              return ChoiceChip(
                label: Text('$gridSize x $gridSize'),
                selected: gridSize == selectedGridSize,
                onSelected: (_) => onQuickSelected(gridSize),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          _GridSizeInputField(value: gridSizeInput, onChanged: onInputChanged),
          const SizedBox(height: AppSpacing.sm),
          Text(helperText, style: Theme.of(context).textTheme.bodySmall),
          if (validationMessage != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            _ValidationBanner(message: validationMessage!),
          ],
        ],
      ),
    );
  }
}

class ConfigSummaryCard extends StatelessWidget {
  const ConfigSummaryCard({
    required this.config,
    required this.validationMessage,
    required this.onPressed,
    super.key,
  });

  final TrainingConfig? config;
  final String? validationMessage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final resolvedConfig = config;
    final instruction =
        resolvedConfig?.selectionInstruction ?? '当前参数不合法，修正后才能进入训练页。';

    return SectionCard(
      title: '参数确认',
      subtitle: '启动前确认本次训练的模式、顺序和规模。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (resolvedConfig == null)
            _ValidationBanner(message: validationMessage ?? '请输入有效的训练参数。'),
          if (resolvedConfig != null)
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                MetricTile(
                  label: '总格数',
                  value: '${resolvedConfig.totalCells}',
                  icon: Icons.apps_rounded,
                ),
                MetricTile(
                  label: '模式',
                  value: resolvedConfig.mode.shortLabel,
                  icon: resolvedConfig.mode.icon,
                ),
                MetricTile(
                  label: '顺序',
                  value: resolvedConfig.orderLabel,
                  icon: Icons.swap_vert_rounded,
                ),
                MetricTile(
                  label: '起始目标',
                  value: resolvedConfig.nextTargetHint,
                  icon: Icons.flag_outlined,
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.md),
          Text(instruction, style: Theme.of(context).textTheme.bodyMedium),
          if (resolvedConfig != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Text(
              resolvedConfig.helperText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: resolvedConfig == null ? null : onPressed,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('进入训练页'),
          ),
        ],
      ),
    );
  }
}

class _ValidationBanner extends StatelessWidget {
  const _ValidationBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: colorScheme.onErrorContainer),
      ),
    );
  }
}

class _GridSizeInputField extends StatefulWidget {
  const _GridSizeInputField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_GridSizeInputField> createState() => _GridSizeInputFieldState();
}

class _GridSizeInputFieldState extends State<_GridSizeInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _GridSizeInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == _controller.text) {
      return;
    }

    _controller.value = TextEditingValue(
      text: widget.value,
      selection: TextSelection.collapsed(offset: widget.value.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: const InputDecoration(
        labelText: '自定义 N',
        hintText: '输入正整数，例如 5',
        border: OutlineInputBorder(),
      ),
      onChanged: widget.onChanged,
    );
  }
}
