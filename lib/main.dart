import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ombapos/screens/auth/login_screen.dart';
import 'package:ombapos/screens/dashboard/activity.dart';
import 'package:ombapos/screens/dashboard/settings.dart';
import 'package:ombapos/screens/dashboard/shift.dart';
import 'package:ombapos/screens/onboarding/onboarding_screen.dart';
import 'package:ombapos/screens/dashboard/pos/pos.dart';
import 'package:ombapos/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:ombapos/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  final isLoggedIn = prefs.getString('userToken') != null;

  runApp(MainApp(hasSeenOnboarding: hasSeenOnboarding, isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  final bool isLoggedIn;

  const MainApp({
    super.key,
    required this.hasSeenOnboarding,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // ChangeNotifierProvider(create: (_) => AppProvider()),
        // ChangeNotifierProvider(create: (_) => PosProvider()),
      ],
      child: MaterialApp.router(
        title: 'Omba POS',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: _createRouter(),
      ),
    );
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: !hasSeenOnboarding
          ? '/onboarding'
          : !isLoggedIn
          // ? '/login'
          ? '/pos' // offline version tidak perlu login
          : '/pos',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        // GoRoute(
        //   path: '/register',
        //   builder: (context, state) => const RegisterScreen(),
        // ),
        GoRoute(
          path: '/pos',
          builder: (context, state) => const MainDashboard(),
          routes: [
            GoRoute(
              path: 'activity',
              builder: (context, state) => const Activity(),
            ),
            GoRoute(path: 'shift', builder: (context, state) => const Shift()),
            GoRoute(
              path: 'settings',
              builder: (context, state) => const Settings(),
            ),
          ],
        ),
      ],
    );
  }
}
