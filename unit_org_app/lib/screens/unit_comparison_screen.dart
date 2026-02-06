import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/constants.dart';
import '../data/rta_signal_corps.dart';
import 'unit_detail_screen.dart';

class UnitComparisonScreen extends StatefulWidget {
  final SignalUnit? initialUnit1;
  final SignalUnit? initialUnit2;

  const UnitComparisonScreen({
    super.key,
    this.initialUnit1,
    this.initialUnit2,
  });

  @override
  State<UnitComparisonScreen> createState() => _UnitComparisonScreenState();
}

class _UnitComparisonScreenState extends State<UnitComparisonScreen> {
  SignalUnit? _unit1;
  SignalUnit? _unit2;

  @override
  void initState() {
    super.initState();
    _unit1 = widget.initialUnit1;
    _unit2 = widget.initialUnit2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'เปรียบเทียบหน่วย',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_unit1 != null && _unit2 != null)
            IconButton(
              icon: const Icon(Icons.swap_horiz, color: AppColors.primary),
              onPressed: _swapUnits,
              tooltip: 'สลับหน่วย',
            ),
        ],
      ),
      body: Column(
        children: [
          // Unit selection row
          _buildUnitSelectionRow(),
          const Divider(height: 1),
          // Comparison content
          Expanded(
            child: _unit1 != null && _unit2 != null
                ? _buildComparisonContent()
                : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSelectionRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(child: _buildUnitSelector(1, _unit1)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.compare_arrows,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
          Expanded(child: _buildUnitSelector(2, _unit2)),
        ],
      ),
    );
  }

  Widget _buildUnitSelector(int slot, SignalUnit? unit) {
    return GestureDetector(
      onTap: () => _selectUnit(slot),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: unit != null
              ? unit.color.withOpacity(0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: unit != null
                ? unit.color.withOpacity(0.3)
                : AppColors.border,
          ),
        ),
        child: unit != null
            ? Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: unit.color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        unit.level.symbol,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: unit.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          unit.abbreviation,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: unit.color,
                          ),
                        ),
                        Text(
                          unit.location.province,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _clearUnit(slot),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: AppColors.textMuted,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'เลือกหน่วยที่ $slot',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.compare_arrows_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'เปรียบเทียบหน่วยทหารสื่อสาร',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'เลือกหน่วย 2 หน่วยเพื่อเปรียบเทียบข้อมูล\nเช่น ที่ตั้ง ระดับ ผู้บังคับบัญชา และภารกิจ',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _selectUnit(_unit1 == null ? 1 : 2),
              icon: const Icon(Icons.add),
              label: Text(_unit1 == null ? 'เลือกหน่วยแรก' : 'เลือกหน่วยที่ 2'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildComparisonContent() {
    if (_unit1 == null || _unit2 == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildComparisonSection(
            title: 'ข้อมูลทั่วไป',
            icon: Icons.info_outline,
            rows: [
              _ComparisonRow(
                label: 'ชื่อหน่วย',
                value1: _unit1!.name,
                value2: _unit2!.name,
              ),
              _ComparisonRow(
                label: 'ชื่อย่อ',
                value1: _unit1!.abbreviation,
                value2: _unit2!.abbreviation,
                color1: _unit1!.color,
                color2: _unit2!.color,
              ),
              _ComparisonRow(
                label: 'ระดับหน่วย',
                value1: _unit1!.level.thaiName,
                value2: _unit2!.level.thaiName,
                isDifferent: _unit1!.level != _unit2!.level,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildComparisonSection(
            title: 'ที่ตั้ง',
            icon: Icons.location_on,
            rows: [
              _ComparisonRow(
                label: 'ที่ตั้ง',
                value1: _unit1!.location.name,
                value2: _unit2!.location.name,
              ),
              _ComparisonRow(
                label: 'จังหวัด',
                value1: _unit1!.location.province,
                value2: _unit2!.location.province,
                isDifferent: _unit1!.location.province != _unit2!.location.province,
              ),
              _ComparisonRow(
                label: 'อำเภอ',
                value1: _unit1!.location.district,
                value2: _unit2!.location.district,
              ),
              if (_unit1!.armyArea != null || _unit2!.armyArea != null)
                _ComparisonRow(
                  label: 'กองทัพภาค',
                  value1: _unit1!.armyArea != null ? 'ทภ.${_unit1!.armyArea}' : 'ส่วนกลาง',
                  value2: _unit2!.armyArea != null ? 'ทภ.${_unit2!.armyArea}' : 'ส่วนกลาง',
                  isDifferent: _unit1!.armyArea != _unit2!.armyArea,
                ),
            ],
          ),
          const SizedBox(height: 16),
          _buildComparisonSection(
            title: 'การบังคับบัญชา',
            icon: Icons.military_tech,
            rows: [
              _ComparisonRow(
                label: 'ยศผู้บังคับหน่วย',
                value1: _unit1!.commanderRank,
                value2: _unit2!.commanderRank,
                isDifferent: _unit1!.commanderRank != _unit2!.commanderRank,
              ),
              _ComparisonRow(
                label: 'กำลังพล',
                value1: _unit1!.personnelRange,
                value2: _unit2!.personnelRange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMissionsComparison(),
          const SizedBox(height: 16),
          _buildHierarchyComparison(),
          const SizedBox(height: 32),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'ดู ${_unit1!.abbreviation}',
                  color: _unit1!.color,
                  onTap: () => _viewUnitDetail(_unit1!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  label: 'ดู ${_unit2!.abbreviation}',
                  color: _unit2!.color,
                  onTap: () => _viewUnitDetail(_unit2!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildComparisonSection({
    required String title,
    required IconData icon,
    required List<_ComparisonRow> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textMuted, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Comparison rows
          ...rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return Column(
              children: [
                _buildComparisonRow(row),
                if (index < rows.length - 1) const Divider(height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(_ComparisonRow row) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            row.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Unit 1 value
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _unit1!.color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: row.isDifferent
                        ? Border.all(color: _unit1!.color.withOpacity(0.3))
                        : null,
                  ),
                  child: Text(
                    row.value1,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: row.color1 ?? AppColors.textPrimary,
                      fontWeight: row.color1 != null ? FontWeight.bold : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Comparison indicator
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  row.isDifferent ? Icons.compare : Icons.drag_handle,
                  size: 20,
                  color: row.isDifferent
                      ? AppColors.warning
                      : AppColors.textMuted,
                ),
              ),
              // Unit 2 value
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _unit2!.color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: row.isDifferent
                        ? Border.all(color: _unit2!.color.withOpacity(0.3))
                        : null,
                  ),
                  child: Text(
                    row.value2,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: row.color2 ?? AppColors.textPrimary,
                      fontWeight: row.color2 != null ? FontWeight.bold : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissionsComparison() {
    final missions1 = _unit1!.missions;
    final missions2 = _unit2!.missions;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.flag, color: AppColors.textMuted, size: 20),
                const SizedBox(width: 8),
                Text(
                  'ภารกิจ',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unit 1 missions
                Expanded(
                  child: _buildMissionsList(
                    missions1,
                    _unit1!.color,
                    _unit1!.abbreviation,
                  ),
                ),
                const SizedBox(width: 16),
                // Unit 2 missions
                Expanded(
                  child: _buildMissionsList(
                    missions2,
                    _unit2!.color,
                    _unit2!.abbreviation,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionsList(List<String> missions, Color color, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$title (${missions.length})',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...missions.asMap().entries.map((entry) {
          final index = entry.key;
          final mission = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mission,
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHierarchyComparison() {
    final parent1 = _unit1!.parentId != null
        ? RTASignalCorps.getUnitById(_unit1!.parentId!)
        : null;
    final parent2 = _unit2!.parentId != null
        ? RTASignalCorps.getUnitById(_unit2!.parentId!)
        : null;
    final children1 = _unit1!.childUnitIds.length;
    final children2 = _unit2!.childUnitIds.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.account_tree, color: AppColors.textMuted, size: 20),
                const SizedBox(width: 8),
                Text(
                  'สายการบังคับบัญชา',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Parent units row
                _buildHierarchyRow(
                  label: 'หน่วยเหนือ',
                  value1: parent1?.abbreviation ?? '-',
                  value2: parent2?.abbreviation ?? '-',
                  color1: parent1?.color ?? AppColors.textMuted,
                  color2: parent2?.color ?? AppColors.textMuted,
                ),
                const SizedBox(height: 16),
                // Child units count row
                _buildHierarchyRow(
                  label: 'จำนวนหน่วยรอง',
                  value1: '$children1 หน่วย',
                  value2: '$children2 หน่วย',
                  color1: _unit1!.color,
                  color2: _unit2!.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHierarchyRow({
    required String label,
    required String value1,
    required String value2,
    required Color color1,
    required Color color2,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color1.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color2.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectUnit(int slot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _UnitSelectionSheet(
        title: 'เลือกหน่วยที่ $slot',
        excludeUnit: slot == 1 ? _unit2 : _unit1,
        onUnitSelected: (unit) {
          Navigator.pop(context);
          setState(() {
            if (slot == 1) {
              _unit1 = unit;
            } else {
              _unit2 = unit;
            }
          });
        },
      ),
    );
  }

  void _clearUnit(int slot) {
    setState(() {
      if (slot == 1) {
        _unit1 = null;
      } else {
        _unit2 = null;
      }
    });
  }

  void _swapUnits() {
    setState(() {
      final temp = _unit1;
      _unit1 = _unit2;
      _unit2 = temp;
    });
  }

  void _viewUnitDetail(SignalUnit unit) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UnitDetailScreen(unit: unit)),
    );
  }
}

class _ComparisonRow {
  final String label;
  final String value1;
  final String value2;
  final Color? color1;
  final Color? color2;
  final bool isDifferent;

  const _ComparisonRow({
    required this.label,
    required this.value1,
    required this.value2,
    this.color1,
    this.color2,
    this.isDifferent = false,
  });
}

class _UnitSelectionSheet extends StatefulWidget {
  final String title;
  final SignalUnit? excludeUnit;
  final Function(SignalUnit) onUnitSelected;

  const _UnitSelectionSheet({
    required this.title,
    this.excludeUnit,
    required this.onUnitSelected,
  });

  @override
  State<_UnitSelectionSheet> createState() => _UnitSelectionSheetState();
}

class _UnitSelectionSheetState extends State<_UnitSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<SignalUnit> _filteredUnits = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredUnits = _getFilteredUnits();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SignalUnit> _getFilteredUnits() {
    var units = RTASignalCorps.allCombinedUnits;

    // Exclude the other selected unit
    if (widget.excludeUnit != null) {
      units = units.where((u) => u.id != widget.excludeUnit!.id).toList();
    }

    if (_searchQuery.isEmpty) {
      return units;
    }

    return units.where((unit) {
      return unit.name.toLowerCase().contains(_searchQuery) ||
          unit.abbreviation.toLowerCase().contains(_searchQuery) ||
          unit.nameEn.toLowerCase().contains(_searchQuery) ||
          unit.location.province.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredUnits = _getFilteredUnits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          ),
                          child: const Icon(
                            Icons.compare_arrows,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: AppTextStyles.titleLarge,
                              ),
                              Text(
                                'พบ ${_filteredUnits.length} หน่วย',
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
                    const SizedBox(height: 16),
                    // Search field
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'ค้นหาหน่วย...',
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Results list
              Expanded(
                child: _filteredUnits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'ไม่พบหน่วยที่ค้นหา',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredUnits.length,
                        itemBuilder: (context, index) {
                          final unit = _filteredUnits[index];
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
          onTap: () => widget.onUnitSelected(unit),
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
                          if (unit.armyArea != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: unit.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'ทภ.${unit.armyArea}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: unit.color,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: unit.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: unit.color,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
