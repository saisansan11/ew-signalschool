/// Learning Path and Objectives Models for Educational App

/// Learning objective with SMART format
class LearningObjective {
  final String id;
  final String description;
  final String category;
  final int targetScore; // Minimum score to pass (percentage)
  final int estimatedMinutes;

  const LearningObjective({
    required this.id,
    required this.description,
    required this.category,
    this.targetScore = 70,
    this.estimatedMinutes = 10,
  });
}

/// A lesson within a learning path
class Lesson {
  final String id;
  final String title;
  final String description;
  final LessonType type;
  final String category;
  final int order;
  final List<String> prerequisites; // Lesson IDs that must be completed first
  final LearningObjective objective;
  final int estimatedMinutes;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.order,
    required this.objective,
    this.prerequisites = const [],
    this.estimatedMinutes = 10,
  });
}

enum LessonType {
  flashcard,
  quiz,
  reading,
  interactive,
}

/// Learning path with structured progression
class LearningPath {
  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;
  final int totalMinutes;
  final PathDifficulty difficulty;

  const LearningPath({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    required this.totalMinutes,
    this.difficulty = PathDifficulty.beginner,
  });

  /// Get available lessons based on completed lessons
  List<Lesson> getAvailableLessons(List<String> completedLessonIds) {
    return lessons.where((lesson) {
      // Check if all prerequisites are completed
      return lesson.prerequisites.every(
        (prereq) => completedLessonIds.contains(prereq),
      );
    }).toList();
  }

  /// Get next recommended lesson
  Lesson? getNextLesson(List<String> completedLessonIds) {
    final available = getAvailableLessons(completedLessonIds);
    final incomplete = available.where(
      (lesson) => !completedLessonIds.contains(lesson.id),
    );
    return incomplete.isEmpty ? null : incomplete.first;
  }

  /// Calculate progress percentage
  double getProgress(List<String> completedLessonIds) {
    if (lessons.isEmpty) return 0;
    final completed = lessons.where(
      (lesson) => completedLessonIds.contains(lesson.id),
    ).length;
    return completed / lessons.length;
  }
}

enum PathDifficulty {
  beginner,
  intermediate,
  advanced,
}

/// Achievement/Badge definition
class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementTier tier;
  final AchievementType type;
  final int requirement; // e.g., 10 flashcards, 5 quizzes, 7 day streak

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tier,
    required this.type,
    required this.requirement,
  });
}

enum AchievementTier {
  bronze,
  silver,
  gold,
  platinum,
}

enum AchievementType {
  flashcardsCompleted,
  quizzesPassed,
  streakDays,
  unitsViewed,
  perfectQuiz,
  masteryRate,
}

/// Spaced Repetition card data
class SpacedRepetitionCard {
  final String cardId;
  int repetitions;
  double easeFactor;
  int interval; // days until next review
  DateTime? nextReviewDate;
  DateTime? lastReviewDate;

  SpacedRepetitionCard({
    required this.cardId,
    this.repetitions = 0,
    this.easeFactor = 2.5,
    this.interval = 1,
    this.nextReviewDate,
    this.lastReviewDate,
  });

  /// SM-2 Algorithm implementation
  /// quality: 0-5 (0=complete blackout, 5=perfect response)
  void updateWithQuality(int quality) {
    lastReviewDate = DateTime.now();

    if (quality < 3) {
      // Failed recall - reset
      repetitions = 0;
      interval = 1;
    } else {
      // Successful recall
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

    // Set next review date
    nextReviewDate = DateTime.now().add(Duration(days: interval));
  }

  /// Check if card is due for review
  bool isDue() {
    if (nextReviewDate == null) return true;
    return DateTime.now().isAfter(nextReviewDate!);
  }

  Map<String, dynamic> toJson() => {
    'cardId': cardId,
    'repetitions': repetitions,
    'easeFactor': easeFactor,
    'interval': interval,
    'nextReviewDate': nextReviewDate?.toIso8601String(),
    'lastReviewDate': lastReviewDate?.toIso8601String(),
  };

  factory SpacedRepetitionCard.fromJson(Map<String, dynamic> json) {
    return SpacedRepetitionCard(
      cardId: json['cardId'],
      repetitions: json['repetitions'] ?? 0,
      easeFactor: (json['easeFactor'] ?? 2.5).toDouble(),
      interval: json['interval'] ?? 1,
      nextReviewDate: json['nextReviewDate'] != null
          ? DateTime.parse(json['nextReviewDate'])
          : null,
      lastReviewDate: json['lastReviewDate'] != null
          ? DateTime.parse(json['lastReviewDate'])
          : null,
    );
  }
}

/// Adaptive quiz state
class AdaptiveQuizState {
  int consecutiveCorrect;
  int consecutiveWrong;
  int currentDifficulty; // 1-3
  List<int> recentResults; // Last 5 results (1=correct, 0=wrong)

  AdaptiveQuizState({
    this.consecutiveCorrect = 0,
    this.consecutiveWrong = 0,
    this.currentDifficulty = 2,
    List<int>? recentResults,
  }) : recentResults = recentResults ?? [];

  void recordAnswer(bool correct) {
    if (correct) {
      consecutiveCorrect++;
      consecutiveWrong = 0;
    } else {
      consecutiveWrong++;
      consecutiveCorrect = 0;
    }

    recentResults.add(correct ? 1 : 0);
    if (recentResults.length > 5) {
      recentResults.removeAt(0);
    }

    _adjustDifficulty();
  }

  void _adjustDifficulty() {
    // Increase difficulty after 3 consecutive correct
    if (consecutiveCorrect >= 3 && currentDifficulty < 3) {
      currentDifficulty++;
      consecutiveCorrect = 0;
    }

    // Decrease difficulty after 2 consecutive wrong
    if (consecutiveWrong >= 2 && currentDifficulty > 1) {
      currentDifficulty--;
      consecutiveWrong = 0;
    }
  }

  double get recentAccuracy {
    if (recentResults.isEmpty) return 0.5;
    return recentResults.reduce((a, b) => a + b) / recentResults.length;
  }
}
