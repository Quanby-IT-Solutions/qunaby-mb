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

import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<FFUploadedFile> getTheSavedLocalProfile() async {
  try {
    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Construct the path to the saved image
    final String filePath = '${directory.path}/assets/local-user-image.png';

    // Check if the file exists
    final file = File(filePath);
    if (!await file.exists()) {
      print('Error: Local profile image not found');
      return FFUploadedFile(bytes: Uint8List(0), name: '');
    }

    // Read the file as bytes
    final bytes = await file.readAsBytes();

    // Create and return an FFUploadedFile
    return FFUploadedFile(
      bytes: bytes,
      name: 'local-user-image.png',
    );
  } catch (e) {
    print('Error getting local profile image: $e');
    return FFUploadedFile(bytes: Uint8List(0), name: '');
  }
}
