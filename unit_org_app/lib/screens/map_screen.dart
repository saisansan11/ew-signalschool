import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/constants.dart';
import '../data/rta_signal_corps.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  SignalUnit? _selectedUnit;
  String _selectedRegion = 'all';

  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;

  final TransformationController _transformController = TransformationController();

  // Thailand map bounds (approximate)
  static const double _mapMinLat = 5.5;
  static const double _mapMaxLat = 20.5;
  static const double _mapMinLng = 97.5;
  static const double _mapMaxLng = 105.5;

  final List<Map<String, dynamic>> _regions = [
    {'id': 'all', 'name': 'ทั้งหมด', 'color': AppColors.primary},
    {'id': 'central', 'name': 'ส่วนกลาง', 'color': AppColors.signalCorps},
    {'id': 'area1', 'name': 'ทภ.1', 'color': const Color(0xFF4CAF50)},
    {'id': 'area2', 'name': 'ทภ.2', 'color': const Color(0xFF2196F3)},
    {'id': 'area3', 'name': 'ทภ.3', 'color': const Color(0xFFFF9800)},
    {'id': 'area4', 'name': 'ทภ.4', 'color': const Color(0xFFE91E63)},
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  Offset _latLngToPosition(double lat, double lng, Size size) {
    final x = (lng - _mapMinLng) / (_mapMaxLng - _mapMinLng) * size.width;
    final y = (1 - (lat - _mapMinLat) / (_mapMaxLat - _mapMinLat)) * size.height;
    return Offset(x, y);
  }

  List<SignalUnit> get _filteredUnits {
    final allUnits = RTASignalCorps.allCombinedUnits
        .where((u) =>
            u.level == UnitLevel.department ||
            u.level == UnitLevel.battalion ||
            u.level == UnitLevel.school)
        .toList();

    if (_selectedRegion == 'all') return allUnits;

    return allUnits.where((unit) {
      // Filter logic based on unit ID patterns
      switch (_selectedRegion) {
        case 'central':
          return unit.id.startsWith('dept_') ||
                 unit.id.contains('_hq') ||
                 unit.abbreviation.contains('กส.');
        case 'area1':
          return unit.id.contains('_1') || unit.abbreviation.contains('1');
        case 'area2':
          return unit.id.contains('_2') || unit.abbreviation.contains('2');
        case 'area3':
          return unit.id.contains('_3') || unit.abbreviation.contains('3');
        case 'area4':
          return unit.id.contains('_4') || unit.abbreviation.contains('4');
        default:
          return true;
      }
    }).toList();
  }

  void _selectUnit(SignalUnit unit) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedUnit = unit;
    });
    _showUnitDetail(unit);
  }

  void _showUnitDetail(SignalUnit unit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _UnitDetailSheet(
        unit: unit,
        onChildTap: (childUnit) {
          Navigator.pop(context);
          _selectUnit(childUnit);
        },
      ),
    );
  }

  void _resetView() {
    HapticFeedback.lightImpact();
    _transformController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background glow
          _buildBackgroundEffects(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar
                _buildAppBar(),

                // Region filter
                _buildRegionFilter(),

                // Map area
                Expanded(
                  child: _buildMapArea(),
                ),
              ],
            ),
          ),

          // Legend
          Positioned(
            left: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: _buildLegend(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -100 + (_glowController.value * 20),
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.signalCorps.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'แผนที่หน่วยทหารสื่อสาร',
                  style: AppTextStyles.titleLarge,
                ),
                Text(
                  '${_filteredUnits.length} หน่วย',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Reset view button
          GestureDetector(
            onTap: _resetView,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.zoom_out_map_rounded,
                size: 22,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildRegionFilter() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
        itemCount: _regions.length,
        itemBuilder: (context, index) {
          final region = _regions[index];
          final isSelected = _selectedRegion == region['id'];

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _selectedRegion = region['id'] as String;
                _selectedUnit = null;
              });
            },
            child: AnimatedContainer(
              duration: AppDurations.fast,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          (region['color'] as Color).withValues(alpha: 0.3),
                          (region['color'] as Color).withValues(alpha: 0.15),
                        ],
                      )
                    : null,
                color: isSelected ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                border: Border.all(
                  color: isSelected
                      ? (region['color'] as Color)
                      : AppColors.border,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (region['color'] as Color).withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: region['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    region['name'] as String,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected
                          ? region['color'] as Color
                          : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )
                .animate(delay: Duration(milliseconds: index * 50))
                .fadeIn()
                .slideX(begin: 0.1, end: 0),
          );
        },
      ),
    );
  }

  Widget _buildMapArea() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        child: InteractiveViewer(
          transformationController: _transformController,
          boundaryMargin: const EdgeInsets.all(50),
          minScale: 0.5,
          maxScale: 4.0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return Stack(
                children: [
                  // Thailand map background
                  _buildMapBackground(size),

                  // Unit markers
                  ..._buildUnitMarkers(size),
                ],
              );
            },
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
        );
  }

  Widget _buildMapBackground(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            AppColors.surfaceLight,
            AppColors.surface,
          ],
        ),
      ),
      child: CustomPaint(
        painter: ThailandMapPainter(),
        size: size,
      ),
    );
  }

  List<Widget> _buildUnitMarkers(Size size) {
    final units = _filteredUnits;

    return units.asMap().entries.map((entry) {
      final index = entry.key;
      final unit = entry.value;

      final pos = _latLngToPosition(
        unit.location.latitude,
        unit.location.longitude,
        size,
      );

      final isSelected = _selectedUnit?.id == unit.id;
      final markerSize = unit.level == UnitLevel.department ? 28.0 : 22.0;

      return Positioned(
        left: pos.dx - markerSize / 2,
        top: pos.dy - markerSize / 2,
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
        )
            .animate(delay: Duration(milliseconds: 300 + (index * 30)))
            .fadeIn()
            .scale(begin: const Offset(0, 0), end: const Offset(1, 1)),
      );
    }).toList();
  }

  Widget _buildMarker(SignalUnit unit, double size, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                unit.color,
                unit.color.withValues(alpha: 0.8),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white70,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: unit.color.withValues(alpha: isSelected ? 0.6 : 0.4),
                blurRadius: isSelected ? 16 : 8,
                spreadRadius: isSelected ? 2 : 0,
              ),
            ],
          ),
          child: Icon(
            Icons.cell_tower_rounded,
            size: size * 0.55,
            color: Colors.white,
          ),
        ),
        if (isSelected) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              border: Border.all(color: unit.color, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: unit.color.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(
              unit.abbreviation,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: unit.color,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.signalCorps,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'สัญลักษณ์',
                style: AppTextStyles.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._regions.skip(1).map((region) => _legendItem(
                region['color'] as Color,
                region['name'] as String,
              )),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 1),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}

/// Unit Detail Bottom Sheet
class _UnitDetailSheet extends StatelessWidget {
  final SignalUnit unit;
  final void Function(SignalUnit) onChildTap;

  const _UnitDetailSheet({
    required this.unit,
    required this.onChildTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusXXL),
            ),
            boxShadow: [
              BoxShadow(
                color: unit.color.withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Header
                    _buildHeader(context),
                    const SizedBox(height: 24),

                    // Info cards
                    _buildInfoCards(),
                    const SizedBox(height: 24),

                    // Description
                    _SectionTitle(title: 'รายละเอียด'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        unit.description,
                        style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                    // Missions
                    if (unit.missions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'ภารกิจ'),
                      const SizedBox(height: 12),
                      ...unit.missions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final mission = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(AppSizes.paddingM),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                unit.color.withValues(alpha: 0.1),
                                unit.color.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppSizes.radiusM),
                            border: Border.all(
                              color: unit.color.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: unit.color.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: unit.color,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  mission,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate(delay: Duration(milliseconds: 200 + (index * 50)))
                            .fadeIn()
                            .slideX(begin: 0.1, end: 0);
                      }),
                    ],

                    // Child units
                    if (unit.childUnitIds.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'หน่วยรอง'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: unit.childUnitIds.asMap().entries.map((entry) {
                          final index = entry.key;
                          final id = entry.value;
                          final childUnit = RTASignalCorps.getUnitById(id);
                          if (childUnit == null) return const SizedBox();

                          return GestureDetector(
                            onTap: () => onChildTap(childUnit),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    childUnit.color.withValues(alpha: 0.15),
                                    childUnit.color.withValues(alpha: 0.08),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                border: Border.all(
                                  color: childUnit.color.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: childUnit.color.withValues(alpha: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.cell_tower_rounded,
                                      size: 12,
                                      color: childUnit.color,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    childUnit.abbreviation,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .animate(delay: Duration(milliseconds: 300 + (index * 30)))
                                .fadeIn()
                                .scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1, 1),
                                ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            unit.color.withValues(alpha: 0.15),
            unit.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(
          color: unit.color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Icon with glow
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  unit.color.withValues(alpha: 0.4),
                  unit.color.withValues(alpha: 0.2),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: unit.color.withValues(alpha: 0.3),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Icon(
              Icons.cell_tower_rounded,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: unit.color,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Text(
                        unit.level.symbol,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      unit.level.thaiName,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: unit.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  unit.name,
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  '${unit.nameEn} (${unit.abbreviation})',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildInfoCards() {
    return Column(
      children: [
        // Location card
        _InfoCard(
          icon: Icons.location_on_rounded,
          title: 'ที่ตั้ง',
          value: unit.location.fullAddress,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),

        // Row with Commander and Personnel
        Row(
          children: [
            Expanded(
              child: _InfoCard(
                icon: Icons.military_tech_rounded,
                title: 'ผู้บังคับบัญชา',
                value: unit.commanderRank,
                color: AppColors.officer,
                compact: true,
              ),
            ),
            if (unit.personnelMin != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  icon: Icons.people_rounded,
                  title: 'กำลังพล',
                  value: unit.personnelRange,
                  color: AppColors.infantry,
                  compact: true,
                ),
              ),
            ],
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.signalCorps,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.titleLarge),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool compact;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? AppSizes.paddingS : AppSizes.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 36 : 42,
            height: compact ? 36 : 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(icon, color: color, size: compact ? 18 : 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: compact
                      ? AppTextStyles.titleSmall.copyWith(color: color)
                      : AppTextStyles.titleMedium.copyWith(color: color),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for Thailand map outline
class ThailandMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Gradient fill
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.surfaceLight,
        AppColors.surface,
      ],
    ).createShader(rect);

    final borderPaint = Paint()
      ..color = AppColors.signalCorps.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final glowPaint = Paint()
      ..color = AppColors.signalCorps.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Thailand shape points
    final points = [
      Offset(0.45 * size.width, 0.05 * size.height),
      Offset(0.55 * size.width, 0.08 * size.height),
      Offset(0.65 * size.width, 0.15 * size.height),
      Offset(0.70 * size.width, 0.25 * size.height),
      Offset(0.75 * size.width, 0.30 * size.height),
      Offset(0.70 * size.width, 0.40 * size.height),
      Offset(0.65 * size.width, 0.45 * size.height),
      Offset(0.60 * size.width, 0.50 * size.height),
      Offset(0.55 * size.width, 0.55 * size.height),
      Offset(0.50 * size.width, 0.60 * size.height),
      Offset(0.48 * size.width, 0.70 * size.height),
      Offset(0.45 * size.width, 0.80 * size.height),
      Offset(0.42 * size.width, 0.90 * size.height),
      Offset(0.40 * size.width, 0.95 * size.height),
      Offset(0.38 * size.width, 0.90 * size.height),
      Offset(0.35 * size.width, 0.80 * size.height),
      Offset(0.33 * size.width, 0.70 * size.height),
      Offset(0.30 * size.width, 0.60 * size.height),
      Offset(0.28 * size.width, 0.50 * size.height),
      Offset(0.25 * size.width, 0.40 * size.height),
      Offset(0.30 * size.width, 0.30 * size.height),
      Offset(0.35 * size.width, 0.20 * size.height),
      Offset(0.38 * size.width, 0.12 * size.height),
      Offset(0.42 * size.width, 0.08 * size.height),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final controlX = (prev.dx + curr.dx) / 2;
      final controlY = (prev.dy + curr.dy) / 2;
      path.quadraticBezierTo(prev.dx, prev.dy, controlX, controlY);
    }
    path.close();

    // Draw glow first
    canvas.drawPath(path, glowPaint);
    // Then fill
    canvas.drawPath(path, paint);
    // Then border
    canvas.drawPath(path, borderPaint);

    // Draw region labels
    _drawRegionLabels(canvas, size);
  }

  void _drawRegionLabels(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final regions = [
      ('ภาคเหนือ', Offset(0.40 * size.width, 0.15 * size.height)),
      ('ภาคอีสาน', Offset(0.62 * size.width, 0.30 * size.height)),
      ('ภาคกลาง', Offset(0.45 * size.width, 0.48 * size.height)),
      ('ภาคใต้', Offset(0.40 * size.width, 0.82 * size.height)),
    ];

    for (final (label, offset) in regions) {
      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: AppColors.textMuted.withValues(alpha: 0.6),
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(offset.dx - textPainter.width / 2, offset.dy),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
