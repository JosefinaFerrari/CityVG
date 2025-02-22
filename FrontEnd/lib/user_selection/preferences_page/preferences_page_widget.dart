import '/backend/schema/structs/index.dart';
import '/components/navigate_back_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'preferences_page_model.dart';
export 'preferences_page_model.dart';

class PreferencesPageWidget extends StatefulWidget {
  const PreferencesPageWidget({super.key});

  @override
  State<PreferencesPageWidget> createState() => _PreferencesPageWidgetState();
}

class _PreferencesPageWidgetState extends State<PreferencesPageWidget>
    with TickerProviderStateMixin {
  late PreferencesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PreferencesPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.counter = 0;
      safeSetState(() {});
      while (_model.counter! < FFAppConstants.listOfPreferences.length) {
        if (_model.isSelectedList.length <
            FFAppConstants.listOfPreferences.length) {
          _model.addToIsSelectedList(false);
          safeSetState(() {});
        }
        _model.counter = _model.counter! + 1;
        safeSetState(() {});
      }
      _model.counter = 0;
      safeSetState(() {});
      if (FFAppState().dataSelected.preferencesSelected.isNotEmpty) {
        _model.countI = 0;
        _model.countJ = 0;
        safeSetState(() {});
        while (_model.countI! < FFAppConstants.listOfPreferences.length) {
          while (_model.countJ! <
              FFAppState().dataSelected.preferencesSelected.length) {
            if (FFAppConstants.listOfPreferences
                    .elementAtOrNull(_model.countI!) ==
                FFAppState()
                    .dataSelected
                    .preferencesSelected
                    .elementAtOrNull(_model.countJ!)) {
              _model.updateIsSelectedListAtIndex(
                _model.countI!,
                (_) => true,
              );
              safeSetState(() {});
              _model.counter = _model.counter! + 1;
              safeSetState(() {});
            }
            _model.countJ = _model.countJ! + 1;
            safeSetState(() {});
          }
          _model.countJ = 0;
          safeSetState(() {});
          _model.countI = _model.countI! + 1;
          safeSetState(() {});
        }
        _model.countI = 0;
        _model.countJ = 0;
        safeSetState(() {});
      }
      if (_model.counter != 0) {
        if (animationsMap['buttonOnActionTriggerAnimation'] != null) {
          await animationsMap['buttonOnActionTriggerAnimation']!
              .controller
              .forward(from: 0.0);
        }
      }
    });

    animationsMap.addAll({
      'buttonOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

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
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    wrapWithModel(
                      model: _model.navigateBackModel,
                      updateCallback: () => safeSetState(() {}),
                      child: NavigateBackWidget(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30.0, 20.0, 30.0, 0.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  FFAppState().dataSelected.placeSelected.city,
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).alternate,
                                fontSize: () {
                                  if (MediaQuery.sizeOf(context).width <
                                      kBreakpointSmall) {
                                    return 36.0;
                                  } else if (MediaQuery.sizeOf(context).width <
                                      kBreakpointMedium) {
                                    return 50.0;
                                  } else if (MediaQuery.sizeOf(context).width <
                                      kBreakpointLarge) {
                                    return 60.0;
                                  } else {
                                    return 65.0;
                                  }
                                }(),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFF989898),
                                    offset: Offset(0.5, 2.0),
                                    blurRadius: 5.0,
                                  )
                                ],
                              ),
                            ),
                            TextSpan(
                              text: ', ',
                              style: TextStyle(
                                fontSize: () {
                                  if (MediaQuery.sizeOf(context).width <
                                      kBreakpointSmall) {
                                    return 36.0;
                                  } else if (MediaQuery.sizeOf(context).width <
                                      kBreakpointMedium) {
                                    return 50.0;
                                  } else if (MediaQuery.sizeOf(context).width <
                                      kBreakpointLarge) {
                                    return 60.0;
                                  } else {
                                    return 65.0;
                                  }
                                }(),
                              ),
                            ),
                            TextSpan(
                              text: FFAppState()
                                  .dataSelected
                                  .placeSelected
                                  .country,
                              style: TextStyle(
                                fontSize: () {
                                  if (MediaQuery.sizeOf(context).width <
                                      kBreakpointSmall) {
                                    return 36.0;
                                  } else if (MediaQuery.sizeOf(context).width <
                                      kBreakpointMedium) {
                                    return 50.0;
                                  } else if (MediaQuery.sizeOf(context).width <
                                      kBreakpointLarge) {
                                    return 60.0;
                                  } else {
                                    return 65.0;
                                  }
                                }(),
                              ),
                            )
                          ],
                          style: FlutterFlowTheme.of(context)
                              .displaySmall
                              .override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).alternate,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: Color(0xFF989898),
                                offset: Offset(0.5, 2.0),
                                blurRadius: 5.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(30.0, 35.0, 0.0, 0.0),
                    child: Text(
                      'Preferences',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).alternate,
                            fontSize: () {
                              if (MediaQuery.sizeOf(context).width <
                                  kBreakpointSmall) {
                                return 20.0;
                              } else if (MediaQuery.sizeOf(context).width <
                                  kBreakpointMedium) {
                                return 24.0;
                              } else {
                                return 26.0;
                              }
                            }(),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 30.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              30.0, 9.0, 0.0, 0.0),
                          child: Text(
                            'Select your preferences to generate a perfect trip for you  (max 5 elements)',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).alternate,
                                  fontSize: () {
                                    if (MediaQuery.sizeOf(context).width <
                                        kBreakpointSmall) {
                                      return 14.0;
                                    } else if (MediaQuery.sizeOf(context)
                                            .width <
                                        kBreakpointMedium) {
                                      return 16.0;
                                    } else {
                                      return 17.0;
                                    }
                                  }(),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w300,
                                  lineHeight: 1.5,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(30.0, 40.0, 30.0, 50.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Builder(
                            builder: (context) {
                              final listOfPreferences =
                                  FFAppConstants.listOfPreferences.toList();

                              return Wrap(
                                spacing: () {
                                  if (MediaQuery.sizeOf(context).width <
                                      kBreakpointSmall) {
                                    return 18.0;
                                  } else if (MediaQuery.sizeOf(context).width <
                                      kBreakpointMedium) {
                                    return 22.0;
                                  } else {
                                    return 24.0;
                                  }
                                }(),
                                runSpacing: () {
                                  if (MediaQuery.sizeOf(context).width <
                                      kBreakpointSmall) {
                                    return 16.0;
                                  } else if (MediaQuery.sizeOf(context).width <
                                      kBreakpointMedium) {
                                    return 20.0;
                                  } else {
                                    return 22.0;
                                  }
                                }(),
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                direction: Axis.horizontal,
                                runAlignment: WrapAlignment.center,
                                verticalDirection: VerticalDirection.down,
                                clipBehavior: Clip.none,
                                children:
                                    List.generate(listOfPreferences.length,
                                        (listOfPreferencesIndex) {
                                  final listOfPreferencesItem =
                                      listOfPreferences[listOfPreferencesIndex];
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if (_model.isSelectedList.elementAtOrNull(
                                          listOfPreferencesIndex)!) {
                                        FFAppState().updateDataSelectedStruct(
                                          (e) => e
                                            ..updatePreferencesSelected(
                                              (e) => e.remove(FFAppConstants
                                                  .listOfPreferences
                                                  .elementAtOrNull(
                                                      listOfPreferencesIndex)),
                                            ),
                                        );
                                        safeSetState(() {});
                                        _model.updateIsSelectedListAtIndex(
                                          listOfPreferencesIndex,
                                          (_) => false,
                                        );
                                        safeSetState(() {});
                                        _model.counter = _model.counter! + -1;
                                        safeSetState(() {});
                                        if (_model.counter == 0) {
                                          if (animationsMap[
                                                  'buttonOnActionTriggerAnimation'] !=
                                              null) {
                                            await animationsMap[
                                                    'buttonOnActionTriggerAnimation']!
                                                .controller
                                                .reverse();
                                          }
                                        }
                                      } else {
                                        if (_model.counter! < 5) {
                                          FFAppState().updateDataSelectedStruct(
                                            (e) => e
                                              ..updatePreferencesSelected(
                                                (e) => e.add(FFAppConstants
                                                    .listOfPreferences
                                                    .elementAtOrNull(
                                                        listOfPreferencesIndex)!),
                                              ),
                                          );
                                          safeSetState(() {});
                                          _model.updateIsSelectedListAtIndex(
                                            listOfPreferencesIndex,
                                            (_) => true,
                                          );
                                          safeSetState(() {});
                                          _model.counter = _model.counter! + 1;
                                          safeSetState(() {});
                                          if (_model.counter == 1) {
                                            if (animationsMap[
                                                    'buttonOnActionTriggerAnimation'] !=
                                                null) {
                                              await animationsMap[
                                                      'buttonOnActionTriggerAnimation']!
                                                  .controller
                                                  .forward(from: 0.0);
                                            }
                                          }
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Error Message'),
                                                content: Text('Max 5 elements'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: functions
                                          .getStringText(
                                              FFAppConstants.listOfPreferences
                                                  .elementAtOrNull(
                                                      listOfPreferencesIndex)!,
                                              MediaQuery.sizeOf(context).width)
                                          .toDouble(),
                                      height: () {
                                        if (MediaQuery.sizeOf(context).width <
                                            kBreakpointSmall) {
                                          return 36.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointMedium) {
                                          return 40.0;
                                        } else {
                                          return 42.0;
                                        }
                                      }(),
                                      decoration: BoxDecoration(
                                        color: valueOrDefault<Color>(
                                          !_model.isSelectedList
                                                  .elementAtOrNull(
                                                      listOfPreferencesIndex)!
                                              ? FlutterFlowTheme.of(context)
                                                  .customColor1
                                              : FlutterFlowTheme.of(context)
                                                  .customColor4,
                                          Color(0xFFD9D9D9),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Text(
                                          FFAppConstants.listOfPreferences
                                              .elementAtOrNull(
                                                  listOfPreferencesIndex)!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                fontSize: () {
                                                  if (MediaQuery.sizeOf(context)
                                                          .width <
                                                      kBreakpointSmall) {
                                                    return 14.0;
                                                  } else if (MediaQuery.sizeOf(
                                                              context)
                                                          .width <
                                                      kBreakpointMedium) {
                                                    return 16.0;
                                                  } else {
                                                    return 17.0;
                                                  }
                                                }(),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FFButtonWidget(
                      onPressed: (_model.counter == 0)
                          ? null
                          : () async {
                              context.pushNamed('BudgetPage');
                            },
                      text: 'NEXT',
                      options: FFButtonOptions(
                        width: () {
                          if (MediaQuery.sizeOf(context).width <
                              kBreakpointSmall) {
                            return 260.0;
                          } else if (MediaQuery.sizeOf(context).width <
                              kBreakpointMedium) {
                            return 300.0;
                          } else if (MediaQuery.sizeOf(context).width <
                              kBreakpointLarge) {
                            return 320.0;
                          } else {
                            return 340.0;
                          }
                        }(),
                        height: () {
                          if (MediaQuery.sizeOf(context).width <
                              kBreakpointSmall) {
                            return 55.0;
                          } else if (MediaQuery.sizeOf(context).width <
                              kBreakpointMedium) {
                            return 60.0;
                          } else if (MediaQuery.sizeOf(context).width <
                              kBreakpointLarge) {
                            return 63.0;
                          } else {
                            return 65.0;
                          }
                        }(),
                        padding: EdgeInsets.all(0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: () {
                                if (MediaQuery.sizeOf(context).width <
                                    kBreakpointSmall) {
                                  return 20.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointMedium) {
                                  return 25.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointLarge) {
                                  return 28.0;
                                } else {
                                  return 30.0;
                                }
                              }(),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ).animateOnActionTrigger(
                      animationsMap['buttonOnActionTriggerAnimation']!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
