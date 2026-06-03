import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/app_constants.dart';
import 'models/user_profile.dart';
import 'screens/dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'services/profile_service.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Barra de estado transparente para look premium
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.bgCard,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await ProfileService.instance.init();

  runApp(const TrinityGymApp());
}

class TrinityGymApp extends StatefulWidget {
  const TrinityGymApp({super.key});

  @override
  State<TrinityGymApp> createState() => _TrinityGymAppState();
}

class _TrinityGymAppState extends State<TrinityGymApp> {
  bool _hasProfile = false;

  @override
  void initState() {
    super.initState();
    _hasProfile = ProfileService.instance.hasProfile;
  }

  void _onOnboardingComplete() {
    setState(() => _hasProfile = true);
  }

  void _onLogout() {
    setState(() => _hasProfile = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: _hasProfile
          ? _MainShell(onLogout: _onLogout)
          : OnboardingScreen(onComplete: _onOnboardingComplete),
    );
  }
}

/// Shell principal con bottom navigation de 4 tabs.
class _MainShell extends StatefulWidget {
  const _MainShell({required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _tab = 0;

  UserProfile get _profile => ProfileService.instance.profile!;

  void _refreshProfile() {
    setState(() {}); // force rebuild with new profile data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          DashboardScreen(
            profile: _profile,
            onProfileUpdated: _refreshProfile,
          ),
          const HomeScreen(),
          ProfileScreen(
            profile: _profile,
            onProfileUpdated: _refreshProfile,
            onLogout: widget.onLogout,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'Entrena',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
