import 'dart:convert';

import 'app_settings_snapshot.dart';
import 'training_record.dart';

class AppBackupData {
  AppBackupData({
    required this.createdAt,
    required this.settings,
    required List<TrainingRecord> trainingRecords,
  }) : trainingRecords = List<TrainingRecord>.unmodifiable(trainingRecords);

  static const int schemaVersion = 1;
  static const String schemaVersionKey = 'schemaVersion';
  static const String createdAtKey = 'createdAt';
  static const String settingsKey = 'settings';
  static const String trainingRecordsKey = 'trainingRecords';

  final DateTime createdAt;
  final AppSettingsSnapshot settings;
  final List<TrainingRecord> trainingRecords;

  String toJsonString() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      schemaVersionKey: schemaVersion,
      createdAtKey: createdAt.toIso8601String(),
      settingsKey: settings.toJson(),
      trainingRecordsKey: trainingRecords
          .map(_trainingRecordToJson)
          .toList(growable: false),
    };
  }

  factory AppBackupData.fromJsonString(String jsonText) {
    final Object? decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('备份文件格式无效。');
    }

    return AppBackupData.fromJson(decoded);
  }

  factory AppBackupData.fromJson(Map<String, dynamic> json) {
    final int version = _readIntValue(json[schemaVersionKey], '备份文件版本无效。');
    if (version != schemaVersion) {
      throw FormatException('不支持的备份文件版本：$version');
    }

    final String createdAtValue = _readStringValue(
      json[createdAtKey],
      '备份文件缺少创建时间。',
    );
    final DateTime? createdAt = DateTime.tryParse(createdAtValue);
    if (createdAt == null) {
      throw FormatException('备份文件创建时间无效：$createdAtValue');
    }

    final Map<String, dynamic> settings = _readJsonMap(
      json[settingsKey],
      '备份文件缺少有效的应用配置。',
    );
    final List<dynamic> records = _readJsonList(
      json[trainingRecordsKey],
      '备份文件缺少有效的训练记录列表。',
    );

    return AppBackupData(
      createdAt: createdAt,
      settings: AppSettingsSnapshot.fromJson(settings),
      trainingRecords: records
          .map(_trainingRecordFromJson)
          .toList(growable: false),
    );
  }
}

Map<String, dynamic> _trainingRecordToJson(TrainingRecord record) {
  return <String, dynamic>{
    'id': record.id,
    'mode': record.mode,
    'order': record.order,
    'gridSize': record.gridSize,
    'durationInMilliseconds': record.durationInMilliseconds,
    'errorCount': record.errorCount,
    'completedAt': record.completedAt.toIso8601String(),
  };
}

TrainingRecord _trainingRecordFromJson(dynamic value) {
  final Map<String, dynamic> json = _readJsonMap(value, '备份文件中的训练记录格式无效。');
  final String completedAtValue = _readStringValue(
    json['completedAt'],
    '备份文件中的训练完成时间无效。',
  );
  final DateTime? completedAt = DateTime.tryParse(completedAtValue);
  if (completedAt == null) {
    throw FormatException('备份文件中的训练完成时间无效：$completedAtValue');
  }

  return TrainingRecord()
    ..id = _readIntValue(json['id'], '备份文件中的训练记录 ID 无效。')
    ..mode = _readStringValue(json['mode'], '备份文件中的训练模式无效。')
    ..order = _readStringValue(json['order'], '备份文件中的训练顺序无效。')
    ..gridSize = _readIntValue(json['gridSize'], '备份文件中的网格大小无效。')
    ..durationInMilliseconds = _readIntValue(
      json['durationInMilliseconds'],
      '备份文件中的训练用时无效。',
    )
    ..errorCount = _readIntValue(json['errorCount'], '备份文件中的错误次数无效。')
    ..completedAt = completedAt;
}

int _readIntValue(Object? value, String errorMessage) {
  if (value is int) {
    return value;
  }
  if (value is num && value == value.roundToDouble()) {
    return value.toInt();
  }

  throw FormatException(errorMessage);
}

String _readStringValue(Object? value, String errorMessage) {
  if (value is String) {
    return value;
  }

  throw FormatException(errorMessage);
}

Map<String, dynamic> _readJsonMap(Object? value, String errorMessage) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map<Object?, Object?>) {
    return value.map<String, dynamic>((Object? key, Object? nestedValue) {
      return MapEntry<String, dynamic>(key.toString(), nestedValue);
    });
  }

  throw FormatException(errorMessage);
}

List<dynamic> _readJsonList(Object? value, String errorMessage) {
  if (value is List<dynamic>) {
    return value;
  }

  throw FormatException(errorMessage);
}
