import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'top3_widget.dart' show Top3Widget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Top3Model extends FlutterFlowModel<Top3Widget> {
  ///  Local state fields for this page.

  List<DocumentReference> selectedPlaces = [];
  void addToSelectedPlaces(DocumentReference item) => selectedPlaces.add(item);
  void removeFromSelectedPlaces(DocumentReference item) =>
      selectedPlaces.remove(item);
  void removeAtIndexFromSelectedPlaces(int index) =>
      selectedPlaces.removeAt(index);
  void insertAtIndexInSelectedPlaces(int index, DocumentReference item) =>
      selectedPlaces.insert(index, item);
  void updateSelectedPlacesAtIndex(
          int index, Function(DocumentReference) updateFn) =>
      selectedPlaces[index] = updateFn(selectedPlaces[index]);

  bool isSelected = false;

  int counter = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
