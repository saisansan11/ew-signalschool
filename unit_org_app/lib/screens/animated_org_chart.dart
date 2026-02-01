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
          // Clamp value because easeOutBack curve can overshoot beyond 0.0-1.0
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
      _expandedUnits.add('signal_dept'); // Keep root expanded
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
        children: [
          // Chain of command header
          _buildChainOfCommand(),
          const SizedBox(height: 24),

          // Org chart
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildOrgTree(RTASignalCorps.rootUnit, 0),
          ),

          const SizedBox(height: 32),

          // Army Area units
          _buildArmyAreaSection(),
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
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'สายการบังคับบัญชา',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _commandBox('กองทัพบก', 'ทบ.', AppColors.error),
              _commandArrow(),
              _commandBox('กรมการทหารสื่อสาร', 'กส.', AppColors.signalCorps),
              _commandArrow(),
              _commandBox('หน่วยขึ้นตรง', 'นขต.กส.', AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _commandBox(String name, String abbr, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
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

  Widget _buildOrgTree(SignalUnit unit, int depth) {
    final isExpanded = _expandedUnits.contains(unit.id);
    final hasChildren = unit.childUnitIds.isNotEmpty;
    final controller = _getExpandController(unit.id);

    return Column(
      children: [
        // Unit node
        _buildAnimatedNode(unit, depth),

        // Children
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
                // Connector line
                Container(
                  width: 2,
                  height: 20,
                  color: unit.color.withValues(alpha: 0.5),
                ),
                // Children row
                _buildChildrenRow(unit),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedNode(SignalUnit unit, int depth) {
    final isSelected = _selectedUnit?.id == unit.id;
    final hasChildren = unit.childUnitIds.isNotEmpty;
    final isExpanded = _expandedUnits.contains(unit.id);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (depth * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _selectUnit(unit),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: isSelected
                ? unit.color.withValues(alpha: 0.2)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(
              color: isSelected ? unit.color : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: unit.color.withValues(alpha: 0.3),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Level symbol
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: unit.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  unit.level.symbol,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: unit.color,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: unit.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cell_tower,
                  size: 24,
                  color: unit.color,
                ),
              ),
              const SizedBox(height: 8),

              // Name
              Text(
                unit.name,
                style: AppTextStyles.titleMedium.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Abbreviation
              Text(
                unit.abbreviation,
                style: TextStyle(
                  fontSize: 11,
                  color: unit.color,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Commander rank
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.military_tech,
                    size: 12,
                    color: AppColors.officer,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit.commanderRank,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),

              // Expand/collapse button
              if (hasChildren) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _toggleExpand(unit.id),
                  child: AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: unit.color,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildrenRow(SignalUnit parent) {
    final children = parent.childUnitIds
        .map((id) => RTASignalCorps.getUnitById(id))
        .where((u) => u != null)
        .cast<SignalUnit>()
        .toList();

    if (children.isEmpty) return const SizedBox();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final unit = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 0 : 8,
            right: index == children.length - 1 ? 0 : 8,
          ),
          child: _buildOrgTree(unit, 1),
        );
      }).toList(),
    );
  }

  Widget _buildArmyAreaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'หน่วยสื่อสารประจำกองทัพภาค',
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: RTASignalCorps.armyAreaUnits
              .map((unit) => _buildArmyAreaCard(unit))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildArmyAreaCard(SignalUnit unit) {
    return GestureDetector(
      onTap: () => _selectUnit(unit),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: unit.color.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: unit.color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${unit.armyArea}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: unit.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    unit.abbreviation,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: unit.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              unit.location.province,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
            ),
            Text(
              unit.location.name,
              style: AppTextStyles.labelSmall,
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
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: unit.color.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: unit.color, width: 2),
                            ),
                            child: Icon(
                              Icons.cell_tower,
                              size: 30,
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
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: unit.color.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  unit.level.thaiName,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: unit.color,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(unit.name,
                                  style: AppTextStyles.headlineMedium),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
