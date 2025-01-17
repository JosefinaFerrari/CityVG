import '/backend/schema/structs/index.dart';
import '/components/navigate_back_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'budget_page_widget.dart' show BudgetPageWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

  ///  State fields for stateful widgets in this page.

  // Model for navigateBack component.
  late NavigateBackModel navigateBackModel;

  @override
  void initState(BuildContext context) {
    navigateBackModel = createModel(context, () => NavigateBackModel());
  }

  @override
  void dispose() {
    navigateBackModel.dispose();
  }
}
