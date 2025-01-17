import '/components/navigate_back_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'daypicker_page_widget.dart' show DaypickerPageWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DaypickerPageModel extends FlutterFlowModel<DaypickerPageWidget> {
  ///  Local state fields for this page.

  bool isSelected = false;

  int startHour = 8;

  int endHour = 20;

  ///  State fields for stateful widgets in this page.

  // Model for navigateBack component.
  late NavigateBackModel navigateBackModel;

  @override
  void initState(BuildContext context) {
    navigateBackModel = createModel(context, () => NavigateBackModel());
  }

  @override
  void dispose() {
    navigateBackModel.dispose();
  }
}
