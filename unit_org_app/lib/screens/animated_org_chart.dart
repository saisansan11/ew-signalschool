import 'package:flutter/material.dart';
import '../app/constants.dart';
import '../data/rta_signal_corps.dart';

class AnimatedOrgChartScreen extends StatefulWidget {
  const AnimatedOrgChartScreen({super.key});

  @override
  State<AnimatedOrgChartScreen> createState() => _AnimatedOrgChartScreenState();
}

class _AnimatedOrgChartScreenState extends State<AnimatedOrgChartScreen>
    with TickerProviderStateMixin {
  SignalUnit? _selectedUnit;
  final Set<String> _expandedUnits = {'signal_dept'};
  final Map<String, AnimationController> _expandControllers = {};

  late AnimationController _entryController;
  late Animation<double> _entryAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _entryAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutBack,
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    for (final controller in _expandControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  AnimationController _getExpandController(String unitId) {
    if (!_expandControllers.containsKey(unitId)) {
      _expandControllers[unitId] = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      if (_expandedUnits.contains(unitId)) {
        _expandControllers[unitId]!.value = 1.0;
      }
    }
    return _expandControllers[unitId]!;
  }

  void _toggleExpand(String unitId) {
    final controller = _getExpandController(unitId);
    setState(() {
      if (_expandedUnits.contains(unitId)) {
        _expandedUnits.remove(unitId);
        controller.reverse();
      } else {
        _expandedUnits.add(unitId);
        controller.forward();
      }
    });
  }

  void _selectUnit(SignalUnit unit) {
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
      builder: (context) => _UnitDetailSheet(unit: unit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            const Text('ผังการจัดหน่วย สส.', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.unfold_more),
            onPressed: _expandAll,
            tooltip: 'ขยายทั้งหมด',
          ),
          IconButton(
            icon: const Icon(Icons.unfold_less),
            onPressed: _collapseAll,
            tooltip: 'ยุบทั้งหมด',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _entryAnimation,
        builder: (context, child) {
          final animValue = _entryAnimation.value.clamp(0.0, 1.0);
          return Opacity(
            opacity: animValue,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - animValue)),
              child: _buildContent(),
            ),
          );
        },
      ),
    );
  }

  void _expandAll() {
    final allIds = RTASignalCorps.allUnits
        .where((u) => u.childUnitIds.isNotEmpty)
        .map((u) => u.id)
        .toSet();

    setState(() {
      _expandedUnits.addAll(allIds);
    });

    for (final id in allIds) {
      _getExpandController(id).forward();
    }
  }

  void _collapseAll() {
    setState(() {
      _expandedUnits.clear();
      _expandedUnits.add('signal_dept');
    });

    for (final controller in _expandControllers.values) {
      controller.reverse();
    }
    _getExpandController('signal_dept').forward();
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chain of command header
          _buildChainOfCommand(),
          const SizedBox(height: 24),

          // Section: หน่วยขึ้นตรง กรมการทหารสื่อสาร
          _buildSectionHeader('หน่วยขึ้นตรง กรมการทหารสื่อสาร', AppColors.signalCorps, Icons.account_tree),
          const SizedBox(height: 16),

          // Root unit: กรมการทหารสื่อสาร
          _buildRootUnit(),
          const SizedBox(height: 16),

          // Direct subordinate units in a structured grid
          _buildDirectSubordinateUnits(),
          const SizedBox(height: 32),

          // Section: หน่วยสื่อสารประจำกองทัพภาค
          _buildSectionHeader('หน่วยสื่อสารประจำกองทัพภาค', AppColors.primary, Icons.map),
          const SizedBox(height: 16),

          // Army Area units grouped by region
          _buildArmyAreaSection(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildChainOfCommand() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.accent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'สายการบังคับบัญชา',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _commandBox('กองทัพบก', 'ทบ.', AppColors.error),
                _commandArrow(),
                _commandBox('กรมการทหารสื่อสาร', 'สส.', AppColors.signalCorps),
                _commandArrow(),
                _commandBox('หน่วยขึ้นตรง', 'นขต.สส.', AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _commandBox(String name, String abbr, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            abbr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _commandArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        Icons.arrow_forward,
        size: 20,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _buildRootUnit() {
    final rootUnit = RTASignalCorps.rootUnit;
    final isSelected = _selectedUnit?.id == rootUnit.id;

    return Center(
      child: GestureDetector(
        onTap: () => _selectUnit(rootUnit),
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                rootUnit.color.withOpacity(0.3),
                rootUnit.color.withOpacity(0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(
              color: rootUnit.color,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: rootUnit.color.withOpacity(0.3),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: rootUnit.color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  rootUnit.level.symbol,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: rootUnit.color, width: 2),
                ),
                child: Icon(
                  Icons.cell_tower,
                  size: 32,
                  color: rootUnit.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                rootUnit.name,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                rootUnit.abbreviation,
                style: TextStyle(
                  fontSize: 16,
                  color: rootUnit.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.military_tech, size: 16, color: AppColors.officer),
                  const SizedBox(width: 4),
                  Text(
                    rootUnit.commanderRank,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.location_on, size: 16, color: AppColors.error),
                  const SizedBox(width: 4),
                  Text(
                    rootUnit.location.province,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectSubordinateUnits() {
    // Get direct children of signal_dept
    final directChildren = RTASignalCorps.rootUnit.childUnitIds
        .map((id) => RTASignalCorps.getUnitById(id))
        .where((u) => u != null)
        .cast<SignalUnit>()
        .toList();

    return Column(
      children: [
        // Connector from root
        Center(
          child: Container(
            width: 3,
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.signalCorps,
                  AppColors.signalCorps.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Grid of subordinate units
        ...directChildren.map((unit) => _buildUnitCard(unit)),
      ],
    );
  }

  Widget _buildUnitCard(SignalUnit unit) {
    final isExpanded = _expandedUnits.contains(unit.id);
    final hasChildren = unit.childUnitIds.isNotEmpty;
    final controller = _getExpandController(unit.id);
    final isSelected = _selectedUnit?.id == unit.id;

    // Get children
    final children = unit.childUnitIds
        .map((id) => RTASignalCorps.getUnitById(id))
        .where((u) => u != null)
        .cast<SignalUnit>()
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Main unit card
          GestureDetector(
            onTap: () => _selectUnit(unit),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(
                  color: isSelected ? unit.color : unit.color.withOpacity(0.5),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: unit.color.withOpacity(0.2),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  // Header row
                  Row(
                    children: [
                      // Level symbol
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: unit.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          unit.level.symbol,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: unit.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Icon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: unit.color.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getUnitIcon(unit),
                          size: 24,
                          color: unit.color,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name & info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              unit.name,
                              style: AppTextStyles.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  unit.abbreviation,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: unit.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.textMuted,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  unit.commanderRank,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Expand button
                      if (hasChildren)
                        GestureDetector(
                          onTap: () => _toggleExpand(unit.id),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: unit.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${children.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: unit.color,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                AnimatedRotation(
                                  turns: isExpanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20,
                                    color: unit.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Children section (expanded)
                  if (hasChildren)
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return ClipRect(
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: controller.value,
                            child: Opacity(
                              opacity: controller.value,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            height: 1,
                            color: unit.color.withOpacity(0.2),
                          ),
                          const SizedBox(height: 12),
                          // Sub-units header
                          Row(
                            children: [
                              Icon(Icons.subdirectory_arrow_right, size: 16, color: unit.color),
                              const SizedBox(width: 8),
                              Text(
                                'หน่วยรอง (${children.length} หน่วย)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: unit.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Children list
                          ...children.map((child) => _buildSubUnitItem(child, unit.color)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubUnitItem(SignalUnit unit, Color parentColor) {
    return GestureDetector(
      onTap: () => _selectUnit(unit),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: parentColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: parentColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            // Connector line
            Container(
              width: 20,
              height: 2,
              color: parentColor.withOpacity(0.3),
            ),
            const SizedBox(width: 8),

            // Level symbol
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: parentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                unit.level.symbol,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: parentColor,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Icon
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: parentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getUnitIcon(unit),
                size: 14,
                color: parentColor,
              ),
            ),
            const SizedBox(width: 10),

            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${unit.abbreviation} • ${unit.commanderRank}',
                    style: TextStyle(
                      fontSize: 11,
                      color: parentColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              size: 18,
              color: parentColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getUnitIcon(SignalUnit unit) {
    if (unit.level == UnitLevel.school) return Icons.school;
    if (unit.level == UnitLevel.factory) return Icons.factory;
    if (unit.level == UnitLevel.center) {
      if (unit.id.contains('ew')) return Icons.radar;
      return Icons.hub;
    }
    if (unit.level == UnitLevel.battalion) return Icons.groups;
    if (unit.level == UnitLevel.company) return Icons.group;
    return Icons.cell_tower;
  }

  Widget _buildArmyAreaSection() {
    return Column(
      children: [
        // Group by army area
        ...RTASignalCorps.armyAreaInfo.map((area) {
          final battalions = RTASignalCorps.getUnitsByArmyArea(area.id);
          return _buildArmyAreaGroup(area, battalions);
        }),
      ],
    );
  }

  Widget _buildArmyAreaGroup(ArmyAreaInfo area, List<SignalUnit> battalions) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: area.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: area.color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusL - 1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: area.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: area.color, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '${area.id}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: area.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        area.name,
                        style: AppTextStyles.titleMedium.copyWith(color: area.color),
                      ),
                      Text(
                        '${area.region} • ${area.headquarters}',
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: area.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${battalions.length} กองพัน',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Battalions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: battalions.map((bn) => _buildBattalionChip(bn, area.color)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattalionChip(SignalUnit unit, Color color) {
    return GestureDetector(
      onTap: () => _selectUnit(unit),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups,
                size: 14,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  unit.abbreviation,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  unit.location.province,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: color.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitDetailSheet extends StatelessWidget {
  final SignalUnit unit;

  const _UnitDetailSheet({required this.unit});

  @override
  Widget build(BuildContext context) {
    // Get sub-units if any
    final subUnits = unit.childUnitIds
        .map((id) => RTASignalCorps.getUnitById(id))
        .where((u) => u != null)
        .cast<SignalUnit>()
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: unit.color, width: 3),
            ),
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
                  children: [
                    // Header
                    Row(
                      children: [
                        Hero(
                          tag: 'unit_icon_${unit.id}',
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  unit.color.withOpacity(0.3),
                                  unit.color.withOpacity(0.1),
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: unit.color, width: 2),
                            ),
                            child: Icon(
                              Icons.cell_tower,
                              size: 36,
                              color: unit.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: unit.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${unit.level.symbol} ${unit.level.thaiName}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: unit.color,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(unit.name, style: AppTextStyles.headlineMedium),
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
                    const SizedBox(height: 24),

                    // Info cards
                    _InfoCard(
                      icon: Icons.location_on,
                      title: 'ที่ตั้ง',
                      value: unit.location.fullAddress,
                      color: unit.color,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.military_tech,
                      title: 'ผู้บังคับบัญชา',
                      value: unit.commanderRank,
                      color: AppColors.officer,
                    ),
                    if (unit.personnelMin != null) ...[
                      const SizedBox(height: 12),
                      _InfoCard(
                        icon: Icons.people,
                        title: 'กำลังพล',
                        value: unit.personnelRange,
                        color: AppColors.primary,
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Description
                    const Text('รายละเอียด', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 8),
                    Text(unit.description, style: AppTextStyles.bodyLarge),

                    // Missions
                    if (unit.missions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text('ภารกิจ', style: AppTextStyles.titleLarge),
                      const SizedBox(height: 8),
                      ...unit.missions.map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 18,
                                color: unit.color,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(m, style: AppTextStyles.bodyMedium),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Sub-units section
                    if (subUnits.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Text('หน่วยรอง', style: AppTextStyles.titleLarge),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: unit.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${subUnits.length} หน่วย',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: unit.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...subUnits.map((sub) => _buildSubUnitCard(sub, unit.color)),
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

  Widget _buildSubUnitCard(SignalUnit sub, Color parentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: parentColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: parentColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: parentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                sub.level.symbol,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: parentColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.name,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 14),
                ),
                Text(
                  '${sub.abbreviation} • ${sub.commanderRank}',
                  style: TextStyle(
                    fontSize: 12,
                    color: parentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelSmall,
                ),
                Text(
                  value,
                  style: AppTextStyles.titleMedium.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
