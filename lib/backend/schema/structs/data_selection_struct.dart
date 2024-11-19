// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class DataSelectionStruct extends FFFirebaseStruct {
  DataSelectionStruct({
    DateTime? startDay,
    DateTime? endDay,
    int? startHour,
    int? endHour,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _startDay = startDay,
        _endDay = endDay,
        _startHour = startHour,
        _endHour = endHour,
        super(firestoreUtilData);

  // "startDay" field.
  DateTime? _startDay;
  DateTime? get startDay => _startDay;
  set startDay(DateTime? val) => _startDay = val;

  bool hasStartDay() => _startDay != null;

  // "endDay" field.
  DateTime? _endDay;
  DateTime? get endDay => _endDay;
  set endDay(DateTime? val) => _endDay = val;

  bool hasEndDay() => _endDay != null;

  // "startHour" field.
  int? _startHour;
  int get startHour => _startHour ?? 0;
  set startHour(int? val) => _startHour = val;

  void incrementStartHour(int amount) => startHour = startHour + amount;

  bool hasStartHour() => _startHour != null;

  // "endHour" field.
  int? _endHour;
  int get endHour => _endHour ?? 0;
  set endHour(int? val) => _endHour = val;

  void incrementEndHour(int amount) => endHour = endHour + amount;

  bool hasEndHour() => _endHour != null;

  static DataSelectionStruct fromMap(Map<String, dynamic> data) =>
      DataSelectionStruct(
        startDay: data['startDay'] as DateTime?,
        endDay: data['endDay'] as DateTime?,
        startHour: castToType<int>(data['startHour']),
        endHour: castToType<int>(data['endHour']),
      );

  static DataSelectionStruct? maybeFromMap(dynamic data) => data is Map
      ? DataSelectionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'startDay': _startDay,
        'endDay': _endDay,
        'startHour': _startHour,
        'endHour': _endHour,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'startDay': serializeParam(
          _startDay,
          ParamType.DateTime,
        ),
        'endDay': serializeParam(
          _endDay,
          ParamType.DateTime,
        ),
        'startHour': serializeParam(
          _startHour,
          ParamType.int,
        ),
        'endHour': serializeParam(
          _endHour,
          ParamType.int,
        ),
      }.withoutNulls;

  static DataSelectionStruct fromSerializableMap(Map<String, dynamic> data) =>
      DataSelectionStruct(
        startDay: deserializeParam(
          data['startDay'],
          ParamType.DateTime,
          false,
        ),
        endDay: deserializeParam(
          data['endDay'],
          ParamType.DateTime,
          false,
        ),
        startHour: deserializeParam(
          data['startHour'],
          ParamType.int,
          false,
        ),
        endHour: deserializeParam(
          data['endHour'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DataSelectionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DataSelectionStruct &&
        startDay == other.startDay &&
        endDay == other.endDay &&
        startHour == other.startHour &&
        endHour == other.endHour;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([startDay, endDay, startHour, endHour]);
}

DataSelectionStruct createDataSelectionStruct({
  DateTime? startDay,
  DateTime? endDay,
  int? startHour,
  int? endHour,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DataSelectionStruct(
      startDay: startDay,
      endDay: endDay,
      startHour: startHour,
      endHour: endHour,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DataSelectionStruct? updateDataSelectionStruct(
  DataSelectionStruct? dataSelection, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dataSelection
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDataSelectionStructData(
  Map<String, dynamic> firestoreData,
  DataSelectionStruct? dataSelection,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dataSelection == null) {
    return;
  }
  if (dataSelection.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && dataSelection.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dataSelectionData =
      getDataSelectionFirestoreData(dataSelection, forFieldValue);
  final nestedData =
      dataSelectionData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = dataSelection.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDataSelectionFirestoreData(
  DataSelectionStruct? dataSelection, [
  bool forFieldValue = false,
]) {
  if (dataSelection == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dataSelection.toMap());

  // Add any Firestore field values
  dataSelection.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDataSelectionListFirestoreData(
  List<DataSelectionStruct>? dataSelections,
) =>
    dataSelections
        ?.map((e) => getDataSelectionFirestoreData(e, true))
        .toList() ??
    [];
