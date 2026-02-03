import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Types of content that can be bookmarked
enum BookmarkType {
  lesson,
  flashcard,
  glossaryTerm,
  referenceCard,
  scenario,
}

/// Represents a bookmarked item
class BookmarkItem {
  final String id;
  final BookmarkType type;
  final String title;
  final String? subtitle;
  final String? category;
  final DateTime addedAt;

  BookmarkItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.category,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'subtitle': subtitle,
        'category': category,
        'addedAt': addedAt.toIso8601String(),
      };

  factory BookmarkItem.fromJson(Map<String, dynamic> json) => BookmarkItem(
        id: json['id'],
        type: BookmarkType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => BookmarkType.lesson,
        ),
        title: json['title'],
        subtitle: json['subtitle'],
        category: json['category'],
        addedAt: DateTime.parse(json['addedAt']),
      );
}

/// Service for managing bookmarks
class BookmarkService extends ChangeNotifier {
  static final BookmarkService _instance = BookmarkService._internal();
  factory BookmarkService() => _instance;
  BookmarkService._internal();

  static const String _prefsKey = 'bookmarks';
  List<BookmarkItem> _bookmarks = [];
  bool _isInitialized = false;

  List<BookmarkItem> get bookmarks => List.unmodifiable(_bookmarks);

  List<BookmarkItem> getBookmarksByType(BookmarkType type) {
    return _bookmarks.where((b) => b.type == type).toList();
  }

  bool isBookmarked(String id) {
    return _bookmarks.any((b) => b.id == id);
  }

  int get totalCount => _bookmarks.length;

  int getCountByType(BookmarkType type) {
    return _bookmarks.where((b) => b.type == type).length;
  }

  /// Initialize the service by loading bookmarks from storage
  Future<void> init() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);

    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _bookmarks = jsonList.map((j) => BookmarkItem.fromJson(j)).toList();
      } catch (e) {
        debugPrint('Error loading bookmarks: $e');
        _bookmarks = [];
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// Add a bookmark
  Future<bool> addBookmark({
    required String id,
    required BookmarkType type,
    required String title,
    String? subtitle,
    String? category,
  }) async {
    if (isBookmarked(id)) return false;

    final bookmark = BookmarkItem(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      category: category,
      addedAt: DateTime.now(),
    );

    _bookmarks.insert(0, bookmark);
    await _saveBookmarks();
    notifyListeners();
    return true;
  }

  /// Remove a bookmark
  Future<bool> removeBookmark(String id) async {
    final index = _bookmarks.indexWhere((b) => b.id == id);
    if (index == -1) return false;

    _bookmarks.removeAt(index);
    await _saveBookmarks();
    notifyListeners();
    return true;
  }

  /// Toggle bookmark (add if not exists, remove if exists)
  Future<bool> toggleBookmark({
    required String id,
    required BookmarkType type,
    required String title,
    String? subtitle,
    String? category,
  }) async {
    if (isBookmarked(id)) {
      await removeBookmark(id);
      return false; // Returns false when removed
    } else {
      await addBookmark(
        id: id,
        type: type,
        title: title,
        subtitle: subtitle,
        category: category,
      );
      return true; // Returns true when added
    }
  }

  /// Clear all bookmarks
  Future<void> clearAll() async {
    _bookmarks.clear();
    await _saveBookmarks();
    notifyListeners();
  }

  /// Clear bookmarks of a specific type
  Future<void> clearByType(BookmarkType type) async {
    _bookmarks.removeWhere((b) => b.type == type);
    await _saveBookmarks();
    notifyListeners();
  }

  /// Save bookmarks to storage
  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_bookmarks.map((b) => b.toJson()).toList());
    await prefs.setString(_prefsKey, jsonString);
  }
}

// Global instance
final bookmarkService = BookmarkService();
