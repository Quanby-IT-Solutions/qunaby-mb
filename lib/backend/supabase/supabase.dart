import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

export 'database/database.dart';
export 'storage/storage.dart';

String _kSupabaseUrl = 'https://vnsnxkhiyguywgggwdau.supabase.co';
String _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuc254a2hpeWd1eXdnZ2d3ZGF1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjExMzM5MDAsImV4cCI6MjAzNjcwOTkwMH0.o2R57GoNJsEi4X2TeyFkPjnkSYvt9Aoiv87_xb_mrBI';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        anonKey: _kSupabaseAnonKey,
        debug: false,
      );
}
