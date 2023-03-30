// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_event.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetNotificationEventCollection on Isar {
  IsarCollection<NotificationEvent> get notificationEvents => this.collection();
}

const NotificationEventSchema = CollectionSchema(
  name: r'NotificationEvent',
  id: -4542001436064910387,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.long,
    ),
    r'errorMessage': PropertySchema(
      id: 1,
      name: r'errorMessage',
      type: IsarType.string,
    ),
    r'packageName': PropertySchema(
      id: 2,
      name: r'packageName',
      type: IsarType.string,
    ),
    r'success': PropertySchema(
      id: 3,
      name: r'success',
      type: IsarType.bool,
    ),
    r'targetHash': PropertySchema(
      id: 4,
      name: r'targetHash',
      type: IsarType.string,
    ),
    r'targetHost': PropertySchema(
      id: 5,
      name: r'targetHost',
      type: IsarType.string,
    ),
    r'targetPost': PropertySchema(
      id: 6,
      name: r'targetPost',
      type: IsarType.string,
    ),
    r'text': PropertySchema(
      id: 7,
      name: r'text',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 8,
      name: r'timestamp',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _notificationEventEstimateSize,
  serialize: _notificationEventSerialize,
  deserialize: _notificationEventDeserialize,
  deserializeProp: _notificationEventDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notificationEventGetId,
  getLinks: _notificationEventGetLinks,
  attach: _notificationEventAttach,
  version: '3.0.5',
);

int _notificationEventEstimateSize(
  NotificationEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.errorMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.packageName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.targetHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.targetHost;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.targetPost;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _notificationEventSerialize(
  NotificationEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeString(offsets[1], object.errorMessage);
  writer.writeString(offsets[2], object.packageName);
  writer.writeBool(offsets[3], object.success);
  writer.writeString(offsets[4], object.targetHash);
  writer.writeString(offsets[5], object.targetHost);
  writer.writeString(offsets[6], object.targetPost);
  writer.writeString(offsets[7], object.text);
  writer.writeLong(offsets[8], object.timestamp);
  writer.writeString(offsets[9], object.title);
}

NotificationEvent _notificationEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationEvent(
    amount: reader.readLongOrNull(offsets[0]),
    errorMessage: reader.readStringOrNull(offsets[1]),
    packageName: reader.readStringOrNull(offsets[2]),
    success: reader.readBoolOrNull(offsets[3]),
    targetHash: reader.readStringOrNull(offsets[4]),
    targetHost: reader.readStringOrNull(offsets[5]),
    targetPost: reader.readStringOrNull(offsets[6]),
    text: reader.readStringOrNull(offsets[7]),
    timestamp: reader.readLongOrNull(offsets[8]),
    title: reader.readStringOrNull(offsets[9]),
  );
  object.id = id;
  return object;
}

P _notificationEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationEventGetId(NotificationEvent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationEventGetLinks(
    NotificationEvent object) {
  return [];
}

void _notificationEventAttach(
    IsarCollection<dynamic> col, Id id, NotificationEvent object) {
  object.id = id;
}

extension NotificationEventQueryWhereSort
    on QueryBuilder<NotificationEvent, NotificationEvent, QWhere> {
  QueryBuilder<NotificationEvent, NotificationEvent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationEventQueryWhere
    on QueryBuilder<NotificationEvent, NotificationEvent, QWhereClause> {
  QueryBuilder<NotificationEvent, NotificationEvent, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationEventQueryFilter
    on QueryBuilder<NotificationEvent, NotificationEvent, QFilterCondition> {
  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      amountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      amountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      amountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      amountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      amountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      amountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'errorMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'errorMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      errorMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'packageName',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'packageName',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      packageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      successIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'success',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      successIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'success',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      successEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'success',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetHash',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetHash',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetHash',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetHash',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetHost',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetHost',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetHost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetHost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetHost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetHost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetHost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetHost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetHost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetHost',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetHost',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetHostIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetHost',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetPost',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetPost',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetPost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetPost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetPost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetPost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetPost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetPost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetPost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetPost',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetPost',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      targetPostIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetPost',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      timestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timestamp',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      timestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timestamp',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      timestampEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      timestampGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      timestampLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      timestampBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension NotificationEventQueryObject
    on QueryBuilder<NotificationEvent, NotificationEvent, QFilterCondition> {}

extension NotificationEventQueryLinks
    on QueryBuilder<NotificationEvent, NotificationEvent, QFilterCondition> {}

extension NotificationEventQuerySortBy
    on QueryBuilder<NotificationEvent, NotificationEvent, QSortBy> {
  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortBySuccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'success', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortBySuccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'success', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTargetHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetHash', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTargetHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetHash', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTargetHost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetHost', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTargetHostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetHost', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTargetPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetPost', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTargetPostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetPost', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension NotificationEventQuerySortThenBy
    on QueryBuilder<NotificationEvent, NotificationEvent, QSortThenBy> {
  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenBySuccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'success', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenBySuccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'success', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTargetHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetHash', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTargetHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetHash', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTargetHost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetHost', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTargetHostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetHost', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTargetPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetPost', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTargetPostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetPost', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension NotificationEventQueryWhereDistinct
    on QueryBuilder<NotificationEvent, NotificationEvent, QDistinct> {
  QueryBuilder<NotificationEvent, NotificationEvent, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QDistinct>
      distinctByErrorMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QDistinct>
      distinctByPackageName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QDistinct>
      distinctBySuccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'success');
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QDistinct>
      distinctByTargetHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QDistinct>
      distinctByTargetHost({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetHost', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QDistinct>
      distinctByTargetPost({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetPost', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<NotificationEvent, NotificationEvent, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension NotificationEventQueryProperty
    on QueryBuilder<NotificationEvent, NotificationEvent, QQueryProperty> {
  QueryBuilder<NotificationEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationEvent, int?, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<NotificationEvent, String?, QQueryOperations>
      errorMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorMessage');
    });
  }

  QueryBuilder<NotificationEvent, String?, QQueryOperations>
      packageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageName');
    });
  }

  QueryBuilder<NotificationEvent, bool?, QQueryOperations> successProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'success');
    });
  }

  QueryBuilder<NotificationEvent, String?, QQueryOperations>
      targetHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetHash');
    });
  }

  QueryBuilder<NotificationEvent, String?, QQueryOperations>
      targetHostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetHost');
    });
  }

  QueryBuilder<NotificationEvent, String?, QQueryOperations>
      targetPostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetPost');
    });
  }

  QueryBuilder<NotificationEvent, String?, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<NotificationEvent, int?, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<NotificationEvent, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
