import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cmc_api_client.dart';
import 'coin_api_client.dart';

/// Attempts to read the CoinMarketCap API key from (priority order):
/// 1. --dart-define CMC_API_KEY
/// 2. .env file (loaded in bootstrap)
final coinMarketCapApiKeyProvider = Provider<String?>((ref) {
  const defineKey = String.fromEnvironment('CMC_API_KEY');
  if (defineKey.isNotEmpty) return defineKey;
  final envKey = dotenv.maybeGet('CMC_API_KEY');
  if (envKey != null && envKey.trim().isNotEmpty) return envKey.trim();
  return null; // indicates not configured
});

/// Provides a configured Dio instance for the CoinGecko API.
final dioProvider = Provider<Dio>((ref) {
  return CoinApiClient.buildDio();
});

/// High-level CoinGecko API client provider.
final coinApiClientProvider = Provider<CoinApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return CoinApiClient(dio);
});

/// Provides a configured Dio instance for CoinMarketCap (adds API key header if present).
final cmcDioProvider = Provider<Dio>((ref) {
  final apiKey = ref.watch(coinMarketCapApiKeyProvider);
  return CmcApiClient.buildDio(apiKey: apiKey);
});

/// High-level CoinMarketCap API client provider.
final cmcApiClientProvider = Provider<CmcApiClient>((ref) {
  final dio = ref.watch(cmcDioProvider);
  return CmcApiClient(dio);
});
