import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TestRecord extends FirestoreRecord {
  TestRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "polyline" field.
  String? _polyline;
  String get polyline => _polyline ?? '';
  bool hasPolyline() => _polyline != null;

  // "center" field.
  LatLng? _center;
  LatLng? get center => _center;
  bool hasCenter() => _center != null;

  void _initializeFields() {
    _polyline = snapshotData['polyline'] as String?;
    _center = snapshotData['center'] as LatLng?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('test');

  static Stream<TestRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TestRecord.fromSnapshot(s));

  static Future<TestRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TestRecord.fromSnapshot(s));

  static TestRecord fromSnapshot(DocumentSnapshot snapshot) => TestRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TestRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TestRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TestRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TestRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTestRecordData({
  String? polyline,
  LatLng? center,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'polyline': polyline,
      'center': center,
    }.withoutNulls,
  );

  return firestoreData;
}

class TestRecordDocumentEquality implements Equality<TestRecord> {
  const TestRecordDocumentEquality();

  @override
  bool equals(TestRecord? e1, TestRecord? e2) {
    return e1?.polyline == e2?.polyline && e1?.center == e2?.center;
  }

  @override
  int hash(TestRecord? e) =>
      const ListEquality().hash([e?.polyline, e?.center]);

  @override
  bool isValidKey(Object? o) => o is TestRecord;
}
