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

Future<String> isDirty(String? taskId) async {
  if (taskId == null || taskId.isEmpty) {
    return 'false';
    // false
  }

  List<SelectPpirFormsRow> ppirList =
      await SQLiteManager.instance.selectPpirForms(taskId: taskId);

  if (ppirList.isEmpty) {
    return 'false';
  }

  var ppir = ppirList.first;
  var value = ppir.data['is_dirty'];

  print('value -> $value');

  if (value == 1 || value == true) {
    return 'true'; // Task is dirty
  } else if (value == 0 || value == false) {
    return 'false'; // Task is not dirty
  } else {
    return 'false'; // Default case for unexpected values
  }
}
