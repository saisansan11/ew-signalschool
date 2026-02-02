/// Learning Paths, Objectives, and Achievements Data

import '../models/learning_models.dart';

class LearningData {
  // ============ LEARNING OBJECTIVES ============

  static const objectives = <String, LearningObjective>{
    'obj_unit_basics': LearningObjective(
      id: 'obj_unit_basics',
      description: 'เข้าใจโครงสร้างพื้นฐานของกองร้อยทหารสื่อสาร',
      category: 'กองร้อยสื่อสาร',
      targetScore: 70,
      estimatedMinutes: 15,
    ),
    'obj_platoon_structure': LearningObjective(
      id: 'obj_platoon_structure',
      description: 'อธิบายหน้าที่และอุปกรณ์ของหมวดต่างๆ ได้',
      category: 'หมวดทหารสื่อสาร',
      targetScore: 70,
      estimatedMinutes: 20,
    ),
    'obj_radio_platoon': LearningObjective(
      id: 'obj_radio_platoon',
      description: 'เข้าใจการปฏิบัติงานของหมวดวิทยุ',
      category: 'หมวดวิทยุ',
      targetScore: 75,
      estimatedMinutes: 15,
    ),
    'obj_wire_platoon': LearningObjective(
      id: 'obj_wire_platoon',
      description: 'เข้าใจการวางสายและตู้สาขาโทรศัพท์',
      category: 'หมวดสาย',
      targetScore: 75,
      estimatedMinutes: 15,
    ),
    'obj_equipment': LearningObjective(
      id: 'obj_equipment',
      description: 'จำแนกอุปกรณ์สื่อสารตามประเภทและหน้าที่',
      category: 'อุปกรณ์สื่อสาร',
      targetScore: 80,
      estimatedMinutes: 20,
    ),
    'obj_signal_battalion': LearningObjective(
      id: 'obj_signal_battalion',
      description: 'เข้าใจโครงสร้างกองพันทหารสื่อสาร',
      category: 'กองพันทหารสื่อสาร',
      targetScore: 75,
      estimatedMinutes: 15,
    ),
  };

  // ============ LEARNING PATHS ============

  static final List<LearningPath> learningPaths = [
    // Path 1: Basic Signal Corps
    LearningPath(
      id: 'path_basic',
      title: 'พื้นฐานทหารสื่อสาร',
      description: 'เรียนรู้โครงสร้างและหน้าที่พื้นฐานของหน่วยทหารสื่อสาร',
      difficulty: PathDifficulty.beginner,
      totalMinutes: 45,
      lessons: [
        Lesson(
          id: 'lesson_intro',
          title: 'รู้จักกองร้อยสื่อสาร',
          description: 'เรียนรู้โครงสร้างพื้นฐานของกองร้อยทหารสื่อสาร',
          type: LessonType.flashcard,
          category: 'กองร้อยสื่อสาร',
          order: 1,
          objective: objectives['obj_unit_basics']!,
          estimatedMinutes: 10,
        ),
        Lesson(
          id: 'lesson_intro_quiz',
          title: 'ทดสอบ: กองร้อยสื่อสาร',
          description: 'ทดสอบความเข้าใจเรื่องกองร้อยสื่อสาร',
          type: LessonType.quiz,
          category: 'กองร้อยสื่อสาร',
          order: 2,
          prerequisites: ['lesson_intro'],
          objective: objectives['obj_unit_basics']!,
          estimatedMinutes: 10,
        ),
        Lesson(
          id: 'lesson_platoons',
          title: 'หมวดในกองร้อยสื่อสาร',
          description: 'เรียนรู้หมวดต่างๆ และหน้าที่',
          type: LessonType.flashcard,
          category: 'หมวดทหารสื่อสาร',
          order: 3,
          prerequisites: ['lesson_intro_quiz'],
          objective: objectives['obj_platoon_structure']!,
          estimatedMinutes: 15,
        ),
        Lesson(
          id: 'lesson_platoons_quiz',
          title: 'ทดสอบ: หมวดทหารสื่อสาร',
          description: 'ทดสอบความเข้าใจเรื่องหมวดต่างๆ',
          type: LessonType.quiz,
          category: 'หมวดทหารสื่อสาร',
          order: 4,
          prerequisites: ['lesson_platoons'],
          objective: objectives['obj_platoon_structure']!,
          estimatedMinutes: 10,
        ),
      ],
    ),

    // Path 2: Radio Operations
    LearningPath(
      id: 'path_radio',
      title: 'การปฏิบัติงานวิทยุ',
      description: 'เรียนรู้การใช้งานวิทยุสื่อสารแบบต่างๆ',
      difficulty: PathDifficulty.intermediate,
      totalMinutes: 40,
      lessons: [
        Lesson(
          id: 'lesson_radio_basics',
          title: 'พื้นฐานวิทยุสื่อสาร',
          description: 'เรียนรู้ประเภทและหลักการของวิทยุ',
          type: LessonType.flashcard,
          category: 'หมวดวิทยุ',
          order: 1,
          objective: objectives['obj_radio_platoon']!,
          estimatedMinutes: 15,
        ),
        Lesson(
          id: 'lesson_radio_equipment',
          title: 'อุปกรณ์วิทยุสื่อสาร',
          description: 'รู้จักอุปกรณ์วิทยุ HF, VHF, UHF',
          type: LessonType.flashcard,
          category: 'อุปกรณ์สื่อสาร',
          order: 2,
          prerequisites: ['lesson_radio_basics'],
          objective: objectives['obj_equipment']!,
          estimatedMinutes: 15,
        ),
        Lesson(
          id: 'lesson_radio_quiz',
          title: 'ทดสอบ: วิทยุสื่อสาร',
          description: 'ทดสอบความรู้เรื่องวิทยุ',
          type: LessonType.quiz,
          category: 'หมวดวิทยุ',
          order: 3,
          prerequisites: ['lesson_radio_equipment'],
          objective: objectives['obj_radio_platoon']!,
          estimatedMinutes: 10,
        ),
      ],
    ),

    // Path 3: Wire Communications
    LearningPath(
      id: 'path_wire',
      title: 'การสื่อสารทางสาย',
      description: 'เรียนรู้ระบบสายและโทรศัพท์สนาม',
      difficulty: PathDifficulty.intermediate,
      totalMinutes: 35,
      lessons: [
        Lesson(
          id: 'lesson_wire_basics',
          title: 'พื้นฐานการสื่อสารทางสาย',
          description: 'เรียนรู้ระบบสายและการวางสาย',
          type: LessonType.flashcard,
          category: 'หมวดสาย',
          order: 1,
          objective: objectives['obj_wire_platoon']!,
          estimatedMinutes: 15,
        ),
        Lesson(
          id: 'lesson_wire_equipment',
          title: 'อุปกรณ์สายและตู้สาขา',
          description: 'รู้จักสายสนาม ตู้สาขา โทรศัพท์สนาม',
          type: LessonType.flashcard,
          category: 'อุปกรณ์สื่อสาร',
          order: 2,
          prerequisites: ['lesson_wire_basics'],
          objective: objectives['obj_equipment']!,
          estimatedMinutes: 10,
        ),
        Lesson(
          id: 'lesson_wire_quiz',
          title: 'ทดสอบ: การสื่อสารทางสาย',
          description: 'ทดสอบความรู้เรื่องสาย',
          type: LessonType.quiz,
          category: 'หมวดสาย',
          order: 3,
          prerequisites: ['lesson_wire_equipment'],
          objective: objectives['obj_wire_platoon']!,
          estimatedMinutes: 10,
        ),
      ],
    ),

    // Path 4: Advanced - Signal Battalion
    LearningPath(
      id: 'path_battalion',
      title: 'กองพันทหารสื่อสาร',
      description: 'เรียนรู้โครงสร้างระดับกองพัน',
      difficulty: PathDifficulty.advanced,
      totalMinutes: 30,
      lessons: [
        Lesson(
          id: 'lesson_battalion_structure',
          title: 'โครงสร้างกองพันสื่อสาร',
          description: 'เรียนรู้การจัดหน่วยระดับกองพัน',
          type: LessonType.flashcard,
          category: 'กองพันทหารสื่อสาร',
          order: 1,
          objective: objectives['obj_signal_battalion']!,
          estimatedMinutes: 15,
        ),
        Lesson(
          id: 'lesson_battalion_quiz',
          title: 'ทดสอบ: กองพันสื่อสาร',
          description: 'ทดสอบความรู้ระดับกองพัน',
          type: LessonType.quiz,
          category: 'กองพันทหารสื่อสาร',
          order: 2,
          prerequisites: ['lesson_battalion_structure'],
          objective: objectives['obj_signal_battalion']!,
          estimatedMinutes: 15,
        ),
      ],
    ),
  ];

  // ============ ACHIEVEMENTS ============

  static const List<Achievement> achievements = [
    // Flashcard Achievements
    Achievement(
      id: 'ach_first_card',
      title: 'เริ่มต้นการเรียนรู้',
      description: 'ทบทวน Flashcard ครั้งแรก',
      icon: '🎯',
      tier: AchievementTier.bronze,
      type: AchievementType.flashcardsCompleted,
      requirement: 1,
    ),
    Achievement(
      id: 'ach_10_cards',
      title: 'นักเรียนขยัน',
      description: 'ทบทวน Flashcard 10 ใบ',
      icon: '📚',
      tier: AchievementTier.bronze,
      type: AchievementType.flashcardsCompleted,
      requirement: 10,
    ),
    Achievement(
      id: 'ach_50_cards',
      title: 'ผู้เชี่ยวชาญ Flashcard',
      description: 'ทบทวน Flashcard 50 ใบ',
      icon: '🏆',
      tier: AchievementTier.silver,
      type: AchievementType.flashcardsCompleted,
      requirement: 50,
    ),
    Achievement(
      id: 'ach_100_cards',
      title: 'ราชา Flashcard',
      description: 'ทบทวน Flashcard 100 ใบ',
      icon: '👑',
      tier: AchievementTier.gold,
      type: AchievementType.flashcardsCompleted,
      requirement: 100,
    ),

    // Quiz Achievements
    Achievement(
      id: 'ach_first_quiz',
      title: 'นักสอบมือใหม่',
      description: 'ทำ Quiz ผ่านครั้งแรก',
      icon: '✅',
      tier: AchievementTier.bronze,
      type: AchievementType.quizzesPassed,
      requirement: 1,
    ),
    Achievement(
      id: 'ach_5_quizzes',
      title: 'นักสอบมืออาชีพ',
      description: 'ทำ Quiz ผ่าน 5 ครั้ง',
      icon: '🎓',
      tier: AchievementTier.silver,
      type: AchievementType.quizzesPassed,
      requirement: 5,
    ),
    Achievement(
      id: 'ach_perfect_quiz',
      title: 'คะแนนเต็ม!',
      description: 'ทำ Quiz ได้ 100%',
      icon: '💯',
      tier: AchievementTier.gold,
      type: AchievementType.perfectQuiz,
      requirement: 1,
    ),

    // Streak Achievements
    Achievement(
      id: 'ach_3_streak',
      title: 'เรียนต่อเนื่อง 3 วัน',
      description: 'เข้าเรียนติดต่อกัน 3 วัน',
      icon: '🔥',
      tier: AchievementTier.bronze,
      type: AchievementType.streakDays,
      requirement: 3,
    ),
    Achievement(
      id: 'ach_7_streak',
      title: 'นักรบ 7 วัน',
      description: 'เข้าเรียนติดต่อกัน 7 วัน',
      icon: '⚡',
      tier: AchievementTier.silver,
      type: AchievementType.streakDays,
      requirement: 7,
    ),
    Achievement(
      id: 'ach_30_streak',
      title: 'ผู้พิชิตเดือน',
      description: 'เข้าเรียนติดต่อกัน 30 วัน',
      icon: '🌟',
      tier: AchievementTier.platinum,
      type: AchievementType.streakDays,
      requirement: 30,
    ),

    // Unit Viewing Achievements
    Achievement(
      id: 'ach_5_units',
      title: 'นักสำรวจ',
      description: 'ดูหน่วยต่างๆ 5 หน่วย',
      icon: '🔍',
      tier: AchievementTier.bronze,
      type: AchievementType.unitsViewed,
      requirement: 5,
    ),
    Achievement(
      id: 'ach_all_units',
      title: 'ผู้รู้ทุกหน่วย',
      description: 'ดูหน่วยทั้งหมดในระบบ',
      icon: '🗺️',
      tier: AchievementTier.gold,
      type: AchievementType.unitsViewed,
      requirement: 15,
    ),

    // Mastery Achievement
    Achievement(
      id: 'ach_mastery_80',
      title: 'ผู้เชี่ยวชาญ',
      description: 'มีอัตราการจำ Flashcard 80%+',
      icon: '🧠',
      tier: AchievementTier.gold,
      type: AchievementType.masteryRate,
      requirement: 80,
    ),
  ];

  /// Get achievements for a specific type
  static List<Achievement> getAchievementsByType(AchievementType type) {
    return achievements.where((a) => a.type == type).toList();
  }

  /// Get achievement by ID
  static Achievement? getAchievementById(String id) {
    try {
      return achievements.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get learning path by ID
  static LearningPath? getPathById(String id) {
    try {
      return learningPaths.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get all lessons across all paths
  static List<Lesson> getAllLessons() {
    return learningPaths.expand((p) => p.lessons).toList();
  }

  /// Get lesson by ID
  static Lesson? getLessonById(String id) {
    for (final path in learningPaths) {
      for (final lesson in path.lessons) {
        if (lesson.id == id) return lesson;
      }
    }
    return null;
  }
}
