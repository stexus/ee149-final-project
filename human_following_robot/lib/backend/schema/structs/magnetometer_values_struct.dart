// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MagnetometerValuesStruct extends BaseStruct {
  MagnetometerValuesStruct({
    double? xValue,
    double? yValue,
    double? zValue,
  })  : _xValue = xValue,
        _yValue = yValue,
        _zValue = zValue;

  // "x_value" field.
  double? _xValue;
  double get xValue => _xValue ?? 0.0;
  set xValue(double? val) => _xValue = val;
  void incrementXValue(double amount) => _xValue = xValue + amount;
  bool hasXValue() => _xValue != null;

  // "y_value" field.
  double? _yValue;
  double get yValue => _yValue ?? 0.0;
  set yValue(double? val) => _yValue = val;
  void incrementYValue(double amount) => _yValue = yValue + amount;
  bool hasYValue() => _yValue != null;

  // "z_value" field.
  double? _zValue;
  double get zValue => _zValue ?? 0.0;
  set zValue(double? val) => _zValue = val;
  void incrementZValue(double amount) => _zValue = zValue + amount;
  bool hasZValue() => _zValue != null;

  static MagnetometerValuesStruct fromMap(Map<String, dynamic> data) =>
      MagnetometerValuesStruct(
        xValue: castToType<double>(data['x_value']),
        yValue: castToType<double>(data['y_value']),
        zValue: castToType<double>(data['z_value']),
      );

  static MagnetometerValuesStruct? maybeFromMap(dynamic data) =>
      data is Map<String, dynamic>
          ? MagnetometerValuesStruct.fromMap(data)
          : null;

  Map<String, dynamic> toMap() => {
        'x_value': _xValue,
        'y_value': _yValue,
        'z_value': _zValue,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'x_value': serializeParam(
          _xValue,
          ParamType.double,
        ),
        'y_value': serializeParam(
          _yValue,
          ParamType.double,
        ),
        'z_value': serializeParam(
          _zValue,
          ParamType.double,
        ),
      }.withoutNulls;

  static MagnetometerValuesStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      MagnetometerValuesStruct(
        xValue: deserializeParam(
          data['x_value'],
          ParamType.double,
          false,
        ),
        yValue: deserializeParam(
          data['y_value'],
          ParamType.double,
          false,
        ),
        zValue: deserializeParam(
          data['z_value'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'MagnetometerValuesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MagnetometerValuesStruct &&
        xValue == other.xValue &&
        yValue == other.yValue &&
        zValue == other.zValue;
  }

  @override
  int get hashCode => const ListEquality().hash([xValue, yValue, zValue]);
}

MagnetometerValuesStruct createMagnetometerValuesStruct({
  double? xValue,
  double? yValue,
  double? zValue,
}) =>
    MagnetometerValuesStruct(
      xValue: xValue,
      yValue: yValue,
      zValue: zValue,
    );
