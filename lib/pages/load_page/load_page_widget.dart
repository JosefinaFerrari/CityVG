import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'load_page_model.dart';
export 'load_page_model.dart';

class LoadPageWidget extends StatefulWidget {
  const LoadPageWidget({super.key});

  @override
  State<LoadPageWidget> createState() => _LoadPageWidgetState();
}

class _LoadPageWidgetState extends State<LoadPageWidget> {
  late LoadPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadPageModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Load an existing \nitinerary',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 38.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          const Shadow(
                            color: Color(0xFFA6A9A9),
                            offset: Offset(2.0, 2.0),
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
                        const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                    child: Container(
                      width: 250.0,
                      height: 2.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5D805F),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 0.0, 0.0),
                    child: Container(
                      width: 50.0,
                      height: 2.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5D805F),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 0.0, 0.0),
                    child: Container(
                      width: 30.0,
                      height: 2.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5D805F),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 0.0, 0.0),
                    child: Container(
                      width: 13.0,
                      height: 2.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5D805F),
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
                        const EdgeInsetsDirectional.fromSTEB(30.0, 40.0, 0.0, 0.0),
                    child: Container(
                      width: 250.0,
                      height: 40.0,
                      decoration: const BoxDecoration(),
                      child: Text(
                        'Insert trip code',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 28.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            const Shadow(
                              color: Color(0xFFC7BFBF),
                              offset: Offset(1.0, 2.0),
                              blurRadius: 3.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(25.0, 24.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 180.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(0.0),
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      child: Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                ),
                            hintText: '[Insert Code]',
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'Inter',
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                          textAlign: TextAlign.start,
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.textControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 130.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFF5D805F),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(24.0),
                              topLeft: Radius.circular(0.0),
                              topRight: Radius.circular(24.0),
                            ),
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Load',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context).info,
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 75.0, 0.0, 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/loadlogo.png',
                    width: 350.0,
                    height: 400.0,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0.0, 1.0),
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
