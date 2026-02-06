import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Model for a unit note
class UnitNote {
  final String unitId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  UnitNote({
    required this.unitId,
    required this.content,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory UnitNote.fromJson(Map<String, dynamic> json) => UnitNote(
        unitId: json['unitId'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  UnitNote copyWith({String? content}) => UnitNote(
        unitId: unitId,
        content: content ?? this.content,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}

/// Service for managing unit notes
class NotesService {
  static const String _notesKey = 'unit_notes';
  static NotesService? _instance;

  SharedPreferences? _prefs;
  Map<String, UnitNote> _notes = {};

  NotesService._();

  static NotesService get instance {
    _instance ??= NotesService._();
    return _instance!;
  }

  /// Initialize the service
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _loadNotes();
  }

  void _loadNotes() {
    final jsonString = _prefs?.getString(_notesKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _notes = {
          for (var json in jsonList)
            (json['unitId'] as String): UnitNote.fromJson(json)
        };
      } catch (e) {
        _notes = {};
      }
    }
  }

  Future<void> _saveNotes() async {
    final jsonList = _notes.values.map((n) => n.toJson()).toList();
    await _prefs?.setString(_notesKey, jsonEncode(jsonList));
  }

  /// Get all notes
  List<UnitNote> get allNotes {
    final notes = _notes.values.toList();
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return notes;
  }

  /// Get note count
  int get count => _notes.length;

  /// Check if a unit has a note
  bool hasNote(String unitId) => _notes.containsKey(unitId);

  /// Get note for a unit
  UnitNote? getNote(String unitId) => _notes[unitId];

  /// Save or update a note for a unit
  Future<void> saveNote(String unitId, String content) async {
    if (content.trim().isEmpty) {
      await deleteNote(unitId);
      return;
    }

    final existing = _notes[unitId];
    if (existing != null) {
      _notes[unitId] = existing.copyWith(content: content);
    } else {
      _notes[unitId] = UnitNote(
        unitId: unitId,
        content: content,
        createdAt: DateTime.now(),
      );
    }
    await _saveNotes();
  }

  /// Delete a note for a unit
  Future<void> deleteNote(String unitId) async {
    _notes.remove(unitId);
    await _saveNotes();
  }

  /// Clear all notes
  Future<void> clearAll() async {
    _notes.clear();
    await _saveNotes();
  }

  /// Search notes by content
  List<UnitNote> searchNotes(String query) {
    if (query.isEmpty) return allNotes;
    final lowerQuery = query.toLowerCase();
    return allNotes.where((note) {
      return note.content.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
