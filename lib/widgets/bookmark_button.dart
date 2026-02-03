import 'package:flutter/material.dart';
import '../services/bookmark_service.dart';

/// A reusable bookmark button widget
class BookmarkButton extends StatelessWidget {
  final String itemId;
  final BookmarkType type;
  final String title;
  final String? subtitle;
  final String? category;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const BookmarkButton({
    super.key,
    required this.itemId,
    required this.type,
    required this.title,
    this.subtitle,
    this.category,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: bookmarkService,
      builder: (context, child) {
        final isBookmarked = bookmarkService.isBookmarked(itemId);

        return IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            size: size,
            color: isBookmarked
                ? (activeColor ?? Colors.amber)
                : (inactiveColor ?? Colors.grey),
          ),
          onPressed: () async {
            final wasAdded = await bookmarkService.toggleBookmark(
              id: itemId,
              type: type,
              title: title,
              subtitle: subtitle,
              category: category,
            );

            if (context.mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasAdded ? 'เพิ่มใน Bookmark แล้ว' : 'ลบออกจาก Bookmark แล้ว',
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        );
      },
    );
  }
}

/// A small bookmark indicator icon (no button functionality)
class BookmarkIndicator extends StatelessWidget {
  final String itemId;
  final double size;
  final Color? color;

  const BookmarkIndicator({
    super.key,
    required this.itemId,
    this.size = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: bookmarkService,
      builder: (context, child) {
        final isBookmarked = bookmarkService.isBookmarked(itemId);

        if (!isBookmarked) return const SizedBox.shrink();

        return Icon(
          Icons.bookmark_rounded,
          size: size,
          color: color ?? Colors.amber,
        );
      },
    );
  }
}
