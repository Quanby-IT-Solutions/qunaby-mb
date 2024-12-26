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

Future<String> updateOnlinePpirFormsFromOfflinePpirForms(String? taskId) async {
  if (taskId == null) {
    return 'Error: Task ID is null';
  }

  try {
    // Fetch the offline PPIR form for the given task ID
    List<SelectPpirFormsRow> offlinePPIRForms =
        await SQLiteManager.instance.selectPpirForms(
      taskId: taskId,
    );

    if (offlinePPIRForms.isEmpty) {
      return 'No offline PPIR form found for task ID: $taskId';
    }

    var offlinePPIR = offlinePPIRForms.first;

    // Update the online PPIR form with the offline data
    await PpirFormsTable().update(
      data: {
        'ppir_assignmentid': offlinePPIR.ppirAssignmentid,
        'gpx': offlinePPIR.gpx,
        'ppir_insuranceid': offlinePPIR.ppirInsuranceid,
        'ppir_farmername': offlinePPIR.ppirFarmername,
        'ppir_address': offlinePPIR.ppirAddress,
        'ppir_farmertype': offlinePPIR.ppirFarmertype,
        'ppir_mobileno': offlinePPIR.ppirMobileno,
        'ppir_groupname': offlinePPIR.ppirGroupname,
        'ppir_groupaddress': offlinePPIR.ppirGroupadress,
        'ppir_lendername': offlinePPIR.ppirLendername,
        'ppir_lenderaddress': offlinePPIR.ppirLenderaddress,
        'ppir_cicno': offlinePPIR.ppirCicno,
        'ppir_farmloc': offlinePPIR.ppirFarmloc,
        'ppir_north': offlinePPIR.ppirNorth,
        'ppir_south': offlinePPIR.ppirSouth,
        'ppir_east': offlinePPIR.ppirEast,
        'ppir_west': offlinePPIR.ppirWest,
        'ppir_att_1': offlinePPIR.ppirAtt1,
        'ppir_att_2': offlinePPIR.ppirAtt2,
        'ppir_att_3': offlinePPIR.ppirAtt3,
        'ppir_att_4': offlinePPIR.ppirAtt4,
        'ppir_area_aci': offlinePPIR.ppirAreaAci,
        'ppir_area_act': offlinePPIR.ppirAreaAct,
        'ppir_dopds_aci': offlinePPIR.ppirDopdsAci,
        'ppir_dopds_act': offlinePPIR.ppirDopdsAct,
        'ppir_doptp_aci': offlinePPIR.ppirDoptpAci,
        'ppir_doptp_act': offlinePPIR.ppirDoptpAct,
        'ppir_svp_aci': offlinePPIR.ppirSvpAci,
        'ppir_svp_act': offlinePPIR.ppirSvpAct,
        'ppir_variety': offlinePPIR.ppirVariety,
        'ppir_stagecrop': offlinePPIR.ppirStagecrop,
        'ppir_remarks': offlinePPIR.ppirRemarks,
        'ppir_name_insured': offlinePPIR.ppirNameInsured,
        'ppir_name_iuia': offlinePPIR.ppirNameIuia,
        'ppir_sig_insured': offlinePPIR.ppirSigInsured,
        'ppir_sig_iuia': offlinePPIR.ppirSigIuia,
        'track_last_coord': offlinePPIR.trackLastCoord,
        'track_date_time': offlinePPIR.trackDateTime,
        'track_total_area': offlinePPIR.trackTotalArea,
        'track_total_distance': offlinePPIR.trackTotalDistance,
        'captured_area': offlinePPIR.capturedArea,
        'sync_status': 'synced',
        'is_dirty': false,
        // 'updated_at': DateTime.now().toIso8601String(),
      },
      matchingRows: (row) => row.eq('task_id', taskId),
    );

    // Update the offline PPIR form to mark it as synced
    await SQLiteManager.instance.updatePPIRForm(
      taskId: taskId,
      ppirSvpAct: offlinePPIR.ppirSvpAct,
      ppirDopdsAct: offlinePPIR.ppirDopdsAct,
      ppirDoptpAct: offlinePPIR.ppirDoptpAct,
      ppirRemarks: offlinePPIR.ppirRemarks,
      ppirNameInsured: offlinePPIR.ppirNameInsured,
      ppirNameIuia: offlinePPIR.ppirNameIuia,
      ppirFarmloc: offlinePPIR.ppirFarmloc,
      ppirAreaAct: offlinePPIR.ppirAreaAct,
      ppirVariety: offlinePPIR.ppirVariety,
      capturedArea: offlinePPIR.capturedArea,
      isDirty: false,
    );

    return 'Up to Data';
  } catch (e) {
    print('Update Error: $e');
    return 'Fail to Update';
  }
}
