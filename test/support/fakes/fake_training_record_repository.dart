import 'package:schulte_grid/data/models/training_record.dart';
import 'package:schulte_grid/data/repositories/training_record_repository.dart';

class FakeTrainingRecordRepository implements TrainingRecordRepository {
  FakeTrainingRecordRepository([List<TrainingRecord>? initialRecords]) {
    if (initialRecords != null) {
      _records.addAll(initialRecords);
      _sortRecords();
    }
  }

  final List<TrainingRecord> _records = <TrainingRecord>[];

  List<TrainingRecord> get savedRecords =>
      List<TrainingRecord>.unmodifiable(_records);

  @override
  Future<List<TrainingRecord>> fetchAll() async {
    return List<TrainingRecord>.unmodifiable(_records);
  }

  @override
  Future<void> save(TrainingRecord record) async {
    _records.add(record);
    _sortRecords();
  }

  void _sortRecords() {
    _records.sort(
      (left, right) => right.completedAt.compareTo(left.completedAt),
    );
  }
}
