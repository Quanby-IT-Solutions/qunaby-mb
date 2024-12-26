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

Future cancelMapDownload() async {
  // Get an instance of your download task

  final store = FMTC.FMTCStore('mapStore');
  final isDownloading = await store.download.isPaused() == false;

  if (isDownloading) {
    // Cancel the download
    await store.download.cancel();
    print('Map download has been cancelled.');
  } else {
    print('No active map download to cancel.');
  }
}
