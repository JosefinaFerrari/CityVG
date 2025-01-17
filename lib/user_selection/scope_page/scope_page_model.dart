import '/backend/schema/structs/index.dart';
import '/components/navigate_back_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'scope_page_widget.dart' show ScopePageWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ScopePageModel extends FlutterFlowModel<ScopePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for navigateBack component.
  late NavigateBackModel navigateBackModel;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // State field(s) for Slider widget.
  double? sliderValue;

  @override
  void initState(BuildContext context) {
    navigateBackModel = createModel(context, () => NavigateBackModel());
  }

  @override
  void dispose() {
    navigateBackModel.dispose();
  }
}
