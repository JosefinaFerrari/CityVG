import '/backend/backend.dart';
import '/components/action_sheet_component_widget.dart';
import '/components/place_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'main_page_widget.dart' show MainPageWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:styled_divider/styled_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MainPageModel extends FlutterFlowModel<MainPageWidget> {
  ///  Local state fields for this page.

  DocumentReference? docrefTmp;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
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
