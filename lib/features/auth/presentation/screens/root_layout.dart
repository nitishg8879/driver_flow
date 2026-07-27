import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootLayout extends StatelessWidget {
  final Widget child;

  const RootLayout({Key? key, required this.child}) : super(key: key);

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/users')) return 1;
    if (location.startsWith('/vehicles')) return 2;
    if (location.startsWith('/vehicle-types')) return 3;
    if (location.startsWith('/schedule')) return 4;
    if (location.startsWith('/tags')) return 5;
    if (location.startsWith('/payments')) return 6;
    if (location.startsWith('/profile')) return 7;
    return 0; // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: Colors.white, // Background for the main app area
      body: Row(
        children: [
          // 1. FIXED SIDEBAR ON THE LEFT
          _buildFixedSidebar(context, selectedIndex),

          // 2. MAIN CONTENT AREA ON THE RIGHT
          Expanded(
            child: child, // go_router injects the active screen here
          ),
        ],
      ),
    );
  }

  Widget _buildFixedSidebar(BuildContext context, int selectedIndex) {
    return Container(
      width: 260, // Fixed width for the side menu
      color: const Color(0xFFF4F5F7), // Sleek grey background
      child: Column(
        children: [
          // HEADER
          // _buildHeader(),

          // SCROLLABLE TABS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  route: '/dashboard',
                  isSelected: selectedIndex == 0,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  context: context,
                  icon: Icons.people_alt_rounded,
                  title: 'Users',
                  route: '/users',
                  isSelected: selectedIndex == 1,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  context: context,
                  icon: Icons.directions_car_rounded,
                  title: 'Vehicles',
                  route: '/vehicles',
                  isSelected: selectedIndex == 2,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  context: context,
                  icon: Icons.two_wheeler_rounded,
                  title: 'Vehicle Types',
                  route: '/vehicle-types',
                  isSelected: selectedIndex == 3,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  context: context,
                  icon: Icons.calendar_month_rounded,
                  title: 'Schedule',
                  route: '/schedule',
                  isSelected: selectedIndex == 4,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  context: context,
                  icon: Icons.label_rounded,
                  title: 'Tags',
                  route: '/tags',
                  isSelected: selectedIndex == 5,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  context: context,
                  icon: Icons.payment_rounded,
                  title: 'Payments',
                  route: '/payments',
                  isSelected: selectedIndex == 6,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  context: context,
                  icon: Icons.business_rounded,
                  title: 'Profile',
                  route: '/profile',
                  isSelected: selectedIndex == 7,
                ),
              ],
            ),
          ),

          // FOOTER
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 24, right: 24),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_shipping, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text(
            'Driver Flow',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.settings_rounded,
            title: 'Settings',
            route: '/settings',
            isSelected: false,
          ),
          const SizedBox(height: 8),
          _buildNavItem(
            context: context,
            icon: Icons.logout_rounded,
            title: 'Logout',
            route:
                '/login', // Route to login screen or trigger your logout logic
            isSelected: false,
            isDanger: true,
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
  }) {
    final activeColor = Colors.blueAccent;
    final defaultColor = const Color(
      0xFF5A5C69,
    ); // Dark grey text for unselected
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
        borderRadius: BorderRadius.circular(12), // Rounded selection effect
        onTap: () => context.go(route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12), // Rounded tabs
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
