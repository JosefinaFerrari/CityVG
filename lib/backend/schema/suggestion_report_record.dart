import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SuggestionReportRecord extends FirestoreRecord {
  SuggestionReportRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "suggestion" field.
  String? _suggestion;
  String get suggestion => _suggestion ?? '';
  bool hasSuggestion() => _suggestion != null;

  // "tag" field.
  String? _tag;
  String get tag => _tag ?? '';
  bool hasTag() => _tag != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _suggestion = snapshotData['suggestion'] as String?;
    _tag = snapshotData['tag'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('suggestionReport');

  static Stream<SuggestionReportRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SuggestionReportRecord.fromSnapshot(s));

  static Future<SuggestionReportRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => SuggestionReportRecord.fromSnapshot(s));

  static SuggestionReportRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SuggestionReportRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SuggestionReportRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SuggestionReportRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SuggestionReportRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SuggestionReportRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSuggestionReportRecordData({
  String? title,
  String? suggestion,
  String? tag,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'suggestion': suggestion,
      'tag': tag,
    }.withoutNulls,
  );

  return firestoreData;
}

class SuggestionReportRecordDocumentEquality
    implements Equality<SuggestionReportRecord> {
  const SuggestionReportRecordDocumentEquality();

  @override
  bool equals(SuggestionReportRecord? e1, SuggestionReportRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.suggestion == e2?.suggestion &&
        e1?.tag == e2?.tag;
  }

  @override
  int hash(SuggestionReportRecord? e) =>
      const ListEquality().hash([e?.title, e?.suggestion, e?.tag]);

  @override
  bool isValidKey(Object? o) => o is SuggestionReportRecord;
}
