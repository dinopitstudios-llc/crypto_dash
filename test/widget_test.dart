import 'package:crypto_dash/features/market/domain/coin_entity.dart';
import 'package:crypto_dash/features/market/presentation/providers/market_providers.dart';
import 'package:crypto_dash/main.dart';
import 'package:crypto_dash/services/api/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders market screen with injected data', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final fakeCoins = [
      const CoinEntity(
        id: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        price: 63123.45,
        change24hPct: 2.5,
        marketCap: 1.2e12,
        volume24h: 35e9,
        sparkline: [63000, 63200, 63150],
        rank: 1,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          marketDataSourceProvider.overrideWithValue(MarketDataSource.mock),
          marketAutoRefreshActivatorProvider.overrideWithValue(null),
          coinMarketCapApiKeyProvider.overrideWithValue(null),
          topCoinsProvider.overrideWith((ref) async => fakeCoins),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Market'), findsWidgets);
    expect(find.textContaining('Bitcoin'), findsOneWidget);
  });
}
