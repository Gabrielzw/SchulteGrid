// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrainingRecordCollection on Isar {
  IsarCollection<TrainingRecord> get trainingRecords => this.collection();
}

const TrainingRecordSchema = CollectionSchema(
  name: r'TrainingRecord',
  id: 6515578706162409027,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'durationInMilliseconds': PropertySchema(
      id: 1,
      name: r'durationInMilliseconds',
      type: IsarType.long,
    ),
    r'errorCount': PropertySchema(
      id: 2,
      name: r'errorCount',
      type: IsarType.long,
    ),
    r'gridSize': PropertySchema(id: 3, name: r'gridSize', type: IsarType.long),
    r'mode': PropertySchema(id: 4, name: r'mode', type: IsarType.string),
    r'order': PropertySchema(id: 5, name: r'order', type: IsarType.string),
  },

  estimateSize: _trainingRecordEstimateSize,
  serialize: _trainingRecordSerialize,
  deserialize: _trainingRecordDeserialize,
  deserializeProp: _trainingRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _trainingRecordGetId,
  getLinks: _trainingRecordGetLinks,
  attach: _trainingRecordAttach,
  version: '3.3.0',
);

int _trainingRecordEstimateSize(
  TrainingRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mode.length * 3;
  bytesCount += 3 + object.order.length * 3;
  return bytesCount;
}

void _trainingRecordSerialize(
  TrainingRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeLong(offsets[1], object.durationInMilliseconds);
  writer.writeLong(offsets[2], object.errorCount);
  writer.writeLong(offsets[3], object.gridSize);
  writer.writeString(offsets[4], object.mode);
  writer.writeString(offsets[5], object.order);
}

TrainingRecord _trainingRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrainingRecord();
  object.completedAt = reader.readDateTime(offsets[0]);
  object.durationInMilliseconds = reader.readLong(offsets[1]);
  object.errorCount = reader.readLong(offsets[2]);
  object.gridSize = reader.readLong(offsets[3]);
  object.id = id;
  object.mode = reader.readString(offsets[4]);
  object.order = reader.readString(offsets[5]);
  return object;
}

P _trainingRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _trainingRecordGetId(TrainingRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _trainingRecordGetLinks(TrainingRecord object) {
  return [];
}

void _trainingRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  TrainingRecord object,
) {
  object.id = id;
}

extension TrainingRecordQueryWhereSort
    on QueryBuilder<TrainingRecord, TrainingRecord, QWhere> {
  QueryBuilder<TrainingRecord, TrainingRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TrainingRecordQueryWhere
    on QueryBuilder<TrainingRecord, TrainingRecord, QWhereClause> {
  QueryBuilder<TrainingRecord, TrainingRecord, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TrainingRecordQueryFilter
    on QueryBuilder<TrainingRecord, TrainingRecord, QFilterCondition> {
  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  completedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  completedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  completedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  durationInMillisecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'durationInMilliseconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  durationInMillisecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationInMilliseconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  durationInMillisecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationInMilliseconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  durationInMillisecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationInMilliseconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  errorCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'errorCount', value: value),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  errorCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'errorCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  errorCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'errorCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  errorCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'errorCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  gridSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gridSize', value: value),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  gridSizeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  gridSizeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  gridSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gridSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  modeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  modeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  modeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  modeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  modeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  modeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  modeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  modeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'mode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  modeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mode', value: ''),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  modeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'mode', value: ''),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  orderEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'order',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  orderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'order',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  orderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'order',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  orderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'order',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  orderStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'order',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  orderEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'order',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  orderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'order',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  orderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'order',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  orderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'order', value: ''),
      );
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterFilterCondition>
  orderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'order', value: ''),
      );
    });
  }
}

extension TrainingRecordQueryObject
    on QueryBuilder<TrainingRecord, TrainingRecord, QFilterCondition> {}

extension TrainingRecordQueryLinks
    on QueryBuilder<TrainingRecord, TrainingRecord, QFilterCondition> {}

extension TrainingRecordQuerySortBy
    on QueryBuilder<TrainingRecord, TrainingRecord, QSortBy> {
  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  sortByDurationInMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  sortByDurationInMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  sortByErrorCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorCount', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  sortByErrorCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorCount', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> sortByGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  sortByGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> sortByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> sortByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> sortByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> sortByOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.desc);
    });
  }
}

extension TrainingRecordQuerySortThenBy
    on QueryBuilder<TrainingRecord, TrainingRecord, QSortThenBy> {
  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  thenByDurationInMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  thenByDurationInMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  thenByErrorCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorCount', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  thenByErrorCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorCount', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> thenByGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy>
  thenByGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> thenByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> thenByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> thenByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.asc);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QAfterSortBy> thenByOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.desc);
    });
  }
}

extension TrainingRecordQueryWhereDistinct
    on QueryBuilder<TrainingRecord, TrainingRecord, QDistinct> {
  QueryBuilder<TrainingRecord, TrainingRecord, QDistinct>
  distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QDistinct>
  distinctByDurationInMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInMilliseconds');
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QDistinct>
  distinctByErrorCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorCount');
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QDistinct> distinctByGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gridSize');
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QDistinct> distinctByMode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrainingRecord, TrainingRecord, QDistinct> distinctByOrder({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'order', caseSensitive: caseSensitive);
    });
  }
}

extension TrainingRecordQueryProperty
    on QueryBuilder<TrainingRecord, TrainingRecord, QQueryProperty> {
  QueryBuilder<TrainingRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TrainingRecord, DateTime, QQueryOperations>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<TrainingRecord, int, QQueryOperations>
  durationInMillisecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInMilliseconds');
    });
  }

  QueryBuilder<TrainingRecord, int, QQueryOperations> errorCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorCount');
    });
  }

  QueryBuilder<TrainingRecord, int, QQueryOperations> gridSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gridSize');
    });
  }

  QueryBuilder<TrainingRecord, String, QQueryOperations> modeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mode');
    });
  }

  QueryBuilder<TrainingRecord, String, QQueryOperations> orderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'order');
    });
  }
}
