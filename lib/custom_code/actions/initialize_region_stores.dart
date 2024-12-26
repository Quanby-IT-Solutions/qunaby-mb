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

import 'index.dart'; // Imports other custom actions

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;

Future<void> initializePhilippinesRegionStores() async {
  // Read the JSON file from assets
  String jsonString =
      await rootBundle.loadString('assets/jsons/regionBoundaries.json');
  List<dynamic> regions = json.decode(jsonString);

  // Iterate over each region and save their metadata as stores
  for (var feature in regions) {
    String? region = feature['Region'] as String?;
    double? minLat = feature['min_lat'] as double?;
    double? maxLat = feature['max_lat'] as double?;
    double? minLon = feature['min_lon'] as double?;
    double? maxLon = feature['max_lon'] as double?;
    double? centreLat = feature['centre_lat'] as double?;
    double? centreLon = feature['centre_lon'] as double?;

    // Ensure that all necessary values are present
    if (region == null ||
        minLat == null ||
        maxLat == null ||
        minLon == null ||
        maxLon == null ||
        centreLat == null ||
        centreLon == null) {
      print('Skipping feature with missing data for region $region.');
      continue;
    }

    String storeName = region.replaceAll(' ', '_').toLowerCase();
    final mgmt = FMTC.FMTCStore(storeName).manage;

    try {
      await mgmt.create();
      print('Store created successfully for $region');

      // Set metadata for the region's bounding box and center
      await FMTC.FMTCStore(storeName).metadata.setBulk(kvs: {
        'minLat': minLat.toString(),
        'maxLat': maxLat.toString(),
        'minLon': minLon.toString(),
        'maxLon': maxLon.toString(),
        'centreLat': centreLat.toString(),
        'centreLon': centreLon.toString(),
      });
      print('Bounding box metadata set for $region');
    } catch (e) {
      print('Error processing $region: $e');
    }
  }
}

Future<void> initializeRegionStores() async {
  await initializePhilippinesRegionStores();
}
