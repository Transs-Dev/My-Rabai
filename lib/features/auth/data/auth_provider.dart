import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provides the current Supabase User object, automatically updating when auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  final supabase = Supabase.instance.client;
  // Fixed: Grab the user object out of the session state safely
  return supabase.auth.onAuthStateChange.map((data) => data.session?.user);
});

// A service class to handle the actual login / signup executions
final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  final _supabase = Supabase.instance.client;

  // Sign up a new user with Email & Password
  Future<void> signUp(String email, String password) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  // Log in an existing user
  Future<void> logIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Sign out
  Future<void> logOut() async {
    await _supabase.auth.signOut();
  }
}