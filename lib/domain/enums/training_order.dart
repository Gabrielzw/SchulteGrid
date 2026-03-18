enum TrainingOrder {
  ascending(label: '正序', description: '从起点逐步点击到终点。'),
  descending(label: '倒序', description: '从终点逐步点击回起点。');

  const TrainingOrder({required this.label, required this.description});

  final String label;
  final String description;
}
