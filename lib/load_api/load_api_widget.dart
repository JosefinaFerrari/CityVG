import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      _model.apiResult = await LocalhostCall.call(
        lat: functions.getLatorLng(FFAppState().location!, 'lat'),
        lng: functions.getLatorLng(FFAppState().location!, 'lng'),
      );

      _model.count = 0;
      safeSetState(() {});
      while (_model.count <
          LocalhostCall.itineraries(
            (_model.apiResult?.jsonBody ?? ''),
          )!
              .length) {
        var itinerariesApiRecordReference =
            ItinerariesApiRecord.collection.doc();
        await itinerariesApiRecordReference.set({
          ...createItinerariesApiRecordData(
            itineraryName: getJsonField(
              LocalhostCall.itineraries(
                (_model.apiResult?.jsonBody ?? ''),
              )?[_model.count],
              r'''$.itineraryName''',
            ).toString().toString(),
            searchId: FFAppState().searchId,
            coverImage: functions.getImageFromAttractions(getJsonField(
                      LocalhostCall.itineraries(
                        (_model.apiResult?.jsonBody ?? ''),
                      )![_model.count],
                      r'''$.attractions''',
                      true,
                    )!) !=
                    'None'
                ? functions.getImageFromAttractions(getJsonField(
                    LocalhostCall.itineraries(
                      (_model.apiResult?.jsonBody ?? ''),
                    )![_model.count],
                    r'''$.attractions''',
                    true,
                  )!)
                : 'https://images.travelandleisureasia.com/wp-content/uploads/sites/2/2023/11/20122038/ljublianica.jpeg',
          ),
          ...mapToFirestore(
            {
              'attractions': getAttractionListFirestoreData(
                functions.attractionsFromJson(getJsonField(
                  LocalhostCall.itineraries(
                    (_model.apiResult?.jsonBody ?? ''),
                  )![_model.count],
                  r'''$.attractions''',
                  true,
                )!),
              ),
              'days': functions.getDatesFromAttractions(getJsonField(
                LocalhostCall.itineraries(
                  (_model.apiResult?.jsonBody ?? ''),
                )![_model.count],
                r'''$.attractions''',
                true,
              )!),
            },
          ),
        });
        _model.output = ItinerariesApiRecord.getDocumentFromData({
          ...createItinerariesApiRecordData(
            itineraryName: getJsonField(
              LocalhostCall.itineraries(
                (_model.apiResult?.jsonBody ?? ''),
              )?[_model.count],
              r'''$.itineraryName''',
            ).toString().toString(),
            searchId: FFAppState().searchId,
            coverImage: functions.getImageFromAttractions(getJsonField(
                      LocalhostCall.itineraries(
                        (_model.apiResult?.jsonBody ?? ''),
                      )![_model.count],
                      r'''$.attractions''',
                      true,
                    )!) !=
                    'None'
                ? functions.getImageFromAttractions(getJsonField(
                    LocalhostCall.itineraries(
                      (_model.apiResult?.jsonBody ?? ''),
                    )![_model.count],
                    r'''$.attractions''',
                    true,
                  )!)
                : 'https://images.travelandleisureasia.com/wp-content/uploads/sites/2/2023/11/20122038/ljublianica.jpeg',
          ),
          ...mapToFirestore(
            {
              'attractions': getAttractionListFirestoreData(
                functions.attractionsFromJson(getJsonField(
                  LocalhostCall.itineraries(
                    (_model.apiResult?.jsonBody ?? ''),
                  )![_model.count],
                  r'''$.attractions''',
                  true,
                )!),
              ),
              'days': functions.getDatesFromAttractions(getJsonField(
                LocalhostCall.itineraries(
                  (_model.apiResult?.jsonBody ?? ''),
                )![_model.count],
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
      onTap: () => FocusScope.of(context).unfocus(),
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
                      letterSpacing: 0.0,
                    ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Lottie.asset(
                  'assets/jsons/Animation_-_1732571831219.json',
                  width: 300.0,
                  height: 300.0,
                  fit: BoxFit.contain,
                  animate: true,
                ),
              ),
              if (_model.isReady)
                FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed('top5');
                  },
                  text: 'Button',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
