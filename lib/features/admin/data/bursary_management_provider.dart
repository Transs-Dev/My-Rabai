import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Stream all applications for the admin overview page
final adminApplicationsStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  return Supabase.instance.client
      .from('bursary_applications')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);
});

// Stream the current bursary application period configurations
final bursaryPeriodStreamProvider = StreamProvider.autoDispose<Map<String, dynamic>?>((ref) {
  return Supabase.instance.client
      .from('bursary_periods')
      .stream(primaryKey: ['id'])
      .limit(1)
      .map((maps) => maps.isNotEmpty ? maps.first : null);
});