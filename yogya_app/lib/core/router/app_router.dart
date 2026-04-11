import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/signup_screen.dart';
import '../../presentation/screens/forgot_password_screen.dart';
import '../../presentation/screens/main_layout.dart';
import '../../presentation/screens/dashboard_screen.dart';
import '../../presentation/screens/eligibility_timeline_screen.dart';
import '../../presentation/screens/documents_scanner_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/eligibility_engine_screen.dart';
import '../../presentation/screens/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/timeline',
          builder: (context, state) => const EligibilityTimelineScreen(),
        ),
        GoRoute(
          path: '/scanner',
          builder: (context, state) => const DocumentsScannerScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/eligibility_engine',
      builder: (context, state) => const EligibilityEngineScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
