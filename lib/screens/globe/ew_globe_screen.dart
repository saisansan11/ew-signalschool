import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../../app/constants.dart';
import '../../services/theme_provider.dart';

/// 3D Globe with Real Earth Map showing EW events around the world
class EWGlobeScreen extends StatefulWidget {
  const EWGlobeScreen({super.key});

  @override
  State<EWGlobeScreen> createState() => _EWGlobeScreenState();
}

class _EWGlobeScreenState extends State<EWGlobeScreen>
    with TickerProviderStateMixin {
  // Globe rotation
  double _rotationX = 0.2;
  double _rotationY = 0.0;
  double _targetRotationX = 0.2;
  double _targetRotationY = 0.0;
  double _zoom = 1.0;
  double _targetZoom = 1.0;

  // Animation controllers
  late AnimationController _autoRotateController;
  late AnimationController _pulseController;
  late AnimationController _zoomAnimController;
  late Animation<double> _zoomAnimation;

  // Selected event
  EWEvent? _selectedEvent;
  bool _autoRotate = true;

  // Drag tracking
  Offset? _lastPanPosition;
  double _lastScale = 1.0;

  // Earth texture
  ui.Image? _earthTexture;
  bool _isLoadingTexture = true;

  @override
  void initState() {
    super.initState();

    _autoRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _zoomAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _zoomAnimation = CurvedAnimation(
      parent: _zoomAnimController,
      curve: Curves.easeInOutCubic,
    );

    _zoomAnimController.addListener(_updateAnimatedValues);

    // Load Earth texture from assets
    _loadEarthTexture();
  }

  Future<void> _loadEarthTexture() async {
    try {
      // Load from local assets
      final data = await DefaultAssetBundle.of(context).load('assets/images/earth_map.jpg');
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();

      if (mounted) {
        setState(() {
          _earthTexture = frame.image;
          _isLoadingTexture = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load Earth texture: $e');
      if (mounted) {
        setState(() => _isLoadingTexture = false);
      }
    }
  }

  void _updateAnimatedValues() {
    if (!mounted) return;
    setState(() {
      final t = _zoomAnimation.value;
      _rotationX = _lerpAngle(_rotationX, _targetRotationX, t * 0.15);
      _rotationY = _lerpAngle(_rotationY, _targetRotationY, t * 0.15);
      _zoom = ui.lerpDouble(_zoom, _targetZoom, t * 0.15)!;
    });
  }

  double _lerpAngle(double from, double to, double t) {
    double diff = to - from;
    // Handle angle wrapping
    while (diff > math.pi) {
      diff -= 2 * math.pi;
    }
    while (diff < -math.pi) {
      diff += 2 * math.pi;
    }
    return from + diff * t;
  }

  void _animateToEvent(EWEvent event) {
    _autoRotate = false;
    _targetRotationY = -event.lon * math.pi / 180;
    _targetRotationX = event.lat * math.pi / 180 * 0.4;
    _targetRotationX = _targetRotationX.clamp(-math.pi / 3, math.pi / 3);
    _targetZoom = 1.6;

    _zoomAnimController.forward(from: 0);
  }

  @override
  void dispose() {
    _autoRotateController.dispose();
    _pulseController.dispose();
    _zoomAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF020208) : AppColorsLight.background,
          body: Stack(
            children: [
              // Space background
              if (isDark) _buildSpaceBackground(),

              // Main content
              SafeArea(
                child: Column(
                  children: [
                    _buildHeader(isDark),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _autoRotateController,
                        builder: (context, _) {
                          double currentRotationY = _rotationY;
                          if (_autoRotate) {
                            currentRotationY += _autoRotateController.value * 2 * math.pi;
                          }
                          return Stack(
                            children: [
                              Center(child: _buildGlobe(isDark)),
                              _buildCompass(isDark, currentRotationY),
                              _buildCoordinatesDisplay(isDark, currentRotationY),
                              if (_selectedEvent != null) _buildEventPanel(isDark),
                              _buildControls(isDark),
                            ],
                          );
                        },
                      ),
                    ),
                    _buildEventList(isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpaceBackground() {
    return AnimatedBuilder(
      animation: _autoRotateController,
      builder: (context, child) {
        return CustomPaint(
          painter: SpaceBackgroundPainter(progress: _autoRotateController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? Colors.white70 : AppColorsLight.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final glow = _pulseController.value;
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.cyan.withAlpha((100 + 50 * glow).toInt()),
                      Colors.blue.withAlpha((80 + 40 * glow).toInt()),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withAlpha((80 * glow).toInt()),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(Icons.public, color: Colors.white, size: 22),
              );
            },
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EW GLOBAL OPS',
                  style: TextStyle(
                    color: isDark ? Colors.cyan[300] : AppColorsLight.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'เหตุการณ์สงครามอิเล็กทรอนิกส์ทั่วโลก',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : AppColorsLight.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          _buildToggleButton(
            icon: _autoRotate ? Icons.sync : Icons.sync_disabled,
            isActive: _autoRotate,
            onTap: () => setState(() => _autoRotate = !_autoRotate),
            tooltip: _autoRotate ? 'หยุดหมุน' : 'หมุนอัตโนมัติ',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required String tooltip,
    required bool isDark,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.cyan.withAlpha(40)
                : (isDark ? Colors.white.withAlpha(10) : Colors.grey.withAlpha(30)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? Colors.cyan.withAlpha(100) : Colors.transparent,
            ),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.cyan : (isDark ? Colors.white38 : Colors.grey),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildGlobe(bool isDark) {
    return GestureDetector(
      onScaleStart: (details) {
        _lastPanPosition = details.focalPoint;
        _lastScale = _zoom;
        setState(() => _autoRotate = false);
      },
      onScaleUpdate: (details) {
        if (_lastPanPosition != null) {
          final delta = details.focalPoint - _lastPanPosition!;
          setState(() {
            _rotationY += delta.dx * 0.006;
            _rotationX -= delta.dy * 0.006;
            _rotationX = _rotationX.clamp(-math.pi / 2.5, math.pi / 2.5);
            _targetRotationY = _rotationY;
            _targetRotationX = _rotationX;

            final newZoom = _lastScale * details.scale;
            _zoom = newZoom.clamp(0.5, 3.0);
            _targetZoom = _zoom;
          });
          _lastPanPosition = details.focalPoint;
        }
      },
      onScaleEnd: (_) => _lastPanPosition = null,
      child: AnimatedBuilder(
        animation: Listenable.merge([_autoRotateController, _pulseController]),
        builder: (context, child) {
          double currentRotationY = _rotationY;
          if (_autoRotate) {
            currentRotationY += _autoRotateController.value * 2 * math.pi;
          }

          final screenSize = MediaQuery.of(context).size;
          final globeSize = math.min(screenSize.width * 0.85, 340.0);
          final displaySize = globeSize * _zoom;

          return SizedBox(
            width: displaySize,
            height: displaySize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The 3D Globe
                CustomPaint(
                  size: Size(displaySize, displaySize),
                  painter: RealEarthGlobePainter(
                    rotationX: _rotationX,
                    rotationY: currentRotationY,
                    earthTexture: _earthTexture,
                    pulseValue: _pulseController.value,
                    isDark: isDark,
                    isLoading: _isLoadingTexture,
                  ),
                ),
                // Event markers
                SizedBox(
                  width: displaySize,
                  height: displaySize,
                  child: Stack(
                    children: ewEvents.map((event) {
                      return _buildEventMarker(
                        event,
                        currentRotationY,
                        displaySize / 2,
                        isDark,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventMarker(EWEvent event, double rotationY, double radius, bool isDark) {
    final pos = _latLonTo3D(event.lat, event.lon, _rotationX, rotationY, radius * 0.92);

    if (pos.z <= 0) return const SizedBox.shrink();

    final isSelected = _selectedEvent?.id == event.id;
    final markerSize = isSelected ? 32.0 : 26.0;
    final depthFactor = (pos.z / radius).clamp(0.35, 1.0);

    return Positioned(
      left: radius + pos.x - markerSize / 2,
      top: radius + pos.y - markerSize / 2,
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedEvent = event);
          _animateToEvent(event);
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final pulse = _pulseController.value;
            final breathe = math.sin(pulse * math.pi) * 0.15 + 1.0;

            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer pulsing ring
                if (isSelected)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: markerSize * depthFactor * 1.8 * breathe,
                    height: markerSize * depthFactor * 1.8 * breathe,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: event.color.withAlpha((100 * pulse * depthFactor).toInt()),
                        width: 2,
                      ),
                    ),
                  ),

                // Middle glow ring
                Container(
                  width: markerSize * depthFactor * 1.4,
                  height: markerSize * depthFactor * 1.4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: event.color.withAlpha((80 * pulse * depthFactor).toInt()),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),

                // Main marker
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: markerSize * depthFactor,
                  height: markerSize * depthFactor,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.3, -0.3),
                      colors: [
                        Color.lerp(event.color, Colors.white, 0.3)!.withAlpha((255 * depthFactor).toInt()),
                        event.color.withAlpha((230 * depthFactor).toInt()),
                        event.color.withAlpha((180 * depthFactor).toInt()),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withAlpha((240 * depthFactor).toInt()),
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: [
                      // Inner shadow for depth
                      BoxShadow(
                        color: Colors.black.withAlpha((40 * depthFactor).toInt()),
                        blurRadius: 4,
                        offset: const Offset(1, 2),
                      ),
                      // Colored glow
                      BoxShadow(
                        color: event.color.withAlpha((120 + 80 * pulse * depthFactor).toInt()),
                        blurRadius: isSelected ? 20 : 12,
                        spreadRadius: isSelected ? 5 : 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      event.icon,
                      color: Colors.white.withAlpha((250 * depthFactor).toInt()),
                      size: (isSelected ? 14 : 11) * depthFactor,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Point3D _latLonTo3D(double lat, double lon, double rotX, double rotY, double radius) {
    final latRad = lat * math.pi / 180;
    final lonRad = lon * math.pi / 180;

    double x = radius * math.cos(latRad) * math.sin(lonRad);
    double y = -radius * math.sin(latRad);
    double z = radius * math.cos(latRad) * math.cos(lonRad);

    // Y rotation
    final cosY = math.cos(rotY);
    final sinY = math.sin(rotY);
    final newX = x * cosY + z * sinY;
    final newZ = -x * sinY + z * cosY;
    x = newX;
    z = newZ;

    // X rotation
    final cosX = math.cos(rotX);
    final sinX = math.sin(rotX);
    final newY = y * cosX - z * sinX;
    final newZ2 = y * sinX + z * cosX;
    y = newY;
    z = newZ2;

    return Point3D(x, y, z);
  }

  Widget _buildEventPanel(bool isDark) {
    final event = _selectedEvent!;

    return Positioned(
      left: 16,
      right: 16,
      top: 16,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, -30 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [Colors.black.withAlpha(230), Colors.black.withAlpha(200)]
                  : [Colors.white.withAlpha(250), Colors.white.withAlpha(235)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: event.color.withAlpha(150), width: 2),
            boxShadow: [
              BoxShadow(color: event.color.withAlpha(50), blurRadius: 30, spreadRadius: 3),
              BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [event.color.withAlpha(100), event.color.withAlpha(50)]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(event.icon, color: event.color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColorsLight.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: event.color, size: 14),
                            const SizedBox(width: 4),
                            Text(event.location, style: TextStyle(color: event.color, fontSize: 12)),
                            const SizedBox(width: 12),
                            Icon(Icons.calendar_today, color: isDark ? Colors.white38 : AppColorsLight.textMuted, size: 12),
                            const SizedBox(width: 4),
                            Text(event.year, style: TextStyle(color: isDark ? Colors.white38 : AppColorsLight.textMuted, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: isDark ? Colors.white38 : AppColorsLight.textMuted),
                    onPressed: () => setState(() => _selectedEvent = null),
                  ),
                ],
              ),
              Divider(height: 24, color: isDark ? Colors.white12 : AppColorsLight.border),
              Text(
                event.description,
                style: TextStyle(color: isDark ? Colors.white70 : AppColorsLight.textSecondary, fontSize: 13, height: 1.6),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: event.tags.map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [event.color.withAlpha(50), event.color.withAlpha(25)]),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: event.color.withAlpha(100)),
                  ),
                  child: Text(tag, style: TextStyle(color: event.color, fontSize: 11, fontWeight: FontWeight.w600)),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompass(bool isDark, double currentRotationY) {
    // Calculate compass rotation (opposite of globe rotation)
    final compassAngle = -currentRotationY;

    return Positioned(
      left: 16,
      top: 16,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.white.withAlpha(20), Colors.white.withAlpha(8)]
                : [Colors.white.withAlpha(250), Colors.white.withAlpha(220)],
          ),
          border: Border.all(
            color: isDark ? Colors.cyan.withAlpha(80) : AppColorsLight.border,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 80 : 30),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
            if (isDark)
              BoxShadow(
                color: Colors.cyan.withAlpha(30),
                blurRadius: 20,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Compass ring markers
            ...List.generate(8, (i) {
              final angle = i * math.pi / 4;
              final isCardinal = i % 2 == 0;
              return Transform.rotate(
                angle: angle,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: isCardinal ? 2 : 1,
                    height: isCardinal ? 8 : 5,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withAlpha(isCardinal ? 120 : 60)
                          : Colors.grey.withAlpha(isCardinal ? 180 : 100),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              );
            }),
            // Rotating compass needle
            Transform.rotate(
              angle: compassAngle,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // North indicator (red)
                  Container(
                    width: 8,
                    height: 22,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFF4444), Color(0xFFCC2222)],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withAlpha(100),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'N',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Center dot
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.cyan : AppColorsLight.primary,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? Colors.cyan : AppColorsLight.primary).withAlpha(150),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  // South indicator (white/grey)
                  Container(
                    width: 6,
                    height: 18,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [Colors.white70, Colors.white38]
                            : [Colors.grey.shade400, Colors.grey.shade600],
                      ),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(3)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinatesDisplay(bool isDark, double currentRotationY) {
    // Calculate center lat/lon from rotation
    // rotationY controls longitude (horizontal rotation)
    // rotationX controls latitude (tilt)
    final centerLon = (-currentRotationY * 180 / math.pi) % 360;
    final normalizedLon = centerLon > 180 ? centerLon - 360 : (centerLon < -180 ? centerLon + 360 : centerLon);
    final centerLat = (_rotationX * 180 / math.pi * 2.5).clamp(-90.0, 90.0);

    // Format coordinates
    final latStr = '${centerLat.abs().toStringAsFixed(1)}°${centerLat >= 0 ? 'N' : 'S'}';
    final lonStr = '${normalizedLon.abs().toStringAsFixed(1)}°${normalizedLon >= 0 ? 'E' : 'W'}';

    // Calculate zoom percentage
    final zoomPercent = ((_zoom - 0.5) / 2.5 * 100).round();

    return Positioned(
      right: 16,
      top: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.white.withAlpha(15), Colors.white.withAlpha(8)]
                : [Colors.white.withAlpha(240), Colors.white.withAlpha(210)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.cyan.withAlpha(60) : AppColorsLight.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 60 : 20),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
            if (isDark)
              BoxShadow(
                color: Colors.cyan.withAlpha(20),
                blurRadius: 15,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Coordinates header
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VIEW CENTER',
                  style: TextStyle(
                    color: isDark ? Colors.cyan.withAlpha(180) : AppColorsLight.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.gps_fixed,
                  size: 14,
                  color: isDark ? Colors.cyan : AppColorsLight.primary,
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Coordinates in one row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.black.withAlpha(40) : Colors.grey.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    latStr,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColorsLight.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    '  ',
                    style: TextStyle(
                      color: isDark ? Colors.white24 : Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    lonStr,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColorsLight.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Zoom level
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.zoom_in,
                  size: 12,
                  color: isDark ? Colors.cyan.withAlpha(150) : AppColorsLight.primary.withAlpha(150),
                ),
                const SizedBox(width: 4),
                Text(
                  '$zoomPercent%',
                  style: TextStyle(
                    color: isDark ? Colors.cyan : AppColorsLight.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(bool isDark) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        children: [
          _buildControlButton(Icons.add, () => setState(() { _zoom = (_zoom + 0.3).clamp(0.5, 3.0); _targetZoom = _zoom; }), isDark),
          const SizedBox(height: 10),
          _buildControlButton(Icons.remove, () => setState(() { _zoom = (_zoom - 0.3).clamp(0.5, 3.0); _targetZoom = _zoom; }), isDark),
          const SizedBox(height: 10),
          _buildControlButton(
            Icons.flag,
            () {
              setState(() {
                _autoRotate = false;
                _targetRotationX = 0.12;
                _targetRotationY = -1.75;
                _targetZoom = 1.8;
              });
              _zoomAnimController.forward(from: 0);
            },
            isDark,
            tooltip: 'ไปที่ประเทศไทย',
            color: Colors.green,
          ),
          const SizedBox(height: 10),
          _buildControlButton(
            Icons.restart_alt,
            () {
              setState(() {
                _targetRotationX = 0.2;
                _targetRotationY = 0;
                _targetZoom = 1.0;
                _autoRotate = true;
              });
              _zoomAnimController.forward(from: 0);
            },
            isDark,
            tooltip: 'รีเซ็ต',
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed, bool isDark, {String? tooltip, Color? color}) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [Colors.white.withAlpha(18), Colors.white.withAlpha(8)]
                  : [Colors.white.withAlpha(240), Colors.white.withAlpha(210)],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color?.withAlpha(120) ?? (isDark ? Colors.cyan.withAlpha(70) : AppColorsLight.border)),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(isDark ? 60 : 25), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Icon(icon, color: color ?? (isDark ? Colors.cyan : AppColorsLight.primary), size: 24),
        ),
      ),
    );
  }

  Widget _buildEventList(bool isDark) {
    return Container(
      height: 135,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [Colors.transparent, Colors.black.withAlpha(180), Colors.black.withAlpha(220)]
              : [Colors.transparent, Colors.white.withAlpha(220), Colors.white.withAlpha(250)],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.cyan.withAlpha(180), blurRadius: 8)],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'INCIDENTS DATABASE',
                  style: TextStyle(color: isDark ? Colors.cyan[300] : AppColorsLight.primary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: ewEvents.length,
              itemBuilder: (context, index) {
                final event = ewEvents[index];
                final isSelected = _selectedEvent?.id == event.id;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedEvent = event);
                    _animateToEvent(event);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    width: 155,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isSelected
                            ? [event.color.withAlpha(90), event.color.withAlpha(45)]
                            : [isDark ? Colors.white.withAlpha(14) : Colors.white.withAlpha(160), isDark ? Colors.white.withAlpha(6) : Colors.white.withAlpha(110)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? event.color : (isDark ? Colors.white.withAlpha(25) : Colors.grey.withAlpha(60)), width: isSelected ? 2 : 1),
                      boxShadow: isSelected ? [BoxShadow(color: event.color.withAlpha(50), blurRadius: 15, spreadRadius: 2)] : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: event.color.withAlpha(70), borderRadius: BorderRadius.circular(8)),
                              child: Icon(event.icon, color: event.color, size: 14),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(event.year, style: TextStyle(color: isDark ? Colors.white38 : AppColorsLight.textMuted, fontSize: 10))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            event.title,
                            style: TextStyle(color: isDark ? Colors.white : AppColorsLight.textPrimary, fontSize: 12, fontWeight: FontWeight.w600, height: 1.3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// DATA MODEL & EVENTS
// ==========================================
class EWEvent {
  final String id;
  final String title;
  final String location;
  final String year;
  final String description;
  final double lat;
  final double lon;
  final IconData icon;
  final Color color;
  final List<String> tags;

  const EWEvent({
    required this.id,
    required this.title,
    required this.location,
    required this.year,
    required this.description,
    required this.lat,
    required this.lon,
    required this.icon,
    required this.color,
    required this.tags,
  });
}

class Point3D {
  final double x, y, z;
  const Point3D(this.x, this.y, this.z);
}

final List<EWEvent> ewEvents = [
  const EWEvent(id: 'ukraine_2022', title: 'สงคราม EW ยูเครน', location: 'Ukraine', year: '2022-ปัจจุบัน',
    description: 'การใช้ EW อย่างเข้มข้นที่สุดในศตวรรษที่ 21 ทั้ง GPS Jamming, Drone Jamming, และ SIGINT มีการใช้ระบบ Krasukha-4, R-330Zh Zhitel และอื่นๆ',
    lat: 48.3794, lon: 31.1656, icon: Icons.flash_on, color: Colors.red, tags: ['GPS Jamming', 'Anti-Drone', 'SIGINT', 'Krasukha-4']),
  const EWEvent(id: 'syria_2015', title: 'EW รัสเซียในซีเรีย', location: 'Syria', year: '2015-2020',
    description: 'รัสเซียทดสอบระบบ EW ใหม่ๆ ในสนามรบจริง รวมถึง Krasukha-4 สำหรับรบกวนเรดาร์ AWACS และระบบ Avtobaza สำหรับดักจับสัญญาณโดรน',
    lat: 35.2137, lon: 38.9968, icon: Icons.radar, color: Colors.orange, tags: ['Radar Jamming', 'AWACS', 'Avtobaza']),
  const EWEvent(id: 'israel_iron', title: 'Iron Dome & EW', location: 'Israel', year: '2012-ปัจจุบัน',
    description: 'ระบบป้องกันขีปนาวุธที่ใช้ EW ร่วมด้วย รวมถึงการรบกวน GPS ของขีปนาวุธและโดรนของข้าศึก และระบบตรวจจับ ELINT สำหรับ Early Warning',
    lat: 31.0461, lon: 34.8516, icon: Icons.shield, color: Colors.blue, tags: ['Missile Defense', 'GPS Denial', 'ELINT']),
  const EWEvent(id: 'china_scs', title: 'EW ทะเลจีนใต้', location: 'South China Sea', year: '2018-ปัจจุบัน',
    description: 'จีนติดตั้งระบบ EW บนเกาะเทียมในทะเลจีนใต้ รวมถึงระบบรบกวนเรดาร์และการสื่อสาร มีรายงานการรบกวน GPS ของเครื่องบินทหารสหรัฐ',
    lat: 11.0, lon: 114.0, icon: Icons.waves, color: Colors.purple, tags: ['Island Defense', 'GPS Jamming', 'Naval EW']),
  const EWEvent(id: 'iraq_2003', title: 'สงครามอ่าวเปอร์เซีย', location: 'Iraq', year: '2003',
    description: 'การใช้ SEAD (Suppression of Enemy Air Defenses) และ Electronic Attack อย่างเป็นระบบ รวมถึง AGM-88 HARM และ EA-6B Prowler',
    lat: 33.2232, lon: 43.6793, icon: Icons.airplanemode_active, color: Colors.amber, tags: ['SEAD', 'HARM', 'Air Defense']),
  const EWEvent(id: 'nato_baltic', title: 'NATO Baltic Air Policing', location: 'Baltic Sea', year: '2014-ปัจจุบัน',
    description: 'การเผชิญหน้าทาง EW ระหว่าง NATO และรัสเซีย รวมถึงการรบกวน GPS ในพื้นที่บอลติก และการซ้อมรบ EW ของทั้งสองฝ่าย',
    lat: 56.8796, lon: 24.6032, icon: Icons.security, color: Colors.cyan, tags: ['NATO', 'GPS Spoofing', 'Baltic']),
  const EWEvent(id: 'thai_preah_vihear', title: 'ปราสาทพระวิหาร', location: 'ชายแดนไทย-กัมพูชา', year: '2008-2011',
    description: 'การปะทะบริเวณปราสาทพระวิหาร มีการใช้การดักฟังวิทยุ และ SIGINT เพื่อติดตามการเคลื่อนไหวของฝ่ายตรงข้าม เป็นกรณีศึกษาสำคัญสำหรับ EW ในภูมิประเทศภูเขา',
    lat: 14.3922, lon: 104.6797, icon: Icons.hearing, color: Colors.green, tags: ['SIGINT', 'Border Conflict', 'Thai-Cambodia']),
  const EWEvent(id: 'thai_south', title: 'ปฏิบัติการชายแดนใต้', location: 'สามจังหวัดชายแดนภาคใต้', year: '2004-ปัจจุบัน',
    description: 'การใช้ EW ในการต่อต้านการก่อความไม่สงบ รวมถึงการดักฟังการสื่อสาร การรบกวนวิทยุสื่อสาร และการใช้ Drone เพื่อการลาดตระเวน',
    lat: 6.5, lon: 101.5, icon: Icons.radio, color: Colors.teal, tags: ['COIN', 'Communications', 'Surveillance']),
  const EWEvent(id: 'thai_myanmar', title: 'ชายแดนไทย-เมียนมา', location: 'แม่สอด-เมียวดี', year: '2021-ปัจจุบัน',
    description: 'สถานการณ์ตึงเครียดบริเวณชายแดน มีการใช้การดักฟังสัญญาณ และการตรวจจับโดรนลาดตระเวน เป็นพื้นที่ที่ต้องเฝ้าระวังทาง EW อย่างต่อเนื่อง',
    lat: 16.7, lon: 98.5, icon: Icons.sensors, color: Colors.deepOrange, tags: ['Border Monitoring', 'Drone Detection', 'Myanmar']),
  const EWEvent(id: 'thai_mekong', title: 'ลุ่มน้ำโขง', location: 'ชายแดนไทย-ลาว', year: '2016-ปัจจุบัน',
    description: 'การเฝ้าระวังทางอิเล็กทรอนิกส์บริเวณลุ่มน้ำโขง รวมถึงการตรวจจับเรือลักลอบและการค้าผิดกฎหมาย ใช้เซ็นเซอร์และ SIGINT ในการตรวจจับ',
    lat: 17.8, lon: 102.6, icon: Icons.water, color: Colors.indigo, tags: ['River Patrol', 'SIGINT', 'Mekong']),
];

// ==========================================
// CUSTOM PAINTERS
// ==========================================

class SpaceBackgroundPainter extends CustomPainter {
  final double progress;
  static final List<_Star> _stars = _generateStars();

  SpaceBackgroundPainter({required this.progress});

  static List<_Star> _generateStars() {
    final random = math.Random(42);
    return List.generate(200, (_) => _Star(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 1.8 + 0.3,
      brightness: random.nextDouble(),
      twinkleSpeed: random.nextDouble() * 4 + 1,
    ));
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Deep space gradient
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 1.3,
        colors: [Color(0xFF080818), Color(0xFF020208)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Stars
    final paint = Paint();
    for (final star in _stars) {
      final twinkle = (math.sin(progress * star.twinkleSpeed * math.pi * 2 + star.brightness * 10) + 1) / 2;
      paint.color = Color.fromARGB((40 + 180 * twinkle * star.brightness).toInt(), 255, 255, 255);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size * (0.7 + 0.5 * twinkle),
        paint,
      );
    }

    // Subtle nebula
    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.2),
        radius: 1.8,
        colors: [Colors.cyan.withAlpha(10), Colors.purple.withAlpha(6), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), nebulaPaint);
  }

  @override
  bool shouldRepaint(covariant SpaceBackgroundPainter oldDelegate) => oldDelegate.progress != progress;
}

class _Star {
  final double x, y, size, brightness, twinkleSpeed;
  const _Star({required this.x, required this.y, required this.size, required this.brightness, required this.twinkleSpeed});
}

/// Real Earth Globe Painter with texture mapping
class RealEarthGlobePainter extends CustomPainter {
  final double rotationX;
  final double rotationY;
  final ui.Image? earthTexture;
  final double pulseValue;
  final bool isDark;
  final bool isLoading;

  RealEarthGlobePainter({
    required this.rotationX,
    required this.rotationY,
    this.earthTexture,
    required this.pulseValue,
    required this.isDark,
    required this.isLoading,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Enhanced outer glow with multiple layers
    if (isDark) {
      // Deep space ambient glow
      for (int i = 5; i >= 0; i--) {
        final glowPaint = Paint()
          ..color = Colors.cyan.withAlpha((12 + 6 * pulseValue - i * 2).toInt().clamp(0, 255))
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15 + i * 12);
        canvas.drawCircle(center, radius + i * 6, glowPaint);
      }

      // Blue atmosphere haze
      final hazePaint = Paint()
        ..color = Colors.blue.withAlpha((8 + 4 * pulseValue).toInt())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
      canvas.drawCircle(center, radius + 25, hazePaint);
    }

    // Clip to sphere
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: radius)));

    if (earthTexture != null && !isLoading) {
      _drawTexturedEarth(canvas, center, radius);
    } else {
      _drawProceduralEarth(canvas, center, radius);
    }

    canvas.restore();

    // Enhanced atmosphere rim with realistic Earth-like blue tint
    final atmoPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.transparent,
          const Color(0xFF4FC3F7).withAlpha(isDark ? 35 : 25),
          const Color(0xFF29B6F6).withAlpha(isDark ? 60 : 40),
          Colors.cyan.withAlpha(isDark ? 90 : 60),
        ],
        stops: const [0.0, 0.78, 0.88, 0.95, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, atmoPaint);

    // Inner subtle atmosphere glow
    final innerAtmoPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          Colors.white.withAlpha(20),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, innerAtmoPaint);

    // Multi-layer glowing border
    final borderGlowPaint = Paint()
      ..color = Colors.cyan.withAlpha((30 + 20 * pulseValue).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center, radius, borderGlowPaint);

    final borderPaint = Paint()
      ..color = Colors.cyan.withAlpha((80 + 40 * pulseValue).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);
  }

  void _drawTexturedEarth(Canvas canvas, Offset center, double radius) {
    final img = earthTexture!;
    final imgW = img.width.toDouble();
    final imgH = img.height.toDouble();

    final paint = Paint()..filterQuality = FilterQuality.high;

    // Higher resolution for smoother sphere appearance
    const int latSteps = 55;
    const int lonSteps = 80;

    for (int i = 0; i < latSteps; i++) {
      for (int j = 0; j < lonSteps; j++) {
        // World lat/lon in radians
        final lat1 = -math.pi / 2 + (i / latSteps) * math.pi;
        final lat2 = -math.pi / 2 + ((i + 1) / latSteps) * math.pi;
        final lon1 = -math.pi + (j / lonSteps) * 2 * math.pi;
        final lon2 = -math.pi + ((j + 1) / lonSteps) * 2 * math.pi;

        // Get 3D position using same transformation as markers
        final p1 = _latLonToScreen(lat1, lon1, radius);
        final p2 = _latLonToScreen(lat1, lon2, radius);
        final p3 = _latLonToScreen(lat2, lon2, radius);
        final p4 = _latLonToScreen(lat2, lon1, radius);

        // Skip if all points are on backside
        if (p1.z <= 0 && p2.z <= 0 && p3.z <= 0 && p4.z <= 0) continue;

        // Calculate average depth for opacity
        final avgZ = (p1.z + p2.z + p3.z + p4.z) / 4;
        if (avgZ < -radius * 0.1) continue;

        // Source rectangle from texture (equirectangular projection)
        final srcX1 = ((lon1 + math.pi) / (2 * math.pi) * imgW).clamp(0.0, imgW - 1);
        final srcX2 = ((lon2 + math.pi) / (2 * math.pi) * imgW).clamp(0.0, imgW - 1);
        final srcY1 = ((math.pi / 2 - lat2) / math.pi * imgH).clamp(0.0, imgH - 1);
        final srcY2 = ((math.pi / 2 - lat1) / math.pi * imgH).clamp(0.0, imgH - 1);

        // Handle texture wrapping
        if ((srcX2 - srcX1).abs() > imgW / 2) continue;

        final srcRect = Rect.fromLTRB(srcX1, srcY1, srcX2, srcY2);

        // Destination quad as Path
        final path = Path()
          ..moveTo(center.dx + p1.x, center.dy + p1.y)
          ..lineTo(center.dx + p2.x, center.dy + p2.y)
          ..lineTo(center.dx + p3.x, center.dy + p3.y)
          ..lineTo(center.dx + p4.x, center.dy + p4.y)
          ..close();

        // Bounding rect for image drawing
        final bounds = path.getBounds();
        if (bounds.width < 1 || bounds.height < 1) continue;

        // Smooth depth-based shading with better falloff
        final depth = ((avgZ / radius) + 1) / 2;
        final smoothDepth = depth * depth; // Quadratic falloff for smoother lighting
        paint.color = Color.fromARGB((255 * smoothDepth.clamp(0.25, 1.0)).toInt(), 255, 255, 255);

        // Draw texture segment
        canvas.save();
        canvas.clipPath(path);
        canvas.drawImageRect(img, srcRect, bounds, paint);
        canvas.restore();
      }
    }

    // Enhanced 3D lighting with multiple light sources
    // Main sun light from top-left
    final sunPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.35),
        radius: 1.0,
        colors: [
          Colors.white.withAlpha(55),
          Colors.white.withAlpha(20),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.7],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, sunPaint);

    // Shadow on the dark side
    final shadowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.5, 0.4),
        radius: 1.4,
        colors: [
          Colors.transparent,
          Colors.black.withAlpha(40),
          Colors.black.withAlpha(90),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, shadowPaint);

    // Subtle rim light for depth
    final rimPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          Colors.transparent,
          Colors.transparent,
          Colors.cyan.withAlpha(15),
        ],
        stops: const [0.0, 0.85, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, rimPaint);
  }

  /// Convert lat/lon to screen position using same transform as markers
  Point3D _latLonToScreen(double latRad, double lonRad, double radius) {
    // 3D position on sphere
    double x = radius * math.cos(latRad) * math.sin(lonRad);
    double y = -radius * math.sin(latRad);
    double z = radius * math.cos(latRad) * math.cos(lonRad);

    // Apply Y rotation (horizontal rotation)
    final cosY = math.cos(rotationY);
    final sinY = math.sin(rotationY);
    final newX = x * cosY + z * sinY;
    final newZ = -x * sinY + z * cosY;
    x = newX;
    z = newZ;

    // Apply X rotation (tilt)
    final cosX = math.cos(rotationX);
    final sinX = math.sin(rotationX);
    final newY = y * cosX - z * sinX;
    final newZ2 = y * sinX + z * cosX;
    y = newY;
    z = newZ2;

    return Point3D(x, y, z);
  }

  void _drawProceduralEarth(Canvas canvas, Offset center, double radius) {
    // Ocean base
    final oceanPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: isDark ? [const Color(0xFF1e4a6e), const Color(0xFF0a1a2a)] : [const Color(0xFF4a9aca), const Color(0xFF2a6a9a)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, oceanPaint);

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.cyan.withAlpha(isDark ? 35 : 50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int lat = -60; lat <= 60; lat += 30) {
      final latRad = lat * math.pi / 180;
      final y = center.dy - radius * math.sin(latRad) * math.cos(rotationX);
      final r = radius * math.cos(latRad);
      if (r > 0) canvas.drawOval(Rect.fromCenter(center: Offset(center.dx, y), width: r * 2, height: r * 0.35), gridPaint);
    }

    for (int lon = 0; lon < 360; lon += 30) {
      _drawLongLine(canvas, center, radius, lon.toDouble(), gridPaint);
    }

    // Continents
    _drawContinents(canvas, center, radius);

    // Lighting
    final lightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 1.5,
        colors: [Colors.white.withAlpha(50), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, lightPaint);
  }

  void _drawLongLine(Canvas canvas, Offset center, double radius, double lon, Paint paint) {
    final path = Path();
    bool started = false;
    final lonRad = (lon * math.pi / 180) + rotationY;

    for (int lat = -90; lat <= 90; lat += 5) {
      final latRad = lat * math.pi / 180;
      double x = radius * math.cos(latRad) * math.sin(lonRad);
      double y = -radius * math.sin(latRad);
      double z = radius * math.cos(latRad) * math.cos(lonRad);

      final cosX = math.cos(rotationX);
      final sinX = math.sin(rotationX);
      final newY = y * cosX - z * sinX;
      final newZ = y * sinX + z * cosX;

      if (newZ > 0) {
        if (!started) { path.moveTo(center.dx + x, center.dy + newY); started = true; }
        else { path.lineTo(center.dx + x, center.dy + newY); }
      } else { started = false; }
    }
    canvas.drawPath(path, paint);
  }

  void _drawContinents(Canvas canvas, Offset center, double radius) {
    final landPaint = Paint()..style = PaintingStyle.fill;
    final landData = [
      {'lat': 40.0, 'lon': 100.0, 'size': 38.0},
      {'lat': 50.0, 'lon': 15.0, 'size': 22.0},
      {'lat': 5.0, 'lon': 20.0, 'size': 28.0},
      {'lat': 45.0, 'lon': -100.0, 'size': 32.0},
      {'lat': -15.0, 'lon': -60.0, 'size': 24.0},
      {'lat': -25.0, 'lon': 135.0, 'size': 20.0},
    ];

    for (final land in landData) {
      final latRad = land['lat']! * math.pi / 180;
      final lonRad = (land['lon']! * math.pi / 180) + rotationY;

      double x = radius * math.cos(latRad) * math.sin(lonRad);
      double y = -radius * math.sin(latRad);
      double z = radius * math.cos(latRad) * math.cos(lonRad);

      final cosX = math.cos(rotationX);
      final sinX = math.sin(rotationX);
      final newY = y * cosX - z * sinX;
      final newZ = y * sinX + z * cosX;

      if (newZ > 0) {
        final scale = 0.4 + 0.6 * (newZ / radius);
        landPaint.color = Colors.green.withAlpha((70 * scale).toInt() + (isDark ? 0 : 35));
        canvas.drawCircle(Offset(center.dx + x, center.dy + newY), land['size']! * scale, landPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RealEarthGlobePainter oldDelegate) {
    return oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.earthTexture != earthTexture ||
        oldDelegate.isLoading != isLoading;
  }
}
