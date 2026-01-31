import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for tracking learning progress
class ProgressService extends ChangeNotifier {
  static ProgressService? _instance;
  static ProgressService get instance => _instance ??= ProgressService._();

  ProgressService._();

  SharedPreferences? _prefs;
  bool _initialized = false;

  // Progress data
  Map<String, bool> _knownFlashcards = {};
  Map<String, int> _quizScores = {};
  List<String> _viewedUnits = [];
  int _totalFlashcardsStudied = 0;
  int _totalQuizzesTaken = 0;
  int _totalCorrectAnswers = 0;
  int _currentStreak = 0;
  DateTime? _lastStudyDate;

  // Getters
  bool get isInitialized => _initialized;
  Map<String, bool> get knownFlashcards => Map.unmodifiable(_knownFlashcards);
  Map<String, int> get quizScores => Map.unmodifiable(_quizScores);
  List<String> get viewedUnits => List.unmodifiable(_viewedUnits);
  int get totalFlashcardsStudied => _totalFlashcardsStudied;
  int get totalQuizzesTaken => _totalQuizzesTaken;
  int get totalCorrectAnswers => _totalCorrectAnswers;
  int get currentStreak => _currentStreak;
  DateTime? get lastStudyDate => _lastStudyDate;

  int get knownFlashcardsCount => _knownFlashcards.values.where((v) => v).length;
  int get viewedUnitsCount => _viewedUnits.length;

  double get flashcardMasteryRate {
    if (_knownFlashcards.isEmpty) return 0;
    return knownFlashcardsCount / _knownFlashcards.length;
  }

  double get quizAverageScore {
    if (_quizScores.isEmpty) return 0;
    final total = _quizScores.values.fold<int>(0, (a, b) => a + b);
    return total / _quizScores.length;
  }

  /// Initialize the service
  Future<void> init() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();
    await _loadProgress();
    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadProgress() async {
    if (_prefs == null) return;

    // Load flashcard progress
    final flashcardJson = _prefs!.getString('known_flashcards');
    if (flashcardJson != null) {
      final decoded = json.decode(flashcardJson) as Map<String, dynamic>;
      _knownFlashcards = decoded.map((k, v) => MapEntry(k, v as bool));
    }

    // Load quiz scores
    final quizJson = _prefs!.getString('quiz_scores');
    if (quizJson != null) {
      final decoded = json.decode(quizJson) as Map<String, dynamic>;
      _quizScores = decoded.map((k, v) => MapEntry(k, v as int));
    }

    // Load viewed units
    _viewedUnits = _prefs!.getStringList('viewed_units') ?? [];

    // Load statistics
    _totalFlashcardsStudied = _prefs!.getInt('total_flashcards_studied') ?? 0;
    _totalQuizzesTaken = _prefs!.getInt('total_quizzes_taken') ?? 0;
    _totalCorrectAnswers = _prefs!.getInt('total_correct_answers') ?? 0;
    _currentStreak = _prefs!.getInt('current_streak') ?? 0;

    final lastStudyString = _prefs!.getString('last_study_date');
    if (lastStudyString != null) {
      _lastStudyDate = DateTime.parse(lastStudyString);
    }

    _updateStreak();
  }

  Future<void> _saveProgress() async {
    if (_prefs == null) return;

    await _prefs!.setString('known_flashcards', json.encode(_knownFlashcards));
    await _prefs!.setString('quiz_scores', json.encode(_quizScores));
    await _prefs!.setStringList('viewed_units', _viewedUnits);
    await _prefs!.setInt('total_flashcards_studied', _totalFlashcardsStudied);
    await _prefs!.setInt('total_quizzes_taken', _totalQuizzesTaken);
    await _prefs!.setInt('total_correct_answers', _totalCorrectAnswers);
    await _prefs!.setInt('current_streak', _currentStreak);

    if (_lastStudyDate != null) {
      await _prefs!.setString('last_study_date', _lastStudyDate!.toIso8601String());
    }
  }

  void _updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastStudyDate == null) {
      _currentStreak = 0;
      return;
    }

    final lastStudy = DateTime(
      _lastStudyDate!.year,
      _lastStudyDate!.month,
      _lastStudyDate!.day,
    );

    final difference = today.difference(lastStudy).inDays;

    if (difference == 0) {
      // Same day, streak continues
    } else if (difference == 1) {
      // Yesterday, streak continues
    } else {
      // More than one day, reset streak
      _currentStreak = 0;
    }
  }

  /// Mark a flashcard as known or learning
  Future<void> markFlashcard(String cardId, bool isKnown) async {
    _knownFlashcards[cardId] = isKnown;
    _totalFlashcardsStudied++;
    _recordStudySession();
    await _saveProgress();
    notifyListeners();
  }

  /// Check if a flashcard is known
  bool isFlashcardKnown(String cardId) {
    return _knownFlashcards[cardId] ?? false;
  }

  /// Record a quiz result
  Future<void> recordQuizResult({
    required String quizId,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
  }) async {
    _quizScores[quizId] = score;
    _totalQuizzesTaken++;
    _totalCorrectAnswers += correctAnswers;
    _recordStudySession();
    await _saveProgress();
    notifyListeners();
  }

  /// Get best score for a quiz category
  int? getBestScore(String category) {
    final categoryScores = _quizScores.entries
        .where((e) => e.key.startsWith(category))
        .map((e) => e.value);

    if (categoryScores.isEmpty) return null;
    return categoryScores.reduce((a, b) => a > b ? a : b);
  }

  /// Mark a unit as viewed
  Future<void> markUnitViewed(String unitId) async {
    if (!_viewedUnits.contains(unitId)) {
      _viewedUnits.add(unitId);
      await _saveProgress();
      notifyListeners();
    }
  }

  /// Check if a unit has been viewed
  bool isUnitViewed(String unitId) {
    return _viewedUnits.contains(unitId);
  }

  void _recordStudySession() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastStudyDate == null) {
      _currentStreak = 1;
    } else {
      final lastStudy = DateTime(
        _lastStudyDate!.year,
        _lastStudyDate!.month,
        _lastStudyDate!.day,
      );

      final difference = today.difference(lastStudy).inDays;

      if (difference == 1) {
        // Consecutive day
        _currentStreak++;
      } else if (difference > 1) {
        // Streak broken
        _currentStreak = 1;
      }
      // difference == 0: Same day, don't increment streak
    }

    _lastStudyDate = now;
  }

  /// Reset all progress
  Future<void> resetProgress() async {
    _knownFlashcards.clear();
    _quizScores.clear();
    _viewedUnits.clear();
    _totalFlashcardsStudied = 0;
    _totalQuizzesTaken = 0;
    _totalCorrectAnswers = 0;
    _currentStreak = 0;
    _lastStudyDate = null;

    if (_prefs != null) {
      await _prefs!.clear();
    }

    notifyListeners();
  }

  /// Get overall progress percentage (0-1)
  double getOverallProgress({
    required int totalFlashcards,
    required int totalUnits,
  }) {
    if (totalFlashcards == 0 && totalUnits == 0) return 0;

    final flashcardProgress = totalFlashcards > 0
        ? knownFlashcardsCount / totalFlashcards
        : 0.0;
    final unitProgress = totalUnits > 0
        ? viewedUnitsCount / totalUnits
        : 0.0;

    return (flashcardProgress + unitProgress) / 2;
  }

  /// Get study statistics
  StudyStats getStats() {
    return StudyStats(
      flashcardsKnown: knownFlashcardsCount,
      totalFlashcardsStudied: _totalFlashcardsStudied,
      quizzesTaken: _totalQuizzesTaken,
      correctAnswers: _totalCorrectAnswers,
      currentStreak: _currentStreak,
      unitsViewed: viewedUnitsCount,
      masteryRate: flashcardMasteryRate,
      averageQuizScore: quizAverageScore,
    );
  }
}

/// Study statistics data class
class StudyStats {
  final int flashcardsKnown;
  final int totalFlashcardsStudied;
  final int quizzesTaken;
  final int correctAnswers;
  final int currentStreak;
  final int unitsViewed;
  final double masteryRate;
  final double averageQuizScore;

  const StudyStats({
    required this.flashcardsKnown,
    required this.totalFlashcardsStudied,
    required this.quizzesTaken,
    required this.correctAnswers,
    required this.currentStreak,
    required this.unitsViewed,
    required this.masteryRate,
    required this.averageQuizScore,
  });

  double get accuracy {
    if (totalFlashcardsStudied == 0) return 0;
    return correctAnswers / totalFlashcardsStudied;
  }
}
