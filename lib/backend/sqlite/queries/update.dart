import 'package:sqflite/sqflite.dart';

/// BEGIN UPDATEATTEMPTSTATUS
Future performUpdateAttemptStatus(
  Database database, {
  String? comments,
  bool? updatedat,
  bool? syncstatus,
  bool? isdirty,
}) {
  const query = '''
UPDATE attempts
SET status = ?, 
    comments = ?, 
    updated_at = ?, 
    sync_status = ?, 
    is_dirty = ?
WHERE id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATEATTEMPTSTATUS

/// BEGIN UPDATESYNCSTATUS
Future performUpdateSyncStatus(
  Database database, {
  String? id,
  bool? syncstatus,
  DateTime? lastsyncedat,
  DateTime? updatedat,
}) {
  const query = '''
UPDATE attempts
SET sync_status = ?,
    last_synced_at = ?,
    is_dirty = false,
    updated_at = ?
WHERE id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATESYNCSTATUS

/// BEGIN UPDATEPPIRUPDATETIME
Future performUpdatePpirUpdateTime(
  Database database, {
  String? taskId,
  String? updatedAt,
}) {
  final query = '''
UPDATE ppir_forms
SET  updated_at = '$updatedAt'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATEPPIRUPDATETIME

/// BEGIN UPDATEPPIRLOCATION
Future performUpdatePPIRLocation(
  Database database, {
  String? ppirsouth,
  String? ppirnorth,
  String? ppireast,
  String? ppirwest,
  String? ppirfarmloc,
  DateTime? isupdatedat,
  bool? isdirty,
  String? taskid,
}) {
  const query = '''
UPDATE ppir_forms
SET ppir_north = ?,
    ppir_south = ?,
    ppir_east = ?,
    ppir_west = ?,
    ppir_farmloc = ?,
    updated_at = ?,
    is_dirty = true
WHERE task_id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATEPPIRLOCATION

/// BEGIN UPDATEPPIRCROPINFO
Future performUpdatePPIRCropInfo(
  Database database, {
  String? ppirvariety,
  String? ppirareaaci,
  String? ppirstagecrop,
  String? ppirareaact,
  DateTime? updatedat,
  bool? isdirty,
  String? taskid,
}) {
  const query = '''
UPDATE ppir_forms
SET ppir_variety = ?,
    ppir_stage_crop = ?,
    ppir_area_aci = ?,
    ppir_area_act = ?,
    updated_at = ?,
    is_dirty = true
WHERE task_id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATEPPIRCROPINFO

/// BEGIN UPDATETASK
Future performUpdateTask(
  Database database, {
  String? id,
  String? tasknumber,
  String? servicegroup,
  String? servicetypes,
  String? priority,
  String? assignee,
  String? fileid,
  DateTime? dateadded,
  DateTime? dateaccess,
  bool? status,
  String? tasktype,
  int? attemptcount,
  DateTime? updatedat,
  bool? isdeleted,
  bool? syncstatus,
  DateTime? lastsyncedat,
  String? localid,
  bool? isdirty,
  bool? isupdating,
}) {
  const query = '''
UPDATE tasks
SET 
  task_number = ?,
  service_group = ?,
  service_type = ?,
  priority = ?,
  assignee = ?,
  file_id = ?,
  date_added = ?,
  date_access = ?,
  status = ?,
  task_type = ?,
  attempt_count = ?,
  created_at = ?,
  updated_at = ?,
  is_deleted = ?,
  sync_status = ?,
  last_synced_at = ?,
  local_id = ?,
  is_dirty = ?,
  is_updating = ?
WHERE id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATETASK

/// BEGIN UPDATEUSERS
Future performUpdateUsers(
  Database database, {
  String? id,
  String? role,
  String? email,
  String? photourl,
  String? inspectorname,
  String? mobilenumber,
  bool? isonline,
  String? authuserid,
  String? createduserid,
  String? createdat,
  String? updatedat,
  String? regionid,
}) {
  const query = '''
UPDATE users
SET 
  role = ?,
  email = ?,
  photo_url = ?,
  inspector_name = ?,
  mobile_number = ?,
  is_online = ?,
  auth_user_id = ?,
  created_user_id = ?,
  created_at = ?,
  updated_at = ?,
  region_id = ?
WHERE id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATEUSERS

/// BEGIN UPDATE DASHBOARD QUERY
Future performUpdateDashboardQuery(
  Database database, {
  String? role,
  String? email,
  String? photourl,
  String? inspectorname,
  String? mobilenumber,
  bool? isonline,
  String? authuserid,
  String? createduserid,
  DateTime? updatedat,
  String? regionid,
}) {
  const query = '''
UPDATE users
SET 
  role = ?,
  email = ?,
  photo_url = ?,
  inspector_name = ?,
  mobile_number = ?,
  is_online = ?,
  auth_user_id = ?,
  created_user_id = ?,
  updated_at = ?,
  region_id = ?
WHERE id = ?
''';
  return database.rawQuery(query);
}

/// END UPDATE DASHBOARD QUERY

/// BEGIN INSERTUPDATE SYNC STATUS
Future performInsertUpdateSyncStatus(
  Database database, {
  String? tablename,
  DateTime? lastsynctimestamp,
}) {
  const query = '''
INSERT OR REPLACE INTO sync_status (table_name, last_sync_timestamp)
VALUES (?, ?);
''';
  return database.rawQuery(query);
}

/// END INSERTUPDATE SYNC STATUS

/// BEGIN ADD TO SYNC QUEUE
Future performAddToSyncQueue(
  Database database, {
  String? tablename,
  String? recordid,
  String? action,
  String? data,
  DateTime? timestamp,
}) {
  const query = '''
INSERT INTO sync_queue (table_name, record_id, action, data, timestamp)
VALUES (?, ?, ?, ?, ?);
''';
  return database.rawQuery(query);
}

/// END ADD TO SYNC QUEUE

/// BEGIN REMOVE FROM SYNC QUEUE
Future performRemoveFromSyncQueue(
  Database database, {
  String? id,
}) {
  const query = '''
DELETE FROM sync_queue WHERE id = ?;
''';
  return database.rawQuery(query);
}

/// END REMOVE FROM SYNC QUEUE

/// BEGIN UPDATE LAST MODIFIED TIMESTAMP
Future performUpdateLastModifiedTimestamp(
  Database database, {
  DateTime? lastmodified,
  String? id,
}) {
  const query = '''
UPDATE tasks SET ..., last_modified = ? WHERE id = ?;
''';
  return database.rawQuery(query);
}

/// END UPDATE LAST MODIFIED TIMESTAMP

/// BEGIN INSERT OFFLINE TASK
Future performInsertOfflineTask(
  Database database, {
  String? id,
  String? taskNumber,
  String? serviceGroup,
  String? status,
  String? serviceType,
  String? priority,
  String? assignee,
  String? dateAdded,
  String? dateAccess,
  String? fileId,
}) {
  final query = '''
INSERT OR REPLACE INTO tasks (id, task_number, service_group, status, service_type, priority, assignee, file_id, date_added, date_access)
VALUES ('$id', '$taskNumber', '$serviceGroup', '$status', '$serviceType', '$priority', '$assignee', '$fileId', '$dateAdded', '$dateAccess')
''';
  return database.rawQuery(query);
}

/// END INSERT OFFLINE TASK

/// BEGIN INSERT OFFLINE PPIR FORM
Future performInsertOfflinePPIRForm(
  Database database, {
  String? taskId,
  String? ppirAssignmentId,
  String? gpx,
  String? ppirInsuranceId,
  String? ppirFarmerName,
  String? ppirAddress,
  String? ppirFarmerType,
  String? ppirMobileNo,
  String? ppirGroupName,
  String? ppirGroupAddress,
  String? ppirLenderName,
  String? ppirLenderAddress,
  String? ppirCICNo,
  String? ppirFarmLoc,
  String? ppirNorth,
  String? ppirSouth,
  String? ppirEast,
  String? ppirWest,
  String? ppirAtt1,
  String? ppirAtt2,
  String? ppirAtt3,
  String? ppirAtt4,
  String? ppirAreaAci,
  String? ppirAreaAct,
  String? ppirDopdsAci,
  String? ppirDopdsAct,
  String? ppirDoptpAci,
  String? ppirDoptpAct,
  String? ppirSvpAci,
  String? ppirSvpAct,
  String? ppirVariety,
  String? ppirStageCrop,
  String? ppirRemarks,
  String? ppirNameInsured,
  String? ppirNameIUIA,
  String? ppirSigInsured,
  String? ppirSigIUIA,
  String? trackLastCoord,
  String? trackDateTime,
  String? trackTotalArea,
  String? trackTotalDistance,
  String? createdAt,
  String? updatedAt,
  String? syncStatus,
  String? lastSyncedAt,
  String? localId,
  String? isDirty,
  String? capturedArea,
}) {
  final query = '''
INSERT OR REPLACE INTO ppir_forms (
    task_id, ppir_assignmentid, gpx, ppir_insuranceid, ppir_farmername, 
    ppir_address, ppir_farmertype, ppir_mobileno, ppir_groupname, 
    ppir_groupaddress, ppir_lendername, ppir_lenderaddress, ppir_cicno, 
    ppir_farmloc, ppir_north, ppir_south, ppir_east, ppir_west, ppir_att_1, 
    ppir_att_2, ppir_att_3, ppir_att_4, ppir_area_aci, ppir_area_act, 
    ppir_dopds_aci, ppir_dopds_act, ppir_doptp_aci, ppir_doptp_act, 
    ppir_svp_aci, ppir_svp_act, ppir_variety, ppir_stagecrop, ppir_remarks, 
    ppir_name_insured, ppir_name_iuia, ppir_sig_insured, ppir_sig_iuia, 
    track_last_coord, track_date_time, track_total_area, track_total_distance, 
    created_at, updated_at, sync_status, last_synced_at, local_id, is_dirty, captured_area
) VALUES (
    '$taskId', '$ppirAssignmentId', '$gpx', '$ppirInsuranceId', '$ppirFarmerName', 
    '$ppirAddress', '$ppirFarmerType', '$ppirMobileNo', '$ppirGroupName', 
    '$ppirGroupAddress', '$ppirLenderName', '$ppirLenderAddress', '$ppirCICNo', 
    '$ppirFarmLoc', '$ppirNorth', '$ppirSouth', '$ppirEast', '$ppirWest', 
    '$ppirAtt1', '$ppirAtt2', '$ppirAtt3', '$ppirAtt4', '$ppirAreaAci', 
    '$ppirAreaAct', '$ppirDopdsAci', '$ppirDopdsAct', '$ppirDoptpAci', 
    '$ppirDoptpAct', '$ppirSvpAci', '$ppirSvpAct', '$ppirVariety', 
    '$ppirStageCrop', '$ppirRemarks', '$ppirNameInsured', '$ppirNameIUIA', 
    '$ppirSigInsured', '$ppirSigIUIA', '$trackLastCoord', '$trackDateTime', 
    '$trackTotalArea', '$trackTotalDistance', '$createdAt', '$updatedAt', 
    '$syncStatus', '$lastSyncedAt', '$localId', '$isDirty', '$capturedArea'
);
''';
  return database.rawQuery(query);
}

/// END INSERT OFFLINE PPIR FORM

/// BEGIN UPDATE PPIR SET A BLANK GPX
Future performUpdatePPIRSetABlankGpx(
  Database database, {
  String? taskId,
  bool? isDirty,
}) {
  final query = '''
UPDATE ppir_forms
SET gpx =  ''
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR SET A BLANK GPX

/// BEGIN UPDATE PPIR FORM
Future performUpdatePPIRForm(
  Database database, {
  String? taskId,
  String? ppirSvpAct,
  String? ppirDopdsAct,
  String? ppirDoptpAct,
  String? ppirRemarks,
  String? ppirNameInsured,
  String? ppirNameIuia,
  String? ppirFarmloc,
  String? ppirAreaAct,
  String? ppirVariety,
  bool? isDirty,
  String? capturedArea,
  DateTime? updatedAt,
}) {
  final query = '''
UPDATE ppir_forms
SET 
  ppir_svp_act = '$ppirSvpAct',
  ppir_dopds_act = '$ppirDopdsAct',
  ppir_doptp_act = '$ppirDoptpAct',
  ppir_remarks = '$ppirRemarks',
  ppir_name_insured = '$ppirNameInsured',
  ppir_name_iuia = '$ppirNameIuia',
  ppir_farmloc = '$ppirFarmloc',
  ppir_area_act = '$ppirAreaAct',
  ppir_variety = '$ppirVariety',
  captured_area = '$capturedArea',
  updated_at = '$updatedAt',
  is_dirty = $isDirty
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM

/// BEGIN UPDATE TASK STATUS
Future performUpdateTaskStatus(
  Database database, {
  String? taskId,
  String? status,
  bool? isDirty,
}) {
  final query = '''
UPDATE tasks
SET 
  status = '$status',
  is_dirty = '$isDirty'
WHERE id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE TASK STATUS

/// BEGIN UPDATE PPIR FORM VALIDITY
Future performUpdatePPIRFormValidity(
  Database database, {
  String? taskId,
  bool? isDirty,
}) {
  final query = '''
UPDATE ppir_forms
SET is_dirty = '$isDirty'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM VALIDITY

/// BEGIN UPDATE PPIR FORM GPX
Future performUpdatePPIRFormGpx(
  Database database, {
  String? taskId,
  String? gpx,
  bool? isDirty,
}) {
  final query = '''
UPDATE ppir_forms
SET 
  gpx = '$gpx',
  is_dirty = '$isDirty'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM GPX

/// BEGIN UPDATE PPIR FORM AFTER GEOTAG
Future performUpdatePPIRFormAfterGeotag(
  Database database, {
  String? taskId,
  String? trackLastCoord,
  String? trackDateTime,
  String? trackTotalArea,
  String? trackTotalDistance,
  String? gpx,
  bool? isDirty,
}) {
  final query = '''
UPDATE ppir_forms
SET 
  gpx = '$gpx',
  track_last_coord = '$trackLastCoord',
  track_date_time = '$trackDateTime',
  track_total_area = '$trackTotalArea',
  track_total_distance = '$trackTotalDistance',
  is_dirty = '$isDirty'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM AFTER GEOTAG

/// BEGIN UPDATE PPIR FORM IUIA SIGNATURE BLOB
Future performUpdatePPIRFormIUIASignatureBlob(
  Database database, {
  String? taskId,
  String? signatureBlob,
}) {
  final query = '''
UPDATE ppir_forms
SET  ppir_sig_iuia = '$signatureBlob'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM IUIA SIGNATURE BLOB

/// BEGIN UPDATE PPIR FORM INSURED SIGNATURE BLOB
Future performUpdatePPIRFormINSUREDSignatureBlob(
  Database database, {
  String? taskId,
  String? signatureBlob,
}) {
  final query = '''
UPDATE ppir_forms
SET  ppir_sig_insured = '$signatureBlob'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE PPIR FORM INSURED SIGNATURE BLOB

/// BEGIN UPDATE USERS PROFILE NAME
Future performUpdateUsersProfileName(
  Database database, {
  String? id,
  String? inspectorName,
}) {
  final query = '''
UPDATE users
SET  inspector_name = '$inspectorName'
WHERE id = '$id';
''';
  return database.rawQuery(query);
}

/// END UPDATE USERS PROFILE NAME

/// BEGIN DELETE ALL ROWS FOR TASKS AND PPIR
Future performDELETEAllRowsForTASKSAndPPIR(
  Database database,
) {
  const query = '''
DELETE FROM tasks;
DELETE FROM ppir_forms;
''';
  return database.rawQuery(query);
}

/// END DELETE ALL ROWS FOR TASKS AND PPIR

/// BEGIN OFFLINE INSERT USERS
Future performOfflineInsertUsers(
  Database database, {
  String? id,
  String? role,
  String? email,
  String? photoUrl,
  String? inspectorName,
  String? mobileNumber,
  String? authUserId,
  String? createdAt,
  String? updatedAt,
  String? regionId,
}) {
  final query = '''
INSERT OR REPLACE INTO users (
    id,
    role,
    email,
    photo_url,
    inspector_name,
    mobile_number,
    auth_user_id,
    created_at,
    updated_at,
    region_id
) 
VALUES (
    '$id', 
    '$role', 
    '$email', 
    '$photoUrl', 
    '$inspectorName', 
    '$mobileNumber', 
    '$authUserId', 
    '$createdAt', 
    '$updatedAt', 
    '$regionId'
);

''';
  return database.rawQuery(query);
}

/// END OFFLINE INSERT USERS

/// BEGIN UPDATE OFFLINE PPIR FORM SYNC STATUS
Future performUpdateOfflinePPIRFormSyncStatus(
  Database database, {
  String? taskId,
  String? syncStatus,
  String? isDirty,
}) {
  final query = '''
UPDATE ppir_forms
SET 
  sync_status = '$syncStatus',
  is_dirty = '$isDirty'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE OFFLINE PPIR FORM SYNC STATUS

/// BEGIN UPDATE OFFLINE TASK SYNC STATUS
Future performUpdateOfflineTaskSyncStatus(
  Database database, {
  String? taskId,
  String? syncStatus,
  String? isDirty,
}) {
  final query = '''
UPDATE tasks
SET 
  sync_status = '$syncStatus',
  is_dirty = '$isDirty'
WHERE id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATE OFFLINE TASK SYNC STATUS

/// BEGIN UPDATEPPIRSUBMITDATETIME
Future performUpdatePpirSubmitDateTime(
  Database database, {
  String? taskId,
  String? submitDate,
}) {
  final query = '''
UPDATE tasks
SET  submit_date = '$submitDate'
WHERE task_id = '$taskId';
''';
  return database.rawQuery(query);
}

/// END UPDATEPPIRSUBMITDATETIME
