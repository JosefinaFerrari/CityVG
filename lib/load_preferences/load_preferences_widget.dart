import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'load_preferences_model.dart';
export 'load_preferences_model.dart';

class LoadPreferencesWidget extends StatefulWidget {
  const LoadPreferencesWidget({super.key});

  @override
  State<LoadPreferencesWidget> createState() => _LoadPreferencesWidgetState();
}

class _LoadPreferencesWidgetState extends State<LoadPreferencesWidget> {
  late LoadPreferencesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadPreferencesModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.categories = functions.getCategoriesText(
          FFAppState().dataSelected.preferencesSelected.toList());
      safeSetState(() {});
      _model.apiResults = await HerokuPreferencesCall.call(
        lat: functions.getLatorLng(
            FFAppState().dataSelected.placeSelected.gps!, 'lat'),
        lng: functions.getLatorLng(
            FFAppState().dataSelected.placeSelected.gps!, 'lng'),
        radius: FFAppState().dataSelected.radius,
        startDate: dateTimeFormat("y-M-d", FFAppState().startDate),
        endDate: dateTimeFormat("y-M-d", FFAppState().endDate),
        numSeniors: FFAppState().dataSelected.peopleSelected.seniors,
        numAdults: FFAppState().dataSelected.peopleSelected.adults,
        numYouth: FFAppState().dataSelected.peopleSelected.youth,
        numChildren: FFAppState().dataSelected.peopleSelected.children,
        budget: FFAppState().dataSelected.budgetSelected,
        categories: _model.categories,
      );

      FFAppState().listOfAttractions = functions
          .attractionTop10fromJson((_model.apiResults?.jsonBody ?? ''))
          .toList()
          .cast<AttractionStruct>();
      safeSetState(() {});

      context.pushNamed(
        'top10',
        extra: <String, dynamic>{
          kTransitionInfoKey: TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
            duration: Duration(milliseconds: 0),
          ),
        },
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'We are creating your trip',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Poppins',
                        fontSize: () {
                          if (MediaQuery.sizeOf(context).width <
                              kBreakpointSmall) {
                            return 24.0;
                          } else if (MediaQuery.sizeOf(context).width <
                              kBreakpointMedium) {
                            return 28.0;
                          } else {
                            return 32.0;
                          }
                        }(),
                        letterSpacing: 0.0,
                      ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 100.0),
                    child: Lottie.asset(
                      'assets/jsons/Animation_-_1732571831219.json',
                      width: 300.0,
                      height: 300.0,
                      fit: BoxFit.contain,
                      animate: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
