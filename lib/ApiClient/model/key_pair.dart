//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class KeyPair {
  /// Returns a new [KeyPair] instance.
  KeyPair({
    required this.key,
    required this.value,
  });

  String key;

  String value;

  @override
  bool operator ==(Object other) => identical(this, other) || other is KeyPair &&
     other.key == key &&
     other.value == value;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key.hashCode) +
    (value.hashCode);

  @override
  String toString() => 'KeyPair[key=$key, value=$value]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'key'] = key;
      _json[r'value'] = value;
    return _json;
  }

  /// Returns a new [KeyPair] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static KeyPair? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "KeyPair[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "KeyPair[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return KeyPair(
        key: mapValueOfType<String>(json, r'key')!,
        value: mapValueOfType<String>(json, r'value')!,
      );
    }
    return null;
  }

  static List<KeyPair>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KeyPair>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KeyPair.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, KeyPair> mapFromJson(dynamic json) {
    final map = <String, KeyPair>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KeyPair.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of KeyPair-objects as value to a dart map
  static Map<String, List<KeyPair>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<KeyPair>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KeyPair.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'key',
    'value',
  };
}

