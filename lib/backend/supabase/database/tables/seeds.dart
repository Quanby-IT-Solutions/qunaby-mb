import '../database.dart';

class SeedsTable extends SupabaseTable<SeedsRow> {
  @override
  String get tableName => 'seeds';

  @override
  SeedsRow createRow(Map<String, dynamic> data) => SeedsRow(data);
}

class SeedsRow extends SupabaseDataRow {
  SeedsRow(super.data);

  @override
  SupabaseTable get table => SeedsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get seed => getField<String>('seed')!;
  set seed(String value) => setField<String>('seed', value);

  String get seedType => getField<String>('seed_type')!;
  set seedType(String value) => setField<String>('seed_type', value);

  String? get syncStatus => getField<String>('sync_status');
  set syncStatus(String? value) => setField<String>('sync_status', value);

  DateTime? get lastSyncedAt => getField<DateTime>('last_synced_at');
  set lastSyncedAt(DateTime? value) =>
      setField<DateTime>('last_synced_at', value);

  bool? get isDirty => getField<bool>('is_dirty');
  set isDirty(bool? value) => setField<bool>('is_dirty', value);

  String? get regionId => getField<String>('region_id');
  set regionId(String? value) => setField<String>('region_id', value);
}
