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

Future<bool> checkPasswordStrength(String newPassword) async {
  // Example criteria: minimum 8 characters, includes a number and a special character
  final hasMinLength = newPassword.length >= 8;
  final hasNumber = newPassword.contains(RegExp(r'[0-9]'));
  final hasSpecialChar =
      newPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  return hasMinLength && hasNumber && hasSpecialChar;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
