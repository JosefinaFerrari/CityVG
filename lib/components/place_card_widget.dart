import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'place_card_model.dart';
export 'place_card_model.dart';

class PlaceCardWidget extends StatefulWidget {
  const PlaceCardWidget({
    super.key,
    required this.name,
    required this.hours,
    required this.price,
    required this.image,
  });

  final String? name;
  final String? hours;
  final String? price;
  final String? image;

  @override
  State<PlaceCardWidget> createState() => _PlaceCardWidgetState();
}

class _PlaceCardWidgetState extends State<PlaceCardWidget> {
  late PlaceCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlaceCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryText,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Image.network(
              widget.image!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1.0, 0.0),
                  child: Text(
                    valueOrDefault<String>(
                      widget.name,
                      'name',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: RatingBarIndicator(
                    itemBuilder: (context, index) => Icon(
                      Icons.star_rounded,
                      color: FlutterFlowTheme.of(context).warning,
                    ),
                    direction: Axis.horizontal,
                    rating: 4.5,
                    unratedColor: const Color(0x56999999),
                    itemCount: 5,
                    itemSize: 24.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.clock,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 18.0,
                      ),
                      Text(
                        valueOrDefault<String>(
                          widget.hours,
                          'hours',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ].divide(const SizedBox(width: 10.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                        child: FaIcon(
                          FontAwesomeIcons.dollarSign,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 18.0,
                        ),
                      ),
                      Text(
                        valueOrDefault<String>(
                          widget.price,
                          'price',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ].divide(const SizedBox(width: 10.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidCreditCard,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 18.0,
                      ),
                      Text(
                        'View details',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ].divide(const SizedBox(width: 10.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 18.0,
                      ),
                      Text(
                        'Mark as completed',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ].divide(const SizedBox(width: 10.0)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
