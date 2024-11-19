// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class NumberOfPeopleStruct extends FFFirebaseStruct {
  NumberOfPeopleStruct({
    int? seniors,
    int? adults,
    int? youth,
    int? children,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _seniors = seniors,
        _adults = adults,
        _youth = youth,
        _children = children,
        super(firestoreUtilData);

  // "seniors" field.
  int? _seniors;
  int get seniors => _seniors ?? 0;
  set seniors(int? val) => _seniors = val;

  void incrementSeniors(int amount) => seniors = seniors + amount;

  bool hasSeniors() => _seniors != null;

  // "adults" field.
  int? _adults;
  int get adults => _adults ?? 0;
  set adults(int? val) => _adults = val;

  void incrementAdults(int amount) => adults = adults + amount;

  bool hasAdults() => _adults != null;

  // "youth" field.
  int? _youth;
  int get youth => _youth ?? 0;
  set youth(int? val) => _youth = val;

  void incrementYouth(int amount) => youth = youth + amount;

  bool hasYouth() => _youth != null;

  // "children" field.
  int? _children;
  int get children => _children ?? 0;
  set children(int? val) => _children = val;

  void incrementChildren(int amount) => children = children + amount;

  bool hasChildren() => _children != null;

  static NumberOfPeopleStruct fromMap(Map<String, dynamic> data) =>
      NumberOfPeopleStruct(
        seniors: castToType<int>(data['seniors']),
        adults: castToType<int>(data['adults']),
        youth: castToType<int>(data['youth']),
        children: castToType<int>(data['children']),
      );

  static NumberOfPeopleStruct? maybeFromMap(dynamic data) => data is Map
      ? NumberOfPeopleStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'seniors': _seniors,
        'adults': _adults,
        'youth': _youth,
        'children': _children,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'seniors': serializeParam(
          _seniors,
          ParamType.int,
        ),
        'adults': serializeParam(
          _adults,
          ParamType.int,
        ),
        'youth': serializeParam(
          _youth,
          ParamType.int,
        ),
        'children': serializeParam(
          _children,
          ParamType.int,
        ),
      }.withoutNulls;

  static NumberOfPeopleStruct fromSerializableMap(Map<String, dynamic> data) =>
      NumberOfPeopleStruct(
        seniors: deserializeParam(
          data['seniors'],
          ParamType.int,
          false,
        ),
        adults: deserializeParam(
          data['adults'],
          ParamType.int,
          false,
        ),
        youth: deserializeParam(
          data['youth'],
          ParamType.int,
          false,
        ),
        children: deserializeParam(
          data['children'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'NumberOfPeopleStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NumberOfPeopleStruct &&
        seniors == other.seniors &&
        adults == other.adults &&
        youth == other.youth &&
        children == other.children;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([seniors, adults, youth, children]);
}

NumberOfPeopleStruct createNumberOfPeopleStruct({
  int? seniors,
  int? adults,
  int? youth,
  int? children,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    NumberOfPeopleStruct(
      seniors: seniors,
      adults: adults,
      youth: youth,
      children: children,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

NumberOfPeopleStruct? updateNumberOfPeopleStruct(
  NumberOfPeopleStruct? numberOfPeople, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    numberOfPeople
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addNumberOfPeopleStructData(
  Map<String, dynamic> firestoreData,
  NumberOfPeopleStruct? numberOfPeople,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (numberOfPeople == null) {
    return;
  }
  if (numberOfPeople.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && numberOfPeople.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final numberOfPeopleData =
      getNumberOfPeopleFirestoreData(numberOfPeople, forFieldValue);
  final nestedData =
      numberOfPeopleData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = numberOfPeople.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getNumberOfPeopleFirestoreData(
  NumberOfPeopleStruct? numberOfPeople, [
  bool forFieldValue = false,
]) {
  if (numberOfPeople == null) {
    return {};
  }
  final firestoreData = mapToFirestore(numberOfPeople.toMap());

  // Add any Firestore field values
  numberOfPeople.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getNumberOfPeopleListFirestoreData(
  List<NumberOfPeopleStruct>? numberOfPeoples,
) =>
    numberOfPeoples
        ?.map((e) => getNumberOfPeopleFirestoreData(e, true))
        .toList() ??
    [];
