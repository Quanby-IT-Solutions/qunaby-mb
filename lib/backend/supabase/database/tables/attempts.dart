import '../database.dart';

class AttemptsTable extends SupabaseTable<AttemptsRow> {
  @override
  String get tableName => 'attempts';

  @override
  AttemptsRow createRow(Map<String, dynamic> data) => AttemptsRow(data);
}

class AttemptsRow extends SupabaseDataRow {
  AttemptsRow(super.data);

  @override
  SupabaseTable get table => AttemptsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get taskId => getField<String>('task_id');
  set taskId(String? value) => setField<String>('task_id', value);

  int? get attemptNumber => getField<int>('attempt_number');
  set attemptNumber(int? value) => setField<int>('attempt_number', value);

  DateTime? get attemptDate => getField<DateTime>('attempt_date');
  set attemptDate(DateTime? value) => setField<DateTime>('attempt_date', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  String? get comments => getField<String>('comments');
  set comments(String? value) => setField<String>('comments', value);

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

  bool? get isUpdating => getField<bool>('is_updating');
  set isUpdating(bool? value) => setField<bool>('is_updating', value);
}
