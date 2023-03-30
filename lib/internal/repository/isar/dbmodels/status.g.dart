// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetStatusCollection on Isar {
  IsarCollection<Status> get status => this.collection();
}

const StatusSchema = CollectionSchema(
  name: r'Status',
  id: -8158262482337811485,
  properties: {
    r'apiOk': PropertySchema(
      id: 0,
      name: r'apiOk',
      type: IsarType.bool,
    ),
    r'permissionStatus': PropertySchema(
      id: 1,
      name: r'permissionStatus',
      type: IsarType.bool,
    )
  },
  estimateSize: _statusEstimateSize,
  serialize: _statusSerialize,
  deserialize: _statusDeserialize,
  deserializeProp: _statusDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _statusGetId,
  getLinks: _statusGetLinks,
  attach: _statusAttach,
  version: '3.0.5',
);

int _statusEstimateSize(
  Status object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _statusSerialize(
  Status object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.apiOk);
  writer.writeBool(offsets[1], object.permissionStatus);
}

Status _statusDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Status(
    apiOk: reader.readBoolOrNull(offsets[0]),
    permissionStatus: reader.readBoolOrNull(offsets[1]),
  );
  return object;
}

P _statusDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _statusGetId(Status object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _statusGetLinks(Status object) {
  return [];
}

void _statusAttach(IsarCollection<dynamic> col, Id id, Status object) {}

extension StatusQueryWhereSort on QueryBuilder<Status, Status, QWhere> {
  QueryBuilder<Status, Status, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StatusQueryWhere on QueryBuilder<Status, Status, QWhereClause> {
  QueryBuilder<Status, Status, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Status, Status, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Status, Status, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Status, Status, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Status, Status, QAfterWhereClause> idBetween(
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

extension StatusQueryFilter on QueryBuilder<Status, Status, QFilterCondition> {
  QueryBuilder<Status, Status, QAfterFilterCondition> apiOkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'apiOk',
      ));
    });
  }

  QueryBuilder<Status, Status, QAfterFilterCondition> apiOkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'apiOk',
      ));
    });
  }

  QueryBuilder<Status, Status, QAfterFilterCondition> apiOkEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'apiOk',
        value: value,
      ));
    });
  }

  QueryBuilder<Status, Status, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Status, Status, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Status, Status, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Status, Status, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Status, Status, QAfterFilterCondition> permissionStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'permissionStatus',
      ));
    });
  }

  QueryBuilder<Status, Status, QAfterFilterCondition>
      permissionStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'permissionStatus',
      ));
    });
  }

  QueryBuilder<Status, Status, QAfterFilterCondition> permissionStatusEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'permissionStatus',
        value: value,
      ));
    });
  }
}

extension StatusQueryObject on QueryBuilder<Status, Status, QFilterCondition> {}

extension StatusQueryLinks on QueryBuilder<Status, Status, QFilterCondition> {}

extension StatusQuerySortBy on QueryBuilder<Status, Status, QSortBy> {
  QueryBuilder<Status, Status, QAfterSortBy> sortByApiOk() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiOk', Sort.asc);
    });
  }

  QueryBuilder<Status, Status, QAfterSortBy> sortByApiOkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiOk', Sort.desc);
    });
  }

  QueryBuilder<Status, Status, QAfterSortBy> sortByPermissionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permissionStatus', Sort.asc);
    });
  }

  QueryBuilder<Status, Status, QAfterSortBy> sortByPermissionStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permissionStatus', Sort.desc);
    });
  }
}

extension StatusQuerySortThenBy on QueryBuilder<Status, Status, QSortThenBy> {
  QueryBuilder<Status, Status, QAfterSortBy> thenByApiOk() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiOk', Sort.asc);
    });
  }

  QueryBuilder<Status, Status, QAfterSortBy> thenByApiOkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiOk', Sort.desc);
    });
  }

  QueryBuilder<Status, Status, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Status, Status, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Status, Status, QAfterSortBy> thenByPermissionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permissionStatus', Sort.asc);
    });
  }

  QueryBuilder<Status, Status, QAfterSortBy> thenByPermissionStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permissionStatus', Sort.desc);
    });
  }
}

extension StatusQueryWhereDistinct on QueryBuilder<Status, Status, QDistinct> {
  QueryBuilder<Status, Status, QDistinct> distinctByApiOk() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'apiOk');
    });
  }

  QueryBuilder<Status, Status, QDistinct> distinctByPermissionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'permissionStatus');
    });
  }
}

extension StatusQueryProperty on QueryBuilder<Status, Status, QQueryProperty> {
  QueryBuilder<Status, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Status, bool?, QQueryOperations> apiOkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'apiOk');
    });
  }

  QueryBuilder<Status, bool?, QQueryOperations> permissionStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'permissionStatus');
    });
  }
}
