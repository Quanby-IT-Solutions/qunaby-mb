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

// // Automatic FlutterFlow imports
// import '/backend/schema/structs/index.dart';
// import '/backend/supabase/supabase.dart';
// import '/backend/sqlite/sqlite_manager.dart';
// import '/actions/actions.dart' as action_blocks;
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import 'index.dart'; // Imports other custom actions
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom action code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// Future<void> fetchProcessAndExportStores() async {
//   print('Starting fetchProcessAndExportStores function...');

//   try {
//     // Step 1: Fetch statistics and store data.
//     print('Initializing FMTC stats...');
//     final stats = FMTC.FMTCRoot.stats;
//     print('Fetching storesAvailable from FMTC...');

//     final storesAvailable = await stats.storesAvailable;
//     print('Number of stores available: ${storesAvailable.length}');

//     // Step 2: Handle case with no stores.
//     if (storesAvailable.isEmpty) {
//       print('No stores available. Exiting function.');
//       return;
//     }

//     // Step 3: Process each store and print its name.
//     print('Processing available stores...');
//     List<String> storeNames = [];

//     for (int i = 0; i < storesAvailable.length; i++) {
//       print('Processing store ${i + 1} of ${storesAvailable.length}...');
//       final store = storesAvailable[i];
//       String rawStoreName = store.storeName;
//       print('Raw store name: $rawStoreName');
//       storeNames.add(rawStoreName);
//       print('Store ${i + 1} processed and added to the list.');
//     }

//     print('All stores processed. Total stores in list: ${storeNames.length}');

//     // Step 4: Export the store data to a specified path.
//     print('Retrieving external storage directory...');
//     final directory =
//         await getExternalStorageDirectory(); // For Android-specific path.
//     final exportPath = '${directory?.path}/exported_tiles.fmtc';
//     print('Export path determined: $exportPath');

//     print('Starting export process...');
//     // Use the correct method for exporting, specifying the path and the stores.
//     final rootExternal = FMTC.FMTCRoot.external(pathToArchive: exportPath);

//     // Call the export method with the required storeNames parameter.
//     await rootExternal.export(storeNames: storeNames);

//     print('Tiles exported successfully to: $exportPath');
//   } catch (e) {
//     print('Error during fetching, processing, or exporting stores: $e');
//   }

//   print('fetchProcessAndExportStores function completed.');
// }

import 'index.dart'; // Imports other custom actions

import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> fetchProcessAndExportStores() async {
  print('Starting fetchProcessAndExportStores function...');

  try {
    // Step 1: Fetch statistics and store data.
    print('Initializing FMTC stats...');
    final stats = FMTC.FMTCRoot.stats;
    print('Fetching storesAvailable from FMTC...');

    final storesAvailable = await stats.storesAvailable;
    print('Number of stores available: ${storesAvailable.length}');

    // Step 2: Handle case with no stores.
    if (storesAvailable.isEmpty) {
      print('No stores available. Exiting function.');
      return;
    }

    // Step 3: Process each store and print its name.
    print('Processing available stores...');
    List<String> storeNames = [];

    for (int i = 0; i < storesAvailable.length; i++) {
      print('Processing store ${i + 1} of ${storesAvailable.length}...');
      final store = storesAvailable[i];
      String rawStoreName = store.storeName;
      print('Raw store name: $rawStoreName');
      storeNames.add(rawStoreName);
      print('Store ${i + 1} processed and added to the list.');
    }

    print('All stores processed. Total stores in list: ${storeNames.length}');

    // Step 4: Export the store data to a specified path.
    print('Retrieving external storage directory...');
    final directory =
        await getExternalStorageDirectory(); // For Android-specific path.
    final exportPath = '${directory?.path}/exported_tiles.fmtc';
    print('Export path determined: $exportPath');

    print('Starting export process...');
    final rootExternal = FMTC.FMTCRoot.external(pathToArchive: exportPath);
    await rootExternal.export(storeNames: storeNames);
    print('Tiles exported successfully to: $exportPath');

    // Step 5: Upload the exported file to Supabase storage.
    print('Starting upload to Supabase...');
    final supabase = Supabase.instance.client;
    final file = File(exportPath);
    final fileName = 'exported_tiles.fmtc';

    final response = await supabase.storage.from('map-tiles').upload(
          fileName,
          file,
          fileOptions: FileOptions(
            cacheControl: '3600', // Optional: Cache control setting
            upsert: true, // Optional: Overwrite if file already exists
          ),
        );

    // Check if the response is a String (path of the uploaded file)
    if (response is String) {
      print('File uploaded successfully to Supabase: $response');
    } else {
      print(
          'Error uploading file to Supabase: Upload failed with response: $response');
    }
  } catch (e) {
    print(
        'Error during fetching, processing, exporting, or uploading stores: $e');
  }

  print('fetchProcessAndExportStores function completed.');
}
