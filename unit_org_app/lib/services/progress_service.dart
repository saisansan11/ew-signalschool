import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/learning_models.dart';
import '../data/learning_data.dart';

/// Service for tracking learning progress with Spaced Repetition and Achievements
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

  // Spaced Repetition data
  Map<String, SpacedRepetitionCard> _srCards = {};

  // Achievement data
  Set<String> _unlockedAchievements = {};
  List<String> _recentAchievements = []; // For showing notifications

  // Learning Path data
  Set<String> _completedLessons = {};
  Map<String, int> _lessonScores = {}; // lessonId -> score percentage

  // Adaptive Quiz state
  Map<String, AdaptiveQuizState> _quizStates = {};
  int _perfectQuizCount = 0;

  // Daily Goals
  int _dailyFlashcardGoal = 10;
  int _dailyQuizGoal = 1;
  int _flashcardsStudiedToday = 0;
  int _quizzesCompletedToday = 0;
  DateTime? _lastDailyResetDate;

  // Streak Freeze
  int _streakFreezeCount = 0; // Available streak freezes
  bool _usedStreakFreezeToday = false;

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
  Set<String> get unlockedAchievements => Set.unmodifiable(_unlockedAchievements);
  Set<String> get completedLessons => Set.unmodifiable(_completedLessons);
  int get perfectQuizCount => _perfectQuizCount;

  int get knownFlashcardsCount => _knownFlashcards.values.where((v) => v).length;
  int get viewedUnitsCount => _viewedUnits.length;

  // Daily Goals getters
  int get dailyFlashcardGoal => _dailyFlashcardGoal;
  int get dailyQuizGoal => _dailyQuizGoal;
  int get flashcardsStudiedToday => _flashcardsStudiedToday;
  int get quizzesCompletedToday => _quizzesCompletedToday;
  bool get dailyFlashcardGoalMet => _flashcardsStudiedToday >= _dailyFlashcardGoal;
  bool get dailyQuizGoalMet => _quizzesCompletedToday >= _dailyQuizGoal;
  bool get allDailyGoalsMet => dailyFlashcardGoalMet && dailyQuizGoalMet;
  double get dailyFlashcardProgress => (_flashcardsStudiedToday / _dailyFlashcardGoal).clamp(0.0, 1.0);
  double get dailyQuizProgress => (_quizzesCompletedToday / _dailyQuizGoal).clamp(0.0, 1.0);
  double get overallDailyProgress => (dailyFlashcardProgress + dailyQuizProgress) / 2;

  // Streak Freeze getters
  int get streakFreezeCount => _streakFreezeCount;
  bool get hasStreakFreeze => _streakFreezeCount > 0;
  bool get usedStreakFreezeToday => _usedStreakFreezeToday;

  double get flashcardMasteryRate {
    if (_knownFlashcards.isEmpty) return 0;
    return knownFlashcardsCount / _knownFlashcards.length;
  }

  double get quizAverageScore {
    if (_quizScores.isEmpty) return 0;
    final total = _quizScores.values.fold<int>(0, (a, b) => a + b);
    return total / _quizScores.length;
  }

  /// Get recent unlocked achievements (and clear the list)
  List<Achievement> popRecentAchievements() {
    final achievements = _recentAchievements
        .map((id) => LearningData.getAchievementById(id))
        .where((a) => a != null)
        .cast<Achievement>()
        .toList();
    _recentAchievements.clear();
    return achievements;
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
    _perfectQuizCount = _prefs!.getInt('perfect_quiz_count') ?? 0;

    final lastStudyString = _prefs!.getString('last_study_date');
    if (lastStudyString != null) {
      _lastStudyDate = DateTime.parse(lastStudyString);
    }

    // Load Spaced Repetition data
    final srJson = _prefs!.getString('sr_cards');
    if (srJson != null) {
      final decoded = json.decode(srJson) as Map<String, dynamic>;
      _srCards = decoded.map((k, v) =>
          MapEntry(k, SpacedRepetitionCard.fromJson(v as Map<String, dynamic>)));
    }

    // Load Achievements
    _unlockedAchievements = (_prefs!.getStringList('unlocked_achievements') ?? []).toSet();

    // Load Learning Path progress
    _completedLessons = (_prefs!.getStringList('completed_lessons') ?? []).toSet();

    final lessonScoresJson = _prefs!.getString('lesson_scores');
    if (lessonScoresJson != null) {
      final decoded = json.decode(lessonScoresJson) as Map<String, dynamic>;
      _lessonScores = decoded.map((k, v) => MapEntry(k, v as int));
    }

    // Load Daily Goals settings
    _dailyFlashcardGoal = _prefs!.getInt('daily_flashcard_goal') ?? 10;
    _dailyQuizGoal = _prefs!.getInt('daily_quiz_goal') ?? 1;
    _flashcardsStudiedToday = _prefs!.getInt('flashcards_studied_today') ?? 0;
    _quizzesCompletedToday = _prefs!.getInt('quizzes_completed_today') ?? 0;

    final lastResetString = _prefs!.getString('last_daily_reset_date');
    if (lastResetString != null) {
      _lastDailyResetDate = DateTime.parse(lastResetString);
    }

    // Load Streak Freeze
    _streakFreezeCount = _prefs!.getInt('streak_freeze_count') ?? 1; // Start with 1 free freeze
    _usedStreakFreezeToday = _prefs!.getBool('used_streak_freeze_today') ?? false;

    _updateStreak();
    _checkDailyReset();
  }

  void _checkDailyReset() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastDailyResetDate == null) {
      _lastDailyResetDate = today;
      return;
    }

    final lastReset = DateTime(
      _lastDailyResetDate!.year,
      _lastDailyResetDate!.month,
      _lastDailyResetDate!.day,
    );

    if (today.isAfter(lastReset)) {
      // New day - reset daily counters
      _flashcardsStudiedToday = 0;
      _quizzesCompletedToday = 0;
      _usedStreakFreezeToday = false;
      _lastDailyResetDate = today;
    }
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
    await _prefs!.setInt('perfect_quiz_count', _perfectQuizCount);

    if (_lastStudyDate != null) {
      await _prefs!.setString('last_study_date', _lastStudyDate!.toIso8601String());
    }

    // Save SR data
    final srData = _srCards.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs!.setString('sr_cards', json.encode(srData));

    // Save Achievements
    await _prefs!.setStringList('unlocked_achievements', _unlockedAchievements.toList());

    // Save Learning Path progress
    await _prefs!.setStringList('completed_lessons', _completedLessons.toList());
    await _prefs!.setString('lesson_scores', json.encode(_lessonScores));

    // Save Daily Goals
    await _prefs!.setInt('daily_flashcard_goal', _dailyFlashcardGoal);
    await _prefs!.setInt('daily_quiz_goal', _dailyQuizGoal);
    await _prefs!.setInt('flashcards_studied_today', _flashcardsStudiedToday);
    await _prefs!.setInt('quizzes_completed_today', _quizzesCompletedToday);
    if (_lastDailyResetDate != null) {
      await _prefs!.setString('last_daily_reset_date', _lastDailyResetDate!.toIso8601String());
    }

    // Save Streak Freeze
    await _prefs!.setInt('streak_freeze_count', _streakFreezeCount);
    await _prefs!.setBool('used_streak_freeze_today', _usedStreakFreezeToday);
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
    } else if (difference == 2 && _streakFreezeCount > 0 && !_usedStreakFreezeToday) {
      // Missed one day - use streak freeze automatically
      _streakFreezeCount--;
      _usedStreakFreezeToday = true;
      // Streak preserved
    } else {
      // More than one day (or no freeze available), reset streak
      _currentStreak = 0;
    }
  }

  // ============ DAILY GOALS ============

  /// Set daily flashcard goal
  Future<void> setDailyFlashcardGoal(int goal) async {
    _dailyFlashcardGoal = goal.clamp(1, 100);
    await _saveProgress();
    notifyListeners();
  }

  /// Set daily quiz goal
  Future<void> setDailyQuizGoal(int goal) async {
    _dailyQuizGoal = goal.clamp(1, 20);
    await _saveProgress();
    notifyListeners();
  }

  /// Increment flashcards studied today
  void _incrementFlashcardsToday() {
    _checkDailyReset();
    _flashcardsStudiedToday++;
  }

  /// Increment quizzes completed today
  void _incrementQuizzesToday() {
    _checkDailyReset();
    _quizzesCompletedToday++;
  }

  /// Get daily goals summary
  DailyGoalsSummary getDailyGoalsSummary() {
    _checkDailyReset();
    return DailyGoalsSummary(
      flashcardGoal: _dailyFlashcardGoal,
      flashcardsCompleted: _flashcardsStudiedToday,
      quizGoal: _dailyQuizGoal,
      quizzesCompleted: _quizzesCompletedToday,
    );
  }

  // ============ STREAK FREEZE ============

  /// Add a streak freeze (earned through achievements or daily goals)
  Future<void> addStreakFreeze([int count = 1]) async {
    _streakFreezeCount = (_streakFreezeCount + count).clamp(0, 5); // Max 5 freezes
    await _saveProgress();
    notifyListeners();
  }

  /// Use a streak freeze manually
  Future<bool> useStreakFreeze() async {
    if (_streakFreezeCount <= 0 || _usedStreakFreezeToday) {
      return false;
    }
    _streakFreezeCount--;
    _usedStreakFreezeToday = true;
    await _saveProgress();
    notifyListeners();
    return true;
  }

  // ============ SPACED REPETITION ============

  /// Get or create SR card for a flashcard
  SpacedRepetitionCard _getOrCreateSRCard(String cardId) {
    return _srCards.putIfAbsent(cardId, () => SpacedRepetitionCard(cardId: cardId));
  }

  /// Get cards due for review
  List<String> getDueCards(List<String> allCardIds) {
    return allCardIds.where((id) {
      final srCard = _srCards[id];
      if (srCard == null) return true; // New card
      return srCard.isDue();
    }).toList();
  }

  /// Mark a flashcard with SM-2 quality rating
  Future<void> markFlashcardSR(String cardId, int quality) async {
    final srCard = _getOrCreateSRCard(cardId);
    srCard.updateWithQuality(quality);

    _knownFlashcards[cardId] = quality >= 3;
    _totalFlashcardsStudied++;
    _incrementFlashcardsToday();
    _recordStudySession();

    // Award streak freeze if daily goal is met
    if (dailyFlashcardGoalMet && _flashcardsStudiedToday == _dailyFlashcardGoal) {
      // First time meeting goal today - check for bonus
      if (allDailyGoalsMet) {
        await addStreakFreeze(); // Bonus freeze for completing all goals
      }
    }

    await _checkAchievements();
    await _saveProgress();
    notifyListeners();
  }

  /// Mark a flashcard as known or learning (simplified)
  Future<void> markFlashcard(String cardId, bool isKnown) async {
    // Convert to SM-2 quality: known = 4, learning = 2
    await markFlashcardSR(cardId, isKnown ? 4 : 2);
  }

  /// Get next review date for a card
  DateTime? getNextReviewDate(String cardId) {
    return _srCards[cardId]?.nextReviewDate;
  }

  /// Get interval days for a card
  int getIntervalDays(String cardId) {
    return _srCards[cardId]?.interval ?? 1;
  }

  /// Check if a flashcard is known
  bool isFlashcardKnown(String cardId) {
    return _knownFlashcards[cardId] ?? false;
  }

  // ============ ADAPTIVE QUIZ ============

  /// Get or create adaptive quiz state for a category
  AdaptiveQuizState getQuizState(String category) {
    return _quizStates.putIfAbsent(category, () => AdaptiveQuizState());
  }

  /// Get recommended difficulty for a category
  int getRecommendedDifficulty(String category) {
    return getQuizState(category).currentDifficulty;
  }

  /// Record an answer for adaptive quiz
  void recordAdaptiveAnswer(String category, bool correct) {
    getQuizState(category).recordAnswer(correct);
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
    _incrementQuizzesToday();

    // Check for perfect quiz
    if (correctAnswers == totalQuestions && totalQuestions > 0) {
      _perfectQuizCount++;
    }

    _recordStudySession();

    // Award streak freeze if all daily goals are met
    if (allDailyGoalsMet && _quizzesCompletedToday == _dailyQuizGoal) {
      await addStreakFreeze(); // Bonus freeze for completing all goals
    }

    await _checkAchievements();
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

  // ============ LEARNING PATH ============

  /// Complete a lesson
  Future<void> completeLesson(String lessonId, int scorePercentage) async {
    _completedLessons.add(lessonId);
    _lessonScores[lessonId] = scorePercentage;
    _recordStudySession();
    await _checkAchievements();
    await _saveProgress();
    notifyListeners();
  }

  /// Check if a lesson is completed
  bool isLessonCompleted(String lessonId) {
    return _completedLessons.contains(lessonId);
  }

  /// Get lesson score
  int? getLessonScore(String lessonId) {
    return _lessonScores[lessonId];
  }

  /// Get learning path progress
  double getPathProgress(String pathId) {
    final path = LearningData.getPathById(pathId);
    if (path == null) return 0;
    return path.getProgress(_completedLessons.toList());
  }

  /// Get next available lesson in a path
  Lesson? getNextLesson(String pathId) {
    final path = LearningData.getPathById(pathId);
    if (path == null) return null;
    return path.getNextLesson(_completedLessons.toList());
  }

  // ============ ACHIEVEMENTS ============

  /// Check and unlock achievements
  Future<void> _checkAchievements() async {
    for (final achievement in LearningData.achievements) {
      if (_unlockedAchievements.contains(achievement.id)) continue;

      bool shouldUnlock = false;

      switch (achievement.type) {
        case AchievementType.flashcardsCompleted:
          shouldUnlock = _totalFlashcardsStudied >= achievement.requirement;
          break;
        case AchievementType.quizzesPassed:
          final passedCount = _quizScores.values.where((s) => s >= 70).length;
          shouldUnlock = passedCount >= achievement.requirement;
          break;
        case AchievementType.streakDays:
          shouldUnlock = _currentStreak >= achievement.requirement;
          break;
        case AchievementType.unitsViewed:
          shouldUnlock = _viewedUnits.length >= achievement.requirement;
          break;
        case AchievementType.perfectQuiz:
          shouldUnlock = _perfectQuizCount >= achievement.requirement;
          break;
        case AchievementType.masteryRate:
          shouldUnlock = (flashcardMasteryRate * 100) >= achievement.requirement;
          break;
      }

      if (shouldUnlock) {
        _unlockedAchievements.add(achievement.id);
        _recentAchievements.add(achievement.id);
      }
    }
  }

  /// Check if an achievement is unlocked
  bool isAchievementUnlocked(String achievementId) {
    return _unlockedAchievements.contains(achievementId);
  }

  /// Get progress towards an achievement (0-1)
  double getAchievementProgress(Achievement achievement) {
    int current = 0;

    switch (achievement.type) {
      case AchievementType.flashcardsCompleted:
        current = _totalFlashcardsStudied;
        break;
      case AchievementType.quizzesPassed:
        current = _quizScores.values.where((s) => s >= 70).length;
        break;
      case AchievementType.streakDays:
        current = _currentStreak;
        break;
      case AchievementType.unitsViewed:
        current = _viewedUnits.length;
        break;
      case AchievementType.perfectQuiz:
        current = _perfectQuizCount;
        break;
      case AchievementType.masteryRate:
        current = (flashcardMasteryRate * 100).round();
        break;
    }

    return (current / achievement.requirement).clamp(0.0, 1.0);
  }

  // ============ UNIT VIEWING ============

  /// Mark a unit as viewed
  Future<void> markUnitViewed(String unitId) async {
    if (!_viewedUnits.contains(unitId)) {
      _viewedUnits.add(unitId);
      await _checkAchievements();
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
    _srCards.clear();
    _unlockedAchievements.clear();
    _recentAchievements.clear();
    _completedLessons.clear();
    _lessonScores.clear();
    _quizStates.clear();
    _perfectQuizCount = 0;

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

/// Daily goals summary
class DailyGoalsSummary {
  final int flashcardGoal;
  final int flashcardsCompleted;
  final int quizGoal;
  final int quizzesCompleted;

  const DailyGoalsSummary({
    required this.flashcardGoal,
    required this.flashcardsCompleted,
    required this.quizGoal,
    required this.quizzesCompleted,
  });

  double get flashcardProgress => (flashcardsCompleted / flashcardGoal).clamp(0.0, 1.0);
  double get quizProgress => (quizzesCompleted / quizGoal).clamp(0.0, 1.0);
  double get overallProgress => (flashcardProgress + quizProgress) / 2;
  bool get flashcardGoalMet => flashcardsCompleted >= flashcardGoal;
  bool get quizGoalMet => quizzesCompleted >= quizGoal;
  bool get allGoalsMet => flashcardGoalMet && quizGoalMet;
}
