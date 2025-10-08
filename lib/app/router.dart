// Central router configuration for the app using go_router.
// Defines routes for main navigation and coin detail.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/market/domain/coin_entity.dart';
import '../features/market/presentation/screens/coin_detail_screen.dart';
import '../features/market/presentation/screens/market_screen.dart';
import '../features/portfolio/presentation/screens/portfolio_screen.dart';
import '../features/watchlist/presentation/screens/watchlist_screen.dart';
import 'shell_scaffold.dart';

/// Route paths as constants for type safety
class AppRoutes {
  static const market = '/';
  static const watchlist = '/watchlist';
  static const portfolio = '/portfolio';
  static const settings = '/settings';
  static const coinDetail = '/coin/:id';

  static String coinDetailPath(String coinId) => '/coin/$coinId';
}

/// Build the GoRouter instance
GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.market,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ShellScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.market,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const MarketScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.watchlist,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const WatchlistScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.portfolio,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const PortfolioScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsTab(),
            ),
          ),
        ],
      ),
      // Coin detail as a full-screen route (outside shell)
      GoRoute(
        path: AppRoutes.coinDetail,
        builder: (context, state) {
          final coinId = state.pathParameters['id']!;
          final extra = state.extra;
          final coin = extra is CoinEntity ? extra : null;
          return CoinDetailScreen(coinId: coinId, coin: coin);
        },
      ),
    ],
  );
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings - Coming Soon')),
    );
  }
}
