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
  final Set<String> _expandedUnits = {'signal_dept'};
  final Map<String, AnimationController> _expandControllers = {};

  late AnimationController _entryController;
  late Animation<double> _entryAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _entryAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
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
        duration: const Duration(milliseconds: 250),
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

  void _showUnitDetail(SignalUnit unit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _UnitDetailSheet(unit: unit),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('ผังการจัดหน่วย สส.', style: AppTextStyles.titleLarge),
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
          return Opacity(
            opacity: _entryAnimation.value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - _entryAnimation.value)),
              child: _buildContent(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: หน่วยขึ้นตรง สส.
          _buildSectionCard(
            title: 'หน่วยขึ้นตรง กรมการทหารสื่อสาร',
            subtitle: 'นขต.สส.',
            icon: Icons.account_tree,
            color: AppColors.signalCorps,
            child: _buildCentralUnitsTree(),
          ),
          const SizedBox(height: 20),

          // Section: หน่วยสื่อสารประจำ ทภ.
          _buildSectionCard(
            title: 'หน่วยสื่อสารประจำกองทัพภาค',
            subtitle: 'ส.พัน. ขึ้นตรง ทภ.',
            icon: Icons.map,
            color: AppColors.primary,
            child: _buildArmyAreaSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleMedium.copyWith(color: color),
                      ),
                      Text(
                        subtitle,
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildCentralUnitsTree() {
    final rootUnit = RTASignalCorps.rootUnit;
    return Column(
      children: [
        // Root unit card
        _buildRootUnitRow(rootUnit),
        // Children tree
        _buildTreeNodeChildren(rootUnit, 0),
      ],
    );
  }

  Widget _buildRootUnitRow(SignalUnit unit) {
    final hasChildren = unit.childUnitIds.isNotEmpty;
    final isExpanded = _expandedUnits.contains(unit.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showUnitDetail(unit),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  unit.color.withValues(alpha: 0.2),
                  unit.color.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: unit.color.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                // Expand/collapse button
                if (hasChildren)
                  GestureDetector(
                    onTap: () => _toggleExpand(unit.id),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: unit.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AnimatedRotation(
                        turns: isExpanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.chevron_right,
                          color: unit.color,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 32),
                const SizedBox(width: 12),
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: unit.color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: unit.color, width: 2),
                  ),
                  child: Icon(Icons.cell_tower, color: unit.color, size: 24),
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
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: unit.color,
                              borderRadius: BorderRadius.circular(4),
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
                            unit.abbreviation,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: unit.color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        unit.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.military_tech, size: 12, color: AppColors.officer),
                          const SizedBox(width: 4),
                          Text(
                            unit.commanderRank,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.location_on, size: 12, color: AppColors.error),
                          const SizedBox(width: 4),
                          Text(
                            unit.location.province,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Child count badge
                if (hasChildren)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: unit.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${unit.childUnitIds.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: unit.color,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTreeNodeChildren(SignalUnit parentUnit, int depth) {
    final controller = _getExpandController(parentUnit.id);
    final children = parentUnit.childUnitIds
        .map((id) => RTASignalCorps.getUnitById(id))
        .where((u) => u != null)
        .cast<SignalUnit>()
        .toList();

    if (children.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
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
      child: Padding(
        padding: EdgeInsets.only(left: 20.0 + (depth * 8)),
        child: Column(
          children: children.asMap().entries.map((entry) {
            final index = entry.key;
            final unit = entry.value;
            final isLast = index == children.length - 1;
            return _buildTreeNode(unit, depth + 1, isLast, parentUnit.color);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTreeNode(SignalUnit unit, int depth, bool isLast, Color parentColor) {
    final hasChildren = unit.childUnitIds.isNotEmpty;
    final isExpanded = _expandedUnits.contains(unit.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tree line + Node
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tree connector
              SizedBox(
                width: 24,
                child: CustomPaint(
                  painter: _TreeLinePainter(
                    color: parentColor.withValues(alpha: 0.4),
                    isLast: isLast,
                  ),
                ),
              ),
              // Node content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: _buildNodeRow(unit, hasChildren, isExpanded),
                ),
              ),
            ],
          ),
        ),
        // Children
        if (hasChildren)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: _buildTreeNodeChildren(unit, depth),
          ),
      ],
    );
  }

  Widget _buildNodeRow(SignalUnit unit, bool hasChildren, bool isExpanded) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showUnitDetail(unit),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: unit.color.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: unit.color.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Expand button
              if (hasChildren)
                GestureDetector(
                  onTap: () => _toggleExpand(unit.id),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: unit.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.chevron_right,
                        color: unit.color,
                        size: 16,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 26,
                  child: Icon(
                    _getUnitIcon(unit),
                    color: unit.color.withValues(alpha: 0.6),
                    size: 18,
                  ),
                ),
              const SizedBox(width: 10),
              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: unit.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  unit.level.symbol,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: unit.color,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          unit.abbreviation,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: unit.color,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.military_tech, size: 10, color: AppColors.officer),
                        const SizedBox(width: 2),
                        Text(
                          unit.commanderRank,
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Child count
              if (hasChildren)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: unit.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${unit.childUnitIds.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: unit.color,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getUnitIcon(SignalUnit unit) {
    switch (unit.level) {
      case UnitLevel.school:
        return Icons.school;
      case UnitLevel.factory:
        return Icons.precision_manufacturing;
      case UnitLevel.center:
        return unit.id.contains('ew') ? Icons.radar : Icons.hub;
      case UnitLevel.battalion:
        return Icons.groups;
      case UnitLevel.company:
        return Icons.group;
      default:
        return Icons.radio;
    }
  }

  Widget _buildArmyAreaSection() {
    return Column(
      children: RTASignalCorps.armyAreaInfo.map((area) {
        final battalions = RTASignalCorps.getUnitsByArmyArea(area.id);
        return _buildArmyAreaCard(area, battalions);
      }).toList(),
    );
  }

  Widget _buildArmyAreaCard(ArmyAreaInfo area, List<SignalUnit> battalions) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: area.color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: area.color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: area.color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: area.color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: area.color, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '${area.id}',
                      style: TextStyle(
                        fontSize: 16,
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
                        area.abbreviation,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: area.color,
                        ),
                      ),
                      Text(
                        area.region,
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: area.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${battalions.length} กองพัน',
                    style: const TextStyle(
                      fontSize: 11,
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
            padding: const EdgeInsets.all(10),
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
      onTap: () => _showUnitDetail(unit),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.groups, size: 16, color: color),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  unit.abbreviation,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  unit.location.province,
                  style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tree line painter for connecting parent to children
class _TreeLinePainter extends CustomPainter {
  final Color color;
  final bool isLast;

  _TreeLinePainter({required this.color, required this.isLast});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Vertical line from top
    if (!isLast) {
      canvas.drawLine(
        Offset(10, 0),
        Offset(10, size.height),
        paint,
      );
    } else {
      canvas.drawLine(
        Offset(10, 0),
        Offset(10, size.height / 2),
        paint,
      );
    }

    // Horizontal line to node
    canvas.drawLine(
      Offset(10, size.height / 2),
      Offset(24, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _TreeLinePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isLast != isLast;
  }
}

/// Unit detail bottom sheet
class _UnitDetailSheet extends StatelessWidget {
  final SignalUnit unit;

  const _UnitDetailSheet({required this.unit});

  @override
  Widget build(BuildContext context) {
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
            border: Border(top: BorderSide(color: unit.color, width: 3)),
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
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                unit.color.withValues(alpha: 0.3),
                                unit.color.withValues(alpha: 0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: unit.color, width: 2),
                          ),
                          child: Icon(Icons.cell_tower, size: 30, color: unit.color),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: unit.color.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${unit.level.symbol} ${unit.level.thaiName}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: unit.color,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(unit.name, style: AppTextStyles.headlineMedium),
                              Text(
                                '${unit.nameEn} (${unit.abbreviation})',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
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
                    const SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.military_tech,
                      title: 'ผู้บังคับบัญชา',
                      value: unit.commanderRank,
                      color: AppColors.officer,
                    ),
                    if (unit.personnelMin != null) ...[
                      const SizedBox(height: 10),
                      _InfoCard(
                        icon: Icons.people,
                        title: 'กำลังพล',
                        value: unit.personnelRange,
                        color: AppColors.primary,
                      ),
                    ],
                    const SizedBox(height: 20),

                    // Description
                    const Text('รายละเอียด', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 8),
                    Text(unit.description, style: AppTextStyles.bodyLarge),

                    // Missions
                    if (unit.missions.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text('ภารกิจ', style: AppTextStyles.titleLarge),
                      const SizedBox(height: 8),
                      ...unit.missions.map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle, size: 16, color: unit.color),
                              const SizedBox(width: 8),
                              Expanded(child: Text(m, style: AppTextStyles.bodyMedium)),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Sub-units
                    if (subUnits.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text('หน่วยรอง', style: AppTextStyles.titleLarge),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: unit.color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${subUnits.length} หน่วย',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: unit.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...subUnits.map((sub) => _SubUnitCard(unit: sub, parentColor: unit.color)),
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

class _SubUnitCard extends StatelessWidget {
  final SignalUnit unit;
  final Color parentColor;

  const _SubUnitCard({required this.unit, required this.parentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: parentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: parentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: parentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                unit.level.symbol,
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
                  unit.name,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 13),
                ),
                Text(
                  '${unit.abbreviation} • ${unit.commanderRank}',
                  style: TextStyle(fontSize: 11, color: parentColor),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelSmall),
                Text(
                  value,
                  style: AppTextStyles.titleMedium.copyWith(color: color, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
