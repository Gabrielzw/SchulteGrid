import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/training_record.dart';

class AppDatabase {
  AppDatabase._(this.instance);

  static const String _databaseName = 'schulte_grid';

  final Isar instance;

  static Future<AppDatabase> create() async {
    final directory = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      <CollectionSchema<dynamic>>[TrainingRecordSchema],
      directory: directory.path,
      name: _databaseName,
    );
    return AppDatabase._(isar);
  }

  Future<void> close() {
    return instance.close();
  }
}
