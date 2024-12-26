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

Future<String> convertCapturedImageToBase64(FFUploadedFile? uploaded) async {
  if (uploaded == null || uploaded.bytes == null) {
    throw Exception("No file uploaded.");
  }

  // Convert the bytes to a Base64 encoded string.
  return base64Encode(uploaded.bytes!);
}
