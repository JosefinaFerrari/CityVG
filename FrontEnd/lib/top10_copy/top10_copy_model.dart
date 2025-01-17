import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'top10_copy_widget.dart' show Top10CopyWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Top10CopyModel extends FlutterFlowModel<Top10CopyWidget> {
  ///  Local state fields for this page.

  List<String> selectedAttractions = [];
  void addToSelectedAttractions(String item) => selectedAttractions.add(item);
  void removeFromSelectedAttractions(String item) =>
      selectedAttractions.remove(item);
  void removeAtIndexFromSelectedAttractions(int index) =>
      selectedAttractions.removeAt(index);
  void insertAtIndexInSelectedAttractions(int index, String item) =>
      selectedAttractions.insert(index, item);
  void updateSelectedAttractionsAtIndex(int index, Function(String) updateFn) =>
      selectedAttractions[index] = updateFn(selectedAttractions[index]);

  bool isSelected = false;

  int counter = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
