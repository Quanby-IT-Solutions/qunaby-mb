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

Future<String> getGpxLink(String? taskId) async {
  if (taskId == null || taskId.isEmpty) {
    return '';
  }

  try {
    // Query the tasks table to get service_group and task_number
    final taskResponse = await SupaFlow.client
        .from('tasks')
        .select('service_group, task_number, assignee')
        .eq('id', taskId)
        .single()
        .execute();

    if (taskResponse.status != 200 || taskResponse.data == null) {
      throw Exception('Error querying tasks table: ${taskResponse.status}');
    }

    final taskData = taskResponse.data as Map;
    final String serviceGroup = taskData['service_group'] ?? '';
    final String taskNumber = taskData['task_number'] ?? '';

    // Get the current user's email
    final currentUser = SupaFlow.client.auth.currentUser;
    final String userEmail = currentUser?.email ?? taskData['assignee'] ?? '';

    if (userEmail.isEmpty) {
      throw Exception('Unable to get user email');
    }

    // Define the folder path in the bucket
    final folderPath = '$serviceGroup/$userEmail/$taskNumber/attachments/';
    print('Supabase folder path: $folderPath');

    // List files in the folder
    final listResponse =
        await SupaFlow.client.storage.from('for_ftp').list(path: folderPath);

    // Filter for GPX files
    final gpxFiles =
        listResponse.where((file) => file.name.toLowerCase().endsWith('.gpx'));

    if (gpxFiles.isEmpty) {
      throw Exception('No GPX file found in the specified folder');
    }

    // Get the first GPX file
    final firstGpxFile = gpxFiles.first;
    final filePath = '$folderPath${firstGpxFile.name}';

    // Get the download URL
    final String downloadUrl = await SupaFlow.client.storage
        .from('for_ftp')
        .createSignedUrl(filePath, 3600); // URL valid for 1 hour

    print('GPX download URL: $downloadUrl');
    return downloadUrl;
  } catch (e) {
    print('Error in getGpxLink: $e');
    return '';
  }
}
