import '../database.dart';

class PpirFormsTable extends SupabaseTable<PpirFormsRow> {
  @override
  String get tableName => 'ppir_forms';

  @override
  PpirFormsRow createRow(Map<String, dynamic> data) => PpirFormsRow(data);
}

class PpirFormsRow extends SupabaseDataRow {
  PpirFormsRow(super.data);

  @override
  SupabaseTable get table => PpirFormsTable();

  String get taskId => getField<String>('task_id')!;
  set taskId(String value) => setField<String>('task_id', value);

  String get ppirAssignmentid => getField<String>('ppir_assignmentid')!;
  set ppirAssignmentid(String value) =>
      setField<String>('ppir_assignmentid', value);

  String? get gpx => getField<String>('gpx');
  set gpx(String? value) => setField<String>('gpx', value);

  String? get ppirInsuranceid => getField<String>('ppir_insuranceid');
  set ppirInsuranceid(String? value) =>
      setField<String>('ppir_insuranceid', value);

  String? get ppirFarmername => getField<String>('ppir_farmername');
  set ppirFarmername(String? value) =>
      setField<String>('ppir_farmername', value);

  String? get ppirAddress => getField<String>('ppir_address');
  set ppirAddress(String? value) => setField<String>('ppir_address', value);

  String? get ppirFarmertype => getField<String>('ppir_farmertype');
  set ppirFarmertype(String? value) =>
      setField<String>('ppir_farmertype', value);

  String? get ppirMobileno => getField<String>('ppir_mobileno');
  set ppirMobileno(String? value) => setField<String>('ppir_mobileno', value);

  String? get ppirGroupname => getField<String>('ppir_groupname');
  set ppirGroupname(String? value) => setField<String>('ppir_groupname', value);

  String? get ppirGroupaddress => getField<String>('ppir_groupaddress');
  set ppirGroupaddress(String? value) =>
      setField<String>('ppir_groupaddress', value);

  String? get ppirLendername => getField<String>('ppir_lendername');
  set ppirLendername(String? value) =>
      setField<String>('ppir_lendername', value);

  String? get ppirLenderaddress => getField<String>('ppir_lenderaddress');
  set ppirLenderaddress(String? value) =>
      setField<String>('ppir_lenderaddress', value);

  String? get ppirCicno => getField<String>('ppir_cicno');
  set ppirCicno(String? value) => setField<String>('ppir_cicno', value);

  String? get ppirFarmloc => getField<String>('ppir_farmloc');
  set ppirFarmloc(String? value) => setField<String>('ppir_farmloc', value);

  String? get ppirNorth => getField<String>('ppir_north');
  set ppirNorth(String? value) => setField<String>('ppir_north', value);

  String? get ppirSouth => getField<String>('ppir_south');
  set ppirSouth(String? value) => setField<String>('ppir_south', value);

  String? get ppirEast => getField<String>('ppir_east');
  set ppirEast(String? value) => setField<String>('ppir_east', value);

  String? get ppirWest => getField<String>('ppir_west');
  set ppirWest(String? value) => setField<String>('ppir_west', value);

  String? get ppirAtt1 => getField<String>('ppir_att_1');
  set ppirAtt1(String? value) => setField<String>('ppir_att_1', value);

  String? get ppirAtt2 => getField<String>('ppir_att_2');
  set ppirAtt2(String? value) => setField<String>('ppir_att_2', value);

  String? get ppirAtt3 => getField<String>('ppir_att_3');
  set ppirAtt3(String? value) => setField<String>('ppir_att_3', value);

  String? get ppirAtt4 => getField<String>('ppir_att_4');
  set ppirAtt4(String? value) => setField<String>('ppir_att_4', value);

  String? get ppirAreaAci => getField<String>('ppir_area_aci');
  set ppirAreaAci(String? value) => setField<String>('ppir_area_aci', value);

  String? get ppirAreaAct => getField<String>('ppir_area_act');
  set ppirAreaAct(String? value) => setField<String>('ppir_area_act', value);

  String? get ppirDopdsAci => getField<String>('ppir_dopds_aci');
  set ppirDopdsAci(String? value) => setField<String>('ppir_dopds_aci', value);

  String? get ppirDopdsAct => getField<String>('ppir_dopds_act');
  set ppirDopdsAct(String? value) => setField<String>('ppir_dopds_act', value);

  String? get ppirDoptpAci => getField<String>('ppir_doptp_aci');
  set ppirDoptpAci(String? value) => setField<String>('ppir_doptp_aci', value);

  String? get ppirDoptpAct => getField<String>('ppir_doptp_act');
  set ppirDoptpAct(String? value) => setField<String>('ppir_doptp_act', value);

  String? get ppirSvpAci => getField<String>('ppir_svp_aci');
  set ppirSvpAci(String? value) => setField<String>('ppir_svp_aci', value);

  String? get ppirSvpAct => getField<String>('ppir_svp_act');
  set ppirSvpAct(String? value) => setField<String>('ppir_svp_act', value);

  String? get ppirVariety => getField<String>('ppir_variety');
  set ppirVariety(String? value) => setField<String>('ppir_variety', value);

  String? get ppirStagecrop => getField<String>('ppir_stagecrop');
  set ppirStagecrop(String? value) => setField<String>('ppir_stagecrop', value);

  String? get ppirRemarks => getField<String>('ppir_remarks');
  set ppirRemarks(String? value) => setField<String>('ppir_remarks', value);

  String? get ppirNameInsured => getField<String>('ppir_name_insured');
  set ppirNameInsured(String? value) =>
      setField<String>('ppir_name_insured', value);

  String? get ppirNameIuia => getField<String>('ppir_name_iuia');
  set ppirNameIuia(String? value) => setField<String>('ppir_name_iuia', value);

  String? get ppirSigInsured => getField<String>('ppir_sig_insured');
  set ppirSigInsured(String? value) =>
      setField<String>('ppir_sig_insured', value);

  String? get ppirSigIuia => getField<String>('ppir_sig_iuia');
  set ppirSigIuia(String? value) => setField<String>('ppir_sig_iuia', value);

  String? get trackLastCoord => getField<String>('track_last_coord');
  set trackLastCoord(String? value) =>
      setField<String>('track_last_coord', value);

  String? get trackDateTime => getField<String>('track_date_time');
  set trackDateTime(String? value) =>
      setField<String>('track_date_time', value);

  String? get trackTotalArea => getField<String>('track_total_area');
  set trackTotalArea(String? value) =>
      setField<String>('track_total_area', value);

  String? get trackTotalDistance => getField<String>('track_total_distance');
  set trackTotalDistance(String? value) =>
      setField<String>('track_total_distance', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get syncStatus => getField<String>('sync_status');
  set syncStatus(String? value) => setField<String>('sync_status', value);

  DateTime? get lastSyncedAt => getField<DateTime>('last_synced_at');
  set lastSyncedAt(DateTime? value) =>
      setField<DateTime>('last_synced_at', value);

  bool? get isDirty => getField<bool>('is_dirty');
  set isDirty(bool? value) => setField<bool>('is_dirty', value);

  String? get capturedArea => getField<String>('captured_area');
  set capturedArea(String? value) => setField<String>('captured_area', value);
}
