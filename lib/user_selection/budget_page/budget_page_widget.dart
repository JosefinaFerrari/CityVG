import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'budget_page_model.dart';
export 'budget_page_model.dart';

class BudgetPageWidget extends StatefulWidget {
  const BudgetPageWidget({super.key});

  @override
  State<BudgetPageWidget> createState() => _BudgetPageWidgetState();
}

class _BudgetPageWidgetState extends State<BudgetPageWidget>
    with TickerProviderStateMixin {
  late BudgetPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BudgetPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().dataSelected.budgetSelected != '') {
        if (FFAppState().dataSelected.budgetSelected == 'cheap') {
          _model.updateIsClickedListAtIndex(
            0,
            (_) => true,
          );
          safeSetState(() {});
        } else {
          if (FFAppState().dataSelected.budgetSelected == 'balanced') {
            _model.updateIsClickedListAtIndex(
              1,
              (_) => true,
            );
            safeSetState(() {});
          } else {
            if (FFAppState().dataSelected.budgetSelected == 'luxury') {
              _model.updateIsClickedListAtIndex(
                2,
                (_) => true,
              );
              safeSetState(() {});
            } else {
              _model.updateIsClickedListAtIndex(
                3,
                (_) => true,
              );
              safeSetState(() {});
            }
          }
        }

        _model.isSelected = true;
        safeSetState(() {});
        if (animationsMap['buttonOnActionTriggerAnimation'] != null) {
          await animationsMap['buttonOnActionTriggerAnimation']!
              .controller
              .forward(from: 0.0);
        }
      } else {
        _model.isSelected = false;
        safeSetState(() {});
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
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
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
                                width: 72.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xC0DDE5D9),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(30.0, 20.0, 30.0, 0.0),
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
                                text: FFAppState()
                                    .dataSelected
                                    .placeSelected
                                    .city,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                  fontFamily: 'Poppins',
                                  color: const Color(0xFF022904),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    const Shadow(
                                      color: Color(0xFF989898),
                                      offset: Offset(0.5, 2.0),
                                      blurRadius: 5.0,
                                    )
                                  ],
                                ),
                              ),
                              const TextSpan(
                                text: ', ',
                                style: TextStyle(),
                              ),
                              TextSpan(
                                text: FFAppState()
                                    .dataSelected
                                    .placeSelected
                                    .country,
                                style: const TextStyle(),
                              )
                            ],
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                              fontFamily: 'Poppins',
                              color: const Color(0xFF022904),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                const Shadow(
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
                          const EdgeInsetsDirectional.fromSTEB(30.0, 35.0, 0.0, 0.0),
                      child: Text(
                        'Budget',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily: 'Poppins',
                          color: const Color(0xFF022904),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            const Shadow(
                              color: Color(0xFF989898),
                              offset: Offset(0.5, 1.0),
                              blurRadius: 4.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(30.0, 9.0, 0.0, 0.0),
                      child: Text(
                        'Select the budget that suits you best.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: const Color(0xFF022904),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w300,
                          shadows: [
                            const Shadow(
                              color: Color(0xFFC4C0C0),
                              offset: Offset(0.5, 1.0),
                              blurRadius: 2.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (_model.isClickedList[0]) {
                                      FFAppState().updateDataSelectedStruct(
                                        (e) => e..budgetSelected = null,
                                      );
                                      safeSetState(() {});
                                      _model.updateIsClickedListAtIndex(
                                        0,
                                        (_) => false,
                                      );
                                      safeSetState(() {});
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
                                      while (_model.counter < 4) {
                                        _model.updateIsClickedListAtIndex(
                                          _model.counter,
                                          (_) => false,
                                        );
                                        safeSetState(() {});
                                        _model.counter = _model.counter + 1;
                                        safeSetState(() {});
                                      }
                                      FFAppState().updateDataSelectedStruct(
                                        (e) => e..budgetSelected = 'Cheap',
                                      );
                                      safeSetState(() {});
                                      _model.updateIsClickedListAtIndex(
                                        0,
                                        (_) => true,
                                      );
                                      safeSetState(() {});
                                      _model.counter = 0;
                                      safeSetState(() {});
                                      if (_model.isSelected == false) {
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
                                  child: Container(
                                    width: 312.0,
                                    height: 74.0,
                                    decoration: BoxDecoration(
                                      color: valueOrDefault<Color>(
                                        !_model.isClickedList[0]
                                            ? const Color(0x76D9D9D9)
                                            : const Color(0xFFD4E8D1),
                                        const Color(0x75D9D9D9),
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: !_model.isClickedList[0]
                                            ? const Color(0xFFD4E8D1)
                                            : const Color(0xFF72978F),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  25.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Cheap \$',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  25.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Budget-friendly',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (_model.isClickedList[1]) {
                                      FFAppState().updateDataSelectedStruct(
                                        (e) => e..budgetSelected = null,
                                      );
                                      safeSetState(() {});
                                      _model.updateIsClickedListAtIndex(
                                        1,
                                        (_) => false,
                                      );
                                      safeSetState(() {});
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
                                      while (_model.counter < 4) {
                                        _model.updateIsClickedListAtIndex(
                                          _model.counter,
                                          (_) => false,
                                        );
                                        safeSetState(() {});
                                        _model.counter = _model.counter + 1;
                                        safeSetState(() {});
                                      }
                                      FFAppState().updateDataSelectedStruct(
                                        (e) => e..budgetSelected = 'Balanced',
                                      );
                                      safeSetState(() {});
                                      _model.updateIsClickedListAtIndex(
                                        1,
                                        (_) => true,
                                      );
                                      safeSetState(() {});
                                      _model.counter = 0;
                                      safeSetState(() {});
                                      if (_model.isSelected == false) {
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
                                  child: Container(
                                    width: 312.0,
                                    height: 74.0,
                                    decoration: BoxDecoration(
                                      color: valueOrDefault<Color>(
                                        !_model.isClickedList[1]
                                            ? const Color(0x76D9D9D9)
                                            : const Color(0xFFD4E8D1),
                                        const Color(0x75D9D9D9),
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: !_model.isClickedList[1]
                                            ? const Color(0xFFD4E8D1)
                                            : const Color(0xFF72978F),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  25.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Balanced \$\$',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  25.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Moderate spending',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (_model.isClickedList[2]) {
                                      FFAppState().updateDataSelectedStruct(
                                        (e) => e..budgetSelected = null,
                                      );
                                      safeSetState(() {});
                                      _model.updateIsClickedListAtIndex(
                                        2,
                                        (_) => false,
                                      );
                                      safeSetState(() {});
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
                                      while (_model.counter < 4) {
                                        _model.updateIsClickedListAtIndex(
                                          _model.counter,
                                          (_) => false,
                                        );
                                        safeSetState(() {});
                                        _model.counter = _model.counter + 1;
                                        safeSetState(() {});
                                      }
                                      FFAppState().updateDataSelectedStruct(
                                        (e) => e..budgetSelected = 'Luxury',
                                      );
                                      safeSetState(() {});
                                      _model.updateIsClickedListAtIndex(
                                        2,
                                        (_) => true,
                                      );
                                      safeSetState(() {});
                                      _model.counter = 0;
                                      safeSetState(() {});
                                      if (_model.isSelected == false) {
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
                                  child: Container(
                                    width: 312.0,
                                    height: 74.0,
                                    decoration: BoxDecoration(
                                      color: valueOrDefault<Color>(
                                        !_model.isClickedList[2]
                                            ? const Color(0x76D9D9D9)
                                            : const Color(0xFFD4E8D1),
                                        const Color(0x75D9D9D9),
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: !_model.isClickedList[2]
                                            ? const Color(0xFFD4E8D1)
                                            : const Color(0xFF72978F),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  25.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Luxury \$\$\$',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  25.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'High-end, indulgent experiences',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (_model.isClickedList[3]) {
                                      FFAppState().updateDataSelectedStruct(
                                        (e) => e..budgetSelected = null,
                                      );
                                      safeSetState(() {});
                                      _model.updateIsClickedListAtIndex(
                                        3,
                                        (_) => false,
                                      );
                                      safeSetState(() {});
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
                                      while (_model.counter < 4) {
                                        _model.updateIsClickedListAtIndex(
                                          _model.counter,
                                          (_) => false,
                                        );
                                        safeSetState(() {});
                                        _model.counter = _model.counter + 1;
                                        safeSetState(() {});
                                      }
                                      FFAppState().updateDataSelectedStruct(
                                        (e) => e..budgetSelected = 'Flexible',
                                      );
                                      safeSetState(() {});
                                      _model.updateIsClickedListAtIndex(
                                        3,
                                        (_) => true,
                                      );
                                      safeSetState(() {});
                                      _model.counter = 0;
                                      safeSetState(() {});
                                      if (_model.isSelected == false) {
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
                                  child: Container(
                                    width: 312.0,
                                    height: 74.0,
                                    decoration: BoxDecoration(
                                      color: valueOrDefault<Color>(
                                        !_model.isClickedList[3]
                                            ? const Color(0x76D9D9D9)
                                            : const Color(0xFFD4E8D1),
                                        const Color(0x75D9D9D9),
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: !_model.isClickedList[3]
                                            ? const Color(0xFFD4E8D1)
                                            : const Color(0xFF72978F),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  25.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Flexible',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  25.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'No budget restrictions',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ].divide(const SizedBox(height: 26.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FFButtonWidget(
                        onPressed: (_model.isSelected == false)
                            ? null
                            : () async {
                                context.pushNamed('LoadApi');
                              },
                        text: 'NEXT',
                        options: FFButtonOptions(
                          width: 260.0,
                          height: 55.0,
                          padding: const EdgeInsets.all(0.0),
                          iconAlignment: IconAlignment.start,
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 20.0,
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
      ),
    );
  }
}
