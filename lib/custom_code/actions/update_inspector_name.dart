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

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> updateInspectorName(String newName) async {
  final supabase = Supabase.instance.client;

  try {
    // Get the current user's ID
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    // Update the inspector_name in the users table
    final response = await supabase
        .from('users')
        .update({'inspector_name': newName}).eq('id', user.id);

    // Fetch the updated user data to confirm the change
    final updatedUser =
        await supabase.from('users').select().eq('id', user.id).single();

    print('Updated user data: $updatedUser');
    print('Inspector name updated successfully');
  } catch (error) {
    print('Error updating inspector name: $error');
    // You might want to show an error message to the user here
    rethrow; // Rethrow the error so it can be handled by the caller if needed
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
