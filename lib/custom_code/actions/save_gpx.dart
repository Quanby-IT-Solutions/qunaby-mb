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

import 'dart:convert';
import 'dart:typed_data';
import 'package:xml/xml.dart' as xml;

Future saveGpx(
  String taskId,
  String routeCoordinates,
  String trackLastCoord,
  String trackDateTime,
  String trackTotalArea,
  String trackTotalDistance,
) async {
  print('Starting saveGpx function');
  print('taskId: $taskId');

  if (taskId.isEmpty || routeCoordinates.isEmpty) {
    print('Invalid input: taskId or routeCoordinates is empty');
    return;
  }

  try {
    // Fetch farmer name and insurance ID
    final List<SelectPpirFormsRow> result =
        await SQLiteManager.instance.selectPpirForms(
      taskId: taskId,
    );

    String farmerName = '';
    String insuranceId = '';

    if (result.isNotEmpty) {
      farmerName = result[0].ppirFarmername ?? '';
      insuranceId = result[0].ppirInsuranceid ?? '';
      print('Farmer Name: $farmerName');
      print('Insurance ID: $insuranceId');
    } else {
      print('No insurance ID and farmer name found for taskId: $taskId');
    }

    // Generate GPX content
    print('Generating GPX content');
    final gpx = _generateGpx(routeCoordinates, insuranceId, farmerName);
    print('GPX content generated successfully');

    // Convert the GPX string to Uint8List
    print('Converting GPX to Uint8List');
    final Uint8List gpxBytes = Uint8List.fromList(utf8.encode(gpx));
    print('GPX converted to Uint8List successfully');

    // Encode GPX content as base64
    final String base64Gpx = base64Encode(gpxBytes);

    // Check if the app is online
    bool isOnline = FFAppState().ONLINE;

    // Save to local SQLite database
    print('Saving to local SQLite database');
    await SQLiteManager.instance.updatePPIRFormAfterGeotag(
      taskId: taskId,
      trackLastCoord: trackLastCoord,
      trackDateTime: trackDateTime,
      trackTotalArea: trackTotalArea,
      trackTotalDistance: trackTotalDistance,
      gpx: base64Gpx,
      isDirty: !isOnline,
    );

    print('Saved to local SQLite database successfully');

    // Only proceed with online saving if the app is online
    if (isOnline) {
      print('App is online. Proceeding with online saving');

      // Update the ppir_forms table with the provided values
      print('Updating ppir_forms table with provided values');
      await SupaFlow.client.from('ppir_forms').update({
        'gpx': base64Gpx,
        'track_last_coord': trackLastCoord,
        'track_date_time': trackDateTime,
        'track_total_area': trackTotalArea,
        'track_total_distance': trackTotalDistance,
      }).eq('task_id', taskId);

      print('ppir_forms table updated successfully with provided values');
    } else {
      print('App is offline. Skipping online saving.');
    }
  } catch (e) {
    print('Error in saveGpx function: $e');
  }
}

String _generateGpx(
    String routeCoordinates, String insuranceId, String farmerName) {
  print('Starting _generateGpx function');
  final builder = xml.XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('gpx', nest: () {
    builder.attribute('version', '1.1');
    builder.attribute('creator', 'PCIC-QUANBY');
    builder.attribute('xmlns', 'http://www.topografix.com/GPX/1/1');
    builder.element('trk', nest: () {
      builder.element('name', nest: '$insuranceId $farmerName');
      builder.element('trkseg', nest: () {
        final coordinates = routeCoordinates.split(' ');
        for (final coord in coordinates) {
          final latLon = coord.split(',');
          if (latLon.length == 2) {
            builder.element('trkpt', nest: () {
              builder.attribute('lat', latLon[0]);
              builder.attribute('lon', latLon[1]);
            });
          }
        }
      });
    });
  });
  print('GPX content generated');
  return builder.buildDocument().toXmlString(pretty: true);
}
