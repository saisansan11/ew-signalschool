import 'package:shared_preferences/shared_preferences.dart';

/// Service for tracking user learning progress
class ProgressService {
  static const String _completedLessonsKey = 'completed_lessons';
  static const String _quizScoresKey = 'quiz_scores';
  static const String _totalXpKey = 'total_xp';

  static SharedPreferences? _prefs;

  /// Initialize the service
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Mark a lesson as completed
  static Future<void> completeLesson(String lessonId) async {
    if (_prefs == null) await init();
    final completed = getCompletedLessons();
    if (!completed.contains(lessonId)) {
      completed.add(lessonId);
      await _prefs!.setStringList(_completedLessonsKey, completed);
      // Add XP for completing lesson
      await addXp(50);
    }
  }

  /// Get list of completed lesson IDs
  static List<String> getCompletedLessons() {
    return _prefs?.getStringList(_completedLessonsKey) ?? [];
  }

  /// Check if a lesson is completed
  static bool isLessonCompleted(String lessonId) {
    return getCompletedLessons().contains(lessonId);
  }

  /// Save quiz score
  static Future<void> saveQuizScore(String quizId, int score, int total) async {
    if (_prefs == null) await init();
    final scores = getQuizScores();
    scores[quizId] = {'score': score, 'total': total, 'percent': (score / total * 100).round()};

    // Convert to storable format
    final List<String> scoreStrings = scores.entries
        .map((e) => '${e.key}:${e.value['score']}:${e.value['total']}')
        .toList();
    await _prefs!.setStringList(_quizScoresKey, scoreStrings);

    // Add XP based on score
    await addXp(score * 10);
  }

  /// Get all quiz scores
  static Map<String, Map<String, int>> getQuizScores() {
    final scoreStrings = _prefs?.getStringList(_quizScoresKey) ?? [];
    final Map<String, Map<String, int>> scores = {};

    for (final str in scoreStrings) {
      final parts = str.split(':');
      if (parts.length >= 3) {
        final quizId = parts[0];
        final score = int.tryParse(parts[1]) ?? 0;
        final total = int.tryParse(parts[2]) ?? 1;
        scores[quizId] = {
          'score': score,
          'total': total,
          'percent': (score / total * 100).round(),
        };
      }
    }
    return scores;
  }

  /// Get score for specific quiz
  static Map<String, int>? getQuizScore(String quizId) {
    return getQuizScores()[quizId];
  }

  /// Add XP points
  static Future<void> addXp(int xp) async {
    if (_prefs == null) await init();
    final current = getTotalXp();
    await _prefs!.setInt(_totalXpKey, current + xp);
  }

  /// Get total XP
  static int getTotalXp() {
    return _prefs?.getInt(_totalXpKey) ?? 0;
  }

  /// Get user level based on XP
  static int getLevel() {
    final xp = getTotalXp();
    // Level formula: level = sqrt(xp / 100)
    return (xp / 100).floor() + 1;
  }

  /// Get XP needed for next level
  static int getXpForNextLevel() {
    final level = getLevel();
    return level * 100;
  }

  /// Get overall progress percentage
  static double getOverallProgress() {
    final completed = getCompletedLessons().length;
    const totalLessons = 9; // Total lessons in the app
    return completed / totalLessons;
  }

  /// Reset all progress (for testing)
  static Future<void> resetProgress() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_completedLessonsKey);
    await _prefs!.remove(_quizScoresKey);
    await _prefs!.remove(_totalXpKey);
    await _prefs!.remove(_studyTimeKey);
    await _prefs!.remove(_streakKey);
    await _prefs!.remove(_lastLoginKey);
    await _prefs!.remove(_loginDaysKey);
  }

  // Additional keys for extended tracking
  static const String _studyTimeKey = 'study_time_minutes';
  static const String _streakKey = 'current_streak';
  static const String _lastLoginKey = 'last_login_date';
  static const String _loginDaysKey = 'total_login_days';

  /// Get total lessons completed count
  static int getTotalLessonsCompleted() {
    return getCompletedLessons().length;
  }

  /// Get progress for a specific level (0.0 to 1.0)
  static double getLevelProgress(int level) {
    final completed = getCompletedLessons();

    // Define lessons per level
    final Map<int, List<String>> levelLessons = {
      1: ['basics', 'spectrum', 'signal_types', 'quiz_level1'],
      2: ['esm', 'ecm', 'eccm', 'tactical_sim', 'quiz_level2'],
      3: ['advanced_eccm', 'direction_finding', 'spectrum_analyzer', 'quiz_level3'],
    };

    final lessons = levelLessons[level] ?? [];
    if (lessons.isEmpty) return 0.0;

    int completedCount = 0;
    for (final lesson in lessons) {
      if (completed.contains(lesson)) {
        completedCount++;
      }
    }

    return completedCount / lessons.length;
  }

  /// Get learning statistics
  static Map<String, dynamic> getLearningStats() {
    return {
      'totalStudyTime': _prefs?.getInt(_studyTimeKey) ?? 0,
      'currentStreak': _prefs?.getInt(_streakKey) ?? 0,
      'totalLoginDays': _prefs?.getInt(_loginDaysKey) ?? 1,
      'lessonsCompleted': getTotalLessonsCompleted(),
      'quizzesCompleted': getQuizScores().length,
      'totalXp': getTotalXp(),
      'level': getLevel(),
    };
  }

  /// Get current login streak
  static int getLoginStreak() {
    return _prefs?.getInt(_streakKey) ?? 0;
  }

  /// Add study time in minutes
  static Future<void> addStudyTime(int minutes) async {
    if (_prefs == null) await init();
    final current = _prefs?.getInt(_studyTimeKey) ?? 0;
    await _prefs!.setInt(_studyTimeKey, current + minutes);
  }

  /// Update login streak
  static Future<void> updateLoginStreak() async {
    if (_prefs == null) await init();

    final lastLoginStr = _prefs?.getString(_lastLoginKey);
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    if (lastLoginStr == null) {
      // First login
      await _prefs!.setString(_lastLoginKey, todayStr);
      await _prefs!.setInt(_streakKey, 1);
      await _prefs!.setInt(_loginDaysKey, 1);
      return;
    }

    if (lastLoginStr == todayStr) {
      // Already logged in today
      return;
    }

    final parts = lastLoginStr.split('-');
    if (parts.length == 3) {
      final lastLogin = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );

      final difference = today.difference(lastLogin).inDays;

      if (difference == 1) {
        // Consecutive day - increase streak
        final streak = (_prefs?.getInt(_streakKey) ?? 0) + 1;
        await _prefs!.setInt(_streakKey, streak);
      } else {
        // Streak broken - reset to 1
        await _prefs!.setInt(_streakKey, 1);
      }
    }

    // Update last login and total login days
    await _prefs!.setString(_lastLoginKey, todayStr);
    final totalDays = (_prefs?.getInt(_loginDaysKey) ?? 0) + 1;
    await _prefs!.setInt(_loginDaysKey, totalDays);
  }

  /// Get quiz scores as simple percentage map
  static Map<String, int> getQuizScorePercentages() {
    final scores = getQuizScores();
    final Map<String, int> percentages = {};

    for (final entry in scores.entries) {
      percentages[entry.key] = entry.value['percent'] ?? 0;
    }

    return percentages;
  }

  // ============ Flashcard Spaced Repetition System ============
  static const String _flashcardDataKey = 'flashcard_data';

  /// Record flashcard review result
  /// quality: 0-5 (0=total blackout, 3=correct with hesitation, 5=perfect)
  static Future<void> recordFlashcardReview(String cardId, int quality) async {
    if (_prefs == null) await init();

    final cardData = getFlashcardData(cardId);
    final now = DateTime.now();

    // SM-2 Algorithm implementation
    int repetitions = cardData['repetitions'] ?? 0;
    double easeFactor = cardData['easeFactor'] ?? 2.5;
    int interval = cardData['interval'] ?? 1;

    if (quality < 3) {
      // Failed - reset
      repetitions = 0;
      interval = 1;
    } else {
      // Passed
      if (repetitions == 0) {
        interval = 1;
      } else if (repetitions == 1) {
        interval = 6;
      } else {
        interval = (interval * easeFactor).round();
      }
      repetitions++;
    }

    // Update ease factor
    easeFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (easeFactor < 1.3) easeFactor = 1.3;

    // Calculate next review date
    final nextReview = now.add(Duration(days: interval));

    // Save card data
    final allData = _getAllFlashcardData();
    allData[cardId] = {
      'repetitions': repetitions,
      'easeFactor': easeFactor,
      'interval': interval,
      'lastReview': now.millisecondsSinceEpoch,
      'nextReview': nextReview.millisecondsSinceEpoch,
      'quality': quality,
    };

    await _saveAllFlashcardData(allData);

    // Add XP for review
    await addXp(quality >= 3 ? 5 : 1);
  }

  /// Get data for a specific flashcard
  static Map<String, dynamic> getFlashcardData(String cardId) {
    final allData = _getAllFlashcardData();
    return Map<String, dynamic>.from(allData[cardId] ?? {});
  }

  /// Get all flashcard data
  static Map<String, dynamic> _getAllFlashcardData() {
    final dataStr = _prefs?.getString(_flashcardDataKey);
    if (dataStr == null) return {};

    try {
      final Map<String, dynamic> result = {};
      final entries = dataStr.split('||');
      for (final entry in entries) {
        if (entry.isEmpty) continue;
        final parts = entry.split('::');
        if (parts.length >= 7) {
          result[parts[0]] = {
            'repetitions': int.tryParse(parts[1]) ?? 0,
            'easeFactor': double.tryParse(parts[2]) ?? 2.5,
            'interval': int.tryParse(parts[3]) ?? 1,
            'lastReview': int.tryParse(parts[4]) ?? 0,
            'nextReview': int.tryParse(parts[5]) ?? 0,
            'quality': int.tryParse(parts[6]) ?? 0,
          };
        }
      }
      return result;
    } catch (e) {
      return {};
    }
  }

  /// Save all flashcard data
  static Future<void> _saveAllFlashcardData(Map<String, dynamic> data) async {
    if (_prefs == null) await init();

    final entries = data.entries.map((e) {
      final d = e.value as Map<String, dynamic>;
      return '${e.key}::${d['repetitions']}::${d['easeFactor']}::${d['interval']}::${d['lastReview']}::${d['nextReview']}::${d['quality']}';
    }).join('||');

    await _prefs!.setString(_flashcardDataKey, entries);
  }

  /// Get cards that are due for review
  static List<String> getDueFlashcards() {
    final allData = _getAllFlashcardData();
    final now = DateTime.now().millisecondsSinceEpoch;
    final dueCards = <String>[];

    for (final entry in allData.entries) {
      final nextReview = entry.value['nextReview'] ?? 0;
      if (nextReview <= now) {
        dueCards.add(entry.key);
      }
    }

    return dueCards;
  }

  /// Get count of cards due for review
  static int getDueFlashcardsCount() {
    return getDueFlashcards().length;
  }

  /// Get total flashcards reviewed (mastery count)
  static int getTotalFlashcardsReviewed() {
    final allData = _getAllFlashcardData();
    return allData.length;
  }

  /// Get mastery level (cards with repetitions >= 3)
  static int getMasteredCardsCount() {
    final allData = _getAllFlashcardData();
    int count = 0;
    for (final entry in allData.entries) {
      final reps = entry.value['repetitions'] ?? 0;
      if (reps >= 3) count++;
    }
    return count;
  }

  /// Get review stats for display
  static Map<String, dynamic> getReviewStats() {
    final allData = _getAllFlashcardData();
    final now = DateTime.now().millisecondsSinceEpoch;

    int dueCount = 0;
    int masteredCount = 0;
    int learningCount = 0;

    for (final entry in allData.entries) {
      final nextReview = entry.value['nextReview'] ?? 0;
      final reps = entry.value['repetitions'] ?? 0;

      if (nextReview <= now) {
        dueCount++;
      }

      if (reps >= 3) {
        masteredCount++;
      } else if (reps > 0) {
        learningCount++;
      }
    }

    return {
      'total': allData.length,
      'due': dueCount,
      'mastered': masteredCount,
      'learning': learningCount,
    };
  }
}
