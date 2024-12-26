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

Future<String?> findLatestFolder(
  String basePath,
  String folderPrefix,
) async {
  //
  try {
    print('Searching for folders in basePath: $basePath');
    print('Looking for folder prefix: $folderPrefix');

    final listResult =
        await SupaFlow.client.storage.from('for_ftp').list(path: basePath);
    print('Found ${listResult.length} items in the basePath');

    String latestFolder = '';
    DateTime latestTimestamp = DateTime(1970); // Start with a very old date

    for (var item in listResult) {
      print('Examining item: ${item.name}');
      if (item.name.startsWith(folderPrefix)) {
        print('Item matches prefix: ${item.name}');
        final parts = item.name.split('_');
        if (parts.length >= 4) {
          final dateStr = parts[2];
          final timeStr =
              parts[3].split('/')[0]; // Remove trailing slash if present
          print('Extracted date: $dateStr, time: $timeStr');
          if (dateStr.length == 8 && timeStr.length == 6) {
            try {
              final timestamp = DateTime.parse('$dateStr $timeStr');
              print('Parsed timestamp: $timestamp');
              if (timestamp.isAfter(latestTimestamp)) {
                latestTimestamp = timestamp;
                latestFolder = '$basePath/${item.name}';
                print('New latest folder: $latestFolder');
              }
            } catch (e) {
              print('Error parsing date/time: $e');
            }
          } else {
            print('Invalid date/time format: $dateStr $timeStr');
          }
        } else {
          print('Not enough parts in the folder name: ${parts.length}');
        }
      } else {
        print('Item does not match prefix: ${item.name}');
      }
    }

    if (latestFolder.isNotEmpty) {
      print('Returning latest folder: $latestFolder');
      return latestFolder;
    } else {
      print('No matching folder found');
      return null;
    }
  } catch (e) {
    print('Error finding latest folder: $e');
    return null;
  }
}
