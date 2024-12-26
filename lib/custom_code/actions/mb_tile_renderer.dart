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

import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future<void> mbTileRenderer(BuildContext context) async {
  try {
    // Step 1: Pick the MBTiles file from the user's device
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mbtiles'],
    );

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      File mbTilesFile = File(filePath);

      // You can now use mbTilesFile to read the content or process further.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File selected: ${mbTilesFile.path}')),
      );
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File picking was canceled.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
