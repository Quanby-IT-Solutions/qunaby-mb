import '../database.dart';

class FileReadTable extends SupabaseTable<FileReadRow> {
  @override
  String get tableName => 'file_read';

  @override
  FileReadRow createRow(Map<String, dynamic> data) => FileReadRow(data);
}

class FileReadRow extends SupabaseDataRow {
  FileReadRow(super.data);

  @override
  SupabaseTable get table => FileReadTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get fileName => getField<String>('file_name')!;
  set fileName(String value) => setField<String>('file_name', value);

  int? get fileSize => getField<int>('file_size');
  set fileSize(int? value) => setField<int>('file_size', value);

  String? get fileType => getField<String>('file_type');
  set fileType(String? value) => setField<String>('file_type', value);

  String? get uploadedBy => getField<String>('uploaded_by');
  set uploadedBy(String? value) => setField<String>('uploaded_by', value);

  DateTime? get uploadedAt => getField<DateTime>('uploaded_at');
  set uploadedAt(DateTime? value) => setField<DateTime>('uploaded_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get syncStatus => getField<String>('sync_status');
  set syncStatus(String? value) => setField<String>('sync_status', value);

  bool? get isDirty => getField<bool>('is_dirty');
  set isDirty(bool? value) => setField<bool>('is_dirty', value);
}
