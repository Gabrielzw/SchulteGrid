import 'package:flutter/material.dart';

enum TrainingMode {
  numbers(
    label: '标准数字模式',
    shortLabel: '数字',
    description: '方格内显示 1 到 N²，后续将按顺序点击。',
    icon: Icons.pin_outlined,
    tone: Color(0xFFE7F1FF),
  ),
  letters(
    label: '字母模式',
    shortLabel: '字母',
    description: '方格内显示等量字母，后续将按字母表点击。',
    icon: Icons.sort_by_alpha_rounded,
    tone: Color(0xFFEAF5EA),
  ),
  colors(
    label: '颜色模式',
    shortLabel: '颜色',
    description: '色块由浅到深排列，后续将补齐颜色训练规则。',
    icon: Icons.palette_outlined,
    tone: Color(0xFFFFF1DE),
  );

  const TrainingMode({
    required this.label,
    required this.shortLabel,
    required this.description,
    required this.icon,
    required this.tone,
  });

  final String label;
  final String shortLabel;
  final String description;
  final IconData icon;
  final Color tone;

  bool get supportsReverse => this != TrainingMode.colors;
}
