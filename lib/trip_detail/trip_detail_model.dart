import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/place_card_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:math' as math;
import 'trip_detail_widget.dart' show TripDetailWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TripDetailModel extends FlutterFlowModel<TripDetailWidget> {
  ///  Local state fields for this page.

  DateTime? day;

  List<LatLng> places = [];
  void addToPlaces(LatLng item) => places.add(item);
  void removeFromPlaces(LatLng item) => places.remove(item);
  void removeAtIndexFromPlaces(int index) => places.removeAt(index);
  void insertAtIndexInPlaces(int index, LatLng item) =>
      places.insert(index, item);
  void updatePlacesAtIndex(int index, Function(LatLng) updateFn) =>
      places[index] = updateFn(places[index]);

  int count = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Read Document] action in tripDetail widget.
  ItinerariesApiRecord? trip;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
