import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';
import 'queries/update.dart';

import 'package:sqflite/sqflite.dart';
export 'queries/read.dart';
export 'queries/update.dart';

class SQLiteManager {
  SQLiteManager._();

  static SQLiteManager? _instance;
  static SQLiteManager get instance => _instance ??= SQLiteManager._();

  static late Database _database;
  Database get database => _database;

  static Future initialize() async {
    if (kIsWeb) {
      return;
    }
    _database = await initializeDatabaseFromDbFile(
      'db_sync',
      'offline_db.db',
    );
  }

  /// START READ QUERY CALLS

  Future<List<SelectUsersInSameRegionRow>> selectUsersInSameRegion({
    String? regionId,
  }) =>
      performSelectUsersInSameRegion(
        _database,
        regionId: regionId,
      );

  Future<List<SelectPpirFormsRow>> selectPpirForms({
    String? taskId,
  }) =>
      performSelectPpirForms(
        _database,
        taskId: taskId,
      );

  Future<List<SelectAllMessagesRow>> selectAllMessages() =>
      performSelectAllMessages(
        _database,
      );

  Future<List<SelectSyncLogsRow>> selectSyncLogs() => performSelectSyncLogs(
        _database,
      );

  Future<List<SelectAttemptsRow>> selectAttempts() => performSelectAttempts(
        _database,
      );

  Future<List<SelectProfileRow>> selectProfile({
    String? email,
  }) =>
      performSelectProfile(
        _database,
        email: email,
      );

  Future<List<GetLastSyncTimestampRow>> getLastSyncTimestamp() =>
      performGetLastSyncTimestamp(
        _database,
      );

  Future<List<GetQueuedChangesRow>> getQueuedChanges() =>
      performGetQueuedChanges(
        _database,
      );

  Future<List<GetModifiedRecordsRow>> getModifiedRecords() =>
      performGetModifiedRecords(
        _database,
      );

  Future<List<OFFLINESelectAllTasksByAssigneeRow>>
      oFFLINESelectAllTasksByAssignee({
    String? assignee,
  }) =>
          performOFFLINESelectAllTasksByAssignee(
            _database,
            assignee: assignee,
          );

  Future<List<OFFLINESelectCountForDispatchRow>> oFFLINESelectCountForDispatch({
    String? assignee,
  }) =>
      performOFFLINESelectCountForDispatch(
        _database,
        assignee: assignee,
      );

  Future<List<OFFLINESelectTaskByIDRow>> oFFLINESelectTaskByID({
    String? taskId,
  }) =>
      performOFFLINESelectTaskByID(
        _database,
        taskId: taskId,
      );

  Future<List<SELECTTASKSAndPPIRByAssigneeRow>> sELECTTASKSAndPPIRByAssignee({
    String? taskId,
    String? assignee,
  }) =>
      performSELECTTASKSAndPPIRByAssignee(
        _database,
        taskId: taskId,
        assignee: assignee,
      );

  Future<List<SELECTRiceSEEDSRow>> sELECTRiceSEEDS({
    String? regionId,
  }) =>
      performSELECTRiceSEEDS(
        _database,
        regionId: regionId,
      );

  Future<List<SELECTCornSEEDSRow>> sELECTCornSEEDS({
    String? regionId,
  }) =>
      performSELECTCornSEEDS(
        _database,
        regionId: regionId,
      );

  Future<List<SELECTPPIRFORMSSignaturesRow>> sELECTPPIRFORMSSignatures({
    String? taskId,
  }) =>
      performSELECTPPIRFORMSSignatures(
        _database,
        taskId: taskId,
      );

  Future<List<OFFLINESelectREGIONCODERow>> oFFLINESelectREGIONCODE({
    String? id,
  }) =>
      performOFFLINESelectREGIONCODE(
        _database,
        id: id,
      );

  Future<List<SELECTPPIRFORMSGpxRow>> sELECTPPIRFORMSGpx({
    String? taskId,
  }) =>
      performSELECTPPIRFORMSGpx(
        _database,
        taskId: taskId,
      );

  Future<List<COUNTIsDirtyRow>> cOUNTIsDirty({
    String? assignee,
  }) =>
      performCOUNTIsDirty(
        _database,
        assignee: assignee,
      );

  Future<List<SELECTPPIRFormsByAssigneeRow>> sELECTPPIRFormsByAssignee({
    String? assignee,
  }) =>
      performSELECTPPIRFormsByAssignee(
        _database,
        assignee: assignee,
      );

  Future<List<SELECTPPIRFormsByAssigneeAndTaskStatusRow>>
      sELECTPPIRFormsByAssigneeAndTaskStatus({
    String? assignee,
    String? status,
  }) =>
          performSELECTPPIRFormsByAssigneeAndTaskStatus(
            _database,
            assignee: assignee,
            status: status,
          );

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  Future updateAttemptStatus({
    String? comments,
    bool? updatedat,
    bool? syncstatus,
    bool? isdirty,
  }) =>
      performUpdateAttemptStatus(
        _database,
        comments: comments,
        updatedat: updatedat,
        syncstatus: syncstatus,
        isdirty: isdirty,
      );

  Future updateSyncStatus({
    String? id,
    bool? syncstatus,
    DateTime? lastsyncedat,
    DateTime? updatedat,
  }) =>
      performUpdateSyncStatus(
        _database,
        id: id,
        syncstatus: syncstatus,
        lastsyncedat: lastsyncedat,
        updatedat: updatedat,
      );

  Future updatePpirUpdateTime({
    String? taskId,
    String? updatedAt,
  }) =>
      performUpdatePpirUpdateTime(
        _database,
        taskId: taskId,
        updatedAt: updatedAt,
      );

  Future updatePPIRLocation({
    String? ppirsouth,
    String? ppirnorth,
    String? ppireast,
    String? ppirwest,
    String? ppirfarmloc,
    DateTime? isupdatedat,
    bool? isdirty,
    String? taskid,
  }) =>
      performUpdatePPIRLocation(
        _database,
        ppirsouth: ppirsouth,
        ppirnorth: ppirnorth,
        ppireast: ppireast,
        ppirwest: ppirwest,
        ppirfarmloc: ppirfarmloc,
        isupdatedat: isupdatedat,
        isdirty: isdirty,
        taskid: taskid,
      );

  Future updatePPIRCropInfo({
    String? ppirvariety,
    String? ppirareaaci,
    String? ppirstagecrop,
    String? ppirareaact,
    DateTime? updatedat,
    bool? isdirty,
    String? taskid,
  }) =>
      performUpdatePPIRCropInfo(
        _database,
        ppirvariety: ppirvariety,
        ppirareaaci: ppirareaaci,
        ppirstagecrop: ppirstagecrop,
        ppirareaact: ppirareaact,
        updatedat: updatedat,
        isdirty: isdirty,
        taskid: taskid,
      );

  Future updateTask({
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
  }) =>
      performUpdateTask(
        _database,
        id: id,
        tasknumber: tasknumber,
        servicegroup: servicegroup,
        servicetypes: servicetypes,
        priority: priority,
        assignee: assignee,
        fileid: fileid,
        dateadded: dateadded,
        dateaccess: dateaccess,
        status: status,
        tasktype: tasktype,
        attemptcount: attemptcount,
        updatedat: updatedat,
        isdeleted: isdeleted,
        syncstatus: syncstatus,
        lastsyncedat: lastsyncedat,
        localid: localid,
        isdirty: isdirty,
        isupdating: isupdating,
      );

  Future updateUsers({
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
  }) =>
      performUpdateUsers(
        _database,
        id: id,
        role: role,
        email: email,
        photourl: photourl,
        inspectorname: inspectorname,
        mobilenumber: mobilenumber,
        isonline: isonline,
        authuserid: authuserid,
        createduserid: createduserid,
        createdat: createdat,
        updatedat: updatedat,
        regionid: regionid,
      );

  Future updateDashboardQuery({
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
  }) =>
      performUpdateDashboardQuery(
        _database,
        role: role,
        email: email,
        photourl: photourl,
        inspectorname: inspectorname,
        mobilenumber: mobilenumber,
        isonline: isonline,
        authuserid: authuserid,
        createduserid: createduserid,
        updatedat: updatedat,
        regionid: regionid,
      );

  Future insertUpdateSyncStatus({
    String? tablename,
    DateTime? lastsynctimestamp,
  }) =>
      performInsertUpdateSyncStatus(
        _database,
        tablename: tablename,
        lastsynctimestamp: lastsynctimestamp,
      );

  Future addToSyncQueue({
    String? tablename,
    String? recordid,
    String? action,
    String? data,
    DateTime? timestamp,
  }) =>
      performAddToSyncQueue(
        _database,
        tablename: tablename,
        recordid: recordid,
        action: action,
        data: data,
        timestamp: timestamp,
      );

  Future removeFromSyncQueue({
    String? id,
  }) =>
      performRemoveFromSyncQueue(
        _database,
        id: id,
      );

  Future updateLastModifiedTimestamp({
    DateTime? lastmodified,
    String? id,
  }) =>
      performUpdateLastModifiedTimestamp(
        _database,
        lastmodified: lastmodified,
        id: id,
      );

  Future insertOfflineTask({
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
  }) =>
      performInsertOfflineTask(
        _database,
        id: id,
        taskNumber: taskNumber,
        serviceGroup: serviceGroup,
        status: status,
        serviceType: serviceType,
        priority: priority,
        assignee: assignee,
        dateAdded: dateAdded,
        dateAccess: dateAccess,
        fileId: fileId,
      );

  Future insertOfflinePPIRForm({
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
  }) =>
      performInsertOfflinePPIRForm(
        _database,
        taskId: taskId,
        ppirAssignmentId: ppirAssignmentId,
        gpx: gpx,
        ppirInsuranceId: ppirInsuranceId,
        ppirFarmerName: ppirFarmerName,
        ppirAddress: ppirAddress,
        ppirFarmerType: ppirFarmerType,
        ppirMobileNo: ppirMobileNo,
        ppirGroupName: ppirGroupName,
        ppirGroupAddress: ppirGroupAddress,
        ppirLenderName: ppirLenderName,
        ppirLenderAddress: ppirLenderAddress,
        ppirCICNo: ppirCICNo,
        ppirFarmLoc: ppirFarmLoc,
        ppirNorth: ppirNorth,
        ppirSouth: ppirSouth,
        ppirEast: ppirEast,
        ppirWest: ppirWest,
        ppirAtt1: ppirAtt1,
        ppirAtt2: ppirAtt2,
        ppirAtt3: ppirAtt3,
        ppirAtt4: ppirAtt4,
        ppirAreaAci: ppirAreaAci,
        ppirAreaAct: ppirAreaAct,
        ppirDopdsAci: ppirDopdsAci,
        ppirDopdsAct: ppirDopdsAct,
        ppirDoptpAci: ppirDoptpAci,
        ppirDoptpAct: ppirDoptpAct,
        ppirSvpAci: ppirSvpAci,
        ppirSvpAct: ppirSvpAct,
        ppirVariety: ppirVariety,
        ppirStageCrop: ppirStageCrop,
        ppirRemarks: ppirRemarks,
        ppirNameInsured: ppirNameInsured,
        ppirNameIUIA: ppirNameIUIA,
        ppirSigInsured: ppirSigInsured,
        ppirSigIUIA: ppirSigIUIA,
        trackLastCoord: trackLastCoord,
        trackDateTime: trackDateTime,
        trackTotalArea: trackTotalArea,
        trackTotalDistance: trackTotalDistance,
        createdAt: createdAt,
        updatedAt: updatedAt,
        syncStatus: syncStatus,
        lastSyncedAt: lastSyncedAt,
        localId: localId,
        isDirty: isDirty,
        capturedArea: capturedArea,
      );

  Future updatePPIRSetABlankGpx({
    String? taskId,
    bool? isDirty,
  }) =>
      performUpdatePPIRSetABlankGpx(
        _database,
        taskId: taskId,
        isDirty: isDirty,
      );

  Future updatePPIRForm({
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
  }) =>
      performUpdatePPIRForm(
        _database,
        taskId: taskId,
        ppirSvpAct: ppirSvpAct,
        ppirDopdsAct: ppirDopdsAct,
        ppirDoptpAct: ppirDoptpAct,
        ppirRemarks: ppirRemarks,
        ppirNameInsured: ppirNameInsured,
        ppirNameIuia: ppirNameIuia,
        ppirFarmloc: ppirFarmloc,
        ppirAreaAct: ppirAreaAct,
        ppirVariety: ppirVariety,
        isDirty: isDirty,
        capturedArea: capturedArea,
        updatedAt: updatedAt,
      );

  Future updateTaskStatus({
    String? taskId,
    String? status,
    bool? isDirty,
  }) =>
      performUpdateTaskStatus(
        _database,
        taskId: taskId,
        status: status,
        isDirty: isDirty,
      );

  Future updatePPIRFormValidity({
    String? taskId,
    bool? isDirty,
  }) =>
      performUpdatePPIRFormValidity(
        _database,
        taskId: taskId,
        isDirty: isDirty,
      );

  Future updatePPIRFormGpx({
    String? taskId,
    String? gpx,
    bool? isDirty,
  }) =>
      performUpdatePPIRFormGpx(
        _database,
        taskId: taskId,
        gpx: gpx,
        isDirty: isDirty,
      );

  Future updatePPIRFormAfterGeotag({
    String? taskId,
    String? trackLastCoord,
    String? trackDateTime,
    String? trackTotalArea,
    String? trackTotalDistance,
    String? gpx,
    bool? isDirty,
  }) =>
      performUpdatePPIRFormAfterGeotag(
        _database,
        taskId: taskId,
        trackLastCoord: trackLastCoord,
        trackDateTime: trackDateTime,
        trackTotalArea: trackTotalArea,
        trackTotalDistance: trackTotalDistance,
        gpx: gpx,
        isDirty: isDirty,
      );

  Future updatePPIRFormIUIASignatureBlob({
    String? taskId,
    String? signatureBlob,
  }) =>
      performUpdatePPIRFormIUIASignatureBlob(
        _database,
        taskId: taskId,
        signatureBlob: signatureBlob,
      );

  Future updatePPIRFormINSUREDSignatureBlob({
    String? taskId,
    String? signatureBlob,
  }) =>
      performUpdatePPIRFormINSUREDSignatureBlob(
        _database,
        taskId: taskId,
        signatureBlob: signatureBlob,
      );

  Future updateUsersProfileName({
    String? id,
    String? inspectorName,
  }) =>
      performUpdateUsersProfileName(
        _database,
        id: id,
        inspectorName: inspectorName,
      );

  Future dELETEAllRowsForTASKSAndPPIR() => performDELETEAllRowsForTASKSAndPPIR(
        _database,
      );

  Future offlineInsertUsers({
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
  }) =>
      performOfflineInsertUsers(
        _database,
        id: id,
        role: role,
        email: email,
        photoUrl: photoUrl,
        inspectorName: inspectorName,
        mobileNumber: mobileNumber,
        authUserId: authUserId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        regionId: regionId,
      );

  Future updateOfflinePPIRFormSyncStatus({
    String? taskId,
    String? syncStatus,
    String? isDirty,
  }) =>
      performUpdateOfflinePPIRFormSyncStatus(
        _database,
        taskId: taskId,
        syncStatus: syncStatus,
        isDirty: isDirty,
      );

  Future updateOfflineTaskSyncStatus({
    String? taskId,
    String? syncStatus,
    String? isDirty,
  }) =>
      performUpdateOfflineTaskSyncStatus(
        _database,
        taskId: taskId,
        syncStatus: syncStatus,
        isDirty: isDirty,
      );

  Future updatePpirSubmitDateTime({
    String? taskId,
    String? submitDate,
  }) =>
      performUpdatePpirSubmitDateTime(
        _database,
        taskId: taskId,
        submitDate: submitDate,
      );

  /// END UPDATE QUERY CALLS
}
