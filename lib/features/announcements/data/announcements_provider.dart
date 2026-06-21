import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Live stream provider that automatically handles updating the UI when announcements change
final announcementsStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final supabase = Supabase.instance.client;
  
  return supabase
      .from('news_posts') // Pulls data from your backend table
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);
});