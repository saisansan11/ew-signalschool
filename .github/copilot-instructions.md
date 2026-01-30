# EW Simulator - AI Agent Instructions

## Project Overview
This is a Flutter web application simulating electronic warfare (EW) jamming scenarios. The app calculates Jammer-to-Signal (J/S) ratios using RF propagation physics to determine if a target signal is successfully jammed.

## Architecture
- **Single-file design**: All application logic resides in `lib/main.dart`
- **Stateful widget**: `JammingSimulator` manages calculation state and UI updates
- **Real-time calculations**: Physics formulas update instantly as user adjusts parameters
- **Web-first**: Optimized for Chrome deployment with `flutter run -d chrome`

## Key Components
- **Physics Engine**: Implements path loss calculations using `calculatePathLoss()` with frequency-dependent formulas
- **Tactical Map**: Visual representation showing target (red radar icon) and jammer vehicle (blue car icon) positions
- **Status Indicator**: Dynamic color-coded status bar (red for jammed, green for active)
- **Control Panel**: Sliders for jammer power (10-500W) and distance (0-60km), UHF mode toggle

## Critical Formulas
```dart
// Power conversion: Watts to dBm
double wattsToDbm(double watts) => 10 * (log(watts * 1000) / ln10);

// Path loss calculation (Free Space Path Loss + frequency adjustment)
double calculatePathLoss(double distKm, double freqMHz) {
  return 32.44 + (20 * (log(freqMHz) / ln10)) + (20 * (log(distKm) / ln10));
}

// J/S ratio: Jammer power minus path loss vs Signal power minus path loss
double jsRatio = (pJ - lossJ) - (pS - lossS);
```

## Development Workflow
- **Build**: `flutter pub get` to install dependencies
- **Run**: Use VS Code task "Run Flutter App" or `flutter run -d chrome`
- **Test**: `flutter test` (currently has default counter test - update for EW logic)
- **Lint**: `flutter analyze` with standard Flutter lints enabled

## Code Patterns
- **State management**: Use `setState()` for all parameter changes triggering UI updates
- **UI styling**: Dark military theme with specific colors:
  - Background: `Color(0xFF1B1B1B)`
  - App bar: `Color(0xFF2E7d32)` (dark green)
  - Map area: `Color(0xFF263238)` with green borders
  - Status: Red/green based on jam state
- **Positioning**: Vehicle position calculated as `vehiclePositionX = (jammerDistanceKm / 60.0) * screenWidth`
- **Threshold logic**: Jamming succeeds when `jsRatio > 0` (0dB threshold)

## File Structure
- `lib/main.dart`: Complete application implementation
- `test/widget_test.dart`: Placeholder test file (needs EW-specific tests)
- `pubspec.yaml`: Basic Flutter dependencies only
- Platform directories: Standard Flutter scaffolding for web deployment

## Adding Features
- Extend physics calculations in `currentJSRatio` getter
- Add new UI controls by inserting `Slider` or `SwitchListTile` widgets in the `ListView`
- Modify visual effects by updating `Stack` children in the map container
- Add new scenarios by adjusting the constant values at the top of the class

## Testing Approach
- Focus on physics calculation accuracy rather than UI interactions
- Test edge cases: zero distance, maximum power, frequency switching
- Verify J/S ratio calculations match expected RF engineering formulas