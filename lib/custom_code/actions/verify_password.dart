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

// Verify Password

import 'dart:convert';

Future<bool> verifyPassword(String currentPassword) async {
  // Assuming the user is already authenticated
  final response = await SupaFlow.client.rpc('verify_user_password', params: {
    'password': currentPassword,
  });

  // Check if the response data is true
  if (response == true) {
    return true;
  } else {
    return false;
  }
  // ba
}
