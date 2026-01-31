import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/constants.dart';
import '../models/unit_models.dart';
import '../data/signal_corps_data.dart';
import '../services/progress_service.dart';

class OrgChartScreen extends StatefulWidget {
  const OrgChartScreen({super.key});

  @override
  State<OrgChartScreen> createState() => _OrgChartScreenState();
}

class _OrgChartScreenState extends State<OrgChartScreen>
    with TickerProviderStateMixin {
  MilitaryUnit? _selectedUnit;
  final Set<String> _expandedUnits = {'signal_bn'};
  final TransformationController _transformController = TransformationController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _showSearch = false;
  String _searchQuery = '';
  List<MilitaryUnit> _searchResults = [];

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _transformController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  MilitaryUnit? _getUnitById(String id) {
    try {
      return SignalCorpsData.units.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  void _toggleExpand(String unitId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_expandedUnits.contains(unitId)) {
        _expandedUnits.remove(unitId);
      } else {
        _expandedUnits.add(unitId);
      }
    });
  }

  void _selectUnit(MilitaryUnit unit) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedUnit = unit;
    });

    // Mark unit as viewed
    ProgressService.instance.markUnitViewed(unit.id);

    _showUnitDetail(unit);
  }

  void _toggleSearch() {
    HapticFeedback.lightImpact();
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchController.clear();
        _searchQuery = '';
        _searchResults = [];
      } else {
        Future.delayed(const Duration(milliseconds: 200), () {
          _searchFocusNode.requestFocus();
        });
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = SignalCorpsData.units.where((unit) {
          return unit.nameThai.toLowerCase().contains(_searchQuery) ||
              unit.name.toLowerCase().contains(_searchQuery) ||
              unit.abbreviation.toLowerCase().contains(_searchQuery) ||
              unit.description.toLowerCase().contains(_searchQuery);
        }).toList();
      }
    });
  }

  void _expandToUnit(MilitaryUnit unit) {
    // Find parent hierarchy and expand all
    void expandParents(String unitId) {
      for (final parent in SignalCorpsData.units) {
        if (parent.childIds.contains(unitId)) {
          _expandedUnits.add(parent.id);
          expandParents(parent.id);
        }
      }
    }

    expandParents(unit.id);
    _expandedUnits.add(unit.id);

    setState(() {
      _showSearch = false;
      _searchController.clear();
      _searchQuery = '';
      _searchResults = [];
      _selectedUnit = unit;
    });

    _showUnitDetail(unit);
  }

  void _showUnitDetail(MilitaryUnit unit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _UnitDetailSheet(unit: unit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background effects
          _buildBackgroundEffects(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar
                _buildAppBar(),

                // Search bar (animated)
                _buildSearchSection(),

                // Legend
                _buildLegend(),

                // Org Chart or Search Results
                Expanded(
                  child: _searchResults.isNotEmpty
                      ? _buildSearchResults()
                      : _buildOrgChartView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Positioned(
              top: -100 + (_pulseController.value * 20),
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
            );
          },
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
            child: Text(
              'โครงสร้างหน่วย',
              style: AppTextStyles.titleLarge,
            ),
          ),

          // Search button
          GestureDetector(
            onTap: _toggleSearch,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _showSearch
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(
                  color: _showSearch ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Icon(
                _showSearch ? Icons.close_rounded : Icons.search_rounded,
                size: 22,
                color: _showSearch ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Reset zoom button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _transformController.value = Matrix4.identity();
            },
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

  Widget _buildSearchSection() {
    return AnimatedSize(
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
      child: _showSearch
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
              padding: const EdgeInsets.only(bottom: AppSizes.paddingS),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 22,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: _onSearchChanged,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'ค้นหาหน่วย...',
                          hintStyle: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textMuted,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.2, end: 0),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _LegendItem(symbol: '●', label: 'หมู่', color: AppColors.textMuted),
            _LegendItem(symbol: '●●', label: 'หมวด', color: AppColors.textMuted),
            _LegendItem(symbol: '|', label: 'ร้อย', color: AppColors.textMuted),
            _LegendItem(symbol: '||', label: 'พัน', color: AppColors.textMuted),
            _LegendItem(symbol: '|||', label: 'กรม', color: AppColors.textMuted),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      physics: const BouncingScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final unit = _searchResults[index];
        return GestureDetector(
          onTap: () => _expandToUnit(unit),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: unit.branch.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    unit.branch.icon,
                    size: 24,
                    color: unit.branch.color,
                  ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: unit.branch.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              unit.size.symbol,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: unit.branch.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            unit.size.thaiName,
                            style: AppTextStyles.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        unit.nameThai,
                        style: AppTextStyles.titleMedium,
                      ),
                      Text(
                        unit.abbreviation,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: unit.branch.color,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          )
              .animate(delay: Duration(milliseconds: index * 50))
              .fadeIn()
              .slideX(begin: 0.1, end: 0),
        );
      },
    );
  }

  Widget _buildOrgChartView() {
    return InteractiveViewer(
      transformationController: _transformController,
      boundaryMargin: const EdgeInsets.all(200),
      minScale: 0.3,
      maxScale: 3.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingXL),
            child: _buildOrgTree(),
          ),
        ),
      ),
    );
  }

  Widget _buildOrgTree() {
    final battalion = _getUnitById('signal_bn');
    if (battalion == null) return const SizedBox();

    return Column(
      children: [
        _buildUnitNode(battalion, 0),
        if (_expandedUnits.contains(battalion.id)) ...[
          const SizedBox(height: 20),
          _buildConnectorLine(),
          const SizedBox(height: 20),
          _buildChildrenRow(battalion.childIds, 1),
        ],
      ],
    ).animate().fadeIn(duration: 500.ms).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
        );
  }

  Widget _buildUnitNode(MilitaryUnit unit, int level) {
    final isSelected = _selectedUnit?.id == unit.id;
    final isExpanded = _expandedUnits.contains(unit.id);
    final hasChildren = unit.childIds.isNotEmpty;
    final isViewed = ProgressService.instance.isUnitViewed(unit.id);

    return GestureDetector(
      onTap: () => _selectUnit(unit),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        width: 150,
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: isSelected
              ? unit.branch.color.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(
            color: isSelected ? unit.branch.color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: unit.branch.color.withValues(alpha: 0.3),
                blurRadius: 16,
                spreadRadius: 0,
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Unit size badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        unit.branch.color.withValues(alpha: 0.3),
                        unit.branch.color.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: unit.branch.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    unit.size.symbol,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: unit.branch.color,
                    ),
                  ),
                ),
                if (isViewed)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: AppColors.success,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Icon with glow
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    unit.branch.color.withValues(alpha: 0.2),
                    unit.branch.color.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: unit.branch.color.withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(
                unit.branch.icon,
                size: 24,
                color: unit.branch.color,
              ),
            ),
            const SizedBox(height: 10),

            // Name
            Text(
              unit.nameThai,
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // Abbreviation
            Text(
              unit.abbreviation,
              style: AppTextStyles.labelSmall.copyWith(
                color: unit.branch.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),

            // Personnel count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.people_outline_rounded,
                    size: 12,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${unit.personnelMin}-${unit.personnelMax}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Expand button
            if (hasChildren) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _toggleExpand(unit.id),
                child: AnimatedContainer(
                  duration: AppDurations.fast,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isExpanded
                        ? unit.branch.color.withValues(alpha: 0.2)
                        : AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isExpanded
                          ? unit.branch.color.withValues(alpha: 0.5)
                          : AppColors.border,
                    ),
                  ),
                  child: AnimatedRotation(
                    duration: AppDurations.fast,
                    turns: isExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: isExpanded ? unit.branch.color : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenRow(List<String> childIds, int level) {
    final children = childIds
        .map((id) => _getUnitById(id))
        .where((u) => u != null)
        .cast<MilitaryUnit>()
        .toList();

    if (children.isEmpty) return const SizedBox();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final unit = entry.value;
        final isExpanded = _expandedUnits.contains(unit.id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              _buildUnitNode(unit, level)
                  .animate(delay: Duration(milliseconds: index * 80))
                  .fadeIn()
                  .slideY(begin: -0.1, end: 0),
              if (isExpanded && unit.childIds.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildConnectorLine(),
                const SizedBox(height: 20),
                _buildChildrenRow(unit.childIds, level + 1),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConnectorLine() {
    return Container(
      width: 3,
      height: 24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.signalCorps.withValues(alpha: 0.5),
            AppColors.signalCorps.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String symbol;
  final String label;
  final Color color;

  const _LegendItem({
    required this.symbol,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              symbol,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.signalCorps,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitDetailSheet extends StatelessWidget {
  final MilitaryUnit unit;

  const _UnitDetailSheet({required this.unit});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
                color: unit.branch.color.withValues(alpha: 0.2),
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
                    // Header with gradient background
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingL),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            unit.branch.color.withValues(alpha: 0.15),
                            unit.branch.color.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                        border: Border.all(
                          color: unit.branch.color.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Large icon with glow
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  unit.branch.color.withValues(alpha: 0.3),
                                  unit.branch.color.withValues(alpha: 0.15),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: unit.branch.color.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Icon(
                              unit.branch.icon,
                              size: 36,
                              color: unit.branch.color,
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
                                        color: unit.branch.color,
                                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                      ),
                                      child: Text(
                                        unit.size.symbol,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      unit.size.thaiName,
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: unit.branch.color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  unit.nameThai,
                                  style: AppTextStyles.headlineMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${unit.name} (${unit.abbreviation})',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 24),

                    // Info cards in grid
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.people_rounded,
                            title: 'กำลังพล',
                            value: '${unit.personnelMin}-${unit.personnelMax}',
                            subtitle: 'นาย',
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.military_tech_rounded,
                            title: 'ผู้บังคับบัญชา',
                            value: unit.commanderRank,
                            subtitle: '',
                            color: AppColors.officer,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                    const SizedBox(height: 24),

                    // Description section
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
                        style: AppTextStyles.bodyLarge.copyWith(
                          height: 1.6,
                        ),
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
                                AppColors.success.withValues(alpha: 0.1),
                                AppColors.success.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppSizes.radiusM),
                            border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
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

                    // Equipment
                    if (unit.equipment.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'ยุทโธปกรณ์หลัก'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: unit.equipment.asMap().entries.map((entry) {
                          final index = entry.key;
                          final equip = entry.value;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  unit.branch.color.withValues(alpha: 0.15),
                                  unit.branch.color.withValues(alpha: 0.08),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                              border: Border.all(
                                color: unit.branch.color.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.settings_input_antenna_rounded,
                                  size: 14,
                                  color: unit.branch.color,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  equip,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          )
                              .animate(delay: Duration(milliseconds: 300 + (index * 30)))
                              .fadeIn()
                              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
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
  final String subtitle;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.labelSmall,
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    subtitle,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
