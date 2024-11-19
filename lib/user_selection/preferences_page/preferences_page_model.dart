import '/flutter_flow/flutter_flow_util.dart';
import 'preferences_page_widget.dart' show PreferencesPageWidget;
import 'package:flutter/material.dart';

class PreferencesPageModel extends FlutterFlowModel<PreferencesPageWidget> {
  ///  Local state fields for this page.

  int? counter = 0;

  List<bool> isSelectedList = [];
  void addToIsSelectedList(bool item) => isSelectedList.add(item);
  void removeFromIsSelectedList(bool item) => isSelectedList.remove(item);
  void removeAtIndexFromIsSelectedList(int index) =>
      isSelectedList.removeAt(index);
  void insertAtIndexInIsSelectedList(int index, bool item) =>
      isSelectedList.insert(index, item);
  void updateIsSelectedListAtIndex(int index, Function(bool) updateFn) =>
      isSelectedList[index] = updateFn(isSelectedList[index]);

  int? countJ = 0;

  int? countI = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
