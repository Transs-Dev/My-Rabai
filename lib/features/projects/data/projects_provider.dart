import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Stream provider that listens to project changes in real time
final projectsStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final supabase = Supabase.instance.client;
  
  return supabase
      .from('development_projects')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);
});