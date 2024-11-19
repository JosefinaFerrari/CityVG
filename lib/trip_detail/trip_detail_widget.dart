import '/components/place_card_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'trip_detail_model.dart';
export 'trip_detail_model.dart';

class TripDetailWidget extends StatefulWidget {
  const TripDetailWidget({super.key});

  @override
  State<TripDetailWidget> createState() => _TripDetailWidgetState();
}

class _TripDetailWidgetState extends State<TripDetailWidget> {
  late TripDetailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TripDetailModel());

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
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0),
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(0.0),
                      ),
                      child: Image.asset(
                        'assets/images/image_3.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: const AlignmentDirectional(-1.0, 0.0),
                              child: Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.share,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 20.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 0.0, 0.0),
                            child: Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.more_vert,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Milan, italy ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/twemoji_flag-italy.png',
                                width: 26.0,
                                height: 26.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: const AlignmentDirectional(1.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed('EditItinerary');
                                  },
                                  child: Container(
                                    width: 30.0,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      size: 20.0,
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
                            const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 35.0),
                        child: Text(
                          'Nov 3 - Nov 6 2024',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 20.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          width: double.infinity,
                          height: 310.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: FlutterFlowGoogleMap(
                            controller: _model.googleMapsController,
                            onCameraIdle: (latLng) =>
                                _model.googleMapsCenter = latLng,
                            initialLocation: _model.googleMapsCenter ??=
                                const LatLng(13.106061, -59.613158),
                            markerColor: GoogleMarkerColor.violet,
                            mapType: MapType.normal,
                            style: GoogleMapStyle.standard,
                            initialZoom: 14.0,
                            allowInteraction: true,
                            allowZoom: true,
                            showZoomControls: false,
                            showLocation: true,
                            showCompass: false,
                            showMapToolbar: false,
                            showTraffic: false,
                            centerMapOnMarkerTap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 25.0, 0.0, 25.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _model.day = '1';
                            safeSetState(() {});
                          },
                          child: Container(
                            height: 38.0,
                            decoration: BoxDecoration(
                              color: _model.day == '1'
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context)
                                      .primaryBackground,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 5.0,
                                  color: Color(0x33000000),
                                  offset: Offset(
                                    0.0,
                                    5.0,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 10.0, 0.0),
                                  child: Text(
                                    'November 3rd',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: _model.day == '1'
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryBackground
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.day = '2';
                          safeSetState(() {});
                        },
                        child: Container(
                          height: 38.0,
                          decoration: BoxDecoration(
                            color: _model.day == '2'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context)
                                    .primaryBackground,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  5.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 10.0, 0.0),
                                child: Text(
                                  'November 4th',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: _model.day == '2'
                                            ? FlutterFlowTheme.of(context)
                                                .primaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.day = '3';
                          safeSetState(() {});
                        },
                        child: Container(
                          height: 38.0,
                          decoration: BoxDecoration(
                            color: _model.day == '3'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context)
                                    .primaryBackground,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  5.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 10.0, 0.0),
                                child: Text(
                                  'November 5th',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: _model.day == '3'
                                            ? FlutterFlowTheme.of(context)
                                                .primaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                        .divide(const SizedBox(width: 15.0))
                        .around(const SizedBox(width: 15.0)),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('placeDetail');
                        },
                        child: wrapWithModel(
                          model: _model.placeCardModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: const PlaceCardWidget(
                            name: 'The Duomo (Milan Cathedral)',
                            hours: '8:00 - 9:00 AM',
                            price: '€ 10',
                            image:
                                'https://firebasestorage.googleapis.com/v0/b/cityvg-1f3e7.firebasestorage.app/o/DemoImages%2Fimage%2018.png?alt=media&token=06b088ef-3c81-4144-90a9-aeeb9d364173',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Transform.rotate(
                            angle: 45.0 * (math.pi / 180),
                            child: Icon(
                              Icons.assistant_navigation,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 100.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.directions_car_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        Text(
                                          '-',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 10.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.train_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        Text(
                                          '-',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 10.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.directions_walk_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        Text(
                                          '1 min',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 10.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.directions_bike_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        Text(
                                          '-',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 10.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                            .divide(const SizedBox(width: 10.0))
                            .around(const SizedBox(width: 10.0)),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      child: wrapWithModel(
                        model: _model.placeCardModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: const PlaceCardWidget(
                          name: 'Galleria Vittorio Emanuele II',
                          hours: '9:00 - 9:30 AM',
                          price: 'Free',
                          image:
                              'https://firebasestorage.googleapis.com/v0/b/cityvg-1f3e7.firebasestorage.app/o/DemoImages%2Fimage.png?alt=media&token=f4844eef-cf62-42a1-9a8e-f9ead64c52eb',
                        ),
                      ),
                    ),
                  ],
                ),
              ].addToEnd(const SizedBox(height: 50.0)),
            ),
          ),
        ),
      ),
    );
  }
}
