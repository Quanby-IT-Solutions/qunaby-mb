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

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:ftpconnect/ftpconnect.dart';

Future<bool> saveToFTP(String? taskId) async {
  if (taskId == null) return false;

  FTPConnect? ftpClient;

  try {
    final taskData = await getTaskData(taskId);
    final String serviceGroup = taskData['service_group'] ?? '';
    final String taskNumber = taskData['task_number'] ?? '';
    final String userEmail = taskData['user_email'] ?? '';
    final String insuranceId = await getInsuranceId(taskId);

    final String basePath = '$serviceGroup/$userEmail';
    final String folderPrefix = '${taskNumber}_$insuranceId';

    print('Searching for latest folder with basePath: $basePath');
    print('Task Number: $taskNumber');
    print('Folder prefix: $folderPrefix');

    final latestFolder = await findLatestFolder(basePath, folderPrefix);

    if (latestFolder == null) {
      print('No matching folder found for the task');
      return false;
    }

    print('Latest folder found: $latestFolder');

    final fileList = await listAllFiles(latestFolder);
    final tempDir = await getTemporaryDirectory();
    final zipFile = File('${tempDir.path}/${taskNumber}_${insuranceId}.zip');

    final archive = Archive();
    for (final filePath in fileList) {
      final fileData =
          await SupaFlow.client.storage.from('for_ftp').download(filePath);

      final relativePath = filePath.substring(latestFolder.length + 1);

      final archiveFile = ArchiveFile(
        relativePath,
        fileData.length,
        fileData,
      );
      archive.addFile(archiveFile);
    }

    final zipOutput = ZipEncoder().encode(archive);
    await zipFile.writeAsBytes(zipOutput!);

    final (ftpUsername, remoteBasePath, fileNamePrefix) =
        await getFtpSettings(serviceGroup);

    // old 34.143.129.187 -> 34.124.202.22 -> test
    ftpClient = FTPConnect('34.124.202.22',
        user: ftpUsername, pass: 'K2c#%!pc!c', port: 21);

    try {
      await ftpClient.connect();
    } catch (e) {
      print('FTP connection error: $e');
      return false;
    }

    final fileName = '$taskNumber.task';
    print('Filename is: $fileName');
    final remotePath = '/$remoteBasePath/$fileName';

    try {
      await ftpClient.makeDirectory(remoteBasePath);
    } catch (e) {
      if (!e.toString().contains('Directory already exists')) {
        print('Error creating directory: $e');
        return false;
      }
    }

    try {
      await ftpClient.changeDirectory(remoteBasePath);
    } catch (e) {
      print('Error changing directory: $e');
      return false;
    }

    try {
      await ftpClient.uploadFile(zipFile, sRemoteName: fileName);
      print('File uploaded successfully to FTP: $fileName');
    } catch (e) {
      print('Error uploading file: $e');
      return false;
    }

    await zipFile.delete();

    return true;
  } catch (e) {
    print('Error in saveToFTP: $e');
    return false;
  } finally {
    if (ftpClient != null) {
      try {
        await ftpClient.disconnect();
      } catch (e) {
        print('Error disconnecting from FTP: $e');
      }
    }
  }
}

Future<Map<String, String>> getTaskData(String taskId) async {
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
  final String userEmail =
      SupaFlow.client.auth.currentUser?.email ?? taskData['assignee'] ?? '';

  if (userEmail.isEmpty) {
    throw Exception('Unable to get user email');
  }

  taskData['user_email'] = userEmail;
  return taskData.cast<String, String>();
}

Future<String> getInsuranceId(String taskId) async {
  final ppirResponse = await SupaFlow.client
      .from('ppir_forms')
      .select('ppir_insuranceid')
      .eq('task_id', taskId)
      .single()
      .execute();

  if (ppirResponse.status != 200 || ppirResponse.data == null) {
    throw Exception('Error querying ppir_forms table: ${ppirResponse.status}');
  }

  return ppirResponse.data['ppir_insuranceid'] ?? '';
}

Future<(String, String, String)> getFtpSettings(String serviceGroup) async {
  switch (serviceGroup) {
    case 'PO1':
      return ('k2c_Ro1', 'RO_1/taskarchive', 'RO1');
    case 'PO2':
      return ('k2c_Ro2', 'RO_2/taskarchive', 'RO2');
    case 'PO3':
      return ('k2c_Ro3', 'RO_3/taskarchive', 'RO3');
    case 'PO4A':
    case 'PO4B':
      return ('k2c_Ro4', 'RO_4/taskarchive', 'RO4');
    case 'PO5':
      return ('k2c_Ro5', 'RO_5/taskarchive', 'RO5');
    case 'PO6':
      return ('k2c_Ro6', 'RO_6/taskarchive', 'RO6');
    case 'PO7':
      return ('k2c_Ro7', 'RO_7/taskarchive', 'RO7');
    case 'PO8':
      return ('k2c_Ro8', 'RO_8/taskarchive', 'RO8');
    case 'PO9':
      return ('k2c_Ro9', 'RO_9/taskarchive', 'RO9');
    case 'PO10':
      return ('k2c_Ro10', 'RO_10/taskarchive', 'RO10');
    case 'PO11':
      return ('k2c_Ro11', 'RO_11/taskarchive', 'RO11');
    case 'PO12':
      return ('k2c_Ro12', 'RO_12/taskarchive', 'RO12');
    case 'PO13':
      return ('k2c_Ro13', 'RO_13/taskarchive', 'RO13');
    default:
      throw Exception('Invalid service group: $serviceGroup');
  }
}

Future<List<String>> listAllFiles(String path) async {
  List<String> allFiles = [];
  final response =
      await SupaFlow.client.storage.from('for_ftp').list(path: path);

  for (final item in response) {
    if (item.name.contains('.')) {
      allFiles.add('$path/${item.name}');
    } else {
      allFiles.addAll(await listAllFiles('$path/${item.name}'));
    }
  }

  return allFiles;
}
