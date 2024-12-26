import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(super.data);

  @override
  SupabaseTable get table => UsersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get role => getField<String>('role')!;
  set role(String value) => setField<String>('role', value);

  String get email => getField<String>('email')!;
  set email(String value) => setField<String>('email', value);

  String? get photoUrl => getField<String>('photo_url');
  set photoUrl(String? value) => setField<String>('photo_url', value);

  String get inspectorName => getField<String>('inspector_name')!;
  set inspectorName(String value) => setField<String>('inspector_name', value);

  String? get mobileNumber => getField<String>('mobile_number');
  set mobileNumber(String? value) => setField<String>('mobile_number', value);

  bool? get isOnline => getField<bool>('is_online');
  set isOnline(bool? value) => setField<bool>('is_online', value);

  String? get authUserId => getField<String>('auth_user_id');
  set authUserId(String? value) => setField<String>('auth_user_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get regionId => getField<String>('region_id');
  set regionId(String? value) => setField<String>('region_id', value);

  bool? get isDeleted => getField<bool>('is_deleted');
  set isDeleted(bool? value) => setField<bool>('is_deleted', value);

  String? get syncStatus => getField<String>('sync_status');
  set syncStatus(String? value) => setField<String>('sync_status', value);

  DateTime? get lastSyncedAt => getField<DateTime>('last_synced_at');
  set lastSyncedAt(DateTime? value) =>
      setField<DateTime>('last_synced_at', value);

  bool? get isDirty => getField<bool>('is_dirty');
  set isDirty(bool? value) => setField<bool>('is_dirty', value);

  DateTime? get lastSeen => getField<DateTime>('last_seen');
  set lastSeen(DateTime? value) => setField<DateTime>('last_seen', value);

  DateTime? get inactivityCheckTime =>
      getField<DateTime>('inactivity_check_time');
  set inactivityCheckTime(DateTime? value) =>
      setField<DateTime>('inactivity_check_time', value);
}
