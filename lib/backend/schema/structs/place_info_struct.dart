// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PlaceInfoStruct extends FFFirebaseStruct {
  PlaceInfoStruct({
    LatLng? gps,
    String? city,
    String? country,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _gps = gps,
        _city = city,
        _country = country,
        super(firestoreUtilData);

  // "gps" field.
  LatLng? _gps;
  LatLng? get gps => _gps;
  set gps(LatLng? val) => _gps = val;

  bool hasGps() => _gps != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  set country(String? val) => _country = val;

  bool hasCountry() => _country != null;

  static PlaceInfoStruct fromMap(Map<String, dynamic> data) => PlaceInfoStruct(
        gps: data['gps'] as LatLng?,
        city: data['city'] as String?,
        country: data['country'] as String?,
      );

  static PlaceInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? PlaceInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'gps': _gps,
        'city': _city,
        'country': _country,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'gps': serializeParam(
          _gps,
          ParamType.LatLng,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'country': serializeParam(
          _country,
          ParamType.String,
        ),
      }.withoutNulls;

  static PlaceInfoStruct fromSerializableMap(Map<String, dynamic> data) =>
      PlaceInfoStruct(
        gps: deserializeParam(
          data['gps'],
          ParamType.LatLng,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        country: deserializeParam(
          data['country'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PlaceInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PlaceInfoStruct &&
        gps == other.gps &&
        city == other.city &&
        country == other.country;
  }

  @override
  int get hashCode => const ListEquality().hash([gps, city, country]);
}

PlaceInfoStruct createPlaceInfoStruct({
  LatLng? gps,
  String? city,
  String? country,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PlaceInfoStruct(
      gps: gps,
      city: city,
      country: country,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PlaceInfoStruct? updatePlaceInfoStruct(
  PlaceInfoStruct? placeInfo, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    placeInfo
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPlaceInfoStructData(
  Map<String, dynamic> firestoreData,
  PlaceInfoStruct? placeInfo,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (placeInfo == null) {
    return;
  }
  if (placeInfo.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && placeInfo.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final placeInfoData = getPlaceInfoFirestoreData(placeInfo, forFieldValue);
  final nestedData = placeInfoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = placeInfo.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPlaceInfoFirestoreData(
  PlaceInfoStruct? placeInfo, [
  bool forFieldValue = false,
]) {
  if (placeInfo == null) {
    return {};
  }
  final firestoreData = mapToFirestore(placeInfo.toMap());

  // Add any Firestore field values
  placeInfo.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPlaceInfoListFirestoreData(
  List<PlaceInfoStruct>? placeInfos,
) =>
    placeInfos?.map((e) => getPlaceInfoFirestoreData(e, true)).toList() ?? [];
