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

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:io';

// for testing only -> https://www.youtube.com/watch?v=HeBmkKREzdw, this vid may fail but i modify it
// Future connected() async {
//   return;
// }

Future connected() async {
  StreamSubscription<List<ConnectivityResult>>? subscription;
  subscription = Connectivity()
      .onConnectivityChanged
      .listen((List<ConnectivityResult> result) async {
    // Got a new connectivity status!

    bool hasConnection = await checkConnection();

    //print("Connection: ${hasConnection}");

    FFAppState().update(() {
      // in app state, i have ONLINE which is a boolean to be utilized here
      FFAppState().ONLINE = hasConnection;
    });
    FFAppState().notifyListeners();
  });
}

Future<bool> checkConnection() async {
  bool hasConnection = false;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      hasConnection = true;
    } else {
      hasConnection = false;
    }
  } on SocketException catch (_) {
    hasConnection = false;
  }

  return hasConnection;
}
