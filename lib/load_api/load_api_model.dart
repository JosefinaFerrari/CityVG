import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import 'load_api_widget.dart' show LoadApiWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoadApiModel extends FlutterFlowModel<LoadApiWidget> {
  ///  Local state fields for this page.

  int count = 0;

  bool isReady = false;

  String? categories;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (herokuItineraries)] action in LoadApi widget.
  ApiCallResponse? apiResult;
  // Stores action output result for [Backend Call - Create Document] action in LoadApi widget.
  ItinerariesApiRecord? output;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
