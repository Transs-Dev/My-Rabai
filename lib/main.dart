import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_rabai/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cpqjaempkzrapknesvjs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNwcWphZW1wa3pyYXBrbmVzdmpzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE0ODc0MjUsImV4cCI6MjA5NzA2MzQyNX0.oIxOoSJTwfZWSZ3JrZTAnspzIua2rhbpCBhvjieQdPU',
  );

  runApp(
    const ProviderScope(
      child: MyRabaiApp(),
    ),
  );
}