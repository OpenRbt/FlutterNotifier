//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StationConfig {
  /// Returns a new [StationConfig] instance.
  StationConfig({
    required this.id,
    this.preflightSec,
    this.name,
    this.hash,
    this.relayBoard,
  });

  int id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? preflightSec;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? hash;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  RelayBoard? relayBoard;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StationConfig &&
     other.id == id &&
     other.preflightSec == preflightSec &&
     other.name == name &&
     other.hash == hash &&
     other.relayBoard == relayBoard;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (preflightSec == null ? 0 : preflightSec!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (hash == null ? 0 : hash!.hashCode) +
    (relayBoard == null ? 0 : relayBoard!.hashCode);

  @override
  String toString() => 'StationConfig[id=$id, preflightSec=$preflightSec, name=$name, hash=$hash, relayBoard=$relayBoard]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'id'] = id;
    if (preflightSec != null) {
      _json[r'preflightSec'] = preflightSec;
    }
    if (name != null) {
      _json[r'name'] = name;
    }
    if (hash != null) {
      _json[r'hash'] = hash;
    }
    if (relayBoard != null) {
      _json[r'relayBoard'] = relayBoard;
    }
    return _json;
  }

  /// Returns a new [StationConfig] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StationConfig? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "StationConfig[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "StationConfig[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StationConfig(
        id: mapValueOfType<int>(json, r'id')!,
        preflightSec: mapValueOfType<int>(json, r'preflightSec'),
        name: mapValueOfType<String>(json, r'name'),
        hash: mapValueOfType<String>(json, r'hash'),
        relayBoard: RelayBoard.fromJson(json[r'relayBoard']),
      );
    }
    return null;
  }

  static List<StationConfig>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StationConfig>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StationConfig.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StationConfig> mapFromJson(dynamic json) {
    final map = <String, StationConfig>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StationConfig.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StationConfig-objects as value to a dart map
  static Map<String, List<StationConfig>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StationConfig>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StationConfig.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
  };
}

