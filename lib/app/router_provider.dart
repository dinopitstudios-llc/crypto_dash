// Riverpod provider for GoRouter instance.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return buildAppRouter();
});
