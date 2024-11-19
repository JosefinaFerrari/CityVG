import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
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
      if (prefs.containsKey('ff_dataSelected')) {
        try {
          final serializedData = prefs.getString('ff_dataSelected') ?? '{}';
          _dataSelected =
              InputDataStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
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
    prefs.setString('ff_dataSelected', value.serialize());
  }

  void updateDataSelectedStruct(Function(InputDataStruct) updateFn) {
    updateFn(_dataSelected);
    prefs.setString('ff_dataSelected', _dataSelected.serialize());
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
