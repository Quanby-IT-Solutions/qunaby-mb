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

import '/auth/supabase_auth/auth_util.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'dart:io';

class FTPSyncException implements Exception {
  final String message;
  final dynamic originalError;
  FTPSyncException(this.message, [this.originalError]);
  @override
  String toString() =>
      'FTPSyncException: $message${originalError != null ? '\nOriginal error: $originalError' : ''}';
}

String convertStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'for dispatch':
    case 'pending':
      return 'for dispatch';
    case 'in progress':
    case 'ongoing':
      return 'ongoing';
    case 'completed':
      return 'completed';
    case 'cancelled':
      return 'cancelled';
    default:
      return 'for dispatch';
  }
}

String convertPriority(String? priority) {
  switch (priority?.toLowerCase()) {
    case 'low':
      return 'Low Priority';
    case 'medium':
      return 'Normal Priority';
    case 'high':
      return 'High Priority';
    case 'urgent':
      return 'Urgent Priority';
    default:
      return 'Normal Priority';
  }
}

Future<bool> syncFromFTP(String? region) async {
  if (region == null) {
    debugPrint('Error: Region is null');
    return false;
  }

  FTPConnect? ftpClient;
  File? tempFile;
  int newTasksCount = 0;
  int newPPIRFormsCount = 0;
  final Set<String> processedFiles = {};

  try {
    debugPrint("Starting sync for region -> $region");

    String numericPart = region
        .replaceAll(RegExp(r'^[POpo]+'), '')
        .replaceAll(RegExp(r'[^\d]+.*$'), '');

    String transformedRegionCode = 'P${numericPart.padLeft(2, '0')}';
    String originalRegionCode = region;

    debugPrint("originalRegionCode -> $originalRegionCode");
    debugPrint("transformedRegionCode -> $transformedRegionCode");

    final ftpServers = [
      {
        'host': '103.82.46.134',
        'user': 'k2c_User1',
        'pass': 'K2c#%!pc!c',
        'port': 21
      },
      {
        'host': '122.55.242.110',
        'user': 'k2c_User1',
        'pass': 'K2c#%!pc!c',
        'port': 21
      },
    ];

    final userQuery = await executeWithRetry(
      operation: () => UsersTable()
          .queryRows(queryFn: (q) => q.eq('email', currentUserEmail)),
      operationName: 'User query',
    );

    if (userQuery.isEmpty) return false;
    final currentUserId = userQuery.first.id;

    final regionQuery = await executeWithRetry(
      operation: () => RegionsTable()
          .queryRows(queryFn: (q) => q.eq('region_code', originalRegionCode)),
      operationName: 'Region query',
    );

    if (regionQuery.isEmpty) return false;
    final regionName = regionQuery.first.regionName + ' PPIR';

    bool connected = false;
    List<String> connectionErrors = [];

    for (var server in ftpServers) {
      try {
        ftpClient = FTPConnect(
          server['host'] as String,
          user: server['user'] as String,
          pass: server['pass'] as String,
          port: server['port'] as int?,
        );

        await Future.any([
          ftpClient!.connect(),
          Future.delayed(const Duration(seconds: 15)).then(
              (_) => throw Exception('Connection timed out after 15 seconds')),
        ]);

        await ftpClient.currentDirectory();
        connected = true;
        debugPrint('Successfully connected to ${server['host']}');
        break;
      } catch (e) {
        final errorMsg =
            'Failed to connect to ${server['host']}: ${e.toString()}';
        connectionErrors.add(errorMsg);
        debugPrint(errorMsg);
        await safeDisconnect(ftpClient);
        ftpClient = null;
        await Future.delayed(const Duration(seconds: 2));
        continue;
      }
    }

    if (!connected) {
      throw FTPSyncException(
          'Failed to connect to all FTP servers', connectionErrors);
    }

    try {
      await ftpClient!.changeDirectory('/Work');
    } catch (e) {
      throw FTPSyncException('Failed to access /Work directory', e);
    }

    List<FTPEntry> files;
    try {
      files = await ftpClient.listDirectoryContent();
    } catch (e) {
      throw FTPSyncException('Failed to list directory content', e);
    }

    final filesToProcess = files
        .where((file) =>
            file.name.startsWith('$transformedRegionCode RICE Region') &&
            file.name.endsWith('.csv'))
        .map((file) => file.name)
        .toList();

    if (filesToProcess.isEmpty) return false;

    for (final filename in filesToProcess) {
      if (processedFiles.contains(filename)) continue;

      tempFile = File('${Directory.systemTemp.path}/$filename');
      bool downloadSuccess = false;

      try {
        downloadSuccess = await executeWithRetry(
          operation: () => ftpClient!.downloadFile(filename, tempFile!),
          operationName: 'File download',
        );

        if (!downloadSuccess) continue;

        final contents = await tempFile.readAsString();
        List<List<dynamic>> rows =
            const CsvToListConverter().convert(contents, eol: '\n');

        if (rows.isEmpty) continue;

        List<String> headers = rows.first.map((e) => e.toString()).toList();
        int assigneeIndex = headers.indexOf('Assignee');

        if (assigneeIndex == -1) continue;

        for (var row in rows.skip(1)) {
          if (row.length <= assigneeIndex) continue;

          final assigneeEmail =
              row[assigneeIndex].toString().trim().toLowerCase();
          if (assigneeEmail != currentUserEmail.trim().toLowerCase()) continue;

          final taskNumber = getTaskNumber(row, headers);

          if (await checkTaskExists(taskNumber, currentUserId)) continue;

          String taskId = const Uuid().v4();
          Map<String, dynamic> rowMap = Map.fromIterables(headers, row);
          final now = DateTime.now().toIso8601String();

          await TasksTable().insert({
            'id': taskId,
            'task_number': taskNumber,
            'service_group': originalRegionCode,
            'service_type': regionName,
            'priority': convertPriority(rowMap['Priority']?.toString()),
            'assignee': currentUserId,
            'date_added': now,
            'date_access': now,
            'status': convertStatus(rowMap['Task Status']?.toString()),
            'task_type': 'ppir',
            'attempt_count': 0,
            'created_at': now,
            'updated_at': now,
            'is_deleted': false,
            'sync_status': 'not_synced',
            'is_dirty': true,
            'is_updating': false,
            'active': true,
          });

          await SQLiteManager.instance.insertOfflineTask(
            id: taskId,
            taskNumber: taskNumber,
            serviceGroup: originalRegionCode,
            status: convertStatus(rowMap['Task Status']?.toString()),
            serviceType: regionName,
            priority: convertPriority(rowMap['Priority']?.toString()),
            assignee: currentUserId,
            dateAdded: now,
            dateAccess: now,
            fileId: filename,
          );

          await PpirFormsTable().insert({
            'task_id': taskId,
            'ppir_assignmentid': rowMap['ppir_assignmentid']?.toString() ?? '',
            'ppir_insuranceid': rowMap['ppir_insuranceid']?.toString() ?? '',
            'ppir_farmername': rowMap['ppir_farmername']?.toString() ?? '',
            'ppir_address': rowMap['ppir_address']?.toString() ?? '',
            'ppir_farmertype': rowMap['ppir_farmertype']?.toString() ?? '',
            'ppir_mobileno': rowMap['ppir_mobileno']?.toString() ?? '',
            'ppir_groupname': rowMap['ppir_groupname']?.toString() ?? '',
            'ppir_groupaddress': rowMap['ppir_groupaddress']?.toString() ?? '',
            'ppir_lendername': rowMap['ppir_lendername']?.toString() ?? '',
            'ppir_lenderaddress':
                rowMap['ppir_lenderaddress']?.toString() ?? '',
            'ppir_cicno': rowMap['ppir_cicno']?.toString() ?? '',
            'ppir_farmloc': rowMap['ppir_farmloc']?.toString() ?? '',
            'ppir_north': rowMap['ppir_north']?.toString() ?? '',
            'ppir_south': rowMap['ppir_south']?.toString() ?? '',
            'ppir_east': rowMap['ppir_east']?.toString() ?? '',
            'ppir_west': rowMap['ppir_west']?.toString() ?? '',
            'ppir_area_aci': rowMap['ppir_area_aci']?.toString() ?? '',
            'ppir_area_act': rowMap['ppir_area_act']?.toString() ?? '',
            'ppir_dopds_aci': rowMap['ppir_dopds_aci']?.toString() ?? '',
            'ppir_dopds_act': rowMap['ppir_dopds_act']?.toString() ?? '',
            'ppir_doptp_aci': rowMap['ppir_doptp_aci']?.toString() ?? '',
            'ppir_doptp_act': rowMap['ppir_doptp_act']?.toString() ?? '',
            'ppir_svp_aci': rowMap['ppir_svp_aci']?.toString() ?? '',
            'ppir_svp_act': 'rice',
            'ppir_variety': rowMap['ppir_variety']?.toString() ?? '',
            'ppir_stagecrop': rowMap['ppir_stagecrop']?.toString() ?? '',
            'created_at': now,
            'updated_at': now,
            'sync_status': 'not_synced',
            'is_dirty': true,
          });

          newPPIRFormsCount++;
          newTasksCount++;
        }

        processedFiles.add(filename);
      } catch (e) {
        debugPrint('Error processing file $filename: $e');
        continue;
      } finally {
        await safeDeleteFile(tempFile);
      }
    }

    if (newTasksCount > 0) {
      FFAppState().syncCount += newTasksCount;
    }

    return processedFiles.isNotEmpty;
  } catch (e) {
    debugPrint('Critical error in syncFromFTP: $e');
    return false;
  } finally {
    await safeDisconnect(ftpClient);
  }
}

Future<T> executeWithRetry<T>({
  required Future<T> Function() operation,
  required String operationName,
  int maxAttempts = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  int attempts = 0;
  while (attempts < maxAttempts) {
    try {
      return await operation();
    } catch (e) {
      attempts++;
      if (attempts == maxAttempts) rethrow;
      debugPrint('Attempt $attempts failed for $operationName: $e');
      await Future.delayed(delay * attempts);
    }
  }
  throw FTPSyncException('All retry attempts failed for $operationName');
}

Future<void> safeDisconnect(FTPConnect? client) async {
  if (client != null) {
    try {
      await client.disconnect();
    } catch (e) {
      debugPrint('Error during FTP disconnect: $e');
    }
  }
}

Future<void> safeDeleteFile(File? file) async {
  if (file != null && await file.exists()) {
    try {
      await file.delete();
    } catch (e) {
      debugPrint('Error deleting temporary file: $e');
    }
  }
}

String getTaskNumber(List<dynamic> row, List<String> headers) {
  final taskNumberIndex = headers.indexOf('Task Number');
  final ppirAssignmentIdIndex = headers.indexOf('ppir_assignmentid');

  if (taskNumberIndex != -1 &&
      row[taskNumberIndex]?.toString().trim().isNotEmpty == true) {
    return row[taskNumberIndex].toString().trim();
  } else if (ppirAssignmentIdIndex != -1) {
    return 'PPIR-${row[ppirAssignmentIdIndex]?.toString() ?? ''}';
  } else {
    return 'PPIR-${const Uuid().v4()}';
  }
}

Future<bool> checkTaskExists(String taskNumber, String currentUserId) async {
  try {
    final onlineTasks = await TasksTable()
        .queryRows(queryFn: (q) => q.eq('task_number', taskNumber));
    final offlineTasks = await SQLiteManager.instance
        .oFFLINESelectAllTasksByAssignee(assignee: currentUserId);
    return onlineTasks.isNotEmpty ||
        offlineTasks.any((task) => task.taskNumber == taskNumber);
  } catch (e) {
    throw FTPSyncException('Failed to check existing tasks', e);
  }
}

// working, but infinite loop if 2 ftp does not work
// import '/auth/supabase_auth/auth_util.dart';
// import 'package:ftpconnect/ftpconnect.dart';
// import 'package:csv/csv.dart';
// import 'dart:convert';
// import 'package:uuid/uuid.dart';
// import 'dart:io';

// Future<bool> syncFromFTP(String? region) async {
//   if (region == null) return false;
//   debugPrint("region -> $region");

//   String numericPart = region
//       .replaceAll(RegExp(r'^[POpo]+'), '')
//       .replaceAll(RegExp(r'[^\d]+.*$'), '');

//   String transformedRegionCode = 'P${numericPart.padLeft(2, '0')}';

//   String originalRegionCode = region;
//   debugPrint("originalRegionCode -> $originalRegionCode");
//   debugPrint("transformedRegionCode -> $transformedRegionCode");

//   FTPConnect? ftpClient;
//   int newTasksCount = 0;
//   int newPPIRFormsCount = 0;

//   final ftpServers = [
//     {
//       'host': '103.82.46.134',
//       'user': 'k2c_User1',
//       'pass': 'K2c#%!pc!c',
//       'port': 21
//     },
//     {
//       'host': '122.55.242.110',
//       'user': 'k2c_User1',
//       'pass': 'K2c#%!pc!c',
//       'port': 21
//     },
//   ];

//   try {
//     final userQuery = await UsersTable()
//         .queryRows(queryFn: (q) => q.eq('email', currentUserEmail));
//     if (userQuery.isEmpty) return false;
//     final currentUserId = userQuery.first.id;

//     final regionQuery = await RegionsTable()
//         .queryRows(queryFn: (q) => q.eq('region_code', originalRegionCode));
//     if (regionQuery.isEmpty) return false;
//     final regionName = regionQuery.first.regionName + ' PPIR';

//     bool connected = false;
//     for (var server in ftpServers) {
//       try {
//         ftpClient = FTPConnect(
//           server['host'] as String,
//           user: server['user'] as String,
//           pass: server['pass'] as String,
//           port: server['port'] as int?,
//         );
//         await ftpClient.connect();
//         connected = true;
//         break;
//       } catch (e) {
//         continue;
//       }
//     }

//     if (!connected) return false;

//     await ftpClient!.changeDirectory('/Work');

//     List<FTPEntry> files = await ftpClient.listDirectoryContent();
//     final filesToProcess = files
//         .where((file) =>
//             file.name.startsWith('$transformedRegionCode RICE Region') &&
//             file.name.endsWith('.csv'))
//         .map((file) => file.name)
//         .toList();

//     if (filesToProcess.isEmpty) return false;

//     for (final filename in filesToProcess) {
//       File tempFile = File('${Directory.systemTemp.path}/$filename');
//       bool downloadSuccess = await ftpClient.downloadFile(filename, tempFile);
//       if (!downloadSuccess) continue;

//       final contents = await tempFile.readAsString();
//       List<List<dynamic>> rows =
//           const CsvToListConverter().convert(contents, eol: '\n');
//       List<String> headers = rows.first.map((e) => e.toString()).toList();
//       int assigneeIndex = headers.indexOf('Assignee');

//       if (assigneeIndex != -1) {
//         List<Map<String, dynamic>> filteredRows = rows
//             .skip(1)
//             .where((row) =>
//                 row.length > assigneeIndex &&
//                 row[assigneeIndex].toString().trim().toLowerCase() ==
//                     currentUserEmail.trim().toLowerCase())
//             .map((row) => Map.fromIterables(headers, row))
//             .toList();

//         for (var row in filteredRows) {
//           String taskNumber = row['Task Number']?.toString().trim() ??
//               'PPIR-${row['ppir_assignmentid']?.toString() ?? ''}';
//           var onlineTasks = await TasksTable()
//               .queryRows(queryFn: (q) => q.eq('task_number', taskNumber));
//           var offlineTasks = await SQLiteManager.instance
//               .oFFLINESelectAllTasksByAssignee(assignee: currentUserId);

//           bool taskExists = onlineTasks.isNotEmpty ||
//               offlineTasks.any((task) => task.taskNumber == taskNumber);
//           if (!taskExists) {
//             String taskId = const Uuid().v4();

//             await TasksTable().insert({
//               'id': taskId,
//               'task_number': taskNumber,
//               'service_group': originalRegionCode,
//               'status':
//                   row['Task Status']?.toString().toLowerCase() ?? 'pending',
//               'service_type': regionName,
//               'priority': row['Priority']?.toString() ?? 'medium',
//               'assignee': currentUserId,
//               'date_added': DateTime.now().toIso8601String(),
//               'date_access': DateTime.now().toIso8601String(),
//               'task_type': 'ppir',
//             });

//             await SQLiteManager.instance.insertOfflineTask(
//               id: taskId,
//               taskNumber: taskNumber,
//               serviceGroup: originalRegionCode,
//               status: row['Task Status']?.toString().toLowerCase() ?? 'pending',
//               serviceType: regionName,
//               priority: row['Priority']?.toString() ?? 'medium',
//               assignee: currentUserId,
//               dateAdded: DateTime.now().toIso8601String(),
//               dateAccess: DateTime.now().toIso8601String(),
//               fileId: filename,
//             );

//             await PpirFormsTable().insert({
//               'task_id': taskId,
//               'ppir_assignmentid': row['ppir_assignmentid']?.toString() ?? '',
//               'ppir_insuranceid': row['ppir_insuranceid']?.toString() ?? '',
//               'ppir_farmername': row['ppir_farmername']?.toString() ?? '',
//               'ppir_address': row['ppir_address']?.toString() ?? '',
//               'ppir_farmertype': row['ppir_farmertype']?.toString() ?? '',
//               'ppir_mobileno': row['ppir_mobileno']?.toString() ?? '',
//               'ppir_groupname': row['ppir_groupname']?.toString() ?? '',
//               'ppir_groupaddress': row['ppir_groupaddress']?.toString() ?? '',
//               'ppir_lendername': row['ppir_lendername']?.toString() ?? '',
//               'ppir_lenderaddress': row['ppir_lenderaddress']?.toString() ?? '',
//               'ppir_cicno': row['ppir_cicno']?.toString() ?? '',
//               'ppir_farmloc': row['ppir_farmloc']?.toString() ?? '',
//               'ppir_north': row['ppir_north']?.toString() ?? '',
//               'ppir_south': row['ppir_south']?.toString() ?? '',
//               'ppir_east': row['ppir_east']?.toString() ?? '',
//               'ppir_west': row['ppir_west']?.toString() ?? '',
//               'ppir_area_aci': row['ppir_area_aci']?.toString() ?? '',
//               'ppir_area_act': row['ppir_area_act']?.toString() ?? '',
//               'ppir_dopds_aci': row['ppir_dopds_aci']?.toString() ?? '',
//               'ppir_dopds_act': row['ppir_dopds_act']?.toString() ?? '',
//               'ppir_doptp_aci': row['ppir_doptp_aci']?.toString() ?? '',
//               'ppir_doptp_act': row['ppir_doptp_act']?.toString() ?? '',
//               'ppir_svp_aci': row['ppir_svp_aci']?.toString() ?? '',
//               'ppir_variety': row['ppir_variety']?.toString() ?? '',
//               'ppir_stagecrop': row['ppir_stagecrop']?.toString() ?? '',
//               'created_at': DateTime.now().toIso8601String(),
//               'updated_at': DateTime.now().toIso8601String(),
//               'sync_status': 'synced',
//               'is_dirty': 'false',
//             });

//             newPPIRFormsCount++;
//             newTasksCount++;
//           }
//         }
//       }
//       await tempFile.delete();
//     }

//     FFAppState().syncCount += newTasksCount;
//     return true;
//   } catch (e) {
//     return false;
//   } finally {
//     await ftpClient?.disconnect();
//   }
// }
