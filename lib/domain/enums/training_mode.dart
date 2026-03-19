import 'package:flutter/material.dart';

enum TrainingMode {
  numbers(
    label: '数字模式',
    shortLabel: '数字',
    description: '方格内显示 1 到 N²，按所选顺序完成点击。',
    icon: Icons.pin_outlined,
    tone: Color(0xFFE7F1FF),
  ),
  letters(
    label: '字母模式',
    shortLabel: '字母',
    description: '方格内显示连续字母，按字母表正序或倒序点击。',
    icon: Icons.sort_by_alpha_rounded,
    tone: Color(0xFFEAF5EA),
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
}
