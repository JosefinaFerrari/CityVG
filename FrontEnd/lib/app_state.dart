import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _searchId = prefs.getString('ff_searchId') ?? _searchId;
    });
    _safeInit(() {
      _savedItineraries = prefs
              .getStringList('ff_savedItineraries')
              ?.map((path) => path.ref)
              .toList() ??
          _savedItineraries;
    });
    _safeInit(() {
      _currentItinerary =
          prefs.getString('ff_currentItinerary')?.ref ?? _currentItinerary;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  InputDataStruct _dataSelected = InputDataStruct.fromSerializableMap(jsonDecode(
      '{\"peopleSelected\":\"{\\\"seniors\\\":\\\"0\\\",\\\"adults\\\":\\\"0\\\",\\\"youth\\\":\\\"0\\\",\\\"children\\\":\\\"0\\\"}\",\"preferencesSelected\":\"[]\"}'));
  InputDataStruct get dataSelected => _dataSelected;
  set dataSelected(InputDataStruct value) {
    _dataSelected = value;
  }

  void updateDataSelectedStruct(Function(InputDataStruct) updateFn) {
    updateFn(_dataSelected);
  }

  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  set startDate(DateTime? value) {
    _startDate = value;
  }

  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  set endDate(DateTime? value) {
    _endDate = value;
  }

  String _searchId = '0';
  String get searchId => _searchId;
  set searchId(String value) {
    _searchId = value;
    prefs.setString('ff_searchId', value);
  }

  List<DocumentReference> _savedItineraries = [];
  List<DocumentReference> get savedItineraries => _savedItineraries;
  set savedItineraries(List<DocumentReference> value) {
    _savedItineraries = value;
    prefs.setStringList(
        'ff_savedItineraries', value.map((x) => x.path).toList());
  }

  void addToSavedItineraries(DocumentReference value) {
    savedItineraries.add(value);
    prefs.setStringList(
        'ff_savedItineraries', _savedItineraries.map((x) => x.path).toList());
  }

  void removeFromSavedItineraries(DocumentReference value) {
    savedItineraries.remove(value);
    prefs.setStringList(
        'ff_savedItineraries', _savedItineraries.map((x) => x.path).toList());
  }

  void removeAtIndexFromSavedItineraries(int index) {
    savedItineraries.removeAt(index);
    prefs.setStringList(
        'ff_savedItineraries', _savedItineraries.map((x) => x.path).toList());
  }

  void updateSavedItinerariesAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    savedItineraries[index] = updateFn(_savedItineraries[index]);
    prefs.setStringList(
        'ff_savedItineraries', _savedItineraries.map((x) => x.path).toList());
  }

  void insertAtIndexInSavedItineraries(int index, DocumentReference value) {
    savedItineraries.insert(index, value);
    prefs.setStringList(
        'ff_savedItineraries', _savedItineraries.map((x) => x.path).toList());
  }

  DocumentReference? _currentItinerary;
  DocumentReference? get currentItinerary => _currentItinerary;
  set currentItinerary(DocumentReference? value) {
    _currentItinerary = value;
    value != null
        ? prefs.setString('ff_currentItinerary', value.path)
        : prefs.remove('ff_currentItinerary');
  }

  List<AttractionStruct> _listOfAttractions = [];
  List<AttractionStruct> get listOfAttractions => _listOfAttractions;
  set listOfAttractions(List<AttractionStruct> value) {
    _listOfAttractions = value;
  }

  void addToListOfAttractions(AttractionStruct value) {
    listOfAttractions.add(value);
  }

  void removeFromListOfAttractions(AttractionStruct value) {
    listOfAttractions.remove(value);
  }

  void removeAtIndexFromListOfAttractions(int index) {
    listOfAttractions.removeAt(index);
  }

  void updateListOfAttractionsAtIndex(
    int index,
    AttractionStruct Function(AttractionStruct) updateFn,
  ) {
    listOfAttractions[index] = updateFn(_listOfAttractions[index]);
  }

  void insertAtIndexInListOfAttractions(int index, AttractionStruct value) {
    listOfAttractions.insert(index, value);
  }

  List<String> _removedAttractions = [];
  List<String> get removedAttractions => _removedAttractions;
  set removedAttractions(List<String> value) {
    _removedAttractions = value;
  }

  void addToRemovedAttractions(String value) {
    removedAttractions.add(value);
  }

  void removeFromRemovedAttractions(String value) {
    removedAttractions.remove(value);
  }

  void removeAtIndexFromRemovedAttractions(int index) {
    removedAttractions.removeAt(index);
  }

  void updateRemovedAttractionsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    removedAttractions[index] = updateFn(_removedAttractions[index]);
  }

  void insertAtIndexInRemovedAttractions(int index, String value) {
    removedAttractions.insert(index, value);
  }

  List<String> _requiredAttractions = [];
  List<String> get requiredAttractions => _requiredAttractions;
  set requiredAttractions(List<String> value) {
    _requiredAttractions = value;
  }

  void addToRequiredAttractions(String value) {
    requiredAttractions.add(value);
  }

  void removeFromRequiredAttractions(String value) {
    requiredAttractions.remove(value);
  }

  void removeAtIndexFromRequiredAttractions(int index) {
    requiredAttractions.removeAt(index);
  }

  void updateRequiredAttractionsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    requiredAttractions[index] = updateFn(_requiredAttractions[index]);
  }

  void insertAtIndexInRequiredAttractions(int index, String value) {
    requiredAttractions.insert(index, value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
