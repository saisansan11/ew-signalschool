# CLAUDE.md - EW_SIM Development Guide

> **Purpose**: This guide helps Claude Code understand the EW_SIM project, apply best practices from available skills, and maintain consistency across development.

## 📱 Project Overview

**EW_SIM** is a comprehensive Flutter-based Electronic Warfare (EW) simulation and educational application designed to provide realistic training and visualization capabilities for EW concepts and operations.

### Core Objectives
- Deliver educational content covering 8 major EW topics
- Provide interactive 3D visualization for terrain mapping and signal propagation
- Simulate realistic EW scenarios for training purposes
- Create an intuitive, accessible learning platform for EW concepts

### Target Platforms
- Android (primary)
- iOS (secondary)
- Minimum SDK: Android API 21+ (Android 5.0), iOS 12.0+

---

## 🛠️ Available Skills Reference

Claude has access to the following skills that should be applied to this project:

### Development Workflow
- **concise-planning**: Use when planning coding tasks - creates actionable checklists
- **lint-and-validate**: Mandatory after every code change - ensures code quality
- **git-pushing**: Handles staging, committing, and pushing with conventional commits
- **kaizen**: Continuous improvement philosophy - small, frequent improvements

### Mobile App Development
- **flutter-architecture**: App structure, state management, navigation patterns
- **mobile-performance**: Optimization for battery, memory, and smooth 60fps
- **offline-first**: Local storage, sync strategies, network resilience
- **app-security**: Secure storage, encryption, authentication best practices
- **cross-platform**: Platform-specific features (Android/iOS differences)

### Educational & Learning Design
- **instructional-design**: Learning objectives, scaffolding, knowledge retention
- **gamification**: Engagement mechanics, progress tracking, achievement systems
- **microlearning**: Bite-sized lessons, spaced repetition, learning paths
- **assessment-design**: Quiz creation, knowledge checks, adaptive difficulty
- **accessibility-learning**: Universal design for learning (UDL), diverse learners

### Frontend & Design
- **frontend-design**: Distinctive, production-grade UI (principles apply to Flutter)
- **react-patterns**: Modern patterns (reference for state management concepts)
- **tailwind-patterns**: CSS utilities (reference for styling approach)
- **ui-ux-pro-max**: Comprehensive UI/UX guidelines (cross-platform applicable)
- **3d-web-experience**: 3D integration patterns (applicable to Cesium integration)

### Optimization & Testing
- **form-cro**: Form optimization principles (applicable to EW input forms)
- **canvas-design**: Visual art creation (could inspire UI mockups)

**Key Principle**: Apply Kaizen philosophy throughout development - small improvements, error-proofing, standardized patterns, just-in-time implementation.

---

## 🎯 Electronic Warfare (EW) Domain Knowledge

### Core EW Disciplines

#### 1. **Spectrum Analysis**
- **Definition**: The systematic examination and evaluation of electromagnetic spectrum usage
- **Key Concepts**:
  - Frequency domain analysis
  - Signal identification and classification
  - Spectrum occupancy and congestion
  - Real-time spectrum monitoring
- **Visualization Needs**: Real-time spectrum waterfall displays, frequency vs. time plots

#### 2. **Electronic Support Measures (ESM)**
- **Definition**: Passive detection, identification, and location of electromagnetic emissions
- **Key Concepts**:
  - Signal intercept and analysis
  - Emitter identification
  - Direction finding (DF)
  - Electronic Order of Battle (EOB)
- **Visualization Needs**: Signal bearing displays, emitter location overlays on maps

#### 3. **Electronic Counter Measures (ECM)**
- **Definition**: Active or passive techniques to deny or degrade enemy use of electromagnetic spectrum
- **Key Concepts**:
  - Jamming techniques (noise, deception, barrage)
  - Chaff and flare deployment
  - Electronic deception
  - Power management and burn-through calculations
- **Visualization Needs**: Jamming coverage zones, effectiveness overlays

#### 4. **Electronic Counter-Counter Measures (ECCM)**
- **Definition**: Techniques to ensure friendly use of electromagnetic spectrum despite enemy EW
- **Key Concepts**:
  - Frequency agility
  - Spread spectrum techniques
  - Anti-jam waveforms
  - Power management
- **Visualization Needs**: Protected zones, signal resilience indicators

#### 5. **Radio Communications with COMSEC**
- **Definition**: Secure communication systems and cryptographic protection
- **Key Concepts**:
  - Encryption/decryption
  - Key management (TRANSEC/COMSEC)
  - Secure voice/data transmission
  - Low Probability of Intercept (LPI) communications
- **Visualization Needs**: Secure network topology, encryption status indicators

#### 6. **Radar Technology**
- **Definition**: Detection and tracking using electromagnetic waves
- **Key Concepts**:
  - Pulse-Doppler processing
  - Synthetic Aperture Radar (SAR)
  - Radar cross-section (RCS)
  - Clutter and target discrimination
- **Visualization Needs**: Radar coverage patterns, target tracks, range rings

#### 7. **Anti-Drone Systems**
- **Definition**: Detection, identification, and neutralization of unmanned aerial systems
- **Key Concepts**:
  - Multi-sensor detection (RF, radar, optical)
  - Drone signature database
  - Jamming and spoofing techniques
  - Kinetic and non-kinetic countermeasures
- **Visualization Needs**: Drone tracks, sensor coverage, threat zones

#### 8. **GPS Warfare**
- **Definition**: Denial, disruption, or spoofing of Global Navigation Satellite Systems (GNSS)
- **Key Concepts**:
  - GPS jamming techniques
  - Spoofing and meaconing
  - Anti-jam GPS receivers
  - Inertial Navigation System (INS) integration
- **Visualization Needs**: GPS denial zones, signal strength maps, spoofing detection

### EW Terminology Reference

| Term | Definition | Usage Context |
|------|------------|---------------|
| **Emitter** | Any source of electromagnetic radiation | ESM, signal analysis |
| **Pulse Repetition Frequency (PRF)** | Rate at which radar pulses are transmitted | Radar identification |
| **Electronic Order of Battle (EOB)** | Database of enemy electronic systems | Tactical planning |
| **Burn-through Range** | Distance at which radar overcomes jamming | ECM effectiveness |
| **Link Budget** | Power calculation for signal transmission | Communications planning |
| **Antenna Gain** | Directional efficiency of antenna | All RF systems |
| **EIRP** | Effective Isotropic Radiated Power | Transmitter capability |
| **Sensitivity** | Minimum detectable signal level | Receiver capability |
| **Doppler Shift** | Frequency change due to relative motion | Moving target detection |
| **Polarization** | Orientation of electromagnetic wave | Signal characteristics |

### Military Standards & Protocols
- **NATO STANAG 4193**: EW support measures
- **MIL-STD-461**: Electromagnetic interference requirements
- **IEEE 802.11**: Wireless communication standards (for modern context)
- **ITU-R Radio Regulations**: Frequency allocation and usage

### Authoritative Resources
- Jane's Radar and Electronic Warfare Systems
- DoD Electronic Warfare Fundamentals (unclassified portions)
- IEEE papers on signal processing and electromagnetic theory
- Open-source intelligence (OSINT) on commercial EW systems

---

## 💡 Development Philosophy (Kaizen-Inspired)

This project follows **Kaizen principles** - continuous improvement through small, deliberate changes:

### 1. Continuous Improvement
- Make the smallest viable change that improves quality
- Refactor while you work (within scope)
- Always leave code better than you found it
- Iterate: make it work → make it clear → make it efficient

### 2. Error Proofing (Poka-Yoke)
- Design systems that prevent errors at compile/design time
- Use type system to make invalid states unrepresentable
- Validate at boundaries, use everywhere safely
- Fail fast with clear error messages

### 3. Standardized Work
- Follow existing codebase patterns
- Document what works (in this CLAUDE.md)
- Use linters to enforce style
- Automate quality gates

### 4. Just-In-Time (JIT)
- Build what's needed now, no more
- No premature optimization
- Add complexity only when measured need exists
- YAGNI (You Aren't Gonna Need It)

**Workflow Integration**:
1. **Plan** with `concise-planning` skill
2. **Implement** following architecture below
3. **Validate** with `lint-and-validate` skill
4. **Commit** using `git-pushing` skill

---

## 🏗️ Flutter Architecture & Development Guidelines

### Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/          # App-wide constants
│   ├── theme/             # Theme configuration
│   ├── utils/             # Utility functions
│   └── services/          # Core services (navigation, etc.)
├── features/
│   ├── spectrum_analysis/
│   │   ├── data/          # Data models and repositories
│   │   ├── domain/        # Business logic
│   │   └── presentation/  # UI components
│   ├── esm/
│   ├── ecm/
│   ├── eccm/
│   ├── radio_comsec/
│   ├── radar/
│   ├── anti_drone/
│   ├── gps_warfare/
│   └── visualization_3d/  # Cesium/3D globe integration
├── shared/
│   ├── widgets/           # Reusable widgets
│   ├── models/            # Shared data models
│   └── extensions/        # Dart extensions
└── config/
    ├── routes/            # Route configuration
    └── dependency_injection/
```

### State Management

**Approach**: **Provider + ChangeNotifier**

**Rationale**:
- Simple and efficient for educational app
- Native Flutter solution with minimal overhead
- Easy to test and debug
- Suitable for moderate complexity

**Alternative Consideration**: Riverpod for more complex state scenarios

**State Organization**:
```dart
// Example state structure
class SpectrumAnalysisState extends ChangeNotifier {
  FrequencyData? _currentData;
  bool _isScanning = false;
  List<SignalPeak> _detectedSignals = [];
  
  // Getters
  FrequencyData? get currentData => _currentData;
  bool get isScanning => _isScanning;
  List<SignalPeak> get detectedSignals => _detectedSignals;
  
  // Methods
  Future<void> startScan() async { /* ... */ }
  void updateFrequencyData(FrequencyData data) { /* ... */ }
}
```

### Code Style & Conventions

#### Naming Conventions
- **Classes**: PascalCase (`RadarSystem`, `SignalProcessor`)
- **Files**: snake_case (`radar_system.dart`, `signal_processor.dart`)
- **Variables/Functions**: camelCase (`frequencyRange`, `calculatePower()`)
- **Constants**: SCREAMING_SNAKE_CASE (`MAX_FREQUENCY`, `DEFAULT_GAIN`)
- **Private members**: prefix with underscore (`_internalState`)

#### Documentation
```dart
/// Calculates effective radiated power based on transmitter and antenna.
///
/// Uses the formula: ERP = P_tx × G_antenna
///
/// Parameters:
///   - [transmitterPower]: Power output in watts
///   - [antennaGain]: Antenna gain in dBi
///
/// Returns: Effective radiated power in watts
double calculateERP(double transmitterPower, double antennaGain) {
  // Implementation
}
```

#### File Organization
1. Imports (Dart SDK, Flutter, packages, relative)
2. Constants
3. Main class/widget
4. Private helper classes/functions
5. Extensions (if any)

#### Widget Structure
```dart
class SpectrumDisplayWidget extends StatelessWidget {
  // 1. Final fields
  final FrequencyData data;
  final VoidCallback? onTap;
  
  // 2. Constructor
  const SpectrumDisplayWidget({
    Key? key,
    required this.data,
    this.onTap,
  }) : super(key: key);
  
  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Container(
      // Widget tree
    );
  }
  
  // 4. Private helper methods
  Widget _buildFrequencyAxis() { /* ... */ }
}
```

### Flutter Best Practices for EW_SIM

#### Performance Optimization
1. **Use `const` constructors** wherever possible
2. **Avoid rebuilds**: Use `Provider.of<T>(context, listen: false)` when not listening
3. **Lazy loading**: Load 3D models and heavy assets on demand
4. **Image caching**: Use `CachedNetworkImage` for educational content images
5. **List optimization**: Use `ListView.builder()` for long lists

#### 3D Visualization Specific
```dart
// Efficient 3D model loading
class ModelLoader {
  final Map<String, Model3D> _cache = {};
  
  Future<Model3D> loadModel(String path) async {
    if (_cache.containsKey(path)) {
      return _cache[path]!;
    }
    
    final model = await _loadFromAsset(path);
    _cache[path] = model;
    return model;
  }
}
```

#### Error Handling
```dart
// Consistent error handling pattern
try {
  final result = await riskyOperation();
  return Right(result);
} on NetworkException catch (e) {
  return Left(NetworkFailure(e.message));
} on CacheException catch (e) {
  return Left(CacheFailure(e.message));
} catch (e) {
  return Left(UnknownFailure(e.toString()));
}
```

#### Dependency Injection
```dart
// Using GetIt for service location
final getIt = GetIt.instance;

void setupDependencies() {
  // Singletons
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<ThemeService>(ThemeService());
  
  // Factories
  getIt.registerFactory<RadarSimulation>(() => RadarSimulation());
  
  // Lazy singletons
  getIt.registerLazySingleton<DatabaseService>(
    () => DatabaseService(),
  );
}
```

---

## 🌐 3D Visualization with Cesium

### Integration Strategy

**Primary Approach**: WebView-based Cesium integration

**Rationale**:
- Cesium provides Google Earth-like capabilities
- Mature library with extensive documentation
- Supports terrain visualization, 3D models, and real-time data
- Cross-platform compatibility

### Technical Implementation

#### WebView Setup
```dart
import 'package:webview_flutter/webview_flutter.dart';

class CesiumGlobeWidget extends StatefulWidget {
  @override
  _CesiumGlobeWidgetState createState() => _CesiumGlobeWidgetState();
}

class _CesiumGlobeWidgetState extends State<CesiumGlobeWidget> {
  late WebViewController _controller;
  
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'assets/cesium/index.html',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _controller = controller;
      },
      javascriptChannels: {
        JavascriptChannel(
          name: 'FlutterBridge',
          onMessageReceived: (JavascriptMessage message) {
            _handleCesiumMessage(message.message);
          },
        ),
      },
    );
  }
  
  void _handleCesiumMessage(String message) {
    // Process messages from Cesium
  }
}
```

#### Cesium HTML Template
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <script src="https://cesium.com/downloads/cesiumjs/releases/1.109/Build/Cesium/Cesium.js"></script>
  <link href="https://cesium.com/downloads/cesiumjs/releases/1.109/Build/Cesium/Widgets/widgets.css" rel="stylesheet">
  <style>
    #cesiumContainer { width: 100%; height: 100%; margin: 0; padding: 0; overflow: hidden; }
  </style>
</head>
<body>
  <div id="cesiumContainer"></div>
  <script>
    const viewer = new Cesium.Viewer('cesiumContainer', {
      terrainProvider: Cesium.createWorldTerrain()
    });
    
    // Communication with Flutter
    function sendToFlutter(message) {
      FlutterBridge.postMessage(JSON.stringify(message));
    }
    
    // Add signal propagation visualization
    function addSignalCoverage(lat, lon, radius, color) {
      viewer.entities.add({
        position: Cesium.Cartesian3.fromDegrees(lon, lat),
        ellipse: {
          semiMinorAxis: radius,
          semiMajorAxis: radius,
          material: Cesium.Color.fromCssColorString(color).withAlpha(0.3),
          outline: true,
          outlineColor: Cesium.Color.fromCssColorString(color)
        }
      });
    }
  </script>
</body>
</html>
```

#### Flutter-Cesium Communication
```dart
class CesiumBridge {
  final WebViewController controller;
  
  CesiumBridge(this.controller);
  
  // Add radar coverage zone
  Future<void> addRadarCoverage({
    required double latitude,
    required double longitude,
    required double radius,
    required Color color,
  }) async {
    final colorHex = '#${color.value.toRadixString(16).substring(2)}';
    await controller.runJavascript(
      'addSignalCoverage($latitude, $longitude, $radius, "$colorHex")'
    );
  }
  
  // Add emitter marker
  Future<void> addEmitter({
    required double latitude,
    required double longitude,
    required String label,
    required EmitterType type,
  }) async {
    await controller.runJavascript('''
      viewer.entities.add({
        position: Cesium.Cartesian3.fromDegrees($longitude, $latitude),
        point: { pixelSize: 10, color: Cesium.Color.RED },
        label: { text: "$label", font: "14px sans-serif" }
      });
    ''');
  }
}
```

### 3D Model Integration

#### Model Format Support
- **Primary**: glTF/GLB (optimized for web, widely supported)
- **Secondary**: COLLADA (DAE) for complex military models
- **Fallback**: Basic geometric primitives for simple shapes

#### Model Loading Strategy
```dart
class Model3DLoader {
  final AssetBundle assetBundle;
  
  Future<String> loadGLTFModel(String assetPath) async {
    final data = await assetBundle.load(assetPath);
    final base64 = base64Encode(data.buffer.asUint8List());
    return 'data:model/gltf-binary;base64,$base64';
  }
}
```

#### Performance Constraints
- **Maximum polygon count per model**: 50,000 triangles
- **Texture resolution**: Max 2048x2048 pixels
- **Number of simultaneous models**: Max 20 on screen
- **LOD (Level of Detail)**: Use 3 LOD levels for complex models
- **Frame rate target**: Minimum 30 FPS on mid-range devices

### Terrain Visualization

#### Data Sources
- **Global terrain**: Cesium World Terrain (online)
- **Custom terrain**: Support for custom DEM (Digital Elevation Model) data
- **Fallback**: WGS84 ellipsoid for offline mode

#### Signal Propagation Overlay
```javascript
// Add radio signal propagation heatmap
function addPropagationMap(centerLat, centerLon, frequency, power) {
  const propagationData = calculatePropagation(centerLat, centerLon, frequency, power);
  
  const rectangles = [];
  for (let lat = -90; lat < 90; lat += 1) {
    for (let lon = -180; lon < 180; lon += 1) {
      const signalStrength = propagationData[lat][lon];
      const color = getColorForStrength(signalStrength);
      
      rectangles.push({
        coordinates: Cesium.Rectangle.fromDegrees(lon, lat, lon + 1, lat + 1),
        material: color.withAlpha(0.5)
      });
    }
  }
  
  viewer.entities.add({
    rectangle: {
      coordinates: rectangles,
      material: new Cesium.ImageMaterialProperty({
        image: generateHeatmap(propagationData)
      })
    }
  });
}
```

---

## ✅ Quality Control & Validation

**MANDATORY**: Run validation after EVERY code change. Do not finish a task until code is error-free.

### Dart/Flutter Validation

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run tests
flutter test

# Check for unused dependencies
flutter pub outdated
```

### Quality Loop (From lint-and-validate skill)

1. **Write/Edit Code**
2. **Run Audit**: `flutter analyze && dart format --set-exit-if-changed .`
3. **Analyze Report**: Check for errors, warnings, infos
4. **Fix & Repeat**: No code should be committed with analysis failures

### Error Handling Pattern

```dart
// Consistent error handling across app
try {
  final result = await riskyOperation();
  return Right(result);
} on NetworkException catch (e) {
  return Left(NetworkFailure(e.message));
} on CacheException catch (e) {
  return Left(CacheFailure(e.message));
} catch (e) {
  return Left(UnknownFailure(e.toString()));
}
```

**Strict Rule**: No code should be reported as "done" without passing these checks.

---

## 🎨 UI/UX Design Guidelines

### Design Principles

#### 1. **Clarity Over Decoration**
- Educational content must be immediately understandable
- Avoid unnecessary visual clutter
- Use whitespace effectively

#### 2. **Progressive Disclosure**
- Present basic concepts first
- Allow users to drill down into details
- Use expandable sections for advanced topics

#### 3. **Visual Consistency**
- Maintain consistent color coding across all EW disciplines
- Use same iconography patterns throughout
- Keep layout patterns predictable

#### 4. **Feedback and Confirmation**
- Provide immediate visual feedback for all interactions
- Show loading states for 3D content
- Confirm destructive actions

### Color Scheme

#### Primary Colors (EW Discipline Mapping)
```dart
class EWColors {
  // Spectrum Analysis - Blue tones
  static const spectrumPrimary = Color(0xFF2196F3);
  static const spectrumAccent = Color(0xFF64B5F6);
  
  // ESM - Green tones (passive detection)
  static const esmPrimary = Color(0xFF4CAF50);
  static const esmAccent = Color(0xFF81C784);
  
  // ECM - Red tones (active jamming)
  static const ecmPrimary = Color(0xFFF44336);
  static const ecmAccent = Color(0xFFE57373);
  
  // ECCM - Orange tones (countermeasures)
  static const eccmPrimary = Color(0xFFFF9800);
  static const eccmAccent = Color(0xFFFFB74D);
  
  // Radio/COMSEC - Purple tones
  static const radioComsecPrimary = Color(0xFF9C27B0);
  static const radioComsecAccent = Color(0xFFBA68C8);
  
  // Radar - Cyan tones
  static const radarPrimary = Color(0xFF00BCD4);
  static const radarAccent = Color(0xFF4DD0E1);
  
  // Anti-Drone - Amber tones
  static const antiDronePrimary = Color(0xFFFFC107);
  static const antiDroneAccent = Color(0xFFFFD54F);
  
  // GPS Warfare - Teal tones
  static const gpsPrimary = Color(0xFF009688);
  static const gpsAccent = Color(0xFF4DB6AC);
  
  // Neutral colors
  static const background = Color(0xFF121212);
  static const surface = Color(0xFF1E1E1E);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0B0);
}
```

#### Theme Configuration
```dart
ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: EWColors.spectrumPrimary,
    scaffoldBackgroundColor: EWColors.background,
    cardColor: EWColors.surface,
    
    // Typography
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: EWColors.textPrimary,
        fontFamily: 'Roboto',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: EWColors.textPrimary,
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: EWColors.textSecondary,
        fontFamily: 'Roboto',
      ),
    ),
    
    // Component themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
```

### Iconography

**Icon Library**: Material Icons + Custom EW Icons

**Custom Icon Requirements**:
- SVG format for scalability
- Consistent stroke width (2px)
- 24x24dp base size
- Monochrome with theme color overlay

**EW-Specific Icons Needed**:
- Radar dish
- Radio waves (various patterns)
- Jammer symbol
- Drone silhouette
- GPS satellite
- Antenna patterns
- Signal strength indicator

### Accessibility

#### WCAG 2.1 Level AA Compliance
- **Color contrast ratio**: Minimum 4.5:1 for text
- **Touch targets**: Minimum 48x48 dp
- **Text scaling**: Support up to 200% system font size
- **Screen reader**: Full semantic labeling with `Semantics` widget

```dart
// Accessibility example
Semantics(
  label: 'Radar coverage zone for Site Alpha',
  hint: 'Shows effective detection range',
  child: RadarCoverageWidget(site: siteAlpha),
)
```

#### Multi-Language Support
- **Primary**: English
- **Secondary**: Thai (native language support)
- **Framework**: Use `flutter_localizations` and `intl` package
- **Text direction**: LTR (Left-to-Right) for both languages

### Animation Guidelines

#### Performance Targets
- **Frame rate**: 60 FPS minimum
- **Animation duration**: 200-400ms for most transitions
- **Easing curves**: Use `Curves.easeInOut` for natural motion

#### Animation Usage
```dart
// Smooth transition for educational content
class ContentTransition extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
```

**Avoid**:
- Excessive animations that distract from content
- Complex 3D transformations on low-end devices
- Simultaneous animations (use choreography)

### Responsive Design

#### Breakpoints
```dart
class ScreenBreakpoints {
  static const double mobile = 600;    // Phones
  static const double tablet = 900;    // Tablets
  static const double desktop = 1200;  // Large screens
}
```

#### Layout Adaptation
```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ScreenBreakpoints.desktop && desktop != null) {
          return desktop!;
        } else if (constraints.maxWidth >= ScreenBreakpoints.tablet && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
```

---

## 🧪 Testing Strategy

### Testing Pyramid

```
           ╱╲
          ╱ E2E╲        End-to-End Tests (10%)
         ╱──────╲
        ╱Integration╲    Integration Tests (20%)
       ╱────────────╲
      ╱  Unit Tests  ╲   Unit Tests (70%)
     ╱────────────────╲
```

### Unit Testing

**Coverage Target**: Minimum 80% for business logic

**Focus Areas**:
- Signal processing algorithms
- EW calculations (power, range, coverage)
- Data models and serialization
- State management logic

```dart
// Example unit test
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RadarCalculations', () {
    test('should calculate correct detection range', () {
      // Arrange
      const transmitPower = 1000.0; // watts
      const antennaGain = 30.0;      // dBi
      const frequency = 10e9;         // 10 GHz
      const targetRCS = 1.0;          // square meters
      
      // Act
      final range = calculateRadarRange(
        transmitPower: transmitPower,
        antennaGain: antennaGain,
        frequency: frequency,
        targetRCS: targetRCS,
      );
      
      // Assert
      expect(range, closeTo(45000, 1000)); // ~45 km ± 1 km
    });
    
    test('should handle zero power input gracefully', () {
      expect(
        () => calculateRadarRange(
          transmitPower: 0,
          antennaGain: 30,
          frequency: 10e9,
          targetRCS: 1,
        ),
        throwsA(isA<InvalidPowerException>()),
      );
    });
  });
}
```

### Widget Testing

**Coverage Target**: All custom widgets and screens

**Focus Areas**:
- User interactions (taps, gestures)
- Navigation flows
- State changes reflected in UI
- Accessibility features

```dart
// Example widget test
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('SpectrumAnalyzer displays frequency data', (tester) async {
    // Arrange
    final testData = FrequencyData(
      centerFrequency: 2.4e9,
      bandwidth: 20e6,
      peaks: [
        SignalPeak(frequency: 2.412e9, power: -50),
        SignalPeak(frequency: 2.437e9, power: -60),
      ],
    );
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: SpectrumAnalyzer(data: testData),
      ),
    );
    
    // Assert
    expect(find.text('2.4 GHz'), findsOneWidget);
    expect(find.byType(FrequencyPlot), findsOneWidget);
    
    // Check accessibility
    final semantics = tester.getSemantics(find.byType(FrequencyPlot));
    expect(semantics.label, contains('Spectrum display'));
  });
  
  testWidgets('Tapping on signal peak shows details', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SpectrumAnalyzer(data: testData)),
    );
    
    // Find and tap the first peak
    await tester.tap(find.byKey(Key('peak_0')));
    await tester.pumpAndSettle();
    
    // Verify detail dialog appears
    expect(find.byType(SignalDetailDialog), findsOneWidget);
    expect(find.text('-50 dBm'), findsOneWidget);
  });
}
```

### Integration Testing

**Coverage Target**: Critical user flows

**Focus Areas**:
- Complete EW scenarios (e.g., detect → analyze → jam)
- 3D visualization with data updates
- State persistence across sessions
- Performance under load

```dart
// Example integration test
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Complete ESM scenario flow', (tester) async {
    // Launch app
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    
    // Navigate to ESM module
    await tester.tap(find.text('ESM'));
    await tester.pumpAndSettle();
    
    // Start signal scan
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle(Duration(seconds: 2));
    
    // Verify signals detected
    expect(find.text('Signals Detected'), findsOneWidget);
    expect(find.byType(SignalListItem), findsWidgets);
    
    // Select first signal
    await tester.tap(find.byType(SignalListItem).first);
    await tester.pumpAndSettle();
    
    // Verify analysis screen appears
    expect(find.text('Signal Analysis'), findsOneWidget);
    expect(find.byType(WaveformDisplay), findsOneWidget);
    
    // Add to EOB (Electronic Order of Battle)
    await tester.tap(find.text('Add to EOB'));
    await tester.pumpAndSettle();
    
    // Verify confirmation
    expect(find.text('Added to EOB'), findsOneWidget);
  });
}
```

### 3D Visualization Testing

**Special Considerations**:
- WebView testing requires platform-specific setup
- Mock JavaScript communication for unit tests
- Visual regression testing for 3D scenes

```dart
// Mock Cesium bridge for testing
class MockCesiumBridge extends Mock implements CesiumBridge {
  final List<Map<String, dynamic>> _commands = [];
  
  @override
  Future<void> addRadarCoverage({
    required double latitude,
    required double longitude,
    required double radius,
    required Color color,
  }) async {
    _commands.add({
      'type': 'radar_coverage',
      'lat': latitude,
      'lon': longitude,
      'radius': radius,
      'color': color,
    });
  }
  
  List<Map<String, dynamic>> get commands => _commands;
}

// Test
test('3D scene adds radar coverage correctly', () async {
  final mockBridge = MockCesiumBridge();
  final scene3D = Scene3DController(bridge: mockBridge);
  
  await scene3D.displayRadarSite(
    latitude: 13.7563,
    longitude: 100.5018,
    range: 50000,
  );
  
  expect(mockBridge.commands.length, 1);
  expect(mockBridge.commands.first['type'], 'radar_coverage');
  expect(mockBridge.commands.first['radius'], 50000);
});
```

### Performance Testing

**Key Metrics**:
- App startup time: < 2 seconds
- Screen transition time: < 300ms
- 3D scene initialization: < 3 seconds
- Memory usage: < 200 MB baseline
- 60 FPS during animations

```dart
// Performance benchmark example
import 'package:flutter/scheduler.dart';

void main() {
  test('Spectrum analysis performance benchmark', () async {
    final stopwatch = Stopwatch()..start();
    final data = generateLargeDataset(points: 10000);
    
    final analyzer = SpectrumAnalyzer();
    final result = await analyzer.process(data);
    
    stopwatch.stop();
    
    // Should complete in less than 100ms
    expect(stopwatch.elapsedMilliseconds, lessThan(100));
  });
}
```

### Test Data

**Mock Signal Database**:
```dart
class MockSignalDatabase {
  static final List<Signal> testSignals = [
    Signal(
      frequency: 2.4e9,
      power: -50,
      modulation: ModulationType.qpsk,
      bandwidth: 20e6,
      category: SignalCategory.communication,
    ),
    Signal(
      frequency: 10e9,
      power: -40,
      modulation: ModulationType.pulseDoppler,
      bandwidth: 100e6,
      category: SignalCategory.radar,
    ),
    // Add more test signals...
  ];
}
```

### Edge Cases to Test

1. **Empty States**
   - No signals detected
   - No data available for visualization
   - Offline mode with no cached data

2. **Boundary Conditions**
   - Maximum frequency (300 GHz)
   - Minimum detectable signal (-120 dBm)
   - Zero-range scenarios

3. **Error Scenarios**
   - Network timeout during data fetch
   - Invalid 3D model format
   - WebView crash recovery
   - GPS unavailable

4. **Concurrent Operations**
   - Multiple signal scans simultaneously
   - 3D rendering during state updates
   - Background calculations while UI interacting

---

## 🔒 Security & Privacy

### Data Protection

#### Sensitive Information Handling
- **EW scenarios**: May contain tactical information - local storage only
- **User progress**: Encrypted with `flutter_secure_storage`
- **No telemetry**: Educational app should not track user behavior
- **Offline-first**: Core functionality available without internet

```dart
// Secure storage for sensitive data
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureDataService {
  final _storage = FlutterSecureStorage();
  
  Future<void> saveScenario(Scenario scenario) async {
    final json = jsonEncode(scenario.toJson());
    await _storage.write(
      key: 'scenario_${scenario.id}',
      value: json,
    );
  }
  
  Future<Scenario?> loadScenario(String id) async {
    final json = await _storage.read(key: 'scenario_$id');
    if (json == null) return null;
    return Scenario.fromJson(jsonDecode(json));
  }
}
```

### Code Security

#### Dependencies Audit
- Run `flutter pub outdated` monthly
- Check for known vulnerabilities with `dart pub deps`
- Pin critical dependencies to specific versions

#### WebView Security
```dart
// Secure WebView configuration
WebView(
  initialUrl: localAssetUrl, // Only load local assets
  javascriptMode: JavascriptMode.unrestricted,
  gestureNavigationEnabled: false,
  
  // Prevent unauthorized navigation
  navigationDelegate: (NavigationRequest request) {
    if (!request.url.startsWith('file://') && 
        !request.url.startsWith('data:')) {
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  },
)
```

---

## 📦 Dependencies

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.0
  
  # UI Components
  flutter_svg: ^2.0.0
  cached_network_image: ^3.3.0
  
  # WebView for Cesium
  webview_flutter: ^4.4.0
  
  # Data & Storage
  sqflite: ^2.3.0
  path_provider: ^2.1.0
  flutter_secure_storage: ^9.0.0
  
  # Utilities
  intl: ^0.18.0
  uuid: ^4.0.0
  
  # Dependency Injection
  get_it: ^7.6.0
  
  # Math & Calculations
  vector_math: ^2.1.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Testing
  mockito: ^5.4.0
  integration_test:
    sdk: flutter
  
  # Code Quality
  flutter_lints: ^3.0.0
```

### Asset Management

```yaml
flutter:
  assets:
    # 3D Models
    - assets/models/radar/
    - assets/models/antennas/
    - assets/models/drones/
    
    # Cesium WebView
    - assets/cesium/
    
    # Educational Content
    - assets/images/diagrams/
    - assets/images/icons/
    
    # Data Files
    - assets/data/signals.json
    - assets/data/scenarios.json
```

---

## 🚀 Build & Deployment

### Development Workflow

```bash
# Clean build
flutter clean
flutter pub get

# Run app (development mode)
flutter run --debug

# Run with specific flavor (if using)
flutter run --flavor development -t lib/main_dev.dart

# Run tests
flutter test
flutter test integration_test/

# Code generation (if using)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Build Configurations

#### Android Release Build
```bash
# Generate release APK
flutter build apk --release --split-per-abi

# Generate release AAB (for Play Store)
flutter build appbundle --release
```

#### iOS Release Build
```bash
# Generate release IPA
flutter build ios --release
```

### Version Management

**Semantic Versioning**: MAJOR.MINOR.PATCH
- **MAJOR**: Breaking changes to UI or core features
- **MINOR**: New EW modules or significant features
- **PATCH**: Bug fixes and minor improvements

```yaml
# pubspec.yaml
version: 1.0.0+1
# Format: version_name+build_number
```

---

## 📚 Documentation Requirements

### Code Documentation

Every public API must include:
1. **Purpose**: What does this class/function do?
2. **Parameters**: What inputs does it accept?
3. **Returns**: What does it return?
4. **Example**: How to use it?

```dart
/// Calculates Line-of-Sight (LOS) distance between two points considering Earth curvature.
///
/// Uses the Haversine formula with terrain elevation adjustments.
/// Accounts for atmospheric refraction (4/3 Earth radius approximation).
///
/// Parameters:
///   - [point1]: First geographic point with elevation
///   - [point2]: Second geographic point with elevation
///   - [frequency]: Operating frequency in Hz (affects refraction)
///
/// Returns: LOS distance in meters, or null if obstructed by terrain
///
/// Example:
/// ```dart
/// final distance = calculateLOS(
///   GeoPoint(lat: 13.7563, lon: 100.5018, elevation: 100),
///   GeoPoint(lat: 13.7600, lon: 100.5100, elevation: 50),
///   frequency: 10e9,
/// );
/// print('LOS distance: ${distance}m');
/// ```
double? calculateLOS(GeoPoint point1, GeoPoint point2, double frequency) {
  // Implementation...
}
```

### EW Scenario Documentation

Each scenario file should include:
```json
{
  "scenario_id": "esm_basic_001",
  "title": "Basic ESM Detection Exercise",
  "description": "Learn to identify and classify common radar emissions",
  "learning_objectives": [
    "Distinguish between pulse and CW radars",
    "Measure PRF and pulse width accurately",
    "Classify emitter based on signal characteristics"
  ],
  "difficulty": "beginner",
  "estimated_time_minutes": 15,
  "prerequisite_scenarios": [],
  "signals": [
    {
      "emitter_id": "radar_001",
      "type": "air_search_radar",
      "frequency_ghz": 10.0,
      "prf_hz": 1000,
      "pulse_width_us": 2.0
    }
  ]
}
```

---

## 🎓 Learning Resources for Developers

### Recommended Reading

**Flutter Development**:
- [Flutter Documentation](https://docs.flutter.dev/)
- "Flutter Complete Reference" by Alberto Miola
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)

**Electronic Warfare**:
- "Introduction to Electronic Warfare" by D. Curtis Schleher
- "Electronic Warfare and Radar Systems Engineering Handbook" (Naval Air Warfare Center)
- [IEEE Xplore](https://ieeexplore.ieee.org/) - Search for "electronic warfare"

**3D Visualization**:
- [Cesium Documentation](https://cesium.com/learn/)
- [WebGL Fundamentals](https://webglfundamentals.org/)

### Community & Support

- **Flutter Community**: [Discord](https://discord.gg/flutter)
- **Stack Overflow**: Tag questions with `flutter` and `electronic-warfare`
- **GitHub Discussions**: Use for feature requests and architectural questions

---

## 🔄 Git Workflow

### Conventional Commits (From git-pushing skill)

**ALWAYS use the smart commit script** - do NOT use manual git commands:

```bash
# Auto-generate conventional commit message
bash skills/git-pushing/scripts/smart_commit.sh

# Or with custom message
bash skills/git-pushing/scripts/smart_commit.sh "feat(esm): add direction finding algorithm"
```

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code restructuring without changing behavior
- `test`: Adding or modifying tests
- `chore`: Build process or auxiliary tools
- `perf`: Performance improvements

**Scopes** (EW modules):
- `spectrum`: Spectrum Analysis
- `esm`: Electronic Support Measures
- `ecm`: Electronic Counter Measures
- `eccm`: Electronic Counter-Counter Measures
- `radio`: Radio Communications with COMSEC
- `radar`: Radar Technology
- `anti-drone`: Anti-Drone Systems
- `gps`: GPS Warfare
- `3d`: 3D Visualization
- `core`: Core functionality

**Example**:
```
feat(esm): add direction finding algorithm

Implement Watson-Watt DF method for signal bearing estimation.
Includes unit tests and integration with ESM display widget.

Closes #42
```

### Branch Strategy

**GitFlow**:
- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/`: Individual feature development
- `hotfix/`: Critical bug fixes

---

## 📋 Planning Approach (concise-planning skill)

## 📞 Support & Contact

### For Development Issues
- Check existing GitHub issues first
- Provide minimal reproducible example
- Include Flutter doctor output
- Specify device/emulator details

### For EW Domain Questions
- Reference authoritative sources (textbooks, standards)
- Distinguish between classified and unclassified concepts
- Use open-source intelligence when possible

---

## 🎯 Roadmap & Future Enhancements

### Phase 1: Core Educational Content (Current)
- ✅ Basic app structure
- ✅ Educational content for 8 EW topics
- 🔄 3D globe with Cesium integration

### Phase 2: Interactive Simulations
- Signal processing visualizations
- Real-time spectrum analyzer simulation
- Interactive jamming scenarios

### Phase 3: Advanced Features
- Multi-player scenarios (collaborative learning)
- AR visualization for antenna patterns
- Export simulation results to PDF

### Phase 4: AI Integration
- Automatic signal classification
- Optimal jamming strategy recommendations
- Adaptive learning path based on performance

---

## 📝 Change Log

### v0.1.0 (Current Development)
- Initial project structure
- Basic navigation
- Placeholder content for EW modules
- Cesium WebView integration prototype

---

## ⚖️ License & Attribution

This is an educational project. Use responsibly and in accordance with local laws regarding electronic warfare information.

**Educational Use Only**: This application is for training and education purposes. It does not contain classified information and should not be used for actual military operations.

**Third-Party Licenses**:
- Cesium: Apache License 2.0
- Flutter: BSD 3-Clause License
- All dependencies: See respective licenses in `pubspec.lock`

---

## 🙏 Acknowledgments

- Cesium Team for excellent 3D visualization platform
- Flutter Team for the amazing framework
- Open-source EW community for educational resources

---

**Last Updated**: 2025-02-01  
**Document Version**: 1.0.0  
**Maintained By**: EW_SIM Development Team

When starting a new coding task, use this approach:

### Plan Template

```markdown
# Plan: [Feature Name]

**Approach**: [1-3 sentences on what and why]

## Scope

**In**:
- [What will be implemented]
- [Components affected]

**Out**:
- [What won't be included]
- [Future considerations]

## Action Items

- [ ] Step 1: Discovery (scan relevant code)
- [ ] Step 2: Implementation (create/modify files)
- [ ] Step 3: Validation (run tests/linters)
- [ ] Step 4: Rollout (commit with conventional message)

## Open Questions

- [Question 1, if any]
```

### Checklist Guidelines

- **Atomic**: Each step is a single logical unit
- **Verb-first**: "Add...", "Refactor...", "Verify..."
- **Concrete**: Name specific files/modules when possible

**Example Plan**:

```markdown
# Plan: Add Signal Bearing Display to ESM Module

**Approach**: Create a circular bearing indicator widget that shows detected signal direction using Watson-Watt DF algorithm results.

## Scope

**In**:
- BearingIndicatorWidget (new widget)
- Integration with ESMState
- Unit tests for bearing calculations
- Widget tests for visual rendering

**Out**:
- Historical bearing data storage
- Multi-signal bearing comparison
- 3D bearing visualization (future)

## Action Items

- [ ] Create lib/features/esm/presentation/widgets/bearing_indicator.dart
- [ ] Add bearing angle to ESMState model
- [ ] Implement circular bearing display with CustomPainter
- [ ] Add unit tests for angle calculations
- [ ] Add widget test for rendering
- [ ] Run flutter analyze && flutter test
- [ ] Commit with "feat(esm): add signal bearing indicator"

## Open Questions

- Should bearing update in real-time or only on user tap?
```

---

## 🎯 Applying Skills to EW_SIM

### When Working on Mobile Performance

Apply principles from **mobile-performance** skill:

```dart
// ✅ Optimize ListView for large signal lists
class SignalListScreen extends StatelessWidget {
  final List<Signal> signals;  // Could be 1000+ signals
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(  // Not ListView(), uses lazy loading
      itemCount: signals.length,
      itemBuilder: (context, index) {
        return SignalListItem(signal: signals[index]);
      },
    );
  }
}

// ✅ Cache network images
CachedNetworkImage(
  imageUrl: 'https://example.com/antenna.png',
  memCacheWidth: 400,  // Reduce memory footprint
  placeholder: (context, url) => CircularProgressIndicator(),
);

// ✅ Dispose resources properly
class RadarDisplayWidget extends StatefulWidget {
  @override
  _RadarDisplayWidgetState createState() => _RadarDisplayWidgetState();
}

class _RadarDisplayWidgetState extends State<RadarDisplayWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late StreamSubscription _radarDataSub;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
    
    _radarDataSub = radarStream.listen(_updateDisplay);
  }
  
  @override
  void dispose() {
    _controller.dispose();  // Prevent memory leak
    _radarDataSub.cancel();
    super.dispose();
  }
}
```

### When Designing Learning Content

Apply principles from **instructional-design** and **microlearning** skills:

```dart
// ✅ Break complex topics into micro-lessons
class ESMCourse {
  final List<MicroLesson> lessons = [
    // Lesson 1: Introduction (5 min)
    MicroLesson(
      title: 'What is ESM?',
      estimatedTime: Duration(minutes: 5),
      content: [
        TextBlock('ESM stands for Electronic Support Measures...'),
        ImageBlock('assets/esm_overview.png'),
        QuickQuiz([
          MultipleChoice('ESM is primarily...', correctIndex: 1),
        ]),
      ],
    ),
    
    // Lesson 2: Hands-on Practice (7 min)
    MicroLesson(
      title: 'Detecting Your First Signal',
      estimatedTime: Duration(minutes: 7),
      content: [
        TextBlock('Let\'s practice signal detection...'),
        InteractiveBlock(SignalDetectionSimulator()),  // 5 min practice
        QuickQuiz([
          PracticalQuestion('Identify the signal type'),
        ]),
      ],
    ),
  ];
  
  // ✅ Define clear learning objectives (SMART)
  final List<LearningObjective> objectives = [
    LearningObjective(
      description: 'Identify 5 common radar types by PRF pattern within 2 minutes',
      assessmentType: AssessmentType.timedPractice,
      bloomLevel: BloomLevel.apply,
    ),
  ];
}
```

### When Implementing Gamification

Apply principles from **gamification** skill:

```dart
// ✅ Add achievement system
class AchievementService {
  Future<void> checkAchievements(UserProgress progress) async {
    // First signal detection
    if (progress.signalsDetected == 1) {
      await _unlockAchievement(Achievement.firstSignal);
    }
    
    // Complete all ESM scenarios
    if (progress.completedESMScenarios == progress.totalESMScenarios) {
      await _unlockAchievement(Achievement.esmMaster);
    }
    
    // Streak system
    if (progress.currentStreak >= 7) {
      await _unlockAchievement(Achievement.weekWarrior);
    }
  }
}

// ✅ Progress visualization
class ProgressCard extends StatelessWidget {
  final UserProgress progress;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Visual progress bar
          LinearProgressIndicator(
            value: progress.completionPercentage,
          ),
          Text('${(progress.completionPercentage * 100).toInt()}% Complete'),
          
          // Streak indicator
          Row(
            children: [
              Icon(Icons.local_fire_department),
              Text('${progress.currentStreak} day streak'),
            ],
          ),
          
          // Next achievement preview
          Text('Next: Complete 10 scenarios to unlock "ESM Expert"'),
        ],
      ),
    );
  }
}
```

### When Supporting Diverse Learners

Apply principles from **accessibility-learning** skill:

```dart
// ✅ Multiple means of representation
class LessonContentViewer extends StatelessWidget {
  final LessonContent content;
  final UserPreferences preferences;
  
  @override
  Widget build(BuildContext context) {
    // Adapt to user's preferred learning style
    switch (preferences.contentFormat) {
      case ContentFormat.text:
        return Text(content.textExplanation);
        
      case ContentFormat.video:
        return VideoPlayer(url: content.videoUrl);
        
      case ContentFormat.audio:
        return AudioPlayer(url: content.audioUrl);
        
      case ContentFormat.interactive:
        return content.interactiveWidget;
    }
  }
}

// ✅ Dyslexia-friendly option
class AccessibleText extends StatelessWidget {
  final String text;
  
  @override
  Widget build(BuildContext context) {
    final isDyslexicMode = context.read<AccessibilitySettings>().dyslexicMode;
    
    return Text(
      text,
      style: TextStyle(
        fontFamily: isDyslexicMode ? 'OpenDyslexic' : 'Roboto',
        fontSize: isDyslexicMode ? 18 : 16,
        height: isDyslexicMode ? 1.6 : 1.4,
        letterSpacing: isDyslexicMode ? 0.8 : 0.0,
      ),
    );
  }
}

// ✅ Screen reader support for complex visualizations
Semantics(
  label: '3D radar coverage visualization',
  hint: 'Shows detection range of 45 kilometers. '
        'Blue zone represents line-of-sight coverage. '
        'Terrain affects coverage shape.',
  value: 'Currently showing Site Alpha radar at coordinates 13.75N, 100.50E',
  child: Cesium3DWidget(),
)
```

### When Implementing Offline Learning

Apply principles from **offline-first** skill:

```dart
// ✅ Download lessons for offline use
class OfflineLearningService {
  Future<void> downloadLesson(Lesson lesson) async {
    // Download all lesson assets
    await _downloadVideo(lesson.videoUrl);
    await _downloadImages(lesson.images);
    await _downloadInteractiveData(lesson.interactiveContent);
    
    // Save to local database
    final db = await database;
    await db.insert('lessons', lesson.toMap());
    
    // Mark as available offline
    lesson.isAvailableOffline = true;
  }
  
  // Sync progress when back online
  Future<void> syncProgress() async {
    final isOnline = await ConnectivityService().checkConnection();
    if (!isOnline) return;
    
    final unsyncedProgress = await _getUnsyncedProgress();
    for (final progress in unsyncedProgress) {
      await _uploadProgress(progress);
    }
  }
}

// ✅ Offline-first quiz
class OfflineQuiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Question>>(
      future: _loadQuestionsLocally(),  // Load from SQLite, not API
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        
        return QuizWidget(
          questions: snapshot.data!,
          onComplete: (results) async {
            // Save results locally
            await _saveResultsLocally(results);
            
            // Sync later when online
            _queueForSync(results);
          },
        );
      },
    );
  }
}
```

### When Working on 3D Visualization

Apply principles from **3d-web-experience** skill:

- **Performance first**: Mobile devices have limited GPU power
- **Progressive loading**: Show low-poly models first, enhance later
- **Fallback states**: Provide 2D alternative if 3D fails
- **Touch controls**: Design for mobile interaction (pinch, rotate, pan)

```dart
// Apply 3D optimization principles
class CesiumGlobeWidget extends StatefulWidget {
  @override
  _CesiumGlobeWidgetState createState() => _CesiumGlobeWidgetState();
}

class _CesiumGlobeWidgetState extends State<CesiumGlobeWidget> {
  bool _isLoading = true;
  bool _useFallback = false;
  
  // Progressive loading - start with low-poly terrain
  Future<void> _initializeCesium() async {
    try {
      await _loadLowPolyTerrain();
      setState(() => _isLoading = false);
      // Enhance in background
      _loadHighPolyTerrain();
    } catch (e) {
      // Fallback to 2D map
      setState(() => _useFallback = true);
    }
  }
}
```

### When Designing Forms (EW Scenario Input)

Apply principles from **form-cro** skill:

- Field order: Easiest first (name, type) → commitment fields last
- Inline validation after field interaction
- Clear error messages
- Mobile-optimized (≥44px touch targets)

```dart
// Apply form CRO principles
class ScenarioInputForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // Easiest field first
          TextFormField(
            decoration: InputDecoration(labelText: 'Scenario Name'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a scenario name';  // Specific, actionable
              }
              return null;
            },
          ),
          
          // Commitment field later
          DropdownButtonFormField(
            items: scenarioTypes,
            decoration: InputDecoration(labelText: 'Scenario Type'),
            // ≥44px touch target automatically via Material Design
          ),
        ],
      ),
    );
  }
}
```

### When Building Educational Content UI

Apply principles from **ui-ux-pro-max** skill:

**Accessibility (CRITICAL)**:
- Color contrast ratio: Minimum 4.5:1
- Touch targets: Minimum 48x48 dp (Flutter standard)
- Screen reader support: Use Semantics widget
- Text scaling: Support up to 200%

```dart
// Apply UI/UX pro principles
Semantics(
  label: 'Radar coverage zone for Site Alpha',
  hint: 'Shows effective detection range',
  child: RadarCoverageWidget(site: siteAlpha),
)

// Color contrast check
const textColor = Color(0xFF0F172A);  // slate-900
const backgroundColor = Colors.white;
// Ratio: 15.52:1 ✓ (exceeds 4.5:1 requirement)
```

**Typography**:
- Line height: 1.5-1.75 for body text
- Line length: 65-75 characters max
- Minimum font size: 16sp on mobile

---

## 🔍 Pre-Delivery Checklist

Before delivering any code, verify:

### Code Quality
- [ ] Runs `flutter analyze` with no errors
- [ ] Runs `dart format .` successfully
- [ ] All tests pass (`flutter test`)
- [ ] No TODO comments left unaddressed
- [ ] Follows existing code patterns
- [ ] Resources properly disposed (controllers, subscriptions, streams)

### Mobile Performance
- [ ] ListView uses `.builder()` for long lists
- [ ] Images are compressed and cached
- [ ] No expensive operations in `build()` methods
- [ ] Animations run at 60 FPS
- [ ] Battery consumption is reasonable
- [ ] Works smoothly on mid-range devices

### UI/UX Quality
- [ ] All touch targets ≥ 48x48 dp
- [ ] Color contrast ≥ 4.5:1 for text
- [ ] Screen reader labels present (Semantics widget)
- [ ] Works in both light and dark mode
- [ ] Responsive on different screen sizes
- [ ] Font size minimum 16sp on mobile
- [ ] No horizontal scrolling issues

### Educational Content
- [ ] Learning objectives clearly defined (SMART format)
- [ ] Content chunked into 5-10 minute lessons
- [ ] Multiple content formats available (text, visual, interactive)
- [ ] Quiz questions aligned with Bloom's taxonomy
- [ ] Progress tracking implemented
- [ ] Achievements/gamification elements functional

### Accessibility & Inclusion
- [ ] Screen reader support for complex visualizations
- [ ] Multiple means of representation (text, audio, video, interactive)
- [ ] Dyslexia-friendly typography option available
- [ ] Keyboard navigation works
- [ ] Cognitive load reduced (chunking, progressive disclosure)
- [ ] Supports different learning paces

### Offline Capability
- [ ] Core lessons available offline
- [ ] Local database saves progress
- [ ] Sync works when back online
- [ ] Handles connectivity changes gracefully
- [ ] User notified of offline/online status

### Security
- [ ] Sensitive data uses `flutter_secure_storage`
- [ ] No hardcoded secrets or API keys
- [ ] Data encrypted at rest if needed
- [ ] Proper certificate validation for network calls

### Platform-Specific
- [ ] Tested on both Android and iOS
- [ ] Platform-specific UI patterns respected
- [ ] Safe area handling correct
- [ ] Status bar/navigation bar handled properly

### Documentation
- [ ] Public APIs have dartdoc comments
- [ ] Complex logic explained
- [ ] README updated if needed
- [ ] CLAUDE.md updated if patterns changed

### Git
- [ ] Conventional commit message
- [ ] Branch strategy followed
- [ ] No merge conflicts
- [ ] Linked to issue/task if applicable

---

## 🎓 Learning Resources

### EW Domain Knowledge
- "Introduction to Electronic Warfare" by D. Curtis Schleher
- "Electronic Warfare and Radar Systems Engineering Handbook" (Naval Air Warfare Center)
- IEEE Xplore: Search "electronic warfare"
- [Jane's Radar and Electronic Warfare Systems](https://www.janes.com/)

### Flutter Development
- [Flutter Documentation](https://docs.flutter.dev/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Provider Documentation](https://pub.dev/packages/provider)

### Mobile Performance
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Flutter Performance Profiling](https://docs.flutter.dev/perf/ui-performance)
- [Optimizing Flutter Performance](https://medium.com/flutter/flutter-performance-tips-1-5-2a6c82d3f8e7)

### Educational Design
- "The ABCs of How We Learn" by Daniel L. Schwartz
- "Make It Stick: The Science of Successful Learning" by Peter C. Brown
- [Universal Design for Learning (UDL) Guidelines](http://udlguidelines.cast.org/)
- [Bloom's Taxonomy](https://cft.vanderbilt.edu/guides-sub-pages/blooms-taxonomy/)
- [Spaced Repetition Research](https://www.gwern.net/Spaced-repetition)

### Gamification & Engagement
- "The Gamification of Learning and Instruction" by Karl M. Kapp
- [Octalysis Framework](https://yukaichou.com/gamification-examples/octalysis-complete-gamification-framework/)
- [Duolingo Engineering Blog](https://blog.duolingo.com/) - Great examples of educational gamification

### Accessibility
- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [Web Content Accessibility Guidelines (WCAG)](https://www.w3.org/WAI/WCAG21/quickref/)
- [Material Design Accessibility](https://m3.material.io/foundations/accessible-design/overview)

### 3D & Visualization
- [Cesium for Unreal](https://cesium.com/learn/) - Concepts apply to WebView integration
- [Three.js Fundamentals](https://threejs.org/manual/) - 3D concepts
- [WebGL Fundamentals](https://webglfundamentals.org/) - Understanding 3D rendering

---

## 📞 Support & Quick Reference

### Common Commands

```bash
# Development
flutter run --debug
flutter run --release

# Testing
flutter test
flutter test --coverage

# Code Quality
flutter analyze
dart format .
flutter pub outdated

# Build
flutter build apk --release
flutter build appbundle --release
flutter build ios --release

# Git (use smart_commit.sh instead)
bash skills/git-pushing/scripts/smart_commit.sh
```

### File Structure Quick Reference

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── services/
├── features/
│   ├── spectrum_analysis/
│   ├── esm/
│   ├── ecm/
│   ├── eccm/
│   ├── radio_comsec/
│   ├── radar/
│   ├── anti_drone/
│   ├── gps_warfare/
│   └── visualization_3d/
└── shared/
    ├── widgets/
    ├── models/
    └── extensions/
```

### Color Scheme Quick Reference

```dart
// EW Module Colors
const spectrumPrimary = Color(0xFF2196F3);   // Blue
const esmPrimary = Color(0xFF4CAF50);        // Green
const ecmPrimary = Color(0xFFF44336);        // Red
const eccmPrimary = Color(0xFFFF9800);       // Orange
const radioComsecPrimary = Color(0xFF9C27B0); // Purple
const radarPrimary = Color(0xFF00BCD4);      // Cyan
const antiDronePrimary = Color(0xFFFFC107);  // Amber
const gpsPrimary = Color(0xFF009688);        // Teal
```

---

## 🔄 Change Log

### v1.2.0 (Current)
- Added comprehensive **Mobile App Development** skills:
  - flutter-architecture (state management, navigation, DI)
  - mobile-performance (60 FPS, battery, memory optimization)
  - offline-first (local storage, sync strategies)
  - app-security (secure storage, encryption)
  - cross-platform (Android/iOS differences)
- Added **Educational & Learning Design** skills:
  - instructional-design (learning objectives, scaffolding)
  - gamification (achievements, progress tracking, engagement)
  - microlearning (bite-sized lessons, spaced repetition)
  - assessment-design (quizzes, adaptive difficulty)
  - accessibility-learning (UDL, diverse learners)
- Enhanced Pre-Delivery Checklist with mobile and learning aspects
- Updated Applying Skills section with practical examples
- Expanded Learning Resources

### v1.1.0
- Integrated available skills reference (concise-planning, lint-and-validate, git-pushing, kaizen, etc.)
- Added Kaizen-inspired development philosophy
- Enhanced quality control section
- Added skill application examples
- Improved pre-delivery checklist

### v1.0.0
- Initial CLAUDE.md structure
- EW domain knowledge documentation
- Flutter architecture guidelines
- 3D visualization with Cesium
- UI/UX design guidelines
- Testing strategy

---

## ⚖️ License & Attribution

This is an educational project. Use responsibly and in accordance with local laws regarding electronic warfare information.

**Educational Use Only**: This application is for training and education purposes. It does not contain classified information and should not be used for actual military operations.

**Third-Party Licenses**:
- Cesium: Apache License 2.0
- Flutter: BSD 3-Clause License
- All dependencies: See respective licenses in `pubspec.lock`

**Skills Reference**:
- Skills documentation is part of Claude's available capabilities
- Applied according to project context and requirements

---

**Last Updated**: 2025-02-01  
**Document Version**: 1.2.0  
**Maintained By**: EW_SIM Development Team

---

## 📝 Quick Start for Claude Code

When you start working on this project:

1. **Read this file first** - Understand the project structure and philosophy
2. **Check available skills** - Reference the skills section above for:
   - Mobile development best practices
   - Educational design principles
   - Performance optimization
   - Accessibility requirements
3. **Plan your work** - Use concise-planning approach
4. **Write code** - Follow Flutter architecture guidelines
5. **Validate** - Run lint-and-validate checks
6. **Commit** - Use git-pushing with conventional commits
7. **Iterate** - Apply Kaizen principles for continuous improvement

### Key Considerations for EW_SIM

**Mobile-First Mindset**:
- Performance matters: 60 FPS, low battery drain
- Touch targets: Minimum 48x48 dp
- Test on real devices, not just emulator
- Offline capability is essential

**Educational Excellence**:
- Clear learning objectives (SMART format)
- Microlearning: 5-10 minute lessons
- Multiple content formats (text, visual, interactive, audio)
- Progress tracking and motivation (achievements, streaks)
- Accessible to diverse learners

**EW Domain Accuracy**:
- Reference authoritative sources
- Use correct terminology
- Realistic simulations
- Educational purpose only (not operational)

Remember: **Small improvements, continuously. Error-proof by design. Follow what works. Build only what's needed.**

---

## 📱 Mobile App Development Skills

### flutter-architecture

**When to apply**: Structuring app, choosing state management, organizing code

#### Core Principles

**Feature-First Architecture**
```
lib/
├── features/          # Each EW topic is a feature
│   ├── spectrum_analysis/
│   │   ├── data/      # Data sources, repositories
│   │   ├── domain/    # Business logic, use cases
│   │   └── presentation/  # UI, widgets, state
│   └── esm/
├── core/              # Shared across features
└── shared/            # Reusable components
```

**State Management Decision Tree**

| Complexity | Solution | When to Use |
|------------|----------|-------------|
| Simple | setState | Single widget, no sharing |
| Local | Provider + ChangeNotifier | Feature-level state |
| Complex | Riverpod | App-wide, many dependencies |
| Reactive | BLoC | Heavy business logic |

**For EW_SIM**: Use **Provider** for educational content, **ChangeNotifier** for 3D scene state.

#### Navigation Patterns

```dart
// Declarative routing (recommended)
GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/esm',
      builder: (context, state) => ESMModule(),
      routes: [
        GoRoute(
          path: 'scenario/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ScenarioScreen(id: id);
          },
        ),
      ],
    ),
  ],
);
```

#### Dependency Injection

```dart
// Use GetIt for service location
final getIt = GetIt.instance;

void setupDependencies() {
  // Singletons for services
  getIt.registerSingleton<SignalDatabase>(SignalDatabase());
  getIt.registerSingleton<ThemeService>(ThemeService());
  
  // Factories for use cases
  getIt.registerFactory(() => AnalyzeSignalUseCase(
    repository: getIt<SignalRepository>(),
  ));
}
```

---

### mobile-performance

**When to apply**: App feels sluggish, battery drain, memory issues

#### 60 FPS Rule

Every frame must complete in **16.67ms** (1000ms / 60fps).

**Performance Checklist**:
- [ ] No expensive operations in build()
- [ ] Images are compressed and cached
- [ ] Lists use ListView.builder, not ListView
- [ ] Animations use AnimatedWidget or ImplicitlyAnimatedWidget
- [ ] 3D scenes optimize polygon count

#### Build Method Optimization

```dart
// ❌ Bad - rebuilds entire tree
class BadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataModel>(context); // Rebuilds on any change
    return Column(
      children: [
        ExpensiveWidget(data: data),
        AnotherWidget(data: data),
      ],
    );
  }
}

// ✅ Good - selective listening
class GoodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<DataModel>(
          builder: (context, data, child) => ExpensiveWidget(data: data),
        ),
        // This doesn't rebuild when DataModel changes
        const AnotherWidget(),
      ],
    );
  }
}
```

#### Image Optimization

```dart
// ✅ Best practices
CachedNetworkImage(
  imageUrl: 'https://example.com/radar.png',
  placeholder: (context, url) => CircularProgressIndicator(),
  memCacheWidth: 800,  // Resize in memory
  maxWidthDiskCache: 1000,  // Limit disk cache size
);

// For local assets
Image.asset(
  'assets/images/antenna.png',
  cacheWidth: 400,  // Don't load full resolution
);
```

#### Memory Management

```dart
// ✅ Dispose controllers and listeners
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late AnimationController _controller;
  late StreamSubscription _subscription;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _subscription = stream.listen((_) {});
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => Container();
}
```

#### Battery Optimization

```dart
// Reduce wake locks and background processing
class SignalScanner {
  Timer? _scanTimer;
  
  void startScanning() {
    // Use longer intervals to save battery
    _scanTimer = Timer.periodic(
      Duration(seconds: 5),  // Not every 100ms
      (_) => _scan(),
    );
  }
  
  void stopScanning() {
    _scanTimer?.cancel();
  }
  
  // Stop scanning when app is in background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      stopScanning();
    } else if (state == AppLifecycleState.resumed) {
      startScanning();
    }
  }
}
```

---

### offline-first

**When to apply**: App must work without internet, sync data later

#### Local Database Strategy

```dart
// Use sqflite for structured data
class SignalDatabase {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  
  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'ew_sim.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE signals(
            id TEXT PRIMARY KEY,
            frequency REAL,
            power REAL,
            timestamp INTEGER,
            synced INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }
  
  // Save locally first, sync later
  Future<void> saveSignal(Signal signal) async {
    final db = await database;
    await db.insert('signals', signal.toMap());
    // Queue for sync when online
    _queueForSync(signal.id);
  }
}
```

#### Connectivity Monitoring

```dart
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  
  Stream<bool> get isOnline => _connectivity.onConnectivityChanged.map(
    (result) => result != ConnectivityResult.none,
  );
  
  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
```

#### Sync Strategy

```dart
class SyncService {
  Future<void> syncWhenOnline() async {
    final isOnline = await ConnectivityService().checkConnection();
    if (!isOnline) return;
    
    // Get all unsynced records
    final unsyncedSignals = await _getUnsyncedSignals();
    
    for (final signal in unsyncedSignals) {
      try {
        await _uploadSignal(signal);
        await _markAsSynced(signal.id);
      } catch (e) {
        // Keep in queue, retry later
        print('Sync failed: $e');
      }
    }
  }
}
```

---

### app-security

**When to apply**: Handling sensitive data, user authentication, secure storage

#### Secure Storage

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = FlutterSecureStorage();
  
  // Store sensitive EW scenario data
  Future<void> saveScenario(String id, Scenario scenario) async {
    await _storage.write(
      key: 'scenario_$id',
      value: jsonEncode(scenario.toJson()),
    );
  }
  
  Future<Scenario?> loadScenario(String id) async {
    final json = await _storage.read(key: 'scenario_$id');
    if (json == null) return null;
    return Scenario.fromJson(jsonDecode(json));
  }
  
  // Clear all data on logout
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

#### Certificate Pinning (for API calls)

```dart
import 'package:dio/dio.dart';

class SecureApiClient {
  late Dio _dio;
  
  SecureApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.ewsim.com',
      connectTimeout: Duration(seconds: 5),
    ));
    
    // Add certificate pinning
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = 
      (client) {
        client.badCertificateCallback = 
          (X509Certificate cert, String host, int port) {
            // Verify certificate fingerprint
            return cert.sha1.toString() == 'YOUR_CERT_SHA1';
          };
        return client;
      };
  }
}
```

#### Data Encryption at Rest

```dart
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  final _key = Key.fromSecureRandom(32);
  final _iv = IV.fromSecureRandom(16);
  
  String encrypt(String plainText) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }
  
  String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(_key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
```

---

### cross-platform

**When to apply**: Handling Android/iOS differences, platform-specific features

#### Platform Detection

```dart
import 'dart:io';

class PlatformHelper {
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  
  static Widget platformWidget({
    required Widget android,
    required Widget ios,
  }) {
    return isAndroid ? android : ios;
  }
}
```

#### Platform-Specific UI

```dart
// Navigation bar differences
class AdaptiveBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTabBar(
        items: _buildTabItems(),
      );
    }
    
    return BottomNavigationBar(
      items: _buildTabItems(),
    );
  }
}

// Loading indicators
Widget adaptiveLoading() {
  if (Platform.isIOS) {
    return CupertinoActivityIndicator();
  }
  return CircularProgressIndicator();
}
```

#### Safe Area Handling

```dart
// Different notch/status bar handling
class SafeScaffold extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // iOS needs more padding for notch
        minimum: Platform.isIOS 
          ? EdgeInsets.only(top: 20)
          : EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
```

---

## 🎓 Educational & Learning Design Skills

### instructional-design

**When to apply**: Designing learning modules, creating educational content flow

#### Learning Objectives (SMART Framework)

Every EW topic module should have clear objectives:

**Format**: "After completing this module, learners will be able to..."

**Example - ESM Module**:
```dart
class ESMModule {
  final List<LearningObjective> objectives = [
    LearningObjective(
      // Specific, Measurable, Achievable, Relevant, Time-bound
      description: 'Identify 5 common radar emission types by their PRF patterns',
      assessmentType: AssessmentType.practice,
      estimatedTime: Duration(minutes: 15),
    ),
    LearningObjective(
      description: 'Calculate bearing angle using Watson-Watt DF method',
      assessmentType: AssessmentType.quiz,
      estimatedTime: Duration(minutes: 10),
    ),
  ];
}
```

#### Scaffolding Strategy

Progressive complexity: Simple → Intermediate → Advanced

```dart
enum DifficultyLevel {
  beginner,    // Guided practice, hints available
  intermediate, // Less guidance, optional hints
  advanced,    // Minimal guidance, realistic constraints
}

class Scenario {
  final DifficultyLevel difficulty;
  final List<Hint> hints;
  final bool showStepByStep;
  
  // Beginner: Step-by-step tutorial
  // Intermediate: Scenario with guidelines
  // Advanced: Open-ended challenge
}
```

#### Knowledge Retention Techniques

```dart
class LearningModule {
  // Spaced Repetition
  DateTime? lastReviewed;
  int reviewCount = 0;
  
  Duration getNextReviewInterval() {
    // Fibonacci spacing: 1 day, 2 days, 3 days, 5 days, 8 days...
    final intervals = [1, 2, 3, 5, 8, 13, 21];
    final index = min(reviewCount, intervals.length - 1);
    return Duration(days: intervals[index]);
  }
  
  // Retrieval Practice
  Future<void> showQuickRecall() async {
    // Random quiz from previously learned content
    final question = await _getRandomQuestion();
    await _showQuizDialog(question);
  }
  
  // Interleaving
  List<Topic> getInterleavedTopics() {
    // Mix ESM + ECM + Radar rather than all ESM then all ECM
    return [
      Topic.esm,
      Topic.ecm,
      Topic.esm,
      Topic.radar,
      Topic.ecm,
    ];
  }
}
```

---

### gamification

**When to apply**: Increasing engagement, motivation, completion rates

#### Achievement System

```dart
class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int points;
  final AchievementTier tier;
  
  // Examples for EW_SIM:
  static final firstSignalDetection = Achievement(
    id: 'first_signal',
    title: 'Signal Hunter',
    description: 'Detect your first radar emission',
    icon: '🎯',
    points: 10,
    tier: AchievementTier.bronze,
  );
  
  static final masterESM = Achievement(
    id: 'master_esm',
    title: 'ESM Master',
    description: 'Complete all ESM scenarios with >80% accuracy',
    icon: '🏆',
    points: 100,
    tier: AchievementTier.gold,
  );
}

enum AchievementTier { bronze, silver, gold, platinum }
```

#### Progress Tracking

```dart
class ProgressTracker {
  int totalScenarios = 50;
  int completedScenarios = 0;
  
  // Visual progress
  double get progressPercentage => completedScenarios / totalScenarios;
  
  // Streak system (daily engagement)
  int currentStreak = 0;
  DateTime? lastActiveDate;
  
  void checkStreak() {
    final today = DateTime.now();
    final yesterday = today.subtract(Duration(days: 1));
    
    if (lastActiveDate?.day == yesterday.day) {
      currentStreak++;
    } else if (lastActiveDate?.day != today.day) {
      currentStreak = 1;
    }
    
    lastActiveDate = today;
  }
  
  // Leaderboard (optional, for competitive learners)
  int totalPoints = 0;
  int rank = 0;
}
```

#### Challenge System

```dart
class Challenge {
  final String title;
  final String description;
  final Duration timeLimit;
  final int targetScore;
  final List<Constraint> constraints;
  
  // Example: "Detect 10 signals in 5 minutes using only passive sensors"
  static final speedChallenge = Challenge(
    title: 'Speed Detection',
    description: 'Identify 10 different radar types in under 5 minutes',
    timeLimit: Duration(minutes: 5),
    targetScore: 10,
    constraints: [
      Constraint.passiveSensorsOnly,
      Constraint.noHints,
    ],
  );
}

enum Constraint {
  passiveSensorsOnly,
  noHints,
  limitedTime,
  highAccuracyRequired,
}
```

---

### microlearning

**When to apply**: Breaking down complex EW concepts into digestible chunks

#### Lesson Structure (5-10 minutes each)

```dart
class MicroLesson {
  final String title;
  final Duration estimatedTime;
  final List<ContentBlock> content;
  final Quiz? quiz;
  
  // Example: "Understanding PRF"
  static final prfLesson = MicroLesson(
    title: 'Pulse Repetition Frequency (PRF)',
    estimatedTime: Duration(minutes: 7),
    content: [
      TextBlock('PRF is the rate at which radar pulses are transmitted...'),
      ImageBlock('assets/diagrams/prf_illustration.png'),
      InteractiveBlock(PRFSimulator()),  // 2-min interactive
      VideoBlock('assets/videos/prf_examples.mp4', duration: Duration(minutes: 2)),
    ],
    quiz: Quiz(questions: [
      MultipleChoice('What does high PRF indicate?', options: [...]),
    ]),
  );
}

// Content types
abstract class ContentBlock {
  Duration get estimatedTime;
}

class TextBlock extends ContentBlock {
  final String text;
  @override
  Duration get estimatedTime => Duration(seconds: text.split(' ').length ~/ 3);
}

class InteractiveBlock extends ContentBlock {
  final Widget widget;
  @override
  Duration get estimatedTime => Duration(minutes: 2);
}
```

#### Spaced Repetition Algorithm

```dart
class SpacedRepetitionService {
  // SM-2 Algorithm (SuperMemo)
  double calculateEaseFactor(int quality) {
    // quality: 0-5 (0=total blackout, 5=perfect recall)
    return max(1.3, currentEF + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)));
  }
  
  Duration getNextReviewInterval({
    required int repetitions,
    required double easeFactor,
    required int quality,
  }) {
    if (quality < 3) {
      // Reset interval if recall is poor
      return Duration(days: 1);
    }
    
    if (repetitions == 0) return Duration(days: 1);
    if (repetitions == 1) return Duration(days: 6);
    
    final interval = (repetitions - 1) * easeFactor;
    return Duration(days: interval.ceil());
  }
}
```

#### Learning Path

```dart
class LearningPath {
  final String name;
  final List<MicroLesson> lessons;
  final Map<int, List<int>> prerequisites;  // lesson index -> required lesson indices
  
  // Adaptive path based on performance
  List<MicroLesson> getNextLessons(UserProgress progress) {
    final completed = progress.completedLessonIds;
    
    return lessons.where((lesson) {
      final index = lessons.indexOf(lesson);
      final prereqs = prerequisites[index] ?? [];
      
      // Can access if all prerequisites completed
      return prereqs.every((prereq) => completed.contains(lessons[prereq].id));
    }).toList();
  }
  
  // Example path: Spectrum → ESM → ECM → ECCM
  static final basicEWPath = LearningPath(
    name: 'Basic Electronic Warfare',
    lessons: [
      MicroLesson.spectrumIntro,
      MicroLesson.spectrumAnalysis,
      MicroLesson.esmIntro,
      MicroLesson.esmPractice,
      MicroLesson.ecmIntro,
      // ...
    ],
    prerequisites: {
      2: [0, 1],  // ESM intro requires spectrum lessons
      4: [2, 3],  // ECM intro requires ESM lessons
    },
  );
}
```

---

### assessment-design

**When to apply**: Creating quizzes, knowledge checks, evaluating understanding

#### Question Types

```dart
abstract class Question {
  String get question;
  String get explanation;
  int get points;
  
  bool evaluate(dynamic answer);
}

// Multiple Choice
class MultipleChoiceQuestion extends Question {
  @override
  final String question;
  final List<String> options;
  final int correctIndex;
  @override
  final String explanation;
  @override
  final int points;
  
  @override
  bool evaluate(dynamic answer) {
    return answer == correctIndex;
  }
}

// Numeric Range (for calculations)
class NumericQuestion extends Question {
  @override
  final String question;
  final double correctValue;
  final double tolerance;  // ±5% acceptable
  final String unit;
  @override
  final String explanation;
  @override
  final int points;
  
  @override
  bool evaluate(dynamic answer) {
    if (answer is! double) return false;
    final diff = (answer - correctValue).abs();
    return diff <= (correctValue * tolerance);
  }
}

// Practical Task
class PracticalQuestion extends Question {
  @override
  final String question;
  final Widget simulator;  // Interactive scenario
  final bool Function(SimulationResult) validator;
  @override
  final String explanation;
  @override
  final int points;
  
  @override
  bool evaluate(dynamic answer) {
    if (answer is! SimulationResult) return false;
    return validator(answer);
  }
}
```

#### Adaptive Difficulty

```dart
class AdaptiveQuiz {
  List<Question> questionPool;
  DifficultyLevel currentDifficulty = DifficultyLevel.intermediate;
  
  Question getNextQuestion(int consecutiveCorrect, int consecutiveWrong) {
    // Increase difficulty after 3 correct
    if (consecutiveCorrect >= 3) {
      currentDifficulty = DifficultyLevel.advanced;
    }
    
    // Decrease difficulty after 2 wrong
    if (consecutiveWrong >= 2) {
      currentDifficulty = DifficultyLevel.beginner;
    }
    
    // Select question matching current difficulty
    final filtered = questionPool.where(
      (q) => q.difficulty == currentDifficulty,
    ).toList();
    
    return filtered[Random().nextInt(filtered.length)];
  }
}
```

#### Bloom's Taxonomy Alignment

```dart
enum BloomLevel {
  remember,    // Recall facts (PRF definition)
  understand,  // Explain concepts (Why high PRF matters)
  apply,       // Use in new situation (Calculate range)
  analyze,     // Break down (Identify signal type from waveform)
  evaluate,    // Judge decisions (Best jamming strategy?)
  create,      // Design solution (Plan ESM coverage)
}

class Question {
  final BloomLevel cognitiveLevel;
  
  // Distribute questions across levels
  static List<Question> balancedQuiz() {
    return [
      // 30% Remember/Understand
      Question(level: BloomLevel.remember),
      Question(level: BloomLevel.understand),
      // 40% Apply/Analyze
      Question(level: BloomLevel.apply),
      Question(level: BloomLevel.analyze),
      // 30% Evaluate/Create
      Question(level: BloomLevel.evaluate),
      Question(level: BloomLevel.create),
    ];
  }
}
```

---

### accessibility-learning

**When to apply**: Supporting diverse learners, inclusive education

#### Universal Design for Learning (UDL)

**Multiple Means of Representation**:
```dart
class LessonContent {
  // Same content, multiple formats
  String? textExplanation;
  String? audioNarrationUrl;
  String? videoUrl;
  String? diagramUrl;
  Widget? interactiveSimulation;
  
  // User preference
  ContentFormat preferredFormat = ContentFormat.text;
  
  Widget build(BuildContext context) {
    switch (preferredFormat) {
      case ContentFormat.text:
        return Text(textExplanation!);
      case ContentFormat.audio:
        return AudioPlayer(url: audioNarrationUrl!);
      case ContentFormat.video:
        return VideoPlayer(url: videoUrl!);
      case ContentFormat.visual:
        return Image.network(diagramUrl!);
      case ContentFormat.interactive:
        return interactiveSimulation!;
    }
  }
}
```

**Multiple Means of Engagement**:
```dart
class LearningPreferences {
  // Learning style preferences
  bool prefersGamefied = false;
  bool prefersCompetitive = false;
  bool prefersCollaborative = false;
  
  // Pace
  LearningPace pace = LearningPace.selfPaced;
  
  // Support level
  SupportLevel supportLevel = SupportLevel.moderate;
}

enum SupportLevel {
  minimal,    // Hints hidden by default
  moderate,   // Hints available on request
  high,       // Step-by-step guidance
}
```

**Multiple Means of Expression**:
```dart
class Assessment {
  // Learner chooses how to demonstrate understanding
  List<AssessmentType> allowedTypes = [
    AssessmentType.multipleChoice,
    AssessmentType.practicalDemo,
    AssessmentType.writtenExplanation,
    AssessmentType.verbalExplanation,  // Voice recording
  ];
  
  // All count toward the same learning objective
}
```

#### Screen Reader Support

```dart
// Semantic descriptions for 3D visualizations
Semantics(
  label: 'Radar coverage visualization',
  hint: 'Interactive 3D globe showing radar detection range. '
        'Blue zone indicates Line-of-Sight coverage extending 45 kilometers. '
        'Terrain elevation affects coverage pattern.',
  child: CesiumGlobeWidget(),
)

// Complex diagrams
Semantics(
  label: 'Spectrum analyzer waterfall display',
  value: 'Showing frequency range 2.4 to 2.5 GHz. '
         'Strong signal detected at 2.437 GHz with power level -45 dBm. '
         'Moderate signal at 2.412 GHz with power level -62 dBm.',
  child: SpectrumWaterfallWidget(),
)
```

#### Cognitive Load Reduction

```dart
class CognitiveLoadOptimizer {
  // Chunking information
  static List<String> chunkText(String longText, {int maxChunkWords = 50}) {
    final words = longText.split(' ');
    final chunks = <String>[];
    
    for (var i = 0; i < words.length; i += maxChunkWords) {
      final chunk = words.sublist(
        i,
        min(i + maxChunkWords, words.length),
      ).join(' ');
      chunks.add(chunk);
    }
    
    return chunks;
  }
  
  // Progressive disclosure
  static Widget buildExpandableContent({
    required String summary,
    required Widget details,
  }) {
    return ExpansionTile(
      title: Text(summary),
      children: [details],
    );
  }
  
  // Visual hierarchy
  static TextStyle getStyleForImportance(Importance level) {
    switch (level) {
      case Importance.critical:
        return TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
      case Importance.important:
        return TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
      case Importance.supporting:
        return TextStyle(fontSize: 14, color: Colors.grey[600]);
    }
  }
}
```

#### Dyslexia-Friendly Typography

```dart
class AccessibleTypography {
  static TextStyle dyslexiaFriendly = TextStyle(
    fontFamily: 'OpenDyslexic',  // Specialized font
    fontSize: 16,
    height: 1.5,  // Increased line spacing
    letterSpacing: 0.5,  // Increased letter spacing
  );
  
  // Color overlays for readability
  static Color tintColor = Colors.yellow.withOpacity(0.1);
  
  // Avoid justified text (uneven spacing)
  static TextAlign alignment = TextAlign.left;
}
```

