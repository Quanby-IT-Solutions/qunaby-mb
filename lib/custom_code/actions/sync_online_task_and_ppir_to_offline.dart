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

Future<String> syncOnlineTaskAndPpirToOffline() async {
  try {
    int updatedOnlineTasksCount = 0;
    int updatedOnlinePPIRFormsCount = 0;
    int newOfflineTasksCount = 0;
    int newOfflinePPIRFormsCount = 0;

    // Step 1: Sync offline data to online
    print('Starting Step 1: Sync offline data to online');
    List<OFFLINESelectAllTasksByAssigneeRow> offlineTasks =
        await SQLiteManager.instance.oFFLINESelectAllTasksByAssignee(
      assignee: currentUserUid,
    );

    for (var offlineTask in offlineTasks) {
      if (await syncOfflineTaskToOnline(offlineTask)) {
        updatedOnlineTasksCount++;
      }
    }

    List<SELECTPPIRFormsByAssigneeRow> offlinePPIRForms =
        await SQLiteManager.instance.sELECTPPIRFormsByAssignee(
      assignee: currentUserUid,
    );

    for (var offlinePPIR in offlinePPIRForms) {
      if (await updateOnlinePpirFormsFromOfflinePpirForms(offlinePPIR.taskId) ==
          'Up to Data') {
        updatedOnlinePPIRFormsCount++;
      }
    }

    print(
        'Updated $updatedOnlineTasksCount tasks and $updatedOnlinePPIRFormsCount PPIR forms online');

    // Step 2: Update sync status in offline database
    print('Starting Step 2: Updating sync status in offline database');
    await Future.wait([
      for (var task in offlineTasks)
        SQLiteManager.instance.updateOfflineTaskSyncStatus(
          taskId: task.id,
          syncStatus: 'synced',
          isDirty: 'false',
        ),
    ]);

    // Step 3: Sync online data to offline
    print('Starting Step 3: Sync online data to offline');
    List<TasksRow> onlineTasks = await TasksTable().queryRows(
      queryFn: (q) => q.eq('assignee', currentUserUid),
    );

    for (var onlineTask in onlineTasks) {
      if (await syncOnlineTaskToOffline(onlineTask)) {
        newOfflineTasksCount++;
        newOfflinePPIRFormsCount++;
      }
    }

    print('Sync completed successfully');
    // return 'Updated $updatedOnlineTasksCount tasks, $updatedOnlinePPIRFormsCount PPIR forms. '
    //    'Added $newOfflineTasksCount new tasks, $newOfflinePPIRFormsCount new PPIR forms.';
    return 'Sync completed successfully';
  } catch (e) {
    print('Sync failed: $e');
    return 'Sync failed: ${e.toString()}';
  }
}

Future<bool> syncOfflineTaskToOnline(
    OFFLINESelectAllTasksByAssigneeRow offlineTask) async {
  var onlineTaskExists = await TasksTable().queryRows(
    queryFn: (q) => q.eq('id', offlineTask.id).eq('assignee', currentUserUid),
  );

  if (onlineTaskExists.isNotEmpty) {
    await TasksTable().update(
      data: {'status': offlineTask.status},
      matchingRows: (row) =>
          row.eq('id', offlineTask.id).eq('assignee', currentUserUid),
    );
    print('Updated online task with ID: ${offlineTask.id}');
    return true;
  }
  return false;
}

Future<bool> syncOnlineTaskToOffline(TasksRow onlineTask) async {
  var offlineTaskExists = await SQLiteManager.instance.oFFLINESelectTaskByID(
    taskId: onlineTask.id,
  );

  if (offlineTaskExists.isEmpty) {
    await SQLiteManager.instance.insertOfflineTask(
      id: onlineTask.id,
      taskNumber: onlineTask.taskNumber,
      serviceGroup: onlineTask.serviceGroup ?? '',
      status: onlineTask.status,
      serviceType: onlineTask.serviceType,
      priority: onlineTask.priority ?? '',
      assignee: onlineTask.assignee ?? '',
      dateAdded: onlineTask.dateAdded?.toIso8601String() ?? '',
      dateAccess: onlineTask.dateAccess?.toIso8601String() ?? '',
      fileId: onlineTask.fileId ?? '',
    );
    print('Inserted new offline task with ID: ${onlineTask.id}');

    await syncOnlinePPIRToOffline(onlineTask.id);
    return true;
  }
  return false;
}

Future<void> syncOnlinePPIRToOffline(String taskId) async {
  var ppirForms = await PpirFormsTable().queryRows(
    queryFn: (q) => q.eq('task_id', taskId),
  );

  if (ppirForms.isNotEmpty) {
    var ppir = ppirForms.first;
    await SQLiteManager.instance.insertOfflinePPIRForm(
      taskId: ppir.taskId,
      ppirAssignmentId: ppir.ppirAssignmentid,
      gpx: ppir.gpx ?? '',
      ppirInsuranceId: ppir.ppirInsuranceid ?? '',
      ppirFarmerName: ppir.ppirFarmername ?? '',
      ppirAddress: ppir.ppirAddress ?? '',
      ppirFarmerType: ppir.ppirFarmertype ?? '',
      ppirMobileNo: ppir.ppirMobileno ?? '',
      ppirGroupName: ppir.ppirGroupname ?? '',
      ppirGroupAddress: ppir.ppirGroupaddress ?? '',
      ppirLenderName: ppir.ppirLendername ?? '',
      ppirLenderAddress: ppir.ppirLenderaddress ?? '',
      ppirCICNo: ppir.ppirCicno ?? '',
      ppirFarmLoc: ppir.ppirFarmloc ?? '',
      ppirNorth: ppir.ppirNorth ?? '',
      ppirSouth: ppir.ppirSouth ?? '',
      ppirEast: ppir.ppirEast ?? '',
      ppirWest: ppir.ppirWest ?? '',
      ppirAtt1: ppir.ppirAtt1 ?? '',
      ppirAtt2: ppir.ppirAtt2 ?? '',
      ppirAtt3: ppir.ppirAtt3 ?? '',
      ppirAtt4: ppir.ppirAtt4 ?? '',
      ppirAreaAci: ppir.ppirAreaAci ?? '',
      ppirAreaAct: ppir.ppirAreaAct ?? '',
      ppirDopdsAci: ppir.ppirDopdsAci ?? '',
      ppirDopdsAct: ppir.ppirDopdsAct ?? '',
      ppirDoptpAci: ppir.ppirDoptpAci ?? '',
      ppirDoptpAct: ppir.ppirDoptpAct ?? '',
      ppirSvpAci: ppir.ppirSvpAci ?? '',
      ppirSvpAct: ppir.ppirSvpAct,
      ppirVariety: ppir.ppirVariety ?? '',
      ppirStageCrop: ppir.ppirStagecrop ?? '',
      ppirRemarks: ppir.ppirRemarks ?? '',
      ppirNameInsured: ppir.ppirNameInsured ?? '',
      ppirNameIUIA: ppir.ppirNameIuia ?? '',
      ppirSigInsured: ppir.ppirSigInsured ?? '',
      ppirSigIUIA: ppir.ppirSigIuia ?? '',
      trackLastCoord: ppir.trackLastCoord ?? '',
      trackDateTime: ppir.trackDateTime ?? '',
      trackTotalArea: ppir.trackTotalArea ?? '',
      trackTotalDistance: ppir.trackTotalDistance ?? '',
      capturedArea: ppir.capturedArea ?? '',
      createdAt: ppir.createdAt?.toIso8601String() ?? '',
      updatedAt: ppir.updatedAt?.toIso8601String() ?? '',
      syncStatus: 'synced',
      lastSyncedAt: DateTime.now().toIso8601String(),
      isDirty: 'false',
    );
    print('Inserted new offline PPIR form for task ID: $taskId');
  } else {
    await SQLiteManager.instance.insertOfflinePPIRForm(
      taskId: taskId,
      ppirAssignmentId: '',
      ppirInsuranceId: '',
      ppirFarmerName: '',
      ppirAddress: '',
      ppirFarmerType: '',
      ppirMobileNo: '',
      ppirGroupName: '',
      ppirGroupAddress: '',
      ppirLenderName: '',
      ppirLenderAddress: '',
      ppirCICNo: '',
      ppirFarmLoc: '',
      ppirNorth: '',
      ppirSouth: '',
      ppirEast: '',
      ppirWest: '',
      ppirAtt1: '',
      ppirAtt2: '',
      ppirAtt3: '',
      ppirAtt4: '',
      ppirAreaAci: '',
      ppirAreaAct: '',
      ppirDopdsAci: '',
      ppirDopdsAct: '',
      ppirDoptpAci: '',
      ppirDoptpAct: '',
      ppirSvpAci: '',
      ppirSvpAct: '',
      ppirVariety: '',
      ppirStageCrop: '',
      ppirRemarks: '',
      ppirNameInsured: '',
      ppirNameIUIA: '',
      ppirSigInsured: '',
      ppirSigIUIA: '',
      trackLastCoord: '',
      trackDateTime: '',
      trackTotalArea: '',
      trackTotalDistance: '',
      capturedArea: '',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      syncStatus: 'synced',
      lastSyncedAt: DateTime.now().toIso8601String(),
      isDirty: 'false',
    );
    print('Inserted placeholder offline PPIR form for task ID: $taskId');
  }
}
