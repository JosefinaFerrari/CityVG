import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'trip_detail_widget.dart' show TripDetailWidget;
import 'package:flutter/material.dart';

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
