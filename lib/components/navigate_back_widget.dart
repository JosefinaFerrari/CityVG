import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'navigate_back_model.dart';
export 'navigate_back_model.dart';

class NavigateBackWidget extends StatefulWidget {
  const NavigateBackWidget({super.key});

  @override
  State<NavigateBackWidget> createState() => _NavigateBackWidgetState();
}

class _NavigateBackWidgetState extends State<NavigateBackWidget> {
  late NavigateBackModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavigateBackModel());

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
      alignment: AlignmentDirectional(-1.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            context.safePop();
          },
          child: Container(
            width: () {
              if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                return 72.0;
              } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                return 90.0;
              } else {
                return 100.0;
              }
            }(),
            height: () {
              if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                return 40.0;
              } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                return 55.0;
              } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                return 60.0;
              } else {
                return 65.0;
              }
            }(),
            decoration: BoxDecoration(
              color: Color(0xC0DDE5D9),
              borderRadius: BorderRadius.circular(valueOrDefault<double>(
                () {
                  if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                    return 24.0;
                  } else if (MediaQuery.sizeOf(context).width <
                      kBreakpointMedium) {
                    return 28.0;
                  } else if (MediaQuery.sizeOf(context).width <
                      kBreakpointLarge) {
                    return 32.0;
                  } else {
                    return 32.0;
                  }
                }(),
                0.0,
              )),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/Group_131_(1).png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
