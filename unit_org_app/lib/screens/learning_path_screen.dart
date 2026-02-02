import 'package:flutter/material.dart';
import '../app/constants.dart';
import '../models/learning_models.dart';
import '../data/learning_data.dart';
import '../services/progress_service.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';

class LearningPathScreen extends StatefulWidget {
  const LearningPathScreen({super.key});

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('เส้นทางการเรียนรู้'),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          itemCount: LearningData.learningPaths.length,
          itemBuilder: (context, index) {
            final path = LearningData.learningPaths[index];
            return _LearningPathCard(
              path: path,
              onTap: () => _openPath(path),
            );
          },
        ),
      ),
    );
  }

  void _openPath(LearningPath path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PathDetailScreen(path: path),
      ),
    );
  }
}

class _LearningPathCard extends StatelessWidget {
  final LearningPath path;
  final VoidCallback onTap;

  const _LearningPathCard({
    required this.path,
    required this.onTap,
  });

  Color get _difficultyColor {
    switch (path.difficulty) {
      case PathDifficulty.beginner:
        return AppColors.success;
      case PathDifficulty.intermediate:
        return AppColors.warning;
      case PathDifficulty.advanced:
        return AppColors.error;
    }
  }

  String get _difficultyText {
    switch (path.difficulty) {
      case PathDifficulty.beginner:
        return 'เริ่มต้น';
      case PathDifficulty.intermediate:
        return 'กลาง';
      case PathDifficulty.advanced:
        return 'สูง';
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ProgressService.instance.getPathProgress(path.id);
    final isCompleted = progress >= 1.0;

    return Semantics(
      label: '${path.title}: ${path.description}. ระดับ $_difficultyText. ความคืบหน้า ${(progress * 100).round()}%',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(
              color: isCompleted ? AppColors.success : AppColors.border,
              width: isCompleted ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Path icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _difficultyColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    child: Icon(
                      _getPathIcon(),
                      color: _difficultyColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(path.title, style: AppTextStyles.titleLarge),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _difficultyColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(AppSizes.radiusS),
                              ),
                              child: Text(
                                _difficultyText,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: _difficultyColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${path.totalMinutes} นาที',
                              style: AppTextStyles.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 28,
                    )
                  else
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textMuted,
                      size: 16,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                path.description,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.surfaceLight,
                        valueColor: AlwaysStoppedAnimation(
                          isCompleted ? AppColors.success : AppColors.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(progress * 100).round()}%',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isCompleted ? AppColors.success : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${path.lessons.length} บทเรียน',
                style: AppTextStyles.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPathIcon() {
    switch (path.difficulty) {
      case PathDifficulty.beginner:
        return Icons.school;
      case PathDifficulty.intermediate:
        return Icons.trending_up;
      case PathDifficulty.advanced:
        return Icons.military_tech;
    }
  }
}

class _PathDetailScreen extends StatefulWidget {
  final LearningPath path;

  const _PathDetailScreen({required this.path});

  @override
  State<_PathDetailScreen> createState() => _PathDetailScreenState();
}

class _PathDetailScreenState extends State<_PathDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final progress = ProgressService.instance;
    final completedLessons = progress.completedLessons;
    final nextLesson = widget.path.getNextLesson(completedLessons.toList());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.path.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with objective
            _buildHeader(nextLesson),

            // Lessons list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                itemCount: widget.path.lessons.length,
                itemBuilder: (context, index) {
                  final lesson = widget.path.lessons[index];
                  final isCompleted = completedLessons.contains(lesson.id);
                  final isAvailable = lesson.prerequisites.every(
                    (prereq) => completedLessons.contains(prereq),
                  );
                  final isNext = lesson.id == nextLesson?.id;

                  return _LessonCard(
                    lesson: lesson,
                    index: index + 1,
                    isCompleted: isCompleted,
                    isAvailable: isAvailable,
                    isNext: isNext,
                    score: progress.getLessonScore(lesson.id),
                    onTap: isAvailable ? () => _startLesson(lesson) : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Lesson? nextLesson) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.accent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('วัตถุประสงค์การเรียนรู้', style: AppTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          if (nextLesson != null) ...[
            Text(
              nextLesson.objective.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${nextLesson.objective.estimatedMinutes} นาที',
                  style: AppTextStyles.labelSmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.check_circle_outline, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  'ผ่าน ${nextLesson.objective.targetScore}%',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ] else
            Text(
              'คุณเรียนจบเส้นทางนี้แล้ว!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.success,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _startLesson(Lesson lesson) async {
    Widget screen;

    switch (lesson.type) {
      case LessonType.flashcard:
        screen = FlashcardScreen(category: lesson.category);
        break;
      case LessonType.quiz:
        screen = QuizScreen(category: lesson.category);
        break;
      default:
        screen = FlashcardScreen(category: lesson.category);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    // Refresh state after returning
    setState(() {});
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final bool isCompleted;
  final bool isAvailable;
  final bool isNext;
  final int? score;
  final VoidCallback? onTap;

  const _LessonCard({
    required this.lesson,
    required this.index,
    required this.isCompleted,
    required this.isAvailable,
    required this.isNext,
    this.score,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'บทที่ $index: ${lesson.title}. ${isCompleted ? "เสร็จสิ้นแล้ว" : isAvailable ? "พร้อมเรียน" : "ยังไม่ปลดล็อค"}',
      button: isAvailable,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // Timeline dot and line
              Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.success
                          : isNext
                              ? AppColors.primary
                              : isAvailable
                                  ? AppColors.surface
                                  : AppColors.surfaceLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.success
                            : isNext
                                ? AppColors.primary
                                : AppColors.border,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : Text(
                              '$index',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: isNext
                                    ? Colors.white
                                    : isAvailable
                                        ? AppColors.textPrimary
                                        : AppColors.textMuted,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Lesson content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  decoration: BoxDecoration(
                    color: isNext
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    border: Border.all(
                      color: isNext ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getLessonIcon(),
                        color: isAvailable ? AppColors.primary : AppColors.textMuted,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.title,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: isAvailable
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 12,
                                  color: AppColors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${lesson.estimatedMinutes} นาที',
                                  style: AppTextStyles.labelSmall,
                                ),
                                if (score != null) ...[
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.star,
                                    size: 12,
                                    color: AppColors.warning,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$score%',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.warning,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!isAvailable)
                        const Icon(
                          Icons.lock,
                          color: AppColors.textMuted,
                          size: 20,
                        )
                      else if (isNext)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppSizes.radiusS),
                          ),
                          child: const Text(
                            'เริ่ม',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getLessonIcon() {
    switch (lesson.type) {
      case LessonType.flashcard:
        return Icons.style;
      case LessonType.quiz:
        return Icons.quiz;
      case LessonType.reading:
        return Icons.menu_book;
      case LessonType.interactive:
        return Icons.touch_app;
    }
  }
}
