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

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
import 'package:latlong2/latlong.dart' as ll;

Future<void> downloadMap(BuildContext context, String? accessToken) async {
  if (accessToken == null) {
    print('Access token is null. Cannot proceed with map download.');
    return;
  }

  final String storeName =
      'AlbayRegion'; // Unique name for the Albay region store

  // Reduced set of coordinates for Albay region
  final albayRegion = FMTC.CustomPolygonRegion(
    [
      ll.LatLng(13.376564, 123.533997),
      ll.LatLng(13.52329, 123.6008),
      ll.LatLng(13.32355, 123.745071),
      ll.LatLng(13.23599, 123.831497),
      ll.LatLng(13.1181, 123.939972),
      ll.LatLng(12.98583, 123.768646),
      ll.LatLng(13.01038, 123.628693),
      ll.LatLng(12.98889, 123.480278),
      ll.LatLng(13.05416, 123.29805),
      ll.LatLng(13.26624, 123.275467),
      ll.LatLng(13.376564, 123.533997),
    ],
  );

  try {
    print('Creating store for Albay region...');
    await FMTC.FMTCStore(storeName).manage.create();

    print('Defining downloadable region...');
    final downloadableRegion = albayRegion.toDownloadable(
      minZoom: 12, // Reduced min zoom
      maxZoom: 18, // Reduced max zoom
      options: TileLayer(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token=$accessToken',
        additionalOptions: {
          'accessToken': accessToken,
          'id': 'mapbox/satellite-v9',
        },
      ),
    );

    print('Checking number of tiles...');
    final tileCount =
        await FMTC.FMTCStore(storeName).download.check(downloadableRegion);

    final estimatedSizeKB = tileCount * 20;
    final estimatedSizeMB = (estimatedSizeKB / 1024).toStringAsFixed(2);

    print(
        'Estimated download: $tileCount tiles, approximately $estimatedSizeMB MB');

    bool? shouldDownload = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Download'),
          content: Text(
              'Are you sure you want to download $tileCount tiles (approximately $estimatedSizeMB MB) for the Albay region?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldDownload == true) {
      print('Starting download...');
      await FMTC.FMTCStore(storeName)
          .download
          .startForeground(
            region: downloadableRegion,
            parallelThreads: 10, // Reduced number of threads
            maxBufferLength: 50, // Reduced buffer length
            skipExistingTiles: true,
            skipSeaTiles: true,
            maxReportInterval: Duration(seconds: 2),
            instanceId: DateTime.now().millisecondsSinceEpoch,
          )
          .listen((progress) {
        print('Download progress: ${progress.percentageProgress}%');
        if (progress.isComplete) {
          print('Map download completed for Albay region.');
        }
      });

      final actualSize = await FMTC.FMTCStore(storeName).stats.size;
      final actualSizeMB = (actualSize / 1024).toStringAsFixed(2);
      print('Actual download size: $actualSizeMB MB');
    } else {
      print('Map download cancelled by user.');
    }
  } catch (e) {
    print('Failed to download map: $e');
  }
}
