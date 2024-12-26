// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MapStatsStruct extends BaseStruct {
  MapStatsStruct({
    String? size,
    String? length,
    String? storeName,
    String? rawStoreName,
  })  : _size = size,
        _length = length,
        _storeName = storeName,
        _rawStoreName = rawStoreName;

  // "size" field.
  String? _size;
  String get size => _size ?? '';
  set size(String? val) => _size = val;

  bool hasSize() => _size != null;

  // "length" field.
  String? _length;
  String get length => _length ?? '';
  set length(String? val) => _length = val;

  bool hasLength() => _length != null;

  // "storeName" field.
  String? _storeName;
  String get storeName => _storeName ?? '';
  set storeName(String? val) => _storeName = val;

  bool hasStoreName() => _storeName != null;

  // "rawStoreName" field.
  String? _rawStoreName;
  String get rawStoreName => _rawStoreName ?? '';
  set rawStoreName(String? val) => _rawStoreName = val;

  bool hasRawStoreName() => _rawStoreName != null;

  static MapStatsStruct fromMap(Map<String, dynamic> data) => MapStatsStruct(
        size: data['size'] as String?,
        length: data['length'] as String?,
        storeName: data['storeName'] as String?,
        rawStoreName: data['rawStoreName'] as String?,
      );

  static MapStatsStruct? maybeFromMap(dynamic data) =>
      data is Map ? MapStatsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'size': _size,
        'length': _length,
        'storeName': _storeName,
        'rawStoreName': _rawStoreName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'size': serializeParam(
          _size,
          ParamType.String,
        ),
        'length': serializeParam(
          _length,
          ParamType.String,
        ),
        'storeName': serializeParam(
          _storeName,
          ParamType.String,
        ),
        'rawStoreName': serializeParam(
          _rawStoreName,
          ParamType.String,
        ),
      }.withoutNulls;

  static MapStatsStruct fromSerializableMap(Map<String, dynamic> data) =>
      MapStatsStruct(
        size: deserializeParam(
          data['size'],
          ParamType.String,
          false,
        ),
        length: deserializeParam(
          data['length'],
          ParamType.String,
          false,
        ),
        storeName: deserializeParam(
          data['storeName'],
          ParamType.String,
          false,
        ),
        rawStoreName: deserializeParam(
          data['rawStoreName'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MapStatsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MapStatsStruct &&
        size == other.size &&
        length == other.length &&
        storeName == other.storeName &&
        rawStoreName == other.rawStoreName;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([size, length, storeName, rawStoreName]);
}

MapStatsStruct createMapStatsStruct({
  String? size,
  String? length,
  String? storeName,
  String? rawStoreName,
}) =>
    MapStatsStruct(
      size: size,
      length: length,
      storeName: storeName,
      rawStoreName: rawStoreName,
    );
