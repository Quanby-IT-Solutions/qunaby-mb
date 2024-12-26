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

Future<String> isDirtyCount() async {
  print(
      'isDirtyCount() called: Comparing online and offline PPIR records for user: $currentUserUid');

  try {
    List<SELECTPPIRFormsByAssigneeRow> offlinePPIRForms =
        await SQLiteManager.instance.sELECTPPIRFormsByAssignee(
      assignee: currentUserUid,
    );

    print(
        'Fetched ${offlinePPIRForms.length} offline PPIR records for user: $currentUserUid');

    int dirtyCount = 0;

    for (var offlinePPIR in offlinePPIRForms) {
      print('Comparing offline PPIR record for task ID: ${offlinePPIR.taskId}');

      var onlinePPIRForms = await PpirFormsTable().queryRows(
        queryFn: (q) => q.eq('task_id', offlinePPIR.taskId),
      );

      if (onlinePPIRForms.isEmpty) {
        dirtyCount++;
        print(
            'No online PPIR found for task ID: ${offlinePPIR.taskId}. Considered dirty.');
      } else {
        var onlinePPIR = onlinePPIRForms.first;
        var differences = findPPIRDifferences(offlinePPIR, onlinePPIR);
        if (differences.isNotEmpty) {
          dirtyCount++;
          print(
              'PPIR for task ID: ${offlinePPIR.taskId} is dirty. Differences: $differences');
        } else {
          print('PPIR for task ID: ${offlinePPIR.taskId} is not dirty.');
        }
      }
    }

    print('Total dirty PPIR records: $dirtyCount');
    return dirtyCount.toString();
  } catch (e) {
    print('Error in isDirtyCount: $e');
    return '0';
  }
}

List<String> findPPIRDifferences(
    SELECTPPIRFormsByAssigneeRow offlinePPIR, dynamic onlinePPIR) {
  List<String> differences = [];

  void checkDifference(
      String field, dynamic offlineValue, dynamic onlineValue) {
    // Convert empty strings to null for comparison
    offlineValue = offlineValue?.toString().isEmpty == true
        ? null
        : offlineValue?.toString();
    onlineValue = onlineValue?.toString().isEmpty == true
        ? null
        : onlineValue?.toString();

    if (offlineValue != onlineValue) {
      differences.add('$field: offline($offlineValue) != online($onlineValue)');
    }
  }

  // Manually check each field
  checkDifference('ppirAssignmentid', offlinePPIR.ppirAssignmentid,
      onlinePPIR.ppirAssignmentid);
  checkDifference('gpx', offlinePPIR.gpx, onlinePPIR.gpx);
  checkDifference('ppirInsuranceid', offlinePPIR.ppirInsuranceid,
      onlinePPIR.ppirInsuranceid);
  checkDifference(
      'ppirFarmername', offlinePPIR.ppirFarmername, onlinePPIR.ppirFarmername);
  checkDifference(
      'ppirAddress', offlinePPIR.ppirAddress, onlinePPIR.ppirAddress);
  checkDifference(
      'ppirFarmertype', offlinePPIR.ppirFarmertype, onlinePPIR.ppirFarmertype);
  checkDifference(
      'ppirMobileno', offlinePPIR.ppirMobileno, onlinePPIR.ppirMobileno);
  checkDifference(
      'ppirGroupname', offlinePPIR.ppirGroupname, onlinePPIR.ppirGroupname);
  checkDifference('ppirGroupaddress', offlinePPIR.ppirGroupaddress,
      onlinePPIR.ppirGroupaddress);
  checkDifference(
      'ppirLendername', offlinePPIR.ppirLendername, onlinePPIR.ppirLendername);
  checkDifference('ppirLenderaddress', offlinePPIR.ppirLenderaddress,
      onlinePPIR.ppirLenderaddress);
  checkDifference('ppirCicno', offlinePPIR.ppirCicno, onlinePPIR.ppirCicno);
  checkDifference(
      'ppirFarmloc', offlinePPIR.ppirFarmloc, onlinePPIR.ppirFarmloc);
  checkDifference('ppirNorth', offlinePPIR.ppirNorth, onlinePPIR.ppirNorth);
  checkDifference('ppirSouth', offlinePPIR.ppirSouth, onlinePPIR.ppirSouth);
  checkDifference('ppirEast', offlinePPIR.ppirEast, onlinePPIR.ppirEast);
  checkDifference('ppirWest', offlinePPIR.ppirWest, onlinePPIR.ppirWest);
  checkDifference(
      'ppirAreaAci', offlinePPIR.ppirAreaAci, onlinePPIR.ppirAreaAci);
  checkDifference(
      'ppirAreaAct', offlinePPIR.ppirAreaAct, onlinePPIR.ppirAreaAct);
  checkDifference(
      'ppirDopdsAci', offlinePPIR.ppirDopdsAci, onlinePPIR.ppirDopdsAci);
  checkDifference(
      'ppirDopdsAct', offlinePPIR.ppirDopdsAct, onlinePPIR.ppirDopdsAct);
  checkDifference(
      'ppirDoptpAci', offlinePPIR.ppirDoptpAci, onlinePPIR.ppirDoptpAci);
  checkDifference(
      'ppirDoptpAct', offlinePPIR.ppirDoptpAct, onlinePPIR.ppirDoptpAct);
  checkDifference('ppirSvpAci', offlinePPIR.ppirSvpAci, onlinePPIR.ppirSvpAci);
  checkDifference('ppirSvpAct', offlinePPIR.ppirSvpAct, onlinePPIR.ppirSvpAct);
  checkDifference(
      'ppirVariety', offlinePPIR.ppirVariety, onlinePPIR.ppirVariety);
  checkDifference(
      'ppirStagecrop', offlinePPIR.ppirStagecrop, onlinePPIR.ppirStagecrop);
  checkDifference(
      'ppirRemarks', offlinePPIR.ppirRemarks, onlinePPIR.ppirRemarks);
  checkDifference('ppirNameInsured', offlinePPIR.ppirNameInsured,
      onlinePPIR.ppirNameInsured);
  checkDifference(
      'ppirNameIuia', offlinePPIR.ppirNameIuia, onlinePPIR.ppirNameIuia);
  checkDifference(
      'ppirSigInsured', offlinePPIR.ppirSigInsured, onlinePPIR.ppirSigInsured);
  checkDifference(
      'ppirSigIuia', offlinePPIR.ppirSigIuia, onlinePPIR.ppirSigIuia);
  checkDifference(
      'trackLastCoord', offlinePPIR.trackLastCoord, onlinePPIR.trackLastCoord);
  checkDifference(
      'trackDateTime', offlinePPIR.trackDateTime, onlinePPIR.trackDateTime);
  checkDifference(
      'trackTotalArea', offlinePPIR.trackTotalArea, onlinePPIR.trackTotalArea);
  checkDifference('trackTotalDistance', offlinePPIR.trackTotalDistance,
      onlinePPIR.trackTotalDistance);
  checkDifference(
      'capturedArea', offlinePPIR.capturedArea, onlinePPIR.capturedArea);

  return differences;
}
