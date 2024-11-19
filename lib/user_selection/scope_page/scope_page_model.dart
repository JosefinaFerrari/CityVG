import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'scope_page_widget.dart' show ScopePageWidget;
import 'package:flutter/material.dart';

class ScopePageModel extends FlutterFlowModel<ScopePageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // State field(s) for Slider widget.
  double? sliderValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
