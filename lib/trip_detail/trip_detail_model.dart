import '/components/place_card_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'trip_detail_widget.dart' show TripDetailWidget;
import 'package:flutter/material.dart';

class TripDetailModel extends FlutterFlowModel<TripDetailWidget> {
  ///  Local state fields for this page.

  String day = '1';

  ///  State fields for stateful widgets in this page.

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // Model for placeCard component.
  late PlaceCardModel placeCardModel1;
  // Model for placeCard component.
  late PlaceCardModel placeCardModel2;

  @override
  void initState(BuildContext context) {
    placeCardModel1 = createModel(context, () => PlaceCardModel());
    placeCardModel2 = createModel(context, () => PlaceCardModel());
  }

  @override
  void dispose() {
    placeCardModel1.dispose();
    placeCardModel2.dispose();
  }
}
