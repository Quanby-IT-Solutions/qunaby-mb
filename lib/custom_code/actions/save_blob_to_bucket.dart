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
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

Future<String> saveBlobToBucket(String? taskId) async {
  if (taskId == null || taskId.isEmpty) {
    return 'Error: Invalid taskId';
  }

  try {
    // Fetch the task details
    final taskResponse = await SupaFlow.client
        .from('tasks')
        .select('service_group, task_number, assignee')
        .eq('id', taskId)
        .single()
        .execute();

    if (taskResponse.status != 200 || taskResponse.data == null) {
      return 'Error: Unable to fetch task details';
    }

    final taskData = taskResponse.data as Map<String, dynamic>;
    final String serviceGroup = taskData['service_group'] ?? '';
    final String taskNumber = taskData['task_number'] ?? '';
    final String userEmail =
        SupaFlow.client.auth.currentUser?.email ?? taskData['assignee'] ?? '';

    // Fetch the insurance ID from ppir_forms
    final ppirResponse = await SupaFlow.client
        .from('ppir_forms')
        .select('ppir_insuranceid')
        .eq('task_id', taskId)
        .single()
        .execute();

    if (ppirResponse.status != 200 || ppirResponse.data == null) {
      return 'Error: Unable to fetch insurance ID';
    }

    final String insuranceId = ppirResponse.data['ppir_insuranceid'] ?? '';

    // Get the current date and time
    final now = DateTime.now();
    final formattedDateTime = DateFormat('yyyyMMdd_HHmmss').format(now);

    // Define attachments folder path with insuranceId and timestamp included
    final String attachmentsPath =
        '$serviceGroup/$userEmail/${taskNumber}_${insuranceId}_$formattedDateTime/attachments/';

    // List existing files in the attachments folder
    final listResult = await SupaFlow.client.storage
        .from('for_ftp')
        .list(path: attachmentsPath);

    // Delete existing files in the attachments folder
    for (var file in listResult) {
      await SupaFlow.client.storage
          .from('for_ftp')
          .remove(['$attachmentsPath${file.name}']);
    }

    // Fetch the PPIR form data from SQLite
    final ppirForms =
        await SQLiteManager.instance.selectPpirForms(taskId: taskId);
    if (ppirForms.isEmpty) {
      return 'Error: PPIR form not found';
    }

    final ppirForm = ppirForms.first;
    final String? gpxBase64 = ppirForm.gpx;
    final String? insuredSignatureBase64 = ppirForm.ppirSigInsured;
    final String? iuiaSignatureBase64 = ppirForm.ppirSigIuia;
    final String? capturedArea = ppirForm.capturedArea;

    // Generate unique IDs for the files
    final uuid = Uuid();
    final String randomId = uuid.v4();

    // Define new file paths
    final String gpxPath = '${attachmentsPath}${randomId}.gpx';
    final String insuredSigPath =
        '${attachmentsPath}${randomId}_ppir_sig_insured.png';
    final String iuiaSigPath =
        '${attachmentsPath}${randomId}_ppir_sig_iuia.png';
    final String capturedAreaPath =
        '${attachmentsPath}${randomId}_captured_area.png';

    // Save GPX file
    if (gpxBase64 != null) {
      final Uint8List gpxBytes = base64.decode(gpxBase64);
      await SupaFlow.client.storage.from('for_ftp').uploadBinary(
            gpxPath,
            gpxBytes,
            fileOptions: FileOptions(contentType: 'application/gpx+xml'),
          );
    }

    // Save insured signature
    if (insuredSignatureBase64 != null) {
      final Uint8List insuredSigBytes = base64.decode(insuredSignatureBase64);
      await SupaFlow.client.storage.from('for_ftp').uploadBinary(
            insuredSigPath,
            insuredSigBytes,
            fileOptions: FileOptions(contentType: 'image/png'),
          );
    }

    // Save IUIA signature
    if (iuiaSignatureBase64 != null) {
      final Uint8List iuiaSigBytes = base64.decode(iuiaSignatureBase64);
      await SupaFlow.client.storage.from('for_ftp').uploadBinary(
            iuiaSigPath,
            iuiaSigBytes,
            fileOptions: FileOptions(contentType: 'image/png'),
          );
    }

    // Save Captured area
    if (capturedArea != null) {
      final Uint8List capturedAreaBytes = base64.decode(capturedArea);
      await SupaFlow.client.storage.from('for_ftp').uploadBinary(
            capturedAreaPath,
            capturedAreaBytes,
            fileOptions: FileOptions(contentType: 'image/png'),
          );
    }

    return 'success';
  } catch (e) {
    return 'Error: ${e.toString()}';
  }
}
