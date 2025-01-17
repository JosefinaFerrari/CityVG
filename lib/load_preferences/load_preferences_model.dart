import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'load_preferences_widget.dart' show LoadPreferencesWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoadPreferencesModel extends FlutterFlowModel<LoadPreferencesWidget> {
  ///  Local state fields for this page.

  bool isReady = false;

  String? categories;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (herokuPreferences)] action in LoadPreferences widget.
  ApiCallResponse? apiResults;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
