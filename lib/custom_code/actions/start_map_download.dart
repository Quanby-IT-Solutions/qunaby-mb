// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
import 'package:latlong2/latlong.dart' as ll;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show pi, cos;

Future<void> startMapDownload(String accessToken) async {
  bool serviceEnabled;
  LocationPermission permission;

  await FMTC.FMTCStore('mapStore').manage.create();

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are not enabled');
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied');
    return;
  }

  // Get the current position
  Position position = await Geolocator.getCurrentPosition();
  ll.LatLng currentLocation = ll.LatLng(position.latitude, position.longitude);

  double latDelta =
      100 / 111320; // 1 degree of latitude is approximately 111320 meters
  double lonDelta = 100 / (111320 * cos(currentLocation.latitude * pi / 180));

  LatLngBounds bounds = LatLngBounds(
    ll.LatLng(currentLocation.latitude - latDelta,
        currentLocation.longitude - lonDelta),
    ll.LatLng(currentLocation.latitude + latDelta,
        currentLocation.longitude + lonDelta),
  );

  final region = FMTC.RectangleRegion(bounds);
  final downloadableRegion = region.toDownloadable(
    minZoom: 16,
    maxZoom: 22, // Adjusted max zoom for faster download
    options: TileLayer(
      urlTemplate:
          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token=${accessToken}',
      additionalOptions: {
        'accessToken': accessToken,
        'id': 'mapbox/satellite-v9',
      },
    ),
  );

  await FMTC.FMTCStore('mapStore')
      .download
      .startForeground(
        region: downloadableRegion,
        parallelThreads: 15,
        maxBufferLength: 100,
        skipExistingTiles: true,
        skipSeaTiles: true,
        maxReportInterval: Duration(seconds: 1),
      )
      .listen((progress) {
    // Get the raw progress value
    double rawProgress = progress.percentageProgress;

    // Convert to a value between 0.0 and 1.0, keeping only the whole number part
    double normalizedProgress = (rawProgress.floor() / 100);

    // Only update if the progress has increased to the next whole percentage
    if (normalizedProgress > FFAppState().mapDownloadProgress ||
        normalizedProgress == 1.0) {
      // Assign the normalized progress value to mapDownloadProgress
      FFAppState().mapDownloadProgress = normalizedProgress;
      FFAppState().update(() {}); // Trigger UI update

      // Print both raw and normalized progress
      print('Raw progress: ${rawProgress.toStringAsFixed(2)}%');
      print(
          'Normalized progress: ${(normalizedProgress * 100).toStringAsFixed(0)}%');
    }

    // Check if download is complete
    if (progress.isComplete) {
      print('ey');
    }
  });
}
