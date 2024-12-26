// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class GeoJson extends StatefulWidget {
  const GeoJson({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<GeoJson> createState() => _GeoJsonState();
}

class _GeoJsonState extends State<GeoJson> {
  late GeoJsonParser _geoJsonParser;

  @override
  void initState() {
    super.initState();
    _geoJsonParser = GeoJsonParser();
    _loadGeoJson();
  }

  Future<void> _loadGeoJson() async {
    try {
      print('DEBUG: Attempting to load GeoJSON file...');
      final String geoJsonString = await rootBundle
          .loadString('assets/jsons/philippines-with-regions.json');
      print('DEBUG: GeoJSON file loaded successfully.');

      print('DEBUG: Parsing GeoJSON data...');

      final jsonData = json.decode(geoJsonString);
      final features = jsonData['features'] as List;

      for (var feature in features) {
        final geometry = feature['geometry'];
        final properties = feature['properties'];

        switch (geometry['type']) {
          case 'Point':
            _processPoint(geometry['coordinates'], properties);
            break;
          case 'LineString':
            _processLineString(geometry['coordinates'], properties);
            break;
          case 'Polygon':
            _processPolygon(geometry['coordinates'], properties);
            break;
          case 'MultiPoint':
            _processMultiPoint(geometry['coordinates'], properties);
            break;
          case 'MultiLineString':
            _processMultiLineString(geometry['coordinates'], properties);
            break;
          case 'MultiPolygon':
            _processMultiPolygon(geometry['coordinates'], properties);
            break;
          case 'GeometryCollection':
            _processGeometryCollection(geometry['geometries'], properties);
            break;
          default:
            print('DEBUG: Unsupported geometry type: ${geometry['type']}');
        }
      }

      print('DEBUG: GeoJSON data parsed successfully.');
      print('DEBUG: Number of polygons: ${_geoJsonParser.polygons.length}');
      print('DEBUG: Number of polylines: ${_geoJsonParser.polylines.length}');
      print('DEBUG: Number of markers: ${_geoJsonParser.markers.length}');

      setState(() {});
      print('DEBUG: Widget state updated.');
    } catch (e) {
      print('DEBUG: Error loading or parsing GeoJSON: $e');
    }
  }

  void _processPoint(List coordinates, Map<String, dynamic> properties) {
    double lng = (coordinates[0] is int)
        ? (coordinates[0] as int).toDouble()
        : coordinates[0];
    double lat = (coordinates[1] is int)
        ? (coordinates[1] as int).toDouble()
        : coordinates[1];
    _geoJsonParser.markers.add(Marker(
      point: latlong2.LatLng(lat, lng),
      width: 80,
      height: 80,
      child: Icon(Icons.location_on, color: Colors.red),
    ));
  }

  void _processLineString(List coordinates, Map<String, dynamic> properties) {
    List<latlong2.LatLng> points = (coordinates as List).map((coord) {
      double lng = (coord[0] is int) ? (coord[0] as int).toDouble() : coord[0];
      double lat = (coord[1] is int) ? (coord[1] as int).toDouble() : coord[1];
      return latlong2.LatLng(lat, lng);
    }).toList();

    _geoJsonParser.polylines.add(Polyline(
      points: points,
      strokeWidth: 2.0,
      color: Colors.blue,
    ));
  }

  void _processPolygon(List coordinates, Map<String, dynamic> properties) {
    for (var ring in coordinates) {
      List<latlong2.LatLng> points = (ring as List).map((coord) {
        double lng =
            (coord[0] is int) ? (coord[0] as int).toDouble() : coord[0];
        double lat =
            (coord[1] is int) ? (coord[1] as int).toDouble() : coord[1];
        return latlong2.LatLng(lat, lng);
      }).toList();

      _geoJsonParser.polygons.add(Polygon(
        points: points,
        color: Colors.blue.withOpacity(0.3),
        borderColor: Colors.blue,
        borderStrokeWidth: 2,
      ));
    }
  }

  void _processMultiPoint(List coordinates, Map<String, dynamic> properties) {
    for (var point in coordinates) {
      _processPoint(point, properties);
    }
  }

  void _processMultiLineString(
      List coordinates, Map<String, dynamic> properties) {
    for (var lineString in coordinates) {
      _processLineString(lineString, properties);
    }
  }

  void _processMultiPolygon(List coordinates, Map<String, dynamic> properties) {
    for (var polygon in coordinates) {
      _processPolygon(polygon, properties);
    }
  }

  void _processGeometryCollection(
      List geometries, Map<String, dynamic> properties) {
    for (var geometry in geometries) {
      switch (geometry['type']) {
        case 'Point':
          _processPoint(geometry['coordinates'], properties);
          break;
        case 'LineString':
          _processLineString(geometry['coordinates'], properties);
          break;
        case 'Polygon':
          _processPolygon(geometry['coordinates'], properties);
          break;
        case 'MultiPoint':
          _processMultiPoint(geometry['coordinates'], properties);
          break;
        case 'MultiLineString':
          _processMultiLineString(geometry['coordinates'], properties);
          break;
        case 'MultiPolygon':
          _processMultiPolygon(geometry['coordinates'], properties);
          break;
        default:
          print(
              'DEBUG: Unsupported geometry type in GeometryCollection: ${geometry['type']}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 400,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: latlong2.LatLng(14.6091, 121.0223),
          initialZoom: 10,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          PolygonLayer(polygons: _geoJsonParser.polygons),
          PolylineLayer(polylines: _geoJsonParser.polylines),
          MarkerLayer(markers: _geoJsonParser.markers),
        ],
      ),
    );
  }
}
