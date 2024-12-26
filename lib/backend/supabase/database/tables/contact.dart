import '../database.dart';

class ContactTable extends SupabaseTable<ContactRow> {
  @override
  String get tableName => 'contact';

  @override
  ContactRow createRow(Map<String, dynamic> data) => ContactRow(data);
}

class ContactRow extends SupabaseDataRow {
  ContactRow(super.data);

  @override
  SupabaseTable get table => ContactTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get purpose => getField<String>('purpose');
  set purpose(String? value) => setField<String>('purpose', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  String? get user => getField<String>('user');
  set user(String? value) => setField<String>('user', value);
}
