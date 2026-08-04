import 'package:driver_flow_admin/features/auth/data/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/app_pages.dart';
import '../../../../utils/constants/app_strings.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch checkLogin and listen for navigation
    ref.listen<AsyncValue<bool>>(checkLoginProvider, (previous, next) {
      next.when(
        data: (isLoggedIn) {
          if (isLoggedIn) {
            context.go(Routes.dashboard);
          } else {
            context.go(Routes.login);
          }
        },
        loading: () {},
        error: (error, stack) {
          context.go(Routes.login);
        },
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
