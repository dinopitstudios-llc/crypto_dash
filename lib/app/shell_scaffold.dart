// Shell scaffold with bottom navigation bar for main tabs.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child, bottomNavigationBar: _BottomNavBar());
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _calculateSelectedIndex(location);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => _onItemTapped(index, context),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.trending_up), label: 'Market'),
        NavigationDestination(
          icon: Icon(Icons.star_outline),
          selectedIcon: Icon(Icons.star),
          label: 'Watchlist',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet),
          label: 'Portfolio',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith(AppRoutes.watchlist)) return 1;
    if (location.startsWith(AppRoutes.portfolio)) return 2;
    if (location.startsWith(AppRoutes.settings)) return 3;
    return 0; // market is default
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.market);
        break;
      case 1:
        context.go(AppRoutes.watchlist);
        break;
      case 2:
        context.go(AppRoutes.portfolio);
        break;
      case 3:
        context.go(AppRoutes.settings);
        break;
    }
  }
}
