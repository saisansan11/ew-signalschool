import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../app/constants.dart';
import '../data/rta_signal_corps.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  SignalUnit? _selectedUnit;
  bool _showingDetail = false;
  bool _isSatellite = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final MapController _mapController = MapController();

  // Thailand center
  static const LatLng _thailandCenter = LatLng(13.7563, 100.5018);
  static const double _initialZoom = 5.5;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _selectUnit(SignalUnit unit) {
    setState(() {
      _selectedUnit = unit;
      _showingDetail = true;
    });

    // Animate to unit location
    _mapController.move(
      LatLng(unit.location.latitude, unit.location.longitude),
      9.0,
    );
  }

  void _closeDetail() {
    setState(() {
      _showingDetail = false;
      _selectedUnit = null;
    });
  }

  void _resetView() {
    _mapController.move(_thailandCenter, _initialZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('แผนที่หน่วยทหารสื่อสาร',
            style: AppTextStyles.titleLarge),
        actions: [
          // Toggle satellite/map view
          IconButton(
            icon: Icon(_isSatellite ? Icons.satellite_alt : Icons.map),
            onPressed: () {
              setState(() {
                _isSatellite = !_isSatellite;
              });
            },
            tooltip: _isSatellite ? 'แผนที่ธรรมดา' : 'ภาพดาวเทียม',
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _resetView,
            tooltip: 'รีเซ็ตมุมมอง',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Flutter Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _thailandCenter,
              initialZoom: _initialZoom,
              minZoom: 4.0,
              maxZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onTap: (_, __) {
                if (_showingDetail) {
                  _closeDetail();
                }
              },
            ),
            children: [
              // Tile layer - ESRI Satellite or OpenStreetMap
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.unit_org_app',
                maxZoom: 18,
              ),

              // Labels overlay for satellite view
              if (_isSatellite)
                TileLayer(
                  urlTemplate:
                      'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
                  userAgentPackageName: 'com.example.unit_org_app',
                  maxZoom: 18,
                ),

              // Unit markers
              MarkerLayer(
                markers: _buildMarkers(),
              ),
            ],
          ),

          // Legend
          Positioned(
            left: 16,
            bottom: 16,
            child: _buildLegend(),
          ),

          // Zoom controls
          Positioned(
            right: 16,
            bottom: 100,
            child: _buildZoomControls(),
          ),

          // Detail overlay
          if (_showingDetail && _selectedUnit != null)
            _buildDetailOverlay(_selectedUnit!),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers() {
    final allUnits = RTASignalCorps.allCombinedUnits
        .where((u) =>
            u.level == UnitLevel.department ||
            u.level == UnitLevel.battalion ||
            u.level == UnitLevel.school)
        .toList();

    // Group units by proximity to add offset for overlapping markers
    final processedUnits = _addOffsetForOverlappingUnits(allUnits);

    return processedUnits.map((unitData) {
      final unit = unitData.unit;
      final offset = unitData.offset;
      final isSelected = _selectedUnit?.id == unit.id;
      final markerSize = unit.level == UnitLevel.department ? 44.0 : 36.0;

      return Marker(
        point: LatLng(
          unit.location.latitude + offset.dy * 0.05,
          unit.location.longitude + offset.dx * 0.05,
        ),
        width: markerSize + 20,
        height: markerSize + 20,
        child: GestureDetector(
          onTap: () => _selectUnit(unit),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              final scale = isSelected ? _pulseAnimation.value : 1.0;
              return Transform.scale(
                scale: scale,
                child: _buildMarker(unit, markerSize, isSelected),
              );
            },
          ),
        ),
      );
    }).toList();
  }

  List<_UnitWithOffset> _addOffsetForOverlappingUnits(List<SignalUnit> units) {
    final result = <_UnitWithOffset>[];
    final processed = <String, bool>{};

    for (int i = 0; i < units.length; i++) {
      final unit = units[i];
      if (processed[unit.id] == true) continue;

      // Find units at similar locations
      final nearby = <SignalUnit>[];
      for (int j = i; j < units.length; j++) {
        final other = units[j];
        if (processed[other.id] == true) continue;

        final distance = _calculateDistance(
          unit.location.latitude,
          unit.location.longitude,
          other.location.latitude,
          other.location.longitude,
        );

        if (distance < 0.3) {
          // Within ~30km
          nearby.add(other);
          processed[other.id] = true;
        }
      }

      // Add offsets for overlapping units in a circular pattern
      if (nearby.length == 1) {
        result.add(_UnitWithOffset(nearby[0], Offset.zero));
      } else {
        for (int k = 0; k < nearby.length; k++) {
          if (k == 0) {
            result.add(_UnitWithOffset(nearby[k], Offset.zero));
          } else {
            final angle = (k * 2 * 3.14159) / (nearby.length - 1);
            final offsetX = 0.8 * (angle < 3.14159 ? 1 : -1) * ((k % 2) + 1);
            final offsetY = 0.8 * (k % 2 == 0 ? 1 : -1);
            result.add(_UnitWithOffset(nearby[k], Offset(offsetX, offsetY)));
          }
        }
      }
    }

    return result;
  }

  double _calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    return ((lat1 - lat2).abs() + (lng1 - lng2).abs());
  }

  Widget _buildMarker(SignalUnit unit, double size, bool isSelected) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: unit.color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: isSelected ? 4 : 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity( 0.5),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
            if (isSelected)
              BoxShadow(
                color: unit.color.withOpacity( 0.7),
                blurRadius: 12,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Icon(
          Icons.cell_tower,
          size: size * 0.5,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity( 0.95),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.textPrimary),
            onPressed: () {
              final currentZoom = _mapController.camera.zoom;
              _mapController.move(
                _mapController.camera.center,
                currentZoom + 1,
              );
            },
            tooltip: 'ซูมเข้า',
          ),
          Container(height: 1, width: 30, color: AppColors.border),
          IconButton(
            icon: const Icon(Icons.remove, color: AppColors.textPrimary),
            onPressed: () {
              final currentZoom = _mapController.camera.zoom;
              _mapController.move(
                _mapController.camera.center,
                currentZoom - 1,
              );
            },
            tooltip: 'ซูมออก',
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity( 0.95),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'สัญลักษณ์',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _legendItem(AppColors.signalCorps, 'กส. (ส่วนกลาง)'),
          _legendItem(const Color(0xFF4CAF50), 'ทภ.1'),
          _legendItem(const Color(0xFF2196F3), 'ทภ.2'),
          _legendItem(const Color(0xFFFF9800), 'ทภ.3'),
          _legendItem(const Color(0xFFE91E63), 'ทภ.4'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity( 0.2),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailOverlay(SignalUnit unit) {
    return AnimatedOpacity(
      opacity: _showingDetail ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: _closeDetail,
        child: Container(
          color: Colors.black54,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping card
              child: AnimatedScale(
                scale: _showingDetail ? 1.0 : 0.8,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    border: Border.all(color: unit.color, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: unit.color.withOpacity( 0.3),
                        blurRadius: 30,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: unit.color.withOpacity( 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: unit.color, width: 2),
                              ),
                              child: Icon(
                                Icons.cell_tower,
                                size: 24,
                                color: unit.color,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: unit.color.withOpacity( 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      unit.level.thaiName,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: unit.color,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    unit.name,
                                    style: AppTextStyles.titleMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    unit.abbreviation,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _closeDetail,
                              icon: const Icon(Icons.close),
                              color: AppColors.textMuted,
                              iconSize: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Location
                        _infoRow(
                          Icons.location_on,
                          'ที่ตั้ง',
                          unit.location.fullAddress,
                          unit.color,
                        ),
                        const SizedBox(height: 10),

                        // Coordinates
                        _infoRow(
                          Icons.gps_fixed,
                          'พิกัด',
                          '${unit.location.latitude.toStringAsFixed(4)}°N, ${unit.location.longitude.toStringAsFixed(4)}°E',
                          unit.color,
                        ),
                        const SizedBox(height: 10),

                        // Commander
                        _infoRow(
                          Icons.military_tech,
                          'ผู้บังคับบัญชา',
                          unit.commanderRank,
                          unit.color,
                        ),

                        if (unit.personnelMin != null) ...[
                          const SizedBox(height: 10),
                          _infoRow(
                            Icons.people,
                            'กำลังพล',
                            unit.personnelRange,
                            unit.color,
                          ),
                        ],

                        const SizedBox(height: 16),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: 12),

                        // Description
                        const Text('รายละเอียด',
                            style: AppTextStyles.titleSmall),
                        const SizedBox(height: 6),
                        Text(
                          unit.description,
                          style: AppTextStyles.bodySmall,
                        ),

                        // Missions
                        if (unit.missions.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text('ภารกิจ', style: AppTextStyles.titleSmall),
                          const SizedBox(height: 6),
                          ...unit.missions.take(3).map(
                                (m) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 14,
                                        color: unit.color,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(m,
                                            style: AppTextStyles.bodySmall),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          if (unit.missions.length > 3)
                            Text(
                              '...และอีก ${unit.missions.length - 3} ภารกิจ',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMuted,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],

                        // Child units
                        if (unit.childUnitIds.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text('หน่วยรอง',
                              style: AppTextStyles.titleSmall),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: unit.childUnitIds.take(6).map((id) {
                              final childUnit = RTASignalCorps.getUnitById(id);
                              if (childUnit == null) return const SizedBox();
                              return _childUnitChip(childUnit);
                            }).toList(),
                          ),
                          if (unit.childUnitIds.length > 6)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                '...และอีก ${unit.childUnitIds.length - 6} หน่วย',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity( 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _childUnitChip(SignalUnit unit) {
    return GestureDetector(
      onTap: () => _selectUnit(unit),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              unit.level.symbol,
              style: TextStyle(fontSize: 9, color: unit.color),
            ),
            const SizedBox(width: 4),
            Text(
              unit.abbreviation,
              style:
                  const TextStyle(fontSize: 10, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitWithOffset {
  final SignalUnit unit;
  final Offset offset;

  _UnitWithOffset(this.unit, this.offset);
}
