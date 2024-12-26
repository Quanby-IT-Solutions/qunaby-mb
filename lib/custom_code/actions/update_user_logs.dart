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

import '/auth/supabase_auth/auth_util.dart'; // for currentUserUid

Future updateUserLogs(BuildContext context) async {
  FFAppState().whatPage = GoRouterState.of(context).uri.toString();
  print('${FFAppState().whatPage}');
// // Check if there is an auth user using 'currentUserUid'
//   if (currentUserUid != null) {
//     // Print the current app's page using FFAppState
//     // print('Current route: ${FFAppState().currentPage}');

//     // Check if FFAppState.ONLINE because later we will use this to update something in the DB
//     if (FFAppState().ONLINE) {
//       // Add your logic here to update the database or perform other actions
//       print('User is online, ready to update the database.');
//     } else {
//       print('User is offline, no updates will be made.');
//     }
//   } else {
//     print('No authenticated user found.');
//   }

  // // Initialize route listener to get the current route
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   // Listen for changes to the router delegate's current configuration
  //   final router = Router.of(context).routerDelegate;
  //   router.addListener(() {
  //     final currentRoute =
  //         router.currentConfiguration?.toString() ?? 'Unknown Route';
  //     // Update the FFAppState with the current route
  //     FFAppState().updateCurrentPage(currentRoute);
  //     print('Current route: $currentRoute');
  //   });
  // });
}
