import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents a note attached to a lesson or content
class Note {
  final String id;
  final String lessonId;
  final String lessonTitle;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? highlightedText;
  final NoteColor color;

  Note({
    required this.id,
    required this.lessonId,
    required this.lessonTitle,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.highlightedText,
    this.color = NoteColor.yellow,
  });

  Note copyWith({
    String? content,
    DateTime? updatedAt,
    String? highlightedText,
    NoteColor? color,
  }) {
    return Note(
      id: id,
      lessonId: lessonId,
      lessonTitle: lessonTitle,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      highlightedText: highlightedText ?? this.highlightedText,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'lessonId': lessonId,
        'lessonTitle': lessonTitle,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'highlightedText': highlightedText,
        'color': color.name,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        lessonId: json['lessonId'],
        lessonTitle: json['lessonTitle'],
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        highlightedText: json['highlightedText'],
        color: NoteColor.values.firstWhere(
          (c) => c.name == json['color'],
          orElse: () => NoteColor.yellow,
        ),
      );
}

enum NoteColor {
  yellow,
  blue,
  green,
  pink,
  purple,
  orange,
}

/// Service for managing notes
class NotesService extends ChangeNotifier {
  static final NotesService _instance = NotesService._internal();
  factory NotesService() => _instance;
  NotesService._internal();

  static const String _prefsKey = 'user_notes';
  List<Note> _notes = [];
  bool _isInitialized = false;

  List<Note> get notes => List.unmodifiable(_notes);

  List<Note> getNotesForLesson(String lessonId) {
    return _notes.where((n) => n.lessonId == lessonId).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  int getNotesCountForLesson(String lessonId) {
    return _notes.where((n) => n.lessonId == lessonId).length;
  }

  int get totalCount => _notes.length;

  /// Initialize the service
  Future<void> init() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);

    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _notes = jsonList.map((j) => Note.fromJson(j)).toList();
      } catch (e) {
        debugPrint('Error loading notes: $e');
        _notes = [];
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// Add a new note
  Future<Note> addNote({
    required String lessonId,
    required String lessonTitle,
    required String content,
    String? highlightedText,
    NoteColor color = NoteColor.yellow,
  }) async {
    final note = Note(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      lessonId: lessonId,
      lessonTitle: lessonTitle,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      highlightedText: highlightedText,
      color: color,
    );

    _notes.insert(0, note);
    await _saveNotes();
    notifyListeners();
    return note;
  }

  /// Update an existing note
  Future<void> updateNote(String noteId, {String? content, NoteColor? color}) async {
    final index = _notes.indexWhere((n) => n.id == noteId);
    if (index == -1) return;

    _notes[index] = _notes[index].copyWith(
      content: content,
      color: color,
      updatedAt: DateTime.now(),
    );

    await _saveNotes();
    notifyListeners();
  }

  /// Delete a note
  Future<void> deleteNote(String noteId) async {
    _notes.removeWhere((n) => n.id == noteId);
    await _saveNotes();
    notifyListeners();
  }

  /// Delete all notes for a lesson
  Future<void> deleteNotesForLesson(String lessonId) async {
    _notes.removeWhere((n) => n.lessonId == lessonId);
    await _saveNotes();
    notifyListeners();
  }

  /// Clear all notes
  Future<void> clearAll() async {
    _notes.clear();
    await _saveNotes();
    notifyListeners();
  }

  /// Search notes
  List<Note> searchNotes(String query) {
    final lowerQuery = query.toLowerCase();
    return _notes.where((n) {
      return n.content.toLowerCase().contains(lowerQuery) ||
          n.lessonTitle.toLowerCase().contains(lowerQuery) ||
          (n.highlightedText?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Save notes to storage
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_notes.map((n) => n.toJson()).toList());
    await prefs.setString(_prefsKey, jsonString);
  }
}

// Global instance
final notesService = NotesService();
