import '/components/to_right_comp_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'start_widget.dart' show StartWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StartModel extends FlutterFlowModel<StartWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for toRightComp component.
  late ToRightCompModel toRightCompModel1;
  // Model for toRightComp component.
  late ToRightCompModel toRightCompModel2;
  // Model for toRightComp component.
  late ToRightCompModel toRightCompModel3;
  // Model for toRightComp component.
  late ToRightCompModel toRightCompModel4;

  @override
  void initState(BuildContext context) {
    toRightCompModel1 = createModel(context, () => ToRightCompModel());
    toRightCompModel2 = createModel(context, () => ToRightCompModel());
    toRightCompModel3 = createModel(context, () => ToRightCompModel());
    toRightCompModel4 = createModel(context, () => ToRightCompModel());
  }

  @override
  void dispose() {
    toRightCompModel1.dispose();
    toRightCompModel2.dispose();
    toRightCompModel3.dispose();
    toRightCompModel4.dispose();
  }
}
