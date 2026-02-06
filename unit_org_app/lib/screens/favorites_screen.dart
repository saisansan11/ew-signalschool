import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/constants.dart';
import '../data/rta_signal_corps.dart';
import '../services/favorites_service.dart';
import 'unit_detail_screen.dart';
import 'unit_comparison_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<SignalUnit> _favoriteUnits = [];
  bool _isLoading = true;
  bool _isReorderMode = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await FavoritesService.instance.init();
    _refreshFavorites();
    setState(() => _isLoading = false);
  }

  void _refreshFavorites() {
    final favoriteIds = FavoritesService.instance.favoriteIds;
    _favoriteUnits = favoriteIds
        .map((id) => RTASignalCorps.getUnitById(id))
        .where((u) => u != null)
        .cast<SignalUnit>()
        .toList();
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
          'หน่วยที่บันทึกไว้',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_favoriteUnits.isNotEmpty) ...[
            IconButton(
              icon: Icon(
                _isReorderMode ? Icons.check : Icons.reorder,
                color: _isReorderMode ? AppColors.success : AppColors.textMuted,
              ),
              onPressed: () {
                setState(() => _isReorderMode = !_isReorderMode);
              },
              tooltip: _isReorderMode ? 'เสร็จสิ้น' : 'จัดเรียงใหม่',
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'compare',
                  child: Row(
                    children: [
                      Icon(Icons.compare_arrows, size: 20),
                      SizedBox(width: 12),
                      Text('เปรียบเทียบ'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('ลบทั้งหมด', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteUnits.isEmpty
              ? _buildEmptyState()
              : _buildFavoritesList(),
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
                color: AppColors.accentPink.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 40,
                color: AppColors.accentPink,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ยังไม่มีหน่วยที่บันทึก',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'แตะไอคอน ❤️ ในหน้ารายละเอียดหน่วย\nเพื่อบันทึกหน่วยที่สนใจ',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildFavoritesList() {
    if (_isReorderMode) {
      return ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favoriteUnits.length,
        onReorder: _onReorder,
        itemBuilder: (context, index) {
          final unit = _favoriteUnits[index];
          return _buildReorderableItem(unit, index);
        },
      );
    }

    return Column(
      children: [
        // Summary card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accentPink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accentPink.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.accentPink.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: AppColors.accentPink,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_favoriteUnits.length} หน่วยที่บันทึกไว้',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.accentPink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'แตะค้างเพื่อจัดเรียงใหม่',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms),

        // Favorites list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _favoriteUnits.length,
            itemBuilder: (context, index) {
              final unit = _favoriteUnits[index];
              return _buildFavoriteItem(unit, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteItem(SignalUnit unit, int index) {
    return Dismissible(
      key: Key(unit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (_) => _removeFavorite(unit),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openUnitDetail(unit),
            onLongPress: () {
              setState(() => _isReorderMode = true);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: unit.color.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  // Unit level indicator
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: unit.color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        unit.level.symbol,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: unit.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Unit info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              unit.abbreviation,
                              style: TextStyle(
                                fontSize: 15,
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
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: unit.color,
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
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              unit.location.province,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.military_tech,
                              size: 14,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              unit.commanderRank,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Favorite icon
                  IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: AppColors.accentPink,
                    ),
                    onPressed: () => _removeFavorite(unit),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms, duration: 300.ms).slideX(begin: 0.05);
  }

  Widget _buildReorderableItem(SignalUnit unit, int index) {
    return Container(
      key: Key(unit.id),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: unit.color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Drag handle
          const Icon(
            Icons.drag_handle,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: 12),
          // Unit level indicator
          Container(
            width: 40,
            height: 40,
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
          // Unit info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.abbreviation,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: unit.color,
                  ),
                ),
                Text(
                  unit.name,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Index indicator
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'compare':
        _openCompareMode();
        break;
      case 'clear':
        _showClearConfirmation();
        break;
    }
  }

  void _openCompareMode() {
    if (_favoriteUnits.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ต้องมีหน่วยอย่างน้อย 2 หน่วยเพื่อเปรียบเทียบ'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UnitComparisonScreen(
          initialUnit1: _favoriteUnits[0],
          initialUnit2: _favoriteUnits.length > 1 ? _favoriteUnits[1] : null,
        ),
      ),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('ลบรายการทั้งหมด?'),
        content: Text(
          'คุณต้องการลบหน่วยที่บันทึกไว้ทั้งหมด ${_favoriteUnits.length} หน่วยหรือไม่?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FavoritesService.instance.clearAll();
              setState(() {
                _favoriteUnits.clear();
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ลบรายการทั้งหมดแล้ว'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text(
              'ลบทั้งหมด',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _openUnitDetail(SignalUnit unit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UnitDetailScreen(unit: unit),
      ),
    ).then((_) {
      // Refresh favorites in case user removed it from detail screen
      setState(() {
        _refreshFavorites();
      });
    });
  }

  Future<void> _removeFavorite(SignalUnit unit) async {
    await FavoritesService.instance.removeFavorite(unit.id);
    setState(() {
      _favoriteUnits.remove(unit);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('นำ ${unit.abbreviation} ออกจากรายการแล้ว'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'ยกเลิก',
            onPressed: () async {
              await FavoritesService.instance.addFavorite(unit.id);
              setState(() {
                _refreshFavorites();
              });
            },
          ),
        ),
      );
    }
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _favoriteUnits.removeAt(oldIndex);
      _favoriteUnits.insert(newIndex, item);
    });
    await FavoritesService.instance.reorder(oldIndex, newIndex);
  }
}
