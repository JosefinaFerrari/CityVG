import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'load_api_model.dart';
export 'load_api_model.dart';

class LoadApiWidget extends StatefulWidget {
  const LoadApiWidget({super.key});

  @override
  State<LoadApiWidget> createState() => _LoadApiWidgetState();
}

class _LoadApiWidgetState extends State<LoadApiWidget> {
  late LoadApiModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadApiModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().searchId = random_data.randomString(
        5,
        5,
        true,
        true,
        true,
      );
      FFAppState().update(() {});
      _model.categories = functions.getCategoriesText(
          FFAppState().dataSelected.preferencesSelected.toList());
      safeSetState(() {});
      _model.apiResult = await HerokuItinerariesCall.call(
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
        requiredPlaces: functions
            .getReqAndRemStrings(FFAppState().requiredAttractions.toList()),
        removedPlaces: functions
            .getReqAndRemStrings(FFAppState().removedAttractions.toList()),
        categories: _model.categories,
      );

      _model.count = 0;
      safeSetState(() {});
      while (_model.count <
          HerokuItinerariesCall.itineraries(
            (_model.apiResult?.jsonBody ?? ''),
          )!
              .length) {
        var itinerariesApiRecordReference =
            ItinerariesApiRecord.collection.doc();
        await itinerariesApiRecordReference.set({
          ...createItinerariesApiRecordData(
            itineraryName: getJsonField(
              HerokuItinerariesCall.itineraries(
                (_model.apiResult?.jsonBody ?? ''),
              )?.elementAtOrNull(_model.count),
              r'''$.itineraryName''',
            ).toString().toString(),
            searchId: FFAppState().searchId,
            coverImage: functions.getImageFromAttractions(getJsonField(
                      HerokuItinerariesCall.itineraries(
                        (_model.apiResult?.jsonBody ?? ''),
                      )!
                          .elementAtOrNull(_model.count),
                      r'''$.attractions''',
                      true,
                    )!) !=
                    'None'
                ? functions.getImageFromAttractions(getJsonField(
                    HerokuItinerariesCall.itineraries(
                      (_model.apiResult?.jsonBody ?? ''),
                    )!
                        .elementAtOrNull(_model.count),
                    r'''$.attractions''',
                    true,
                  )!)
                : 'https://images.travelandleisureasia.com/wp-content/uploads/sites/2/2023/11/20122038/ljublianica.jpeg',
            tripCode: random_data.randomString(
              6,
              6,
              true,
              true,
              true,
            ),
          ),
          ...mapToFirestore(
            {
              'attractions': getAttractionListFirestoreData(
                functions.attractionsFromJson(getJsonField(
                  HerokuItinerariesCall.itineraries(
                    (_model.apiResult?.jsonBody ?? ''),
                  )!
                      .elementAtOrNull(_model.count),
                  r'''$.attractions''',
                  true,
                )!),
              ),
              'days': functions.getDatesFromAttractions(getJsonField(
                HerokuItinerariesCall.itineraries(
                  (_model.apiResult?.jsonBody ?? ''),
                )!
                    .elementAtOrNull(_model.count),
                r'''$.attractions''',
                true,
              )!),
            },
          ),
        });
        _model.output = ItinerariesApiRecord.getDocumentFromData({
          ...createItinerariesApiRecordData(
            itineraryName: getJsonField(
              HerokuItinerariesCall.itineraries(
                (_model.apiResult?.jsonBody ?? ''),
              )?.elementAtOrNull(_model.count),
              r'''$.itineraryName''',
            ).toString().toString(),
            searchId: FFAppState().searchId,
            coverImage: functions.getImageFromAttractions(getJsonField(
                      HerokuItinerariesCall.itineraries(
                        (_model.apiResult?.jsonBody ?? ''),
                      )!
                          .elementAtOrNull(_model.count),
                      r'''$.attractions''',
                      true,
                    )!) !=
                    'None'
                ? functions.getImageFromAttractions(getJsonField(
                    HerokuItinerariesCall.itineraries(
                      (_model.apiResult?.jsonBody ?? ''),
                    )!
                        .elementAtOrNull(_model.count),
                    r'''$.attractions''',
                    true,
                  )!)
                : 'https://images.travelandleisureasia.com/wp-content/uploads/sites/2/2023/11/20122038/ljublianica.jpeg',
            tripCode: random_data.randomString(
              6,
              6,
              true,
              true,
              true,
            ),
          ),
          ...mapToFirestore(
            {
              'attractions': getAttractionListFirestoreData(
                functions.attractionsFromJson(getJsonField(
                  HerokuItinerariesCall.itineraries(
                    (_model.apiResult?.jsonBody ?? ''),
                  )!
                      .elementAtOrNull(_model.count),
                  r'''$.attractions''',
                  true,
                )!),
              ),
              'days': functions.getDatesFromAttractions(getJsonField(
                HerokuItinerariesCall.itineraries(
                  (_model.apiResult?.jsonBody ?? ''),
                )!
                    .elementAtOrNull(_model.count),
                r'''$.attractions''',
                true,
              )!),
            },
          ),
        }, itinerariesApiRecordReference);
        _model.count = _model.count + 1;
        safeSetState(() {});
      }
      _model.isReady = true;
      safeSetState(() {});

      context.goNamed('top3');
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
