import 'package:flutter/material.dart';
import 'package:my_rabai/core/router/app_router.dart';
import 'package:my_rabai/core/theme/app_theme.dart';

class MyRabaiApp extends StatelessWidget {
  const MyRabaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Rabai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router, // Safe and sound!
    );
  }
}