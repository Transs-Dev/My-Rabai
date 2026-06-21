import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final isAdminProvider = FutureProvider.autoDispose<bool>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  
  if (user == null) return false;

  try {
    final response = await supabase
        .from('profiles')
        .select('is_admin')
        .eq('id', user.id)
        .maybeSingle();
        
    return response?['is_admin'] == true;
  } catch (_) {
    return false;
  }
});