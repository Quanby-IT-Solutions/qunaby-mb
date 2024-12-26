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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

// Additional imports
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future<String> uploadPhotoUrlToAsset(String? photoUrl) async {
  if (photoUrl == null || photoUrl.isEmpty) {
    print('Error: photoUrl is null or empty');
    return '';
  }

  try {
    // Download the image
    final response = await http.get(Uri.parse(photoUrl));
    if (response.statusCode != 200) {
      print('Error downloading image: ${response.statusCode}');
      return '';
    }

    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Create a new directory called 'assets' if it doesn't exist
    final assetDirectory = Directory('${directory.path}/assets');
    if (!await assetDirectory.exists()) {
      await assetDirectory.create(recursive: true);
    }

    // Create the file path
    final String filePath = '${assetDirectory.path}/local-user-image.png';

    // Write the image data to a file
    await File(filePath).writeAsBytes(response.bodyBytes);

    print('Image saved successfully at: $filePath');
    return filePath;
  } catch (e) {
    print('Error saving image: $e');
    return '';
  }
}
