enum TrainingSessionStatus {
  ready(label: '待开始', actionLabel: '开始训练'),
  running(label: '训练中', actionLabel: '重新开始'),
  completed(label: '已完成', actionLabel: '再来一局');

  const TrainingSessionStatus({required this.label, required this.actionLabel});

  final String label;
  final String actionLabel;
}
