# crypto_dash

A Flutter cryptocurrency price & portfolio tracker (learning project).

## Project Roadmap / Checklist

A living task list with architecture, features, testing, and stretch goals is maintained in `PROJECT_CHECKLIST.md`.

> Update statuses there as you progress (commit messages can reference IDs like `F3`, `D2`, etc.).

## Configuration (Environment Variables)

Runtime configuration uses a `.env` file (loaded via `flutter_dotenv`) plus optional `--dart-define` overrides.

1. Copy / edit the generated `.env` file at project root (it's already ignored by git):

	```env
	CMC_API_KEY=YOUR_KEY_HERE
	MARKET_DATA_SOURCE=coinmarketcap   # coinmarketcap | coingecko | mock
	```

1. Override at build/run time (highest priority):

	```powershell
	flutter run --dart-define CMC_API_KEY=XXXX --dart-define MARKET_DATA_SOURCE=coingecko
	```

Priority order (highest first):

- `--dart-define` values
- `.env` file values
- Defaults (if unset): `MARKET_DATA_SOURCE` defaults to `coinmarketcap`.

If `MARKET_DATA_SOURCE=coinmarketcap` but `CMC_API_KEY` is missing, the UI shows a red warning chip; requests will 401 until a key is added.

### Adding New Vars

Add them to `.env`, list under `assets:` in `pubspec.yaml` (already done for `.env`), then read with:

```dart
final value = dotenv.maybeGet('VAR_NAME');
```

Or for compile-time define (allows tree-shake):

```dart
const define = String.fromEnvironment('VAR_NAME');
```

Use a provider to expose config to the widget tree.

## Getting Started

Typical dev run (uses .env):

```powershell
flutter pub get
flutter run
```

> Tip: When running on Chrome, Flutter may open both the dashboard tab and a Flutter DevTools tab. If you only see the blue "Flutter DevTools" landing page, check the other newly opened tab (or the device window) for the actual `Crypto Dash` UI served on a different localhost port.

Quick run with mock data only:

```powershell
flutter run --dart-define MARKET_DATA_SOURCE=mock
```

Switch to CoinGecko regardless of .env:

```powershell
flutter run --dart-define MARKET_DATA_SOURCE=coingecko
```

Flutter official docs:

For general help: <https://docs.flutter.dev/>

## Testing & Coverage

Run the test suite locally with:

```powershell
flutter test
```

To generate and audit line coverage, use the helper in `tool/coverage.dart`:

```powershell
dart run tool/coverage.dart
```

The script runs `flutter test --coverage`, enforces the project-wide minimum of **40%** line coverage, and prints a summary. Override the threshold with `--min=<percent>` when experimenting locally. Exclude additional files by repeating `--exclude=<glob>` (defaults already skip generated `.g.dart` and `.freezed.dart` outputs).

## Observability (Sentry)

Crash and performance telemetry is handled via [Sentry for Flutter](https://docs.sentry.io/platforms/dart/guides/flutter/). By default the integration is dormant until a DSN is supplied.

1. Add the following keys to your `.env` (or pass them as `--dart-define`s in CI):

   ```ini
   SENTRY_DSN=___your_project_dsn___
   SENTRY_ENV=development
   # Optional:
   # SENTRY_RELEASE=1.0.0+1
   # SENTRY_TRACES_SAMPLE_RATE=0.2
   ```

2. Run the app normally. When `SENTRY_DSN` is present, `bootstrap.dart` initializes Sentry before `runApp`, wiring global error handlers and basic performance tracing. If no DSN is found the app falls back to console logging only.

For production builds choose an appropriate `SENTRY_TRACES_SAMPLE_RATE` (0.0 – 1.0) to balance APM signal vs. event volume.
