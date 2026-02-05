import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';
import '../../services/notes_service.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _searchQuery = '';
  String _selectedLesson = 'ทั้งหมด';

  @override
  void initState() {
    super.initState();
    notesService.init();
  }

  List<Note> _getFilteredNotes() {
    var notes = notesService.notes;

    if (_searchQuery.isNotEmpty) {
      notes = notesService.searchNotes(_searchQuery);
    }

    if (_selectedLesson != 'ทั้งหมด') {
      notes = notes.where((n) => n.lessonTitle == _selectedLesson).toList();
    }

    return notes;
  }

  Set<String> _getLessonTitles() {
    return notesService.notes.map((n) => n.lessonTitle).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeProvider, notesService]),
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;
        final filteredNotes = _getFilteredNotes();
        final lessonTitles = _getLessonTitles();

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Text(
              'MY NOTES',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
            actions: [
              if (notesService.totalCount > 0)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  ),
                  color: isDark ? AppColors.surface : AppColorsLight.surface,
                  onSelected: (value) {
                    if (value == 'clear_all') {
                      _showClearDialog(context, isDark);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'clear_all',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Text('ลบ Notes ทั้งหมด', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          body: Column(
            children: [
              // Search bar
              Container(
                padding: const EdgeInsets.all(16),
                color: isDark ? AppColors.surface : AppColorsLight.surface,
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ค้นหา Notes...',
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.background : AppColorsLight.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),

              // Lesson filter chips
              if (lessonTitles.isNotEmpty)
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: FilterChip(
                          label: Text('ทั้งหมด (${notesService.totalCount})'),
                          selected: _selectedLesson == 'ทั้งหมด',
                          onSelected: (_) => setState(() => _selectedLesson = 'ทั้งหมด'),
                          backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
                          selectedColor: AppColors.primary.withAlpha(30),
                          checkmarkColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: _selectedLesson == 'ทั้งหมด'
                                ? AppColors.primary
                                : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      ...lessonTitles.map((title) {
                        final count = notesService.getNotesCountForLesson(
                          notesService.notes.firstWhere((n) => n.lessonTitle == title).lessonId,
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: FilterChip(
                            label: Text('$title ($count)'),
                            selected: _selectedLesson == title,
                            onSelected: (_) => setState(() => _selectedLesson = title),
                            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
                            selectedColor: AppColors.primary.withAlpha(30),
                            checkmarkColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: _selectedLesson == title
                                  ? AppColors.primary
                                  : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
                              fontSize: 12,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

              // Notes count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'พบ ${filteredNotes.length} รายการ',
                      style: TextStyle(
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Notes list
              Expanded(
                child: filteredNotes.isEmpty
                    ? _buildEmptyState(isDark)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          return _buildNoteCard(filteredNotes[index], isDark);
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddNoteDialog(context, isDark),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : AppColorsLight.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.note_alt_outlined,
              size: 48,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'ยังไม่มี Notes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'เพิ่ม Notes ขณะเรียนบทเรียน\nหรือกดปุ่ม + เพื่อเพิ่ม Note ใหม่',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Note note, bool isDark) {
    final noteColor = _getNoteColor(note.color);

    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        notesService.deleteNote(note.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('ลบ Note แล้ว'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                notesService.addNote(
                  lessonId: note.lessonId,
                  lessonTitle: note.lessonTitle,
                  content: note.content,
                  highlightedText: note.highlightedText,
                  color: note.color,
                );
              },
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _showEditNoteDialog(context, note, isDark),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surface : AppColorsLight.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: noteColor, width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lesson title and time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.school,
                            size: 14,
                            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              note.lessonTitle,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _formatDate(note.updatedAt),
                      style: TextStyle(
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                // Highlighted text (if any)
                if (note.highlightedText != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: noteColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.format_quote, color: noteColor, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            note.highlightedText!,
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Note content
                const SizedBox(height: 8),
                Text(
                  note.content,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),

                // Color indicator row
                const SizedBox(height: 12),
                Row(
                  children: [
                    ...NoteColor.values.map((c) {
                      final isSelected = c == note.color;
                      return GestureDetector(
                        onTap: () => notesService.updateNote(note.id, color: c),
                        child: Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: _getNoteColor(c),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: isDark ? Colors.white : Colors.black,
                                    width: 2,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getNoteColor(NoteColor color) {
    switch (color) {
      case NoteColor.yellow:
        return Colors.amber;
      case NoteColor.blue:
        return Colors.blue;
      case NoteColor.green:
        return Colors.green;
      case NoteColor.pink:
        return Colors.pink;
      case NoteColor.purple:
        return Colors.purple;
      case NoteColor.orange:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes} นาทีที่แล้ว';
      }
      return '${diff.inHours} ชั่วโมงที่แล้ว';
    } else if (diff.inDays == 1) {
      return 'เมื่อวาน';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} วันที่แล้ว';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showAddNoteDialog(BuildContext context, bool isDark) {
    final contentController = TextEditingController();
    NoteColor selectedColor = NoteColor.yellow;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surface : AppColorsLight.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.border : AppColorsLight.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'เพิ่ม Note ใหม่',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Color selection
              Row(
                children: NoteColor.values.map((c) {
                  final isSelected = c == selectedColor;
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedColor = c),
                    child: Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: _getNoteColor(c),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: isDark ? Colors.white : Colors.black,
                                width: 3,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Content input
              TextField(
                controller: contentController,
                maxLines: 5,
                autofocus: true,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'เขียน Note ของคุณ...',
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.background : AppColorsLight.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (contentController.text.trim().isNotEmpty) {
                      notesService.addNote(
                        lessonId: 'quick_note_${DateTime.now().millisecondsSinceEpoch}',
                        lessonTitle: 'Quick Note',
                        content: contentController.text.trim(),
                        color: selectedColor,
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'บันทึก',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, Note note, bool isDark) {
    final contentController = TextEditingController(text: note.content);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColorsLight.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.border : AppColorsLight.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'แก้ไข Note',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Content input
            TextField(
              controller: contentController,
              maxLines: 5,
              autofocus: true,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'เขียน Note ของคุณ...',
                hintStyle: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                ),
                filled: true,
                fillColor: isDark ? AppColors.background : AppColorsLight.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (contentController.text.trim().isNotEmpty) {
                    notesService.updateNote(
                      note.id,
                      content: contentController.text.trim(),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'บันทึก',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'ลบ Notes ทั้งหมด?',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
        ),
        content: Text(
          'การดำเนินการนี้จะลบ Notes ทั้งหมดและไม่สามารถกู้คืนได้',
          style: TextStyle(
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              notesService.clearAll();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ลบทั้งหมด', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
