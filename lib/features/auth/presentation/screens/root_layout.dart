import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:driver_flow_admin/core/router/app_pages.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_strings.dart';
import '../bloc/auth_bloc.dart';

class RootLayout extends StatefulWidget {
  final Widget child;

  const RootLayout({super.key, required this.child});

  @override
  State<RootLayout> createState() => _RootLayoutState();
}

class _RootLayoutState extends State<RootLayout> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _collapsed ? 88 : AppConstants.sidebarWidth,
            child: _buildSidebar(context),
          ),
          // Main Content
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.05 * 255).round()),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with App Logo & Collapse Toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              mainAxisAlignment: _collapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (!_collapsed) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.local_shipping_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _collapsed = !_collapsed),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withAlpha(
                          (0.5 * 255).round(),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _collapsed
                            ? Icons.menu_open_rounded
                            : Icons.keyboard_double_arrow_left_rounded,
                        size: 24,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (!_collapsed)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(height: 32),
            ),

          if (_collapsed) const SizedBox(height: 16),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard_rounded,
                  label: AppStrings.dashboard,
                  path: Routes.dashboard,
                  isSelected: currentPath == Routes.dashboard,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.school_outlined,
                  selectedIcon: Icons.school_rounded,
                  label: AppStrings.students,
                  path: Routes.students,
                  isSelected: currentPath.startsWith(Routes.students),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: AppStrings.instructors,
                  path: Routes.instructors,
                  isSelected: currentPath.startsWith(Routes.instructors),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.local_shipping_outlined,
                  selectedIcon: Icons.local_shipping_rounded,
                  label: AppStrings.vehicles,
                  path: Routes.vehicles,
                  isSelected: currentPath.startsWith(Routes.vehicles),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.calendar_month_outlined,
                  selectedIcon: Icons.calendar_month_rounded,
                  label: AppStrings.schedule,
                  path: Routes.schedule,
                  isSelected: currentPath.startsWith(Routes.schedule),
                ),
              ],
            ),
          ),

          // User Profile & Logout (Footer)
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required String path,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Tooltip(
        message: _collapsed ? label : '',
        preferBelow: false,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.go(path),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: _collapsed ? 0 : 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primaryContainer.withAlpha(
                        (0.6 * 255).round(),
                      )
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary.withAlpha((0.2 * 255).round())
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: _collapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Icon(
                    isSelected ? selectedIcon : icon,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  if (!_collapsed) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colorScheme.primary,
                        size: 18,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: EdgeInsets.all(_collapsed ? 8 : 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(
          (0.3 * 255).round(),
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha((0.5 * 255).round()),
        ),
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return state.maybeWhen(
            authenticated: (user) {
              final avatar = CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary,
                child: Text(
                  user.name?.isNotEmpty == true
                      ? user.name![0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );

              if (_collapsed) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    avatar,
                    const SizedBox(height: 12),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      color: colorScheme.error,
                      onPressed: () => context.read<AuthBloc>().add(
                        const AuthEvent.logoutRequested(),
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  avatar,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.name ?? 'N/A',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user.email ?? 'N/A',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    color: colorScheme.onSurfaceVariant,
                    hoverColor: colorScheme.errorContainer,
                    onPressed: () => context.read<AuthBloc>().add(
                      const AuthEvent.logoutRequested(),
                    ),
                  ),
                ],
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
