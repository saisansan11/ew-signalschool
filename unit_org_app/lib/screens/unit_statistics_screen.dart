import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/constants.dart';
import '../data/rta_signal_corps.dart';
import 'unit_detail_screen.dart';

class UnitStatisticsScreen extends StatefulWidget {
  const UnitStatisticsScreen({super.key});

  @override
  State<UnitStatisticsScreen> createState() => _UnitStatisticsScreenState();
}

class _UnitStatisticsScreenState extends State<UnitStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppColors.signalCorps,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.signalCorps,
                      AppColors.signalCorps.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.analytics_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'สถิติหน่วยทหารสื่อสาร',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'ภาพรวมการจัดหน่วย',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Overview Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewSection(),
                  const SizedBox(height: 24),
                  _buildUnitLevelSection(),
                  const SizedBox(height: 24),
                  _buildArmyAreaSection(),
                  const SizedBox(height: 24),
                  _buildProvinceDistribution(),
                  const SizedBox(height: 24),
                  _buildCommanderRankSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    final allUnits = RTASignalCorps.allCombinedUnits;
    final centralUnits = RTASignalCorps.centralUnits;
    final armyAreaUnits = RTASignalCorps.armyAreaUnits;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.dashboard_rounded,
          title: 'ภาพรวม',
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _OverviewCard(
                icon: Icons.account_tree_rounded,
                value: '${allUnits.length}',
                label: 'หน่วยทั้งหมด',
                color: AppColors.primary,
                bgColor: AppColors.bentoSky,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewCard(
                icon: Icons.location_city_rounded,
                value: '${centralUnits.length}',
                label: 'ส่วนกลาง',
                color: AppColors.signalCorps,
                bgColor: AppColors.bentoCream,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewCard(
                icon: Icons.map_rounded,
                value: '${armyAreaUnits.length}',
                label: 'ส่วนภูมิภาค',
                color: AppColors.accent,
                bgColor: AppColors.bentoMint,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildUnitLevelSection() {
    final levelCounts = <UnitLevel, int>{};
    for (final unit in RTASignalCorps.allCombinedUnits) {
      levelCounts[unit.level] = (levelCounts[unit.level] ?? 0) + 1;
    }

    // Sort by count descending
    final sortedLevels = levelCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = RTASignalCorps.allCombinedUnits.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.layers_rounded,
          title: 'จำนวนหน่วยตามระดับ',
          color: AppColors.accentPurple,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: sortedLevels.asMap().entries.map((entry) {
              final index = entry.key;
              final level = entry.value.key;
              final count = entry.value.value;
              final percentage = count / total;

              return Padding(
                padding: EdgeInsets.only(bottom: index < sortedLevels.length - 1 ? 16 : 0),
                child: _LevelBarItem(
                  level: level,
                  count: count,
                  percentage: percentage,
                  onTap: () => _showUnitsOfLevel(level),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildArmyAreaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.military_tech_rounded,
          title: 'หน่วยตามกองทัพภาค',
          color: AppColors.accentOrange,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            // Central units
            _ArmyAreaCard(
              title: 'ส่วนกลาง',
              subtitle: 'กรุงเทพฯ',
              battalionCount: RTASignalCorps.centralUnits.length,
              color: AppColors.signalCorps,
              icon: Icons.location_city_rounded,
              onTap: () => _showCentralUnits(),
            ),
            // Army Areas
            ...RTASignalCorps.armyAreaInfo.map((area) {
              final units = RTASignalCorps.getUnitsByArmyArea(area.id);
              return _ArmyAreaCard(
                title: area.abbreviation,
                subtitle: area.region,
                battalionCount: units.length,
                color: area.color,
                icon: Icons.shield_rounded,
                onTap: () => _showArmyAreaUnits(area),
              );
            }),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildProvinceDistribution() {
    // Count units by province
    final provinceCounts = <String, int>{};
    for (final unit in RTASignalCorps.allCombinedUnits) {
      final province = unit.location.province;
      provinceCounts[province] = (provinceCounts[province] ?? 0) + 1;
    }

    // Sort by count descending
    final sortedProvinces = provinceCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take top 8
    final topProvinces = sortedProvinces.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.location_on_rounded,
          title: 'การกระจายตามจังหวัด',
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              // Province chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: topProvinces.map((entry) {
                  return GestureDetector(
                    onTap: () => _showUnitsInProvince(entry.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${entry.value}',
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
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Text(
                    'หน่วยกระจายอยู่ใน ${provinceCounts.length} จังหวัด',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildCommanderRankSection() {
    // Count units by commander rank
    final rankCounts = <String, int>{};
    for (final unit in RTASignalCorps.allCombinedUnits) {
      rankCounts[unit.commanderRank] = (rankCounts[unit.commanderRank] ?? 0) + 1;
    }

    // Define rank order (higher to lower)
    final rankOrder = ['พลโท', 'พลตรี', 'พันเอก', 'พันโท', 'พันตรี', 'ร้อยเอก'];

    // Sort by rank order
    final sortedRanks = rankCounts.entries.toList()
      ..sort((a, b) {
        final aIndex = rankOrder.indexOf(a.key);
        final bIndex = rankOrder.indexOf(b.key);
        if (aIndex == -1 && bIndex == -1) return 0;
        if (aIndex == -1) return 1;
        if (bIndex == -1) return -1;
        return aIndex.compareTo(bIndex);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.stars_rounded,
          title: 'ผู้บังคับบัญชาตามยศ',
          color: AppColors.officer,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: sortedRanks.asMap().entries.map((entry) {
              final index = entry.key;
              final rank = entry.value.key;
              final count = entry.value.value;

              final colors = [
                AppColors.officer,
                const Color(0xFFCD7F32), // Bronze
                AppColors.accentOrange,
                AppColors.primary,
                AppColors.accent,
                AppColors.accentPurple,
              ];
              final color = colors[index % colors.length];

              return Padding(
                padding: EdgeInsets.only(bottom: index < sortedRanks.length - 1 ? 12 : 0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.military_tech,
                          size: 20,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rank,
                            style: AppTextStyles.titleSmall.copyWith(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getRankDescription(rank),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$count หน่วย',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.headlineSmall),
      ],
    );
  }

  String _getRankDescription(String rank) {
    switch (rank) {
      case 'พลโท':
        return 'ผบ.กรม หรือเทียบเท่า';
      case 'พลตรี':
        return 'ผบ.โรงเรียน หรือเทียบเท่า';
      case 'พันเอก':
        return 'ผบ.ศูนย์/กรม หรือเทียบเท่า';
      case 'พันโท':
        return 'ผบ.กองพัน/กอง';
      case 'พันตรี':
        return 'ผบ.กองร้อย หรือรอง ผบ.พัน';
      default:
        return 'ผู้บังคับหน่วย';
    }
  }

  void _showUnitsOfLevel(UnitLevel level) {
    final units = RTASignalCorps.getUnitsByLevel(level);
    _showUnitsBottomSheet('หน่วยระดับ${level.thaiName}', units);
  }

  void _showCentralUnits() {
    _showUnitsBottomSheet('หน่วยส่วนกลาง', RTASignalCorps.centralUnits);
  }

  void _showArmyAreaUnits(ArmyAreaInfo area) {
    final units = RTASignalCorps.getUnitsByArmyArea(area.id);
    _showUnitsBottomSheet('${area.abbreviation} - ${area.region}', units);
  }

  void _showUnitsInProvince(String province) {
    final units = RTASignalCorps.allCombinedUnits
        .where((u) => u.location.province == province)
        .toList();
    _showUnitsBottomSheet('หน่วยใน จ.$province', units);
  }

  void _showUnitsBottomSheet(String title, List<SignalUnit> units) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _UnitsListSheet(
        title: title,
        units: units,
        onUnitTap: (unit) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UnitDetailScreen(unit: unit)),
          );
        },
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color bgColor;

  const _OverviewCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LevelBarItem extends StatelessWidget {
  final UnitLevel level;
  final int count;
  final double percentage;
  final VoidCallback onTap;

  const _LevelBarItem({
    required this.level,
    required this.count,
    required this.percentage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getLevelColor(level);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                level.symbol,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      level.thaiName,
                      style: AppTextStyles.titleSmall,
                    ),
                    Text(
                      '$count หน่วย',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(UnitLevel level) {
    switch (level) {
      case UnitLevel.department:
        return AppColors.officer;
      case UnitLevel.center:
        return AppColors.accentPurple;
      case UnitLevel.school:
        return AppColors.accentOrange;
      case UnitLevel.factory:
        return const Color(0xFF795548);
      case UnitLevel.battalion:
        return AppColors.primary;
      case UnitLevel.company:
        return AppColors.accent;
      case UnitLevel.platoon:
        return AppColors.accentIndigo;
      case UnitLevel.squad:
        return AppColors.textMuted;
    }
  }
}

class _ArmyAreaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int battalionCount;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ArmyAreaCard({
    required this.title,
    required this.subtitle,
    required this.battalionCount,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 16,
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$battalionCount หน่วย',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitsListSheet extends StatelessWidget {
  final String title;
  final List<SignalUnit> units;
  final Function(SignalUnit) onUnitTap;

  const _UnitsListSheet({
    required this.title,
    required this.units,
    required this.onUnitTap,
  });

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
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.signalCorps.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                      child: const Icon(
                        Icons.list_alt_rounded,
                        color: AppColors.signalCorps,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.titleLarge,
                          ),
                          Text(
                            '${units.length} หน่วย',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: units.length,
                  itemBuilder: (context, index) {
                    final unit = units[index];
                    return _buildUnitItem(unit);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnitItem(SignalUnit unit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onUnitTap(unit),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: unit.color.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: unit.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      unit.level.symbol,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            unit.abbreviation,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: unit.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              unit.level.thaiName,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        unit.name,
                        style: AppTextStyles.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            unit.location.province,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: unit.color.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
