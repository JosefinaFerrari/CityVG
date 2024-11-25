import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ItinerariesApiRecord extends FirestoreRecord {
  ItinerariesApiRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "itineraryName" field.
  String? _itineraryName;
  String get itineraryName => _itineraryName ?? '';
  bool hasItineraryName() => _itineraryName != null;

  // "attractions" field.
  List<AttractionStruct>? _attractions;
  List<AttractionStruct> get attractions => _attractions ?? const [];
  bool hasAttractions() => _attractions != null;

  // "searchId" field.
  String? _searchId;
  String get searchId => _searchId ?? '';
  bool hasSearchId() => _searchId != null;

  // "coverImage" field.
  String? _coverImage;
  String get coverImage => _coverImage ?? '';
  bool hasCoverImage() => _coverImage != null;

  // "days" field.
  List<DateTime>? _days;
  List<DateTime> get days => _days ?? const [];
  bool hasDays() => _days != null;

  void _initializeFields() {
    _itineraryName = snapshotData['itineraryName'] as String?;
    _attractions = getStructList(
      snapshotData['attractions'],
      AttractionStruct.fromMap,
    );
    _searchId = snapshotData['searchId'] as String?;
    _coverImage = snapshotData['coverImage'] as String?;
    _days = getDataList(snapshotData['days']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('itineraries_api');

  static Stream<ItinerariesApiRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ItinerariesApiRecord.fromSnapshot(s));

  static Future<ItinerariesApiRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ItinerariesApiRecord.fromSnapshot(s));

  static ItinerariesApiRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ItinerariesApiRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ItinerariesApiRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ItinerariesApiRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ItinerariesApiRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ItinerariesApiRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createItinerariesApiRecordData({
  String? itineraryName,
  String? searchId,
  String? coverImage,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'itineraryName': itineraryName,
      'searchId': searchId,
      'coverImage': coverImage,
    }.withoutNulls,
  );

  return firestoreData;
}

class ItinerariesApiRecordDocumentEquality
    implements Equality<ItinerariesApiRecord> {
  const ItinerariesApiRecordDocumentEquality();

  @override
  bool equals(ItinerariesApiRecord? e1, ItinerariesApiRecord? e2) {
    const listEquality = ListEquality();
    return e1?.itineraryName == e2?.itineraryName &&
        listEquality.equals(e1?.attractions, e2?.attractions) &&
        e1?.searchId == e2?.searchId &&
        e1?.coverImage == e2?.coverImage &&
        listEquality.equals(e1?.days, e2?.days);
  }

  @override
  int hash(ItinerariesApiRecord? e) => const ListEquality().hash(
      [e?.itineraryName, e?.attractions, e?.searchId, e?.coverImage, e?.days]);

  @override
  bool isValidKey(Object? o) => o is ItinerariesApiRecord;
}
