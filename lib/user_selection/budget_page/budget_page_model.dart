import '/flutter_flow/flutter_flow_util.dart';
import 'budget_page_widget.dart' show BudgetPageWidget;
import 'package:flutter/material.dart';

class BudgetPageModel extends FlutterFlowModel<BudgetPageWidget> {
  ///  Local state fields for this page.

  List<bool> isClickedList = [false, false, false, false];
  void addToIsClickedList(bool item) => isClickedList.add(item);
  void removeFromIsClickedList(bool item) => isClickedList.remove(item);
  void removeAtIndexFromIsClickedList(int index) =>
      isClickedList.removeAt(index);
  void insertAtIndexInIsClickedList(int index, bool item) =>
      isClickedList.insert(index, item);
  void updateIsClickedListAtIndex(int index, Function(bool) updateFn) =>
      isClickedList[index] = updateFn(isClickedList[index]);

  int counter = 0;

  bool isSelected = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
