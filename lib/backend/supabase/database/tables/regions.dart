import '../database.dart';

class RegionsTable extends SupabaseTable<RegionsRow> {
  @override
  String get tableName => 'regions';

  @override
  RegionsRow createRow(Map<String, dynamic> data) => RegionsRow(data);
}

class RegionsRow extends SupabaseDataRow {
  RegionsRow(super.data);

  @override
  SupabaseTable get table => RegionsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get regionCode => getField<String>('region_code')!;
  set regionCode(String value) => setField<String>('region_code', value);

  String get regionName => getField<String>('region_name')!;
  set regionName(String value) => setField<String>('region_name', value);

  String? get regionDescription => getField<String>('region_description');
  set regionDescription(String? value) =>
      setField<String>('region_description', value);

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
}
