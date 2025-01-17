import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/place_card_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'trip_detail_model.dart';
export 'trip_detail_model.dart';

class TripDetailWidget extends StatefulWidget {
  const TripDetailWidget({
    super.key,
    required this.tripRef,
    bool? isPreview,
  }) : this.isPreview = isPreview ?? false;

  final DocumentReference? tripRef;
  final bool isPreview;

  @override
  State<TripDetailWidget> createState() => _TripDetailWidgetState();
}

class _TripDetailWidgetState extends State<TripDetailWidget> {
  late TripDetailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TripDetailModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.trip =
          await ItinerariesApiRecord.getDocumentOnce(widget!.tripRef!);
      _model.count = 0;
      _model.day = _model.trip!.days.length > 0
          ? _model.trip?.days?.firstOrNull
          : getCurrentTimestamp;
      safeSetState(() {});
      while (_model.count < _model.trip!.attractions.length) {
        _model.addToPlaces(
            _model.trip!.attractions.elementAtOrNull(_model.count)!.location!);
        safeSetState(() {});
        _model.count = _model.count + 1;
        safeSetState(() {});
      }
    });

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
      );
    }

    return StreamBuilder<ItinerariesApiRecord>(
      stream: ItinerariesApiRecord.getDocument(widget!.tripRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        final tripDetailItinerariesApiRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
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
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: Image.network(
                            tripDetailItinerariesApiRecord.coverImage,
                            width: double.infinity,
                            height: () {
                              if (MediaQuery.sizeOf(context).width <
                                  kBreakpointSmall) {
                                return 300.0;
                              } else if (MediaQuery.sizeOf(context).width <
                                  kBreakpointMedium) {
                                return 400.0;
                              } else {
                                return 450.0;
                              }
                            }(),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
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
                                        if (MediaQuery.sizeOf(context).width <
                                            kBreakpointSmall) {
                                          return 40.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointMedium) {
                                          return 50.0;
                                        } else {
                                          return 55.0;
                                        }
                                      }(),
                                      height: () {
                                        if (MediaQuery.sizeOf(context).width <
                                            kBreakpointSmall) {
                                          return 40.0;
                                        } else if (MediaQuery.sizeOf(context)
                                                .width <
                                            kBreakpointMedium) {
                                          return 50.0;
                                        } else {
                                          return 55.0;
                                        }
                                      }(),
                                      decoration: BoxDecoration(
                                        color: Color(0xA6FFFFFF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        size: () {
                                          if (MediaQuery.sizeOf(context).width <
                                              kBreakpointSmall) {
                                            return 25.0;
                                          } else if (MediaQuery.sizeOf(context)
                                                  .width <
                                              kBreakpointMedium) {
                                            return 30.0;
                                          } else {
                                            return 32.0;
                                          }
                                        }(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (!isWeb &&
                                  responsiveVisibility(
                                    context: context,
                                    desktop: false,
                                  ))
                                Container(
                                  width: () {
                                    if (MediaQuery.sizeOf(context).width <
                                        kBreakpointSmall) {
                                      return 40.0;
                                    } else if (MediaQuery.sizeOf(context)
                                            .width <
                                        kBreakpointMedium) {
                                      return 50.0;
                                    } else {
                                      return 55.0;
                                    }
                                  }(),
                                  height: () {
                                    if (MediaQuery.sizeOf(context).width <
                                        kBreakpointSmall) {
                                      return 40.0;
                                    } else if (MediaQuery.sizeOf(context)
                                            .width <
                                        kBreakpointMedium) {
                                      return 50.0;
                                    } else {
                                      return 55.0;
                                    }
                                  }(),
                                  decoration: BoxDecoration(
                                    color: Color(0xA5FFFFFF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Builder(
                                      builder: (context) => Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 2.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            await Share.share(
                                              'Inserisci questo codice nell\'app: ${tripDetailItinerariesApiRecord.tripCode}',
                                              sharePositionOrigin:
                                                  getWidgetBoundingBox(context),
                                            );
                                          },
                                          child: Icon(
                                            Icons.share,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            size: () {
                                              if (MediaQuery.sizeOf(context)
                                                      .width <
                                                  kBreakpointSmall) {
                                                return 25.0;
                                              } else if (MediaQuery.sizeOf(
                                                          context)
                                                      .width <
                                                  kBreakpointMedium) {
                                                return 30.0;
                                              } else {
                                                return 35.0;
                                              }
                                            }(),
                                          ),
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  '${tripDetailItinerariesApiRecord.attractions.length > 0 ? tripDetailItinerariesApiRecord.attractions.firstOrNull?.city : 'City'}, ${tripDetailItinerariesApiRecord.attractions.length > 0 ? tripDetailItinerariesApiRecord.attractions.firstOrNull?.country : 'Country'}',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: () {
                                          if (MediaQuery.sizeOf(context).width <
                                              kBreakpointSmall) {
                                            return 20.0;
                                          } else if (MediaQuery.sizeOf(context)
                                                  .width <
                                              kBreakpointMedium) {
                                            return 22.0;
                                          } else {
                                            return 23.0;
                                          }
                                        }(),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                if (false)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/twemoji_flag-italy.png',
                                      width: 26.0,
                                      height: 26.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 35.0),
                            child: Text(
                              '${tripDetailItinerariesApiRecord.days.length > 0 ? dateTimeFormat("yMMMd", tripDetailItinerariesApiRecord.days.firstOrNull) : 'Dec 9, 2024'} - ${tripDetailItinerariesApiRecord.days.length > 0 ? dateTimeFormat("yMMMd", tripDetailItinerariesApiRecord.days.lastOrNull) : 'Dec 12, 2024'}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF949494),
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 20.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 22.0;
                                      } else {
                                        return 23.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 5.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 270.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: FlutterFlowGoogleMap(
                                    controller: _model.googleMapsController,
                                    onCameraIdle: (latLng) =>
                                        _model.googleMapsCenter = latLng,
                                    initialLocation: _model.googleMapsCenter ??=
                                        _model.places.length > 0
                                            ? _model.places.firstOrNull!
                                            : currentUserLocationValue!,
                                    markers: _model.places
                                        .map(
                                          (marker) => FlutterFlowMarker(
                                            marker.serialize(),
                                            marker,
                                          ),
                                        )
                                        .toList(),
                                    markerColor: GoogleMarkerColor.violet,
                                    mapType: MapType.normal,
                                    style: GoogleMapStyle.standard,
                                    initialZoom: 12.0,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final date =
                            tripDetailItinerariesApiRecord.days.toList();

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(date.length, (dateIndex) {
                              final dateItem = date[dateIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 25.0, 0.0, 25.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.day = dateItem;
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    height: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 38.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 41.0;
                                      } else {
                                        return 42.0;
                                      }
                                    }(),
                                    decoration: BoxDecoration(
                                      color: _model.day == dateItem
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                      boxShadow: [
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 10.0, 0.0),
                                          child: Text(
                                            dateTimeFormat("MMMEd", dateItem),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: _model.day == dateItem
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  fontSize: () {
                                                    if (MediaQuery.sizeOf(
                                                                context)
                                                            .width <
                                                        kBreakpointSmall) {
                                                      return 16.0;
                                                    } else if (MediaQuery
                                                                .sizeOf(context)
                                                            .width <
                                                        kBreakpointMedium) {
                                                      return 17.0;
                                                    } else {
                                                      return 18.0;
                                                    }
                                                  }(),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                                .divide(SizedBox(width: 15.0))
                                .around(SizedBox(width: 15.0)),
                          ),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final attraction = tripDetailItinerariesApiRecord
                            .attractions
                            .where((e) => e.day == _model.day)
                            .toList()
                            .sortedList(keyOf: (e) => e.day!, desc: false)
                            .toList();

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(attraction.length,
                              (attractionIndex) {
                            final attractionItem = attraction[attractionIndex];
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 20.0, 0.0, 20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Transform.rotate(
                                        angle: 45.0 * (math.pi / 180),
                                        child: Icon(
                                          Icons.assistant_navigation,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: () {
                                            if (MediaQuery.sizeOf(context)
                                                    .width <
                                                kBreakpointSmall) {
                                              return 24.0;
                                            } else if (MediaQuery.sizeOf(
                                                        context)
                                                    .width <
                                                kBreakpointMedium) {
                                              return 26.0;
                                            } else {
                                              return 27.0;
                                            }
                                          }(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 100.0,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: Color(0xFF949494),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    currentUserLocationValue =
                                                        await getCurrentUserLocation(
                                                            defaultLocation:
                                                                LatLng(
                                                                    0.0, 0.0));
                                                    if (attractionIndex != 0) {
                                                      if (isiOS) {
                                                        await launchURL(
                                                            'maps://?saddr=${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lat').toString()},${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lng').toString()}&daddr=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&dirflg=d');
                                                      } else {
                                                        await launchURL(
                                                            'https://www.google.com/maps/dir/?api=1&origin=${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lat').toString()},${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lng').toString()}&destination=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&travelmode=driving');
                                                      }
                                                    } else {
                                                      if (isiOS) {
                                                        await launchURL(
                                                            'maps://?saddr=${functions.getLatorLng(currentUserLocationValue!, 'lat').toString()},${functions.getLatorLng(currentUserLocationValue!, 'lng').toString()}&daddr=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&dirflg=d');
                                                      } else {
                                                        await launchURL(
                                                            'https://www.google.com/maps/dir/?api=1&origin=${functions.getLatorLng(currentUserLocationValue!, 'lat').toString()},${functions.getLatorLng(currentUserLocationValue!, 'lng').toString()}&destination=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&travelmode=driving');
                                                      }
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .directions_car_rounded,
                                                        color:
                                                            Color(0xFF949494),
                                                        size: 24.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    currentUserLocationValue =
                                                        await getCurrentUserLocation(
                                                            defaultLocation:
                                                                LatLng(
                                                                    0.0, 0.0));
                                                    if (attractionIndex != 0) {
                                                      if (isiOS) {
                                                        await launchURL(
                                                            'maps://?saddr=${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lat').toString()},${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lng').toString()}&daddr=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&dirflg=r');
                                                      } else {
                                                        await launchURL(
                                                            'https://www.google.com/maps/dir/?api=1&origin=${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lat').toString()},${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lng').toString()}&destination=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&travelmode=transit');
                                                      }
                                                    } else {
                                                      if (isiOS) {
                                                        await launchURL(
                                                            'maps://?saddr=${functions.getLatorLng(currentUserLocationValue!, 'lat').toString()},${functions.getLatorLng(currentUserLocationValue!, 'lng').toString()}&daddr=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&dirflg=r');
                                                      } else {
                                                        await launchURL(
                                                            'https://www.google.com/maps/dir/?api=1&origin=${functions.getLatorLng(currentUserLocationValue!, 'lat').toString()},${functions.getLatorLng(currentUserLocationValue!, 'lng').toString()}&destination=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&travelmode=transit');
                                                      }
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Icon(
                                                        Icons.train_rounded,
                                                        color:
                                                            Color(0xFF949494),
                                                        size: 24.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    currentUserLocationValue =
                                                        await getCurrentUserLocation(
                                                            defaultLocation:
                                                                LatLng(
                                                                    0.0, 0.0));
                                                    if (attractionIndex != 0) {
                                                      if (isiOS) {
                                                        await launchURL(
                                                            'maps://?saddr=${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lat').toString()},${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lng').toString()}&daddr=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&dirflg=w');
                                                      } else {
                                                        await launchURL(
                                                            'https://www.google.com/maps/dir/?api=1&origin=${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lat').toString()},${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lng').toString()}&destination=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&travelmode=walking');
                                                      }
                                                    } else {
                                                      if (isiOS) {
                                                        await launchURL(
                                                            'maps://?saddr=${functions.getLatorLng(currentUserLocationValue!, 'lat').toString()},${functions.getLatorLng(currentUserLocationValue!, 'lng').toString()}&daddr=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&dirflg=w');
                                                      } else {
                                                        await launchURL(
                                                            'https://www.google.com/maps/dir/?api=1&origin=${functions.getLatorLng(currentUserLocationValue!, 'lat').toString()},${functions.getLatorLng(currentUserLocationValue!, 'lng').toString()}&destination=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&travelmode=walking');
                                                      }
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .directions_walk_rounded,
                                                        color:
                                                            Color(0xFF949494),
                                                        size: 24.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    currentUserLocationValue =
                                                        await getCurrentUserLocation(
                                                            defaultLocation:
                                                                LatLng(
                                                                    0.0, 0.0));
                                                    if (attractionIndex != 0) {
                                                      if (isiOS) {
                                                        await launchURL(
                                                            'maps://?saddr=${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lat').toString()},${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lng').toString()}&daddr=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&dirflg=w');
                                                      } else {
                                                        await launchURL(
                                                            'https://www.google.com/maps/dir/?api=1&origin=${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lat').toString()},${functions.getLatorLng(tripDetailItinerariesApiRecord.attractions.elementAtOrNull(attractionIndex - 1)!.location!, 'lng').toString()}&destination=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&travelmode=bicycling');
                                                      }
                                                    } else {
                                                      if (isiOS) {
                                                        await launchURL(
                                                            'maps://?saddr=${functions.getLatorLng(currentUserLocationValue!, 'lat').toString()},${functions.getLatorLng(currentUserLocationValue!, 'lng').toString()}&daddr=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&dirflg=w');
                                                      } else {
                                                        await launchURL(
                                                            'https://www.google.com/maps/dir/?api=1&origin=${functions.getLatorLng(currentUserLocationValue!, 'lat').toString()},${functions.getLatorLng(currentUserLocationValue!, 'lng').toString()}&destination=${functions.getLatorLng(attractionItem.location!, 'lat').toString()},${functions.getLatorLng(attractionItem.location!, 'lng').toString()}&travelmode=bicycling');
                                                      }
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .directions_bike_rounded,
                                                        color:
                                                            Color(0xFF949494),
                                                        size: 24.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]
                                        .divide(SizedBox(width: 10.0))
                                        .around(SizedBox(width: 10.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15.0, 0.0, 15.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        'placeDetail',
                                        queryParameters: {
                                          'attraction': serializeParam(
                                            attractionItem,
                                            ParamType.DataStruct,
                                          ),
                                        }.withoutNulls,
                                      );
                                    },
                                    child: PlaceCardWidget(
                                      key: Key(
                                          'Key7dx_${attractionIndex}_of_${attraction.length}'),
                                      name: attractionItem.name,
                                      hours:
                                          '${attractionItem.startingHour} - ${attractionItem.endingHour}',
                                      price: attractionItem.productPrice
                                          .toString(),
                                      image: attractionItem.images.length > 0
                                          ? attractionItem.images.lastOrNull!
                                          : 'https://images.travelandleisureasia.com/wp-content/uploads/sites/2/2023/11/20122038/ljublianica.jpeg',
                                      isVisited: attractionItem.isVisited,
                                      rating: valueOrDefault<double>(
                                        tripDetailItinerariesApiRecord
                                            .attractions
                                            .elementAtOrNull(attractionIndex)
                                            ?.productRating,
                                        4.0,
                                      ),
                                      setVisited: () async {
                                        if (!attractionItem.isVisited &&
                                            !widget!.isPreview) {
                                          await widget!.tripRef!.update({
                                            ...mapToFirestore(
                                              {
                                                'attractions':
                                                    FieldValue.arrayUnion([
                                                  getAttractionFirestoreData(
                                                    updateAttractionStruct(
                                                      functions.setVisited(
                                                          attractionItem),
                                                      clearUnsetFields: false,
                                                    ),
                                                    true,
                                                  )
                                                ]),
                                              },
                                            ),
                                          });

                                          await widget!.tripRef!.update({
                                            ...mapToFirestore(
                                              {
                                                'attractions':
                                                    FieldValue.arrayRemove([
                                                  getAttractionFirestoreData(
                                                    updateAttractionStruct(
                                                      attractionItem,
                                                      clearUnsetFields: false,
                                                    ),
                                                    true,
                                                  )
                                                ]),
                                              },
                                            ),
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        );
                      },
                    ),
                  ].addToEnd(SizedBox(height: 50.0)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
