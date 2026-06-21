import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// A stream provider that listens to live real-time rows from your database
final homeStatsProvider = StreamProvider<Map<String, String>>((ref) {
  final supabase = Supabase.instance.client;
  
  return supabase
      .from('constituency_stats')
      .stream(primaryKey: ['id'])
      .map((List<Map<String, dynamic>> data) {
        // Transform the list of rows into a clean key-value map for the UI
        final Map<String, String> statsMap = {};
        for (final row in data) {
          final key = row['key_name'] as String;
          final value = row['display_value'] as String;
          statsMap[key] = value;
        }
        return statsMap;
      });
});