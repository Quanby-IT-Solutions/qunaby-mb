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

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';

Future successToast(
  BuildContext context,
  String title, // title of the notification
  String description, // description text in the notification
  int animationDuration, // duration in seconds
  int toastDuration,
) async {
  // see here that ElegantNotification without any 'dot something' in front
  ElegantNotification(
    title: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
    description: Text(
      description,
      style: TextStyle(
        fontSize: 9,
        color: Colors.white,
      ),
    ),
    animationDuration: Duration(milliseconds: animationDuration),
    toastDuration: Duration(milliseconds: toastDuration),
    icon: Icon(
      // you can specify which icon you want, here I am using Material icons Library
      Icons.check_circle_outline,
      color: Colors.white,
      size: 24,
    ),
    showProgressIndicator: false,
    background: Colors.green,
    width: 250,
    height: 60,
    closeButton: (dismiss) => ElevatedButton(
      onPressed: dismiss,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: const Icon(Icons.close, color: Colors.white),
    ),
  ).show(context);
}
