import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'to_right_comp_model.dart';
export 'to_right_comp_model.dart';

class ToRightCompWidget extends StatefulWidget {
  const ToRightCompWidget({super.key});

  @override
  State<ToRightCompWidget> createState() => _ToRightCompWidgetState();
}

class _ToRightCompWidgetState extends State<ToRightCompWidget> {
  late ToRightCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ToRightCompModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: () {
          if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
            return 72.0;
          } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
            return 80.0;
          } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
            return 88.0;
          } else {
            return 100.0;
          }
        }(),
        height: () {
          if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
            return 40.0;
          } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
            return 44.0;
          } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
            return 48.0;
          } else {
            return 52.0;
          }
        }(),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: BorderRadius.circular(valueOrDefault<double>(
            () {
              if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                return 20.0;
              } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                return 26.0;
              } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                return 30.0;
              } else {
                return 35.0;
              }
            }(),
            0.0,
          )),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/Group_131.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
