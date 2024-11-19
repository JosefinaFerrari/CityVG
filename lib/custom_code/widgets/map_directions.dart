// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong2;

class MapDirections extends StatefulWidget {
  const MapDirections({
    super.key,
    this.width,
    this.height,
    required this.polyline,
    required this.initialCenter,
  });

  final double? width;
  final double? height;
  final String polyline;
  final LatLng initialCenter;

  @override
  State<MapDirections> createState() => _MapDirectionsState();
}

class _MapDirectionsState extends State<MapDirections> {
  late List<latlong2.LatLng> _decodedPolyline;

  @override
  void initState() {
    super.initState();
    _decodedPolyline = _decodePolyline(widget.polyline);
  }

  List<latlong2.LatLng> _decodePolyline(String encoded) {
    List<latlong2.LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(latlong2.LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    final latlong2.LatLng center = _decodedPolyline.isNotEmpty
        ? _decodedPolyline[0]
        : latlong2.LatLng(0, 0); // Default to (0, 0) if polyline is empty

    return FlutterMap(
      options: MapOptions(
        initialCenter: latlong2.LatLng(
            widget.initialCenter.latitude, widget.initialCenter.longitude),
        initialZoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: _decodedPolyline,
              color: Colors.blue,
              strokeWidth: 4.0,
            ),
          ],
        ),
      ],
    );
  }
}
