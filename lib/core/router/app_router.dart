// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../presentation/screens/splash/splash_screen.dart';
// import '../../presentation/screens/auth/login_screen.dart';
// import '../../presentation/screens/main_shell/main_shell.dart';
// import '../../presentation/screens/dashboard/dashboard_screen.dart';
// import '../../presentation/screens/timeline/timeline_screen.dart';
// import '../../presentation/screens/documents/documents_screen.dart';
// import '../../presentation/screens/profile/profile_screen.dart';
// import '../../presentation/screens/settings/settings_screen.dart';
// import '../../presentation/screens/attempt_history/attempt_history_screen.dart';
// import '../../presentation/screens/eligibility/eligibility_screen.dart';

// final routerProvider = Provider<GoRouter>((ref) {
//   return GoRouter(
//     initialLocation: '/splash',
//     routes: [
//       GoRoute(
//         path: '/splash',
//         builder: (context, state) => const SplashScreen(),
//       ),
//       GoRoute(
//         path: '/login',
//         builder: (context, state) => const LoginScreen(),
//       ),
//       StatefulShellRoute.indexedStack(
//         builder: (context, state, shell) =>
//             MainShell(shell: shell),
//         branches: [
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/dashboard',
//                 builder: (context, state) =>
//                     const DashboardScreen(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/timeline',
//                 builder: (context, state) =>
//                     const TimelineScreen(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/documents',
//                 builder: (context, state) =>
//                     const DocumentsScreen(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/profile',
//                 builder: (context, state) =>
//                     const ProfileScreen(),
//               ),
//             ],
//           ),
//         ],
//       ),
//       GoRoute(
//         path: '/settings',
//         builder: (context, state) => const SettingsScreen(),
//       ),
//       GoRoute(
//         path: '/attempt-history',
//         builder: (context, state) =>
//             const AttemptHistoryScreen(),
//       ),
//       GoRoute(
//         path: '/eligibility-engine',
//         builder: (context, state) =>
//             const EligibilityScreen(),
//       ),
//     ],
//   );
// });

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/auth_provider.dart';

// Screen imports — unchanged paths
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/main_shell/main_shell.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/timeline/timeline_screen.dart';
import '../../presentation/screens/documents/documents_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/attempt_history/attempt_history_screen.dart';
import '../../presentation/screens/eligibility/eligibility_screen.dart';
import '../../presentation/screens/help/help_screen.dart';

// ── Route path constants ──────────────────────────────────
class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const dashboard = '/dashboard';
  static const timeline = '/timeline';
  static const documents = '/documents';
  static const profile = '/profile';
  static const settings = '/settings';
  static const attemptHistory = '/attempt-history';
  static const eligibility = '/eligibility-engine';
  static const helpSupport = '/help-support';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Watch Firebase stream for auth state changes
  final authStateAsync = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirectLimit: 1,
    refreshListenable: _AuthChangeNotifier(ref),
    redirect: (context, state) {
      // Handle loading, error, or data states
      final isLoading = authStateAsync.isLoading;
      final hasError = authStateAsync.hasError;
      final isLoggedIn =
          authStateAsync.valueOrNull != null; // non-null User = logged in

      final onSplash = state.matchedLocation == AppRoutes.splash;
      final onAuthScreen = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signUp ||
          state.matchedLocation == AppRoutes.forgotPassword;

      // Still loading Firebase — stay on splash
      if (isLoading) return onSplash ? null : AppRoutes.splash;

      // Firebase finished loading - advance from splash
      // Only redirect away from splash, don't force immediate redirect
      if (onSplash && !isLoading && !hasError) {
        // Give splash screen 2 seconds to display before redirecting
        // Splash screen has its own timers to handle navigation
        return null; // Stay on splash, let splash screen handle timing
      }

      // If there's an error in Firebase init, go to login as fallback
      if (hasError && !onAuthScreen && !onSplash) {
        return AppRoutes.login;
      }

      // Not logged in → redirect to login
      // (unless already on an auth screen or splash)
      if (!isLoggedIn && !onAuthScreen && !onSplash) {
        return AppRoutes.login;
      }

      // Logged in → redirect to dashboard
      if (isLoggedIn && (onAuthScreen || onSplash)) {
        return AppRoutes.dashboard;
      }

      return null; // no redirect needed
    },
    routes: [
      // ── Splash ──────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => SplashScreen(),
      ),

      // ── Auth routes ──────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (_, __) => SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, __) => ForgotPasswordScreen(),
      ),

      // ── Main shell (bottom nav) ───────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (_, __) => DashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.timeline,
              builder: (_, __) => TimelineScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.documents,
              builder: (_, __) => DocumentsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (_, __) => ProfileScreen(),
            ),
          ]),
        ],
      ),

      // ── Secondary routes ─────────────────────────────────
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.attemptHistory,
        builder: (_, __) => AttemptHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.eligibility,
        builder: (_, __) => EligibilityScreen(),
      ),
      GoRoute(
        path: AppRoutes.helpSupport,
        builder: (_, __) => HelpScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.error}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
});

// ── Listenable that triggers router refresh on auth change ─
// GoRouter needs a ChangeNotifier; Riverpod streams need bridging.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
}
