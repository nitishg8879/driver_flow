import 'package:driver_flow_admin/core/router/app_pages.dart';
import 'package:driver_flow_admin/core/router/app_router_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/root_layout.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/schedule/presentation/cubit/schedule_cubit.dart';
import '../../features/schedule/presentation/screens/schedule_screen.dart';
import '../../features/user/presentation/cubit/user_cubit.dart';
import '../../features/user/presentation/screens/users_screen.dart';
import '../../features/vehicle_type/presentation/cubit/vehicle_type_cubit.dart';
import '../../features/vehicle_type/presentation/screens/vehicle_type_screen.dart';
import '../../features/tags/presentation/cubit/tags_cubit.dart';
import '../../features/tags/presentation/screens/tags_screen.dart';
import '../../features/payment/presentation/cubit/payment_cubit.dart';
import '../../features/payment/presentation/screens/payment_list_screen.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
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
            path: Routes.users,
            name: 'users',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: BlocProvider(
                  create: (context) => sl<UserCubit>(),
                  child: const UsersScreen(),
                ),
              );
            },
          ),

          GoRoute(
            path: Routes.vehicleTypes,
            name: 'vehicleTypes',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: BlocProvider(
                  create: (context) => sl<VehicleTypeCubit>(),
                  child: const VehicleTypeScreen(),
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.schedule,
            name: 'schedule',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: BlocProvider(
                  create: (context) => sl<ScheduleCubit>(),
                  child: const ScheduleScreen(),
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.tags,
            name: 'tags',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: BlocProvider(
                  create: (context) => sl<TagsCubit>(),
                  child: const TagsScreen(),
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.payments,
            name: 'payments',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: BlocProvider(
                  create: (context) => sl<PaymentCubit>(),
                  child: const PaymentListScreen(),
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.profile,
            name: 'profile',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: BlocProvider(
                  create: (context) => sl<ProfileCubit>(),
                  child: const ProfileScreen(),
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
