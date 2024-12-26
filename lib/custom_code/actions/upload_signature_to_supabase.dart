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

Future<String?> uploadSignatureToSupabase(String? base64Signature) async {
  // if (base64Signature == null) return null;

  // Convert base64 string to byte data
  // final bytes = base64.decode(base64Signature);

  // Define the bucket and file path where the signature will be stored
  // const bucketName = 'signature';
  // const fileName = 'signature-${DateTime.now().millisecondsSinceEpoch}.png';

  // Use the existing Supabase client from your imports
  // final response = await Supabase.instance.client.storage
  // .from(bucketName)
  // .uploadBinary(fileName, bytes);

  // Check if the upload was successful
  // if (response.error != null) {
  // print('Failed to upload signature: ${response.error!.message}');
  // return null;
  //  }

  // Return the file path of the uploaded file, or you can construct a URL to return instead
  // return fileName;
  return '';
}
