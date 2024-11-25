// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InputDataStruct extends FFFirebaseStruct {
  InputDataStruct({
    PlaceInfoStruct? placeSelected,
    double? radius,
    NumberOfPeopleStruct? peopleSelected,
    List<String>? preferencesSelected,
    String? budgetSelected,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _placeSelected = placeSelected,
        _radius = radius,
        _peopleSelected = peopleSelected,
        _preferencesSelected = preferencesSelected,
        _budgetSelected = budgetSelected,
        super(firestoreUtilData);

  // "placeSelected" field.
  PlaceInfoStruct? _placeSelected;
  PlaceInfoStruct get placeSelected => _placeSelected ?? PlaceInfoStruct();
  set placeSelected(PlaceInfoStruct? val) => _placeSelected = val;

  void updatePlaceSelected(Function(PlaceInfoStruct) updateFn) {
    updateFn(_placeSelected ??= PlaceInfoStruct());
  }

  bool hasPlaceSelected() => _placeSelected != null;

  // "radius" field.
  double? _radius;
  double get radius => _radius ?? 0.0;
  set radius(double? val) => _radius = val;

  void incrementRadius(double amount) => radius = radius + amount;

  bool hasRadius() => _radius != null;

  // "peopleSelected" field.
  NumberOfPeopleStruct? _peopleSelected;
  NumberOfPeopleStruct get peopleSelected =>
      _peopleSelected ?? NumberOfPeopleStruct();
  set peopleSelected(NumberOfPeopleStruct? val) => _peopleSelected = val;

  void updatePeopleSelected(Function(NumberOfPeopleStruct) updateFn) {
    updateFn(_peopleSelected ??= NumberOfPeopleStruct());
  }

  bool hasPeopleSelected() => _peopleSelected != null;

  // "preferencesSelected" field.
  List<String>? _preferencesSelected;
  List<String> get preferencesSelected => _preferencesSelected ?? const [];
  set preferencesSelected(List<String>? val) => _preferencesSelected = val;

  void updatePreferencesSelected(Function(List<String>) updateFn) {
    updateFn(_preferencesSelected ??= []);
  }

  bool hasPreferencesSelected() => _preferencesSelected != null;

  // "budgetSelected" field.
  String? _budgetSelected;
  String get budgetSelected => _budgetSelected ?? '';
  set budgetSelected(String? val) => _budgetSelected = val;

  bool hasBudgetSelected() => _budgetSelected != null;

  static InputDataStruct fromMap(Map<String, dynamic> data) => InputDataStruct(
        placeSelected: PlaceInfoStruct.maybeFromMap(data['placeSelected']),
        radius: castToType<double>(data['radius']),
        peopleSelected:
            NumberOfPeopleStruct.maybeFromMap(data['peopleSelected']),
        preferencesSelected: getDataList(data['preferencesSelected']),
        budgetSelected: data['budgetSelected'] as String?,
      );

  static InputDataStruct? maybeFromMap(dynamic data) => data is Map
      ? InputDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'placeSelected': _placeSelected?.toMap(),
        'radius': _radius,
        'peopleSelected': _peopleSelected?.toMap(),
        'preferencesSelected': _preferencesSelected,
        'budgetSelected': _budgetSelected,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'placeSelected': serializeParam(
          _placeSelected,
          ParamType.DataStruct,
        ),
        'radius': serializeParam(
          _radius,
          ParamType.double,
        ),
        'peopleSelected': serializeParam(
          _peopleSelected,
          ParamType.DataStruct,
        ),
        'preferencesSelected': serializeParam(
          _preferencesSelected,
          ParamType.String,
          isList: true,
        ),
        'budgetSelected': serializeParam(
          _budgetSelected,
          ParamType.String,
        ),
      }.withoutNulls;

  static InputDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      InputDataStruct(
        placeSelected: deserializeStructParam(
          data['placeSelected'],
          ParamType.DataStruct,
          false,
          structBuilder: PlaceInfoStruct.fromSerializableMap,
        ),
        radius: deserializeParam(
          data['radius'],
          ParamType.double,
          false,
        ),
        peopleSelected: deserializeStructParam(
          data['peopleSelected'],
          ParamType.DataStruct,
          false,
          structBuilder: NumberOfPeopleStruct.fromSerializableMap,
        ),
        preferencesSelected: deserializeParam<String>(
          data['preferencesSelected'],
          ParamType.String,
          true,
        ),
        budgetSelected: deserializeParam(
          data['budgetSelected'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'InputDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is InputDataStruct &&
        placeSelected == other.placeSelected &&
        radius == other.radius &&
        peopleSelected == other.peopleSelected &&
        listEquality.equals(preferencesSelected, other.preferencesSelected) &&
        budgetSelected == other.budgetSelected;
  }

  @override
  int get hashCode => const ListEquality().hash([
        placeSelected,
        radius,
        peopleSelected,
        preferencesSelected,
        budgetSelected
      ]);
}

InputDataStruct createInputDataStruct({
  PlaceInfoStruct? placeSelected,
  double? radius,
  NumberOfPeopleStruct? peopleSelected,
  String? budgetSelected,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    InputDataStruct(
      placeSelected:
          placeSelected ?? (clearUnsetFields ? PlaceInfoStruct() : null),
      radius: radius,
      peopleSelected:
          peopleSelected ?? (clearUnsetFields ? NumberOfPeopleStruct() : null),
      budgetSelected: budgetSelected,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

InputDataStruct? updateInputDataStruct(
  InputDataStruct? inputData, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    inputData
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addInputDataStructData(
  Map<String, dynamic> firestoreData,
  InputDataStruct? inputData,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (inputData == null) {
    return;
  }
  if (inputData.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && inputData.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final inputDataData = getInputDataFirestoreData(inputData, forFieldValue);
  final nestedData = inputDataData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = inputData.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getInputDataFirestoreData(
  InputDataStruct? inputData, [
  bool forFieldValue = false,
]) {
  if (inputData == null) {
    return {};
  }
  final firestoreData = mapToFirestore(inputData.toMap());

  // Handle nested data for "placeSelected" field.
  addPlaceInfoStructData(
    firestoreData,
    inputData.hasPlaceSelected() ? inputData.placeSelected : null,
    'placeSelected',
    forFieldValue,
  );

  // Handle nested data for "peopleSelected" field.
  addNumberOfPeopleStructData(
    firestoreData,
    inputData.hasPeopleSelected() ? inputData.peopleSelected : null,
    'peopleSelected',
    forFieldValue,
  );

  // Add any Firestore field values
  inputData.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getInputDataListFirestoreData(
  List<InputDataStruct>? inputDatas,
) =>
    inputDatas?.map((e) => getInputDataFirestoreData(e, true)).toList() ?? [];
