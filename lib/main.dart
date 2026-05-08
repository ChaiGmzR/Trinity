import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TrinityGymApp());
}

class TrinityGymApp extends StatelessWidget {
  const TrinityGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const HomeScreen(),
    );
  }
}
