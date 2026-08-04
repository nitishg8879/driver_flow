import 'package:driver_flow_admin/core/router/app_pages.dart';
import 'package:driver_flow_admin/core/services/storage_service.dart';
import 'package:driver_flow_admin/features/auth/data/repositories/auth_repository.dart';
import 'package:driver_flow_admin/features/auth/presentation/models/menu_item_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'auth_provider.g.dart';

@riverpod
Future<bool> checkLogin(Ref ref) async {
  return ref.read(storageServiceProvider).isLoggedIn;
}

@riverpod
Future<List<MenuItem>> menuItems(Ref ref) async {
  return [
    const MenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard_rounded,
      route: Routes.dashboard,
      index: 0,
    ),
    const MenuItem(
      title: 'Users',
      icon: Icons.people_alt_rounded,
      route: Routes.users,
      index: 1,
    ),
    const MenuItem(
      title: 'Vehicle Types',
      icon: Icons.two_wheeler_rounded,
      route: Routes.vehicleTypes,
      index: 2,
    ),
    const MenuItem(
      title: 'Schedule',
      icon: Icons.calendar_month_rounded,
      route: Routes.schedule,
      index: 3,
    ),
    const MenuItem(
      title: 'Tags',
      icon: Icons.label_rounded,
      route: Routes.tags,
      index: 4,
    ),
    const MenuItem(
      title: 'Payments',
      icon: Icons.payment_rounded,
      route: Routes.payments,
      index: 5,
    ),
    const MenuItem(
      title: 'Profile',
      icon: Icons.business_rounded,
      route: Routes.profile,
      index: 6,
    ),
  ];
}

@riverpod
Future<void> logout(Ref ref) async {
  await ref.read(authRepositoryProvider).logout();
  await ref.read(storageServiceProvider).clearAll();
  ref.invalidate(checkLoginProvider);
}

@riverpod
Future<bool> login(
  Ref ref, {
  required String email,
  required String password,
}) async {
  final result = await ref.read(authRepositoryProvider).login(email, password);
  return result.id != null;
}
