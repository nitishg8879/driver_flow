import 'package:driver_flow_admin/core/router/app_pages.dart';
import 'package:driver_flow_admin/features/auth/data/provider/auth_provider.dart';
import 'package:driver_flow_admin/features/auth/presentation/models/menu_item_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RootLayout extends ConsumerWidget {
  final Widget child;

  const RootLayout({Key? key, required this.child}) : super(key: key);

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/users')) return 1;
    if (location.startsWith('/vehicle-types')) return 2;
    if (location.startsWith('/schedule')) return 3;
    if (location.startsWith('/tags')) return 4;
    if (location.startsWith('/payments')) return 5;
    if (location.startsWith('/profile')) return 6;
    return 0; // Default fallback
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _calculateSelectedIndex(context);
    final menuItems = ref.watch(menuItemsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // 1. FIXED SIDEBAR ON THE LEFT
          _buildFixedSidebar(context, ref, selectedIndex, menuItems),

          // 2. MAIN CONTENT AREA ON THE RIGHT
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildFixedSidebar(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
    AsyncValue<List<MenuItem>> menuItems,
  ) {
    return Container(
      width: 260,
      color: const Color(0xFFF4F5F7),
      child: Column(
        children: [
          // SCROLLABLE TABS
          Expanded(
            child: menuItems.when(
              data: (items) {
                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      _buildNavItem(
                        context: context,
                        icon: items[i].icon,
                        title: items[i].title,
                        route: items[i].route,
                        isSelected: selectedIndex == items[i].index,
                      ),
                      if (i < items.length - 1) const SizedBox(height: 8),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),

          // FOOTER
          _buildFooter(context, ref),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.logout_rounded,
            title: 'Logout',
            route: Routes.login,
            isSelected: false,
            isDanger: true,
            onTap: () async {
              await ref.read(logoutProvider.future);
              if (context.mounted) {
                context.go(Routes.login);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
    bool isDanger = false,
    VoidCallback? onTap,
  }) {
    final activeColor = Colors.blueAccent;
    final defaultColor = const Color(0xFF5A5C69);
    final dangerColor = Colors.redAccent;

    final itemColor = isSelected
        ? activeColor
        : (isDanger ? dangerColor : defaultColor);
    final bgColor = isSelected
        ? activeColor.withOpacity(0.12)
        : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () => context.go(route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: itemColor, size: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: itemColor,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
