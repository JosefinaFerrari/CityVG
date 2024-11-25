import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'load_api_widget.dart' show LoadApiWidget;
import 'package:flutter/material.dart';

class LoadApiModel extends FlutterFlowModel<LoadApiWidget> {
  ///  Local state fields for this page.

  int count = 0;

  bool isReady = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (localhost)] action in LoadApi widget.
  ApiCallResponse? apiResult;
  // Stores action output result for [Backend Call - Create Document] action in LoadApi widget.
  ItinerariesApiRecord? output;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
