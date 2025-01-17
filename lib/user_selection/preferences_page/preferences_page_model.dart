import '/backend/schema/structs/index.dart';
import '/components/navigate_back_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'preferences_page_widget.dart' show PreferencesPageWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
