import 'package:flutter/material.dart';
import '../app/constants.dart';
import '../models/unit_models.dart';
import '../data/signal_corps_data.dart';

class OrgChartScreen extends StatefulWidget {
  const OrgChartScreen({super.key});

  @override
  State<OrgChartScreen> createState() => _OrgChartScreenState();
}

class _OrgChartScreenState extends State<OrgChartScreen> {
  MilitaryUnit? _selectedUnit;
  final Set<String> _expandedUnits = {'signal_bn'};
  final TransformationController _transformController =
      TransformationController();

  @override
  void dispose() {
    _transformController.dispose();
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
    setState(() {
      if (_expandedUnits.contains(unitId)) {
        _expandedUnits.remove(unitId);
      } else {
        _expandedUnits.add(unitId);
      }
    });
  }

  void _selectUnit(MilitaryUnit unit) {
    setState(() {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('โครงสร้างหน่วย', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out_map),
            onPressed: () {
              _transformController.value = Matrix4.identity();
            },
            tooltip: 'รีเซ็ตมุมมอง',
          ),
        ],
      ),
      body: Column(
        children: [
          // Legend
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingS,
            ),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _LegendItem(
                    symbol: '●',
                    label: 'หมู่',
                    color: AppColors.textMuted,
                  ),
                  _LegendItem(
                    symbol: '●●',
                    label: 'หมวด',
                    color: AppColors.textMuted,
                  ),
                  _LegendItem(
                    symbol: '|',
                    label: 'ร้อย',
                    color: AppColors.textMuted,
                  ),
                  _LegendItem(
                    symbol: '||',
                    label: 'พัน',
                    color: AppColors.textMuted,
                  ),
                  _LegendItem(
                    symbol: '|||',
                    label: 'กรม',
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Org Chart
          Expanded(
            child: InteractiveViewer(
              transformationController: _transformController,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.5,
              maxScale: 2.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    child: _buildOrgTree(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrgTree() {
    // Start from battalion level for Signal Corps
    final battalion = _getUnitById('signal_bn');
    if (battalion == null) return const SizedBox();

    return Column(
      children: [
        // Battalion node
        _buildUnitNode(battalion),
        if (_expandedUnits.contains(battalion.id)) ...[
          const SizedBox(height: 16),
          _buildConnectorLine(),
          const SizedBox(height: 16),
          // Companies row
          _buildChildrenRow(battalion.childIds),
        ],
      ],
    );
  }

  Widget _buildUnitNode(MilitaryUnit unit) {
    final isSelected = _selectedUnit?.id == unit.id;
    final isExpanded = _expandedUnits.contains(unit.id);
    final hasChildren = unit.childIds.isNotEmpty;

    return GestureDetector(
      onTap: () => _selectUnit(unit),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        width: 140,
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: isSelected
              ? unit.branch.color.withOpacity(0.2)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: isSelected ? unit.branch.color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: unit.branch.color.withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Unit size symbol
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: unit.branch.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                unit.size.symbol,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: unit.branch.color,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: unit.branch.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                unit.branch.icon,
                size: 22,
                color: unit.branch.color,
              ),
            ),
            const SizedBox(height: 8),

            // Name
            Text(
              unit.nameThai,
              style: AppTextStyles.titleMedium.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Abbreviation
            Text(
              unit.abbreviation,
              style: AppTextStyles.labelSmall.copyWith(
                color: unit.branch.color,
                fontSize: 10,
              ),
            ),

            // Personnel
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.people_outline,
                  size: 12,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 2),
                Text(
                  '${unit.personnelMin}-${unit.personnelMax}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),

            // Expand button
            if (hasChildren) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _toggleExpand(unit.id),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenRow(List<String> childIds) {
    final children = childIds
        .map((id) => _getUnitById(id))
        .where((u) => u != null)
        .cast<MilitaryUnit>()
        .toList();

    if (children.isEmpty) return const SizedBox();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((unit) {
        final isExpanded = _expandedUnits.contains(unit.id);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              _buildUnitNode(unit),
              if (isExpanded && unit.childIds.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildConnectorLine(),
                const SizedBox(height: 16),
                _buildChildrenRow(unit.childIds),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConnectorLine() {
    return Container(
      width: 2,
      height: 20,
      color: AppColors.border,
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
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              symbol,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
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
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: unit.branch.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            unit.branch.icon,
                            size: 30,
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
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: unit.branch.color
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      unit.size.symbol,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: unit.branch.color,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    unit.size.thaiName,
                                    style: AppTextStyles.labelSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                unit.nameThai,
                                style: AppTextStyles.headlineMedium,
                              ),
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
                    const SizedBox(height: 24),

                    // Info cards
                    _InfoCard(
                      icon: Icons.people,
                      title: 'กำลังพล',
                      value: '${unit.personnelMin} - ${unit.personnelMax} นาย',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.military_tech,
                      title: 'ผู้บังคับบัญชา',
                      value: unit.commanderRank,
                      color: AppColors.officer,
                    ),
                    const SizedBox(height: 24),

                    // Description
                    const Text('รายละเอียด', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      unit.description,
                      style: AppTextStyles.bodyLarge,
                    ),

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
                              const Icon(
                                Icons.check_circle,
                                size: 18,
                                color: AppColors.success,
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

                    // Equipment
                    if (unit.equipment.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text('ยุทโธปกรณ์หลัก',
                          style: AppTextStyles.titleLarge),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: unit.equipment.map((e) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusFull,
                              ),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              e,
                              style: AppTextStyles.bodyMedium,
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
          Column(
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
        ],
      ),
    );
  }
}
