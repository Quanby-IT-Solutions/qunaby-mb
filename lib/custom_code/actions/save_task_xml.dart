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

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

Future<String> saveTaskXml(String? generatedTaskXml, String? taskId) async {
  print('Starting saveTaskXml function');
  if (generatedTaskXml == null || generatedTaskXml.isEmpty || taskId == null) {
    return 'Error: Invalid input';
  }

  try {
    //
    final taskResponse = await SupaFlow.client
        .from('tasks')
        .select('service_group, task_number, assignee')
        .eq('id', taskId)
        .single()
        .execute();

    if (taskResponse.status != 200 || taskResponse.data == null) {
      throw Exception('Error querying tasks table: ${taskResponse.status}');
    }

    final taskData = taskResponse.data as Map<String, dynamic>;
    final String serviceGroup = taskData['service_group'] ?? '';
    final String taskNumber = taskData['task_number'] ?? '';
    final String userEmail =
        SupaFlow.client.auth.currentUser?.email ?? taskData['assignee'] ?? '';

    if (userEmail.isEmpty) {
      throw Exception('Unable to get user email');
    }

    // Fetch the insurance ID from ppir_forms
    final ppirResponse = await SupaFlow.client
        .from('ppir_forms')
        .select('ppir_insuranceid')
        .eq('task_id', taskId)
        .single()
        .execute();

    if (ppirResponse.status != 200 || ppirResponse.data == null) {
      throw Exception(
          'Error querying ppir_forms table: ${ppirResponse.status}');
    }

    final String insuranceId = ppirResponse.data['ppir_insuranceid'] ?? '';

    // Find the latest folder for this task and insurance ID
    final String basePath = '$serviceGroup/$userEmail';
    final String folderPrefix = '${taskNumber}_$insuranceId';

    print('Searching for latest folder with basePath: $basePath');
    print('Folder prefix: $folderPrefix');

    final latestFolder = await findLatestFolder(basePath, folderPrefix);

    if (latestFolder == null) {
      print('No matching folder found for the task');
      throw Exception('No matching folder found for the task');
    }

    print('Latest folder found: $latestFolder');

    final String fileName = 'Task.xml';
    final String filePath = '$latestFolder/$fileName';

    final Uint8List xmlBytes =
        Uint8List.fromList(utf8.encode(generatedTaskXml));

    // Upload the new XML file to Supabase storage
    final response = await SupaFlow.client.storage.from('for_ftp').uploadBinary(
          filePath,
          xmlBytes,
          fileOptions: FileOptions(
            contentType: 'application/xml',
            upsert: true, // Use upsert to overwrite if file exists
          ),
        );

    if (response == null) {
      throw Exception('Error uploading XML file to Supabase');
    }

    // Save XML locally
    await _saveXmlLocally(latestFolder, fileName, generatedTaskXml);

    return 'XML saved successfully both in Supabase and locally';
  } catch (e) {
    print('Error in saveTaskXml function: $e');
    return 'Error: $e';
  }
}

Future<void> _saveXmlLocally(
    String folderPath, String fileName, String xmlContent) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final fullFolderPath = '${directory.path}/$folderPath';
    await Directory(fullFolderPath).create(recursive: true);
    final file = File('$fullFolderPath/$fileName');

    // Write new XML content
    await file.writeAsString(xmlContent);
    print('New XML file saved locally');
  } catch (e) {
    print('Error saving XML locally: $e');
  }
}
