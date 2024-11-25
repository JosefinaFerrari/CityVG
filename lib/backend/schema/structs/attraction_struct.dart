// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AttractionStruct extends FFFirebaseStruct {
  AttractionStruct({
    String? name,
    String? productName,
    LatLng? location,
    String? city,
    String? country,
    String? description,
    String? productTitle,
    String? productSummary,
    String? productCheckoutUrl,
    double? productRating,
    List<String>? images,
    DateTime? day,
    String? startingHour,
    String? endingHour,
    double? productPrice,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _productName = productName,
        _location = location,
        _city = city,
        _country = country,
        _description = description,
        _productTitle = productTitle,
        _productSummary = productSummary,
        _productCheckoutUrl = productCheckoutUrl,
        _productRating = productRating,
        _images = images,
        _day = day,
        _startingHour = startingHour,
        _endingHour = endingHour,
        _productPrice = productPrice,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "productName" field.
  String? _productName;
  String get productName => _productName ?? '';
  set productName(String? val) => _productName = val;

  bool hasProductName() => _productName != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  set location(LatLng? val) => _location = val;

  bool hasLocation() => _location != null;

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

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "productTitle" field.
  String? _productTitle;
  String get productTitle => _productTitle ?? '';
  set productTitle(String? val) => _productTitle = val;

  bool hasProductTitle() => _productTitle != null;

  // "productSummary" field.
  String? _productSummary;
  String get productSummary => _productSummary ?? '';
  set productSummary(String? val) => _productSummary = val;

  bool hasProductSummary() => _productSummary != null;

  // "productCheckoutUrl" field.
  String? _productCheckoutUrl;
  String get productCheckoutUrl => _productCheckoutUrl ?? '';
  set productCheckoutUrl(String? val) => _productCheckoutUrl = val;

  bool hasProductCheckoutUrl() => _productCheckoutUrl != null;

  // "productRating" field.
  double? _productRating;
  double get productRating => _productRating ?? 0.0;
  set productRating(double? val) => _productRating = val;

  void incrementProductRating(double amount) =>
      productRating = productRating + amount;

  bool hasProductRating() => _productRating != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  set images(List<String>? val) => _images = val;

  void updateImages(Function(List<String>) updateFn) {
    updateFn(_images ??= []);
  }

  bool hasImages() => _images != null;

  // "day" field.
  DateTime? _day;
  DateTime? get day => _day;
  set day(DateTime? val) => _day = val;

  bool hasDay() => _day != null;

  // "startingHour" field.
  String? _startingHour;
  String get startingHour => _startingHour ?? '';
  set startingHour(String? val) => _startingHour = val;

  bool hasStartingHour() => _startingHour != null;

  // "endingHour" field.
  String? _endingHour;
  String get endingHour => _endingHour ?? '';
  set endingHour(String? val) => _endingHour = val;

  bool hasEndingHour() => _endingHour != null;

  // "productPrice" field.
  double? _productPrice;
  double get productPrice => _productPrice ?? 0.0;
  set productPrice(double? val) => _productPrice = val;

  void incrementProductPrice(double amount) =>
      productPrice = productPrice + amount;

  bool hasProductPrice() => _productPrice != null;

  static AttractionStruct fromMap(Map<String, dynamic> data) =>
      AttractionStruct(
        name: data['name'] as String?,
        productName: data['productName'] as String?,
        location: data['location'] as LatLng?,
        city: data['city'] as String?,
        country: data['country'] as String?,
        description: data['description'] as String?,
        productTitle: data['productTitle'] as String?,
        productSummary: data['productSummary'] as String?,
        productCheckoutUrl: data['productCheckoutUrl'] as String?,
        productRating: castToType<double>(data['productRating']),
        images: getDataList(data['images']),
        day: data['day'] as DateTime?,
        startingHour: data['startingHour'] as String?,
        endingHour: data['endingHour'] as String?,
        productPrice: castToType<double>(data['productPrice']),
      );

  static AttractionStruct? maybeFromMap(dynamic data) => data is Map
      ? AttractionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'productName': _productName,
        'location': _location,
        'city': _city,
        'country': _country,
        'description': _description,
        'productTitle': _productTitle,
        'productSummary': _productSummary,
        'productCheckoutUrl': _productCheckoutUrl,
        'productRating': _productRating,
        'images': _images,
        'day': _day,
        'startingHour': _startingHour,
        'endingHour': _endingHour,
        'productPrice': _productPrice,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'productName': serializeParam(
          _productName,
          ParamType.String,
        ),
        'location': serializeParam(
          _location,
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
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'productTitle': serializeParam(
          _productTitle,
          ParamType.String,
        ),
        'productSummary': serializeParam(
          _productSummary,
          ParamType.String,
        ),
        'productCheckoutUrl': serializeParam(
          _productCheckoutUrl,
          ParamType.String,
        ),
        'productRating': serializeParam(
          _productRating,
          ParamType.double,
        ),
        'images': serializeParam(
          _images,
          ParamType.String,
          isList: true,
        ),
        'day': serializeParam(
          _day,
          ParamType.DateTime,
        ),
        'startingHour': serializeParam(
          _startingHour,
          ParamType.String,
        ),
        'endingHour': serializeParam(
          _endingHour,
          ParamType.String,
        ),
        'productPrice': serializeParam(
          _productPrice,
          ParamType.double,
        ),
      }.withoutNulls;

  static AttractionStruct fromSerializableMap(Map<String, dynamic> data) =>
      AttractionStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        productName: deserializeParam(
          data['productName'],
          ParamType.String,
          false,
        ),
        location: deserializeParam(
          data['location'],
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
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        productTitle: deserializeParam(
          data['productTitle'],
          ParamType.String,
          false,
        ),
        productSummary: deserializeParam(
          data['productSummary'],
          ParamType.String,
          false,
        ),
        productCheckoutUrl: deserializeParam(
          data['productCheckoutUrl'],
          ParamType.String,
          false,
        ),
        productRating: deserializeParam(
          data['productRating'],
          ParamType.double,
          false,
        ),
        images: deserializeParam<String>(
          data['images'],
          ParamType.String,
          true,
        ),
        day: deserializeParam(
          data['day'],
          ParamType.DateTime,
          false,
        ),
        startingHour: deserializeParam(
          data['startingHour'],
          ParamType.String,
          false,
        ),
        endingHour: deserializeParam(
          data['endingHour'],
          ParamType.String,
          false,
        ),
        productPrice: deserializeParam(
          data['productPrice'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'AttractionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is AttractionStruct &&
        name == other.name &&
        productName == other.productName &&
        location == other.location &&
        city == other.city &&
        country == other.country &&
        description == other.description &&
        productTitle == other.productTitle &&
        productSummary == other.productSummary &&
        productCheckoutUrl == other.productCheckoutUrl &&
        productRating == other.productRating &&
        listEquality.equals(images, other.images) &&
        day == other.day &&
        startingHour == other.startingHour &&
        endingHour == other.endingHour &&
        productPrice == other.productPrice;
  }

  @override
  int get hashCode => const ListEquality().hash([
        name,
        productName,
        location,
        city,
        country,
        description,
        productTitle,
        productSummary,
        productCheckoutUrl,
        productRating,
        images,
        day,
        startingHour,
        endingHour,
        productPrice
      ]);
}

AttractionStruct createAttractionStruct({
  String? name,
  String? productName,
  LatLng? location,
  String? city,
  String? country,
  String? description,
  String? productTitle,
  String? productSummary,
  String? productCheckoutUrl,
  double? productRating,
  DateTime? day,
  String? startingHour,
  String? endingHour,
  double? productPrice,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AttractionStruct(
      name: name,
      productName: productName,
      location: location,
      city: city,
      country: country,
      description: description,
      productTitle: productTitle,
      productSummary: productSummary,
      productCheckoutUrl: productCheckoutUrl,
      productRating: productRating,
      day: day,
      startingHour: startingHour,
      endingHour: endingHour,
      productPrice: productPrice,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AttractionStruct? updateAttractionStruct(
  AttractionStruct? attraction, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    attraction
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAttractionStructData(
  Map<String, dynamic> firestoreData,
  AttractionStruct? attraction,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (attraction == null) {
    return;
  }
  if (attraction.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && attraction.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final attractionData = getAttractionFirestoreData(attraction, forFieldValue);
  final nestedData = attractionData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = attraction.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAttractionFirestoreData(
  AttractionStruct? attraction, [
  bool forFieldValue = false,
]) {
  if (attraction == null) {
    return {};
  }
  final firestoreData = mapToFirestore(attraction.toMap());

  // Add any Firestore field values
  attraction.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAttractionListFirestoreData(
  List<AttractionStruct>? attractions,
) =>
    attractions?.map((e) => getAttractionFirestoreData(e, true)).toList() ?? [];
