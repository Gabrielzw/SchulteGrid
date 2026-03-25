import 'package:schulte_grid/data/models/app_settings_snapshot.dart';
import 'package:schulte_grid/data/repositories/app_settings_repository.dart';

class FakeAppSettingsRepository implements AppSettingsRepository {
  FakeAppSettingsRepository(this.snapshot);

  AppSettingsSnapshot snapshot;

  @override
  Future<AppSettingsSnapshot> readSnapshot() async {
    return snapshot;
  }

  @override
  Future<void> replaceSnapshot(AppSettingsSnapshot value) async {
    snapshot = value;
  }
}
