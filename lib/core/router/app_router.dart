import 'package:driver_flow_admin/core/router/app_pages.dart';
import 'package:driver_flow_admin/core/router/app_router_observer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/root_layout.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../di/service_locator.dart';
import '../services/storage_service.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    observers: [AppRouterObserver()],
    routes: [
      // Splash Screen
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Login Screen
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Root Layout with nested routes
      ShellRoute(
        builder: (context, state, child) {
          return RootLayout(child: child);
        },
        routes: [
          GoRoute(
            path: Routes.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) {
              return NoTransitionPage(child: const DashboardScreen());
            },
          ),
          GoRoute(
            path: Routes.students,
            name: 'students',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: const Scaffold(
                  body: Center(child: Text('Students Screen - Coming Soon')),
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.instructors,
            name: 'instructors',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: const Scaffold(
                  body: Center(child: Text('Instructors Screen - Coming Soon')),
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.vehicles,
            name: 'vehicles',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: const Scaffold(
                  body: Center(child: Text('Vehicles Screen - Coming Soon')),
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.schedule,
            name: 'schedule',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: const Scaffold(
                  body: Center(child: Text('Schedule Screen - Coming Soon')),
                ),
              );
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final storage = sl<StorageService>();
      final isLoggedIn = storage.isLoggedIn;

      final isOnSplash = state.matchedLocation == Routes.splash;
      final isOnLogin = state.matchedLocation == Routes.login;

      // If on splash screen, let it handle navigation
      if (isOnSplash) {
        return null;
      }

      // If not logged in and not on login screen, redirect to login
      if (!isLoggedIn && !isOnLogin) {
        return Routes.login;
      }

      // If logged in and on login screen, redirect to dashboard
      if (isLoggedIn && isOnLogin) {
        return Routes.dashboard;
      }

      return null;
    },
  );
}
