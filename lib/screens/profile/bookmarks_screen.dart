import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';
import '../../services/bookmark_service.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BookmarkType? _selectedFilter;

  final List<_FilterOption> _filters = [
    _FilterOption(null, 'ทั้งหมด', Icons.bookmark_rounded),
    _FilterOption(BookmarkType.lesson, 'บทเรียน', Icons.school_rounded),
    _FilterOption(BookmarkType.flashcard, 'Flashcard', Icons.style_rounded),
    _FilterOption(BookmarkType.glossaryTerm, 'คำศัพท์', Icons.abc_rounded),
    _FilterOption(BookmarkType.referenceCard, 'Reference', Icons.dashboard_rounded),
    _FilterOption(BookmarkType.scenario, 'สถานการณ์', Icons.map_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedFilter = _filters[_tabController.index].type;
        });
      }
    });

    // Initialize bookmark service
    bookmarkService.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BookmarkItem> _getFilteredBookmarks() {
    if (_selectedFilter == null) {
      return bookmarkService.bookmarks;
    }
    return bookmarkService.getBookmarksByType(_selectedFilter!);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeProvider, bookmarkService]),
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;
        final filteredBookmarks = _getFilteredBookmarks();

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Text(
              'BOOKMARKS',
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
              if (filteredBookmarks.isNotEmpty)
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
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ลบ Bookmark ทั้งหมด',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor:
                  isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              indicatorColor: AppColors.primary,
              tabAlignment: TabAlignment.start,
              tabs: _filters.map((filter) {
                final count = filter.type == null
                    ? bookmarkService.totalCount
                    : bookmarkService.getCountByType(filter.type!);
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(filter.icon, size: 18),
                      const SizedBox(width: 6),
                      Text(filter.label),
                      if (count > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(40),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          body: filteredBookmarks.isEmpty
              ? _buildEmptyState(isDark)
              : _buildBookmarkList(filteredBookmarks, isDark),
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
              color: (isDark ? AppColors.surface : AppColorsLight.surface),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border_rounded,
              size: 48,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'ยังไม่มี Bookmark',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'กด icon bookmark ในบทเรียน Flashcard\nหรือ Reference Card เพื่อบันทึก',
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

  Widget _buildBookmarkList(List<BookmarkItem> bookmarks, bool isDark) {
    // Group bookmarks by date
    final Map<String, List<BookmarkItem>> groupedBookmarks = {};
    final now = DateTime.now();

    for (final bookmark in bookmarks) {
      String dateLabel;
      final diff = now.difference(bookmark.addedAt);

      if (diff.inDays == 0) {
        dateLabel = 'วันนี้';
      } else if (diff.inDays == 1) {
        dateLabel = 'เมื่อวาน';
      } else if (diff.inDays < 7) {
        dateLabel = '${diff.inDays} วันที่แล้ว';
      } else if (diff.inDays < 30) {
        dateLabel = '${(diff.inDays / 7).floor()} สัปดาห์ที่แล้ว';
      } else {
        dateLabel = 'เก่ากว่า 1 เดือน';
      }

      groupedBookmarks.putIfAbsent(dateLabel, () => []);
      groupedBookmarks[dateLabel]!.add(bookmark);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedBookmarks.length,
      itemBuilder: (context, index) {
        final dateLabel = groupedBookmarks.keys.elementAt(index);
        final items = groupedBookmarks[dateLabel]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                dateLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                ),
              ),
            ),
            ...items.map((bookmark) => _buildBookmarkCard(bookmark, isDark)),
          ],
        );
      },
    );
  }

  Widget _buildBookmarkCard(BookmarkItem bookmark, bool isDark) {
    final typeInfo = _getTypeInfo(bookmark.type);

    return Dismissible(
      key: Key(bookmark.id),
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
        bookmarkService.removeBookmark(bookmark.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ลบ "${bookmark.title}" แล้ว'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                bookmarkService.addBookmark(
                  id: bookmark.id,
                  type: bookmark.type,
                  title: bookmark.title,
                  subtitle: bookmark.subtitle,
                  category: bookmark.category,
                );
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColorsLight.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.border : AppColorsLight.border,
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: typeInfo.color.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              typeInfo.icon,
              color: typeInfo.color,
              size: 24,
            ),
          ),
          title: Text(
            bookmark.title,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bookmark.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  bookmark.subtitle!,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColorsLight.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: typeInfo.color.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      typeInfo.label,
                      style: TextStyle(
                        fontSize: 10,
                        color: typeInfo.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (bookmark.category != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.background
                            : AppColorsLight.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        bookmark.category!,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColorsLight.textMuted,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.bookmark_rounded,
              color: typeInfo.color,
            ),
            onPressed: () {
              bookmarkService.removeBookmark(bookmark.id);
            },
          ),
          onTap: () {
            _navigateToItem(bookmark);
          },
        ),
      ),
    );
  }

  _TypeInfo _getTypeInfo(BookmarkType type) {
    switch (type) {
      case BookmarkType.lesson:
        return _TypeInfo('บทเรียน', Icons.school_rounded, Colors.blue);
      case BookmarkType.flashcard:
        return _TypeInfo('Flashcard', Icons.style_rounded, Colors.purple);
      case BookmarkType.glossaryTerm:
        return _TypeInfo('คำศัพท์', Icons.abc_rounded, Colors.green);
      case BookmarkType.referenceCard:
        return _TypeInfo('Reference', Icons.dashboard_rounded, Colors.orange);
      case BookmarkType.scenario:
        return _TypeInfo('สถานการณ์', Icons.map_rounded, Colors.cyan);
    }
  }

  void _navigateToItem(BookmarkItem bookmark) {
    // Navigate to the appropriate screen based on bookmark type
    // This will be implemented when integrating with other screens
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เปิด: ${bookmark.title}'),
        duration: const Duration(seconds: 1),
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
          'ลบ Bookmark ทั้งหมด?',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
        ),
        content: Text(
          'การดำเนินการนี้จะลบ Bookmark ทั้งหมดของคุณและไม่สามารถกู้คืนได้',
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
              bookmarkService.clearAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ลบ Bookmark ทั้งหมดแล้ว')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'ลบทั้งหมด',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption {
  final BookmarkType? type;
  final String label;
  final IconData icon;

  _FilterOption(this.type, this.label, this.icon);
}

class _TypeInfo {
  final String label;
  final IconData icon;
  final Color color;

  _TypeInfo(this.label, this.icon, this.color);
}
