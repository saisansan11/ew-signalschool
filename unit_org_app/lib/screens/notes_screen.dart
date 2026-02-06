import 'package:flutter/material.dart';
import '../app/constants.dart';
import '../data/rta_signal_corps.dart';
import '../services/notes_service.dart';
import 'unit_detail_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UnitNote> _notes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    await NotesService.instance.init();
    setState(() {
      _notes = NotesService.instance.allNotes;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _notes = NotesService.instance.searchNotes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'บันทึกของฉัน',
          style: AppTextStyles.headlineMedium,
        ),
        actions: [
          if (_notes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: _showClearAllConfirmation,
              tooltip: 'ล้างบันทึกทั้งหมด',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'ค้นหาในบันทึก...',
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
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentTeal.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.note_alt_outlined,
                        size: 16,
                        color: AppColors.accentTeal,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_notes.length} บันทึก',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Notes list
          Expanded(
            child: _notes.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return _NoteCard(
                        note: _notes[index],
                        onTap: () => _navigateToUnit(_notes[index].unitId),
                        onDelete: () => _deleteNote(_notes[index].unitId),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accentTeal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.note_alt_outlined,
              size: 40,
              color: AppColors.accentTeal,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ? 'ไม่พบบันทึกที่ค้นหา' : 'ยังไม่มีบันทึก',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'ลองค้นหาด้วยคำอื่น'
                : 'เพิ่มบันทึกได้จากหน้ารายละเอียดหน่วย',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToUnit(String unitId) {
    final unit = RTASignalCorps.getUnitById(unitId);
    if (unit != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UnitDetailScreen(unit: unit)),
      ).then((_) => _loadNotes());
    }
  }

  Future<void> _deleteNote(String unitId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('ลบบันทึก?'),
        content: const Text('ต้องการลบบันทึกนี้หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await NotesService.instance.deleteNote(unitId);
      _loadNotes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ลบบันทึกแล้ว'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showClearAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('ล้างบันทึกทั้งหมด?'),
        content: const Text('การดำเนินการนี้ไม่สามารถยกเลิกได้'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await NotesService.instance.clearAll();
              _loadNotes();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ล้างบันทึกทั้งหมดแล้ว'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('ล้างทั้งหมด'),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final UnitNote note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final unit = RTASignalCorps.getUnitById(note.unitId);
    if (unit == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unit header
                Row(
                  children: [
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
                            fontSize: 11,
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
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: AppColors.error,
                      onPressed: onDelete,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Divider
                Container(
                  height: 1,
                  color: AppColors.border,
                ),
                const SizedBox(height: 12),
                // Note content
                Text(
                  note.content,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Timestamp
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(note.updatedAt),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'เมื่อสักครู่';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} นาทีที่แล้ว';
    } else if (diff.inDays < 1) {
      return '${diff.inHours} ชั่วโมงที่แล้ว';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} วันที่แล้ว';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
