import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'people_page_copy_model.dart';
export 'people_page_copy_model.dart';

class PeoplePageCopyWidget extends StatefulWidget {
  const PeoplePageCopyWidget({super.key});

  @override
  State<PeoplePageCopyWidget> createState() => _PeoplePageCopyWidgetState();
}

class _PeoplePageCopyWidgetState extends State<PeoplePageCopyWidget>
    with TickerProviderStateMixin {
  late PeoplePageCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PeoplePageCopyModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      safeSetState(() {
        _model.countControllerValue1 = valueOrDefault<int>(
          FFAppState().dataSelected.peopleSelected.seniors,
          0,
        );
      });
      safeSetState(() {
        _model.countControllerValue2 = valueOrDefault<int>(
          FFAppState().dataSelected.peopleSelected.adults,
          0,
        );
      });
      safeSetState(() {
        _model.countControllerValue3 = valueOrDefault<int>(
          FFAppState().dataSelected.peopleSelected.youth,
          0,
        );
      });
      safeSetState(() {
        _model.countControllerValue4 = valueOrDefault<int>(
          FFAppState().dataSelected.peopleSelected.children,
          0,
        );
      });
      if ((_model.countControllerValue1 == 0) &&
          (_model.countControllerValue2 == 0) &&
          (_model.countControllerValue3 == 0) &&
          (_model.countControllerValue4 == 0)) {
        _model.isSelected = false;
        safeSetState(() {});
      } else {
        _model.isSelected = true;
        safeSetState(() {});
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
              Align(
                alignment: AlignmentDirectional(-1.0, -1.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30.0, 0.0, 0.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.safePop();
                                      },
                                      child: Container(
                                        width: 90.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xC0DDE5D9),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Group_131_(1).png',
                                              width: 0.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, -1.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 980.0, 0.0),
                                    child: RichText(
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: FFAppState()
                                                .dataSelected
                                                .placeSelected
                                                .city,
                                            style: FlutterFlowTheme.of(context)
                                                .displaySmall
                                                .override(
                                              fontFamily: 'Poppins',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              fontSize: 55.0,
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
                                            style: TextStyle(),
                                          ),
                                          TextSpan(
                                            text: FFAppState()
                                                .dataSelected
                                                .placeSelected
                                                .country,
                                            style: TextStyle(),
                                          )
                                        ],
                                        style: FlutterFlowTheme.of(context)
                                            .displaySmall
                                            .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          fontSize: 55.0,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                120.0, 35.0, 0.0, 0.0),
                            child: Text(
                              'Who is going? ',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).alternate,
                                fontSize: 42.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFF989898),
                                    offset: Offset(0.5, 1.0),
                                    blurRadius: 4.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                120.0, 9.0, 0.0, 0.0),
                            child: Text(
                              'Select the number of people in the trip',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    fontSize: 28.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w300,
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFFC4C0C0),
                                        offset: Offset(0.5, 1.0),
                                        blurRadius: 2.0,
                                      )
                                    ],
                                    lineHeight: 1.5,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Container(
                          width: 1200.0,
                          height: 490.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent4,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    25.0, 24.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, -1.0),
                                      child: Text(
                                        'Seniors\n(65 or above)',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 24.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, -1.0),
                                      child: Text(
                                        'Adults\n(25-64 years)',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 24.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, -1.0),
                                      child: Text(
                                        'Youth\n(13-24 years)',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 24.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, -1.0),
                                      child: Text(
                                        'Children\n(0-12 years)',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 24.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 50.0)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 26.0, 25.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 0.0),
                                        child: Container(
                                          width: 120.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .accent3,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: FlutterFlowCountController(
                                            decrementIconBuilder: (enabled) =>
                                                Icon(
                                              Icons.remove_rounded,
                                              color: enabled
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryText
                                                  : FlutterFlowTheme.of(context)
                                                      .alternate,
                                              size: 30.0,
                                            ),
                                            incrementIconBuilder: (enabled) =>
                                                Icon(
                                              Icons.add_rounded,
                                              color: enabled
                                                  ? FlutterFlowTheme.of(context)
                                                      .primary
                                                  : FlutterFlowTheme.of(context)
                                                      .alternate,
                                              size: 30.0,
                                            ),
                                            countBuilder: (count) => Text(
                                              count.toString(),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 26.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            count: _model
                                                .countControllerValue1 ??= 0,
                                            updateCount: (count) async {
                                              safeSetState(() =>
                                                  _model.countControllerValue1 =
                                                      count);
                                              FFAppState()
                                                  .updateDataSelectedStruct(
                                                (e) => e
                                                  ..updatePeopleSelected(
                                                    (e) => e
                                                      ..seniors = _model
                                                          .countControllerValue1,
                                                  ),
                                              );
                                              safeSetState(() {});
                                              if ((_model.countControllerValue1 == 0) &&
                                                  (_model.countControllerValue2 ==
                                                      0) &&
                                                  (_model.countControllerValue3 ==
                                                      0) &&
                                                  (_model.countControllerValue4 ==
                                                      0)) {
                                                _model.isSelected = false;
                                                safeSetState(() {});
                                                if (animationsMap[
                                                        'buttonOnActionTriggerAnimation'] !=
                                                    null) {
                                                  await animationsMap[
                                                          'buttonOnActionTriggerAnimation']!
                                                      .controller
                                                      .reverse();
                                                }
                                              } else {
                                                if (_model.isSelected != true) {
                                                  _model.isSelected = true;
                                                  safeSetState(() {});
                                                  if (animationsMap[
                                                          'buttonOnActionTriggerAnimation'] !=
                                                      null) {
                                                    await animationsMap[
                                                            'buttonOnActionTriggerAnimation']!
                                                        .controller
                                                        .forward(from: 0.0);
                                                  }
                                                }
                                              }
                                            },
                                            stepSize: 1,
                                            minimum: 0,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(1.0, -1.0),
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: Container(
                                            width: 120.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: FlutterFlowCountController(
                                              decrementIconBuilder: (enabled) =>
                                                  Icon(
                                                Icons.remove_rounded,
                                                color: enabled
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                size: 30.0,
                                              ),
                                              incrementIconBuilder: (enabled) =>
                                                  Icon(
                                                Icons.add_rounded,
                                                color: enabled
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .primary
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                size: 30.0,
                                              ),
                                              countBuilder: (count) => Text(
                                                count.toString(),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLarge
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 26.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              count: _model
                                                  .countControllerValue2 ??= 0,
                                              updateCount: (count) async {
                                                safeSetState(() => _model
                                                        .countControllerValue2 =
                                                    count);
                                                FFAppState()
                                                    .updateDataSelectedStruct(
                                                  (e) => e
                                                    ..updatePeopleSelected(
                                                      (e) => e
                                                        ..adults = _model
                                                            .countControllerValue2,
                                                    ),
                                                );
                                                safeSetState(() {});
                                                if ((_model.countControllerValue1 == 0) &&
                                                    (_model.countControllerValue2 ==
                                                        0) &&
                                                    (_model.countControllerValue3 ==
                                                        0) &&
                                                    (_model.countControllerValue4 ==
                                                        0)) {
                                                  _model.isSelected = false;
                                                  safeSetState(() {});
                                                  if (animationsMap[
                                                          'buttonOnActionTriggerAnimation'] !=
                                                      null) {
                                                    await animationsMap[
                                                            'buttonOnActionTriggerAnimation']!
                                                        .controller
                                                        .reverse();
                                                  }
                                                } else {
                                                  if (_model.isSelected !=
                                                      true) {
                                                    _model.isSelected = true;
                                                    safeSetState(() {});
                                                    if (animationsMap[
                                                            'buttonOnActionTriggerAnimation'] !=
                                                        null) {
                                                      await animationsMap[
                                                              'buttonOnActionTriggerAnimation']!
                                                          .controller
                                                          .forward(from: 0.0);
                                                    }
                                                  }
                                                }
                                              },
                                              stepSize: 1,
                                              minimum: 0,
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(1.0, -1.0),
                                      child: Container(
                                        decoration: BoxDecoration(),
                                      ),
                                    ),
                                    Container(
                                      width: 120.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .accent3,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: FlutterFlowCountController(
                                        decrementIconBuilder: (enabled) => Icon(
                                          Icons.remove_rounded,
                                          color: enabled
                                              ? FlutterFlowTheme.of(context)
                                                  .secondaryText
                                              : FlutterFlowTheme.of(context)
                                                  .alternate,
                                          size: 30.0,
                                        ),
                                        incrementIconBuilder: (enabled) => Icon(
                                          Icons.add_rounded,
                                          color: enabled
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .alternate,
                                          size: 30.0,
                                        ),
                                        countBuilder: (count) => Text(
                                          count.toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                fontFamily: 'Poppins',
                                                fontSize: 26.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        count: _model.countControllerValue3 ??=
                                            0,
                                        updateCount: (count) async {
                                          safeSetState(() => _model
                                              .countControllerValue3 = count);
                                          FFAppState().updateDataSelectedStruct(
                                            (e) => e
                                              ..updatePeopleSelected(
                                                (e) => e
                                                  ..youth = _model
                                                      .countControllerValue3,
                                              ),
                                          );
                                          safeSetState(() {});
                                          if ((_model.countControllerValue1 == 0) &&
                                              (_model.countControllerValue2 ==
                                                  0) &&
                                              (_model.countControllerValue3 ==
                                                  0) &&
                                              (_model.countControllerValue4 ==
                                                  0)) {
                                            _model.isSelected = false;
                                            safeSetState(() {});
                                            if (animationsMap[
                                                    'buttonOnActionTriggerAnimation'] !=
                                                null) {
                                              await animationsMap[
                                                      'buttonOnActionTriggerAnimation']!
                                                  .controller
                                                  .reverse();
                                            }
                                          } else {
                                            if (_model.isSelected != true) {
                                              _model.isSelected = true;
                                              safeSetState(() {});
                                              if (animationsMap[
                                                      'buttonOnActionTriggerAnimation'] !=
                                                  null) {
                                                await animationsMap[
                                                        'buttonOnActionTriggerAnimation']!
                                                    .controller
                                                    .forward(from: 0.0);
                                              }
                                            }
                                          }
                                        },
                                        stepSize: 1,
                                        minimum: 0,
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                12.0, 0.0, 12.0, 0.0),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(1.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 1.0, 0.0, 0.0),
                                        child: Container(
                                          decoration: BoxDecoration(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 120.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .accent3,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: FlutterFlowCountController(
                                        decrementIconBuilder: (enabled) => Icon(
                                          Icons.remove_rounded,
                                          color: enabled
                                              ? FlutterFlowTheme.of(context)
                                                  .secondaryText
                                              : FlutterFlowTheme.of(context)
                                                  .alternate,
                                          size: 30.0,
                                        ),
                                        incrementIconBuilder: (enabled) => Icon(
                                          Icons.add_rounded,
                                          color: enabled
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .alternate,
                                          size: 30.0,
                                        ),
                                        countBuilder: (count) => Text(
                                          count.toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                fontFamily: 'Poppins',
                                                fontSize: 26.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        count: _model.countControllerValue4 ??=
                                            0,
                                        updateCount: (count) async {
                                          safeSetState(() => _model
                                              .countControllerValue4 = count);
                                          FFAppState().updateDataSelectedStruct(
                                            (e) => e
                                              ..updatePeopleSelected(
                                                (e) => e
                                                  ..children = _model
                                                      .countControllerValue4,
                                              ),
                                          );
                                          safeSetState(() {});
                                          if ((_model.countControllerValue1 == 0) &&
                                              (_model.countControllerValue2 ==
                                                  0) &&
                                              (_model.countControllerValue3 ==
                                                  0) &&
                                              (_model.countControllerValue4 ==
                                                  0)) {
                                            _model.isSelected = false;
                                            safeSetState(() {});
                                            if (animationsMap[
                                                    'buttonOnActionTriggerAnimation'] !=
                                                null) {
                                              await animationsMap[
                                                      'buttonOnActionTriggerAnimation']!
                                                  .controller
                                                  .reverse();
                                            }
                                          } else {
                                            if (_model.isSelected != true) {
                                              _model.isSelected = true;
                                              safeSetState(() {});
                                              if (animationsMap[
                                                      'buttonOnActionTriggerAnimation'] !=
                                                  null) {
                                                await animationsMap[
                                                        'buttonOnActionTriggerAnimation']!
                                                    .controller
                                                    .forward(from: 0.0);
                                              }
                                            }
                                          }
                                        },
                                        stepSize: 1,
                                        minimum: 0,
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                12.0, 0.0, 12.0, 0.0),
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 50.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                        child: FFButtonWidget(
                          onPressed: (_model.isSelected == false)
                              ? null
                              : () async {
                                  context.pushNamed('PreferencesPage');
                                },
                          text: 'NEXT',
                          options: FFButtonOptions(
                            width: 260.0,
                            height: 55.0,
                            padding: EdgeInsets.all(0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 26.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['buttonOnActionTriggerAnimation']!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
