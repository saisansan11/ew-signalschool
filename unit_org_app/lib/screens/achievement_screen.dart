import 'package:flutter/material.dart';
import '../app/constants.dart';
import '../models/learning_models.dart';
import '../data/learning_data.dart';
import '../services/progress_service.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  @override
  Widget build(BuildContext context) {
    final progress = ProgressService.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('รางวัลและความสำเร็จ'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats summary
              _buildStatsSummary(progress),
              const SizedBox(height: 24),

              // Achievement sections
              _buildSection(
                'Flashcard',
                LearningData.getAchievementsByType(AchievementType.flashcardsCompleted),
                progress,
              ),
              _buildSection(
                'Quiz',
                [
                  ...LearningData.getAchievementsByType(AchievementType.quizzesPassed),
                  ...LearningData.getAchievementsByType(AchievementType.perfectQuiz),
                ],
                progress,
              ),
              _buildSection(
                'Streak',
                LearningData.getAchievementsByType(AchievementType.streakDays),
                progress,
              ),
              _buildSection(
                'การสำรวจ',
                [
                  ...LearningData.getAchievementsByType(AchievementType.unitsViewed),
                  ...LearningData.getAchievementsByType(AchievementType.masteryRate),
                ],
                progress,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSummary(ProgressService progress) {
    final stats = progress.getStats();
    final unlockedCount = progress.unlockedAchievements.length;
    final totalCount = LearningData.achievements.length;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.2),
            AppColors.accent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: AppColors.warning, size: 32),
              const SizedBox(width: 12),
              Text(
                '$unlockedCount / $totalCount',
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              const Text('รางวัล', style: AppTextStyles.bodyLarge),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            child: LinearProgressIndicator(
              value: totalCount > 0 ? unlockedCount / totalCount : 0,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation(AppColors.warning),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          // Quick stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickStat(
                icon: Icons.local_fire_department,
                value: '${stats.currentStreak}',
                label: 'วัน Streak',
                color: AppColors.error,
              ),
              _QuickStat(
                icon: Icons.style,
                value: '${stats.totalFlashcardsStudied}',
                label: 'Flashcard',
                color: AppColors.primary,
              ),
              _QuickStat(
                icon: Icons.quiz,
                value: '${stats.quizzesTaken}',
                label: 'Quiz',
                color: AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Achievement> achievements, ProgressService progress) {
    if (achievements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(title, style: AppTextStyles.titleLarge),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            return _AchievementCard(
              achievement: achievements[index],
              isUnlocked: progress.isAchievementUnlocked(achievements[index].id),
              progressValue: progress.getAchievementProgress(achievements[index]),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _QuickStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(color: color),
        ),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;
  final double progressValue;

  const _AchievementCard({
    required this.achievement,
    required this.isUnlocked,
    required this.progressValue,
  });

  Color get _tierColor {
    switch (achievement.tier) {
      case AchievementTier.bronze:
        return const Color(0xFFCD7F32);
      case AchievementTier.silver:
        return const Color(0xFFC0C0C0);
      case AchievementTier.gold:
        return const Color(0xFFFFD700);
      case AchievementTier.platinum:
        return const Color(0xFFE5E4E2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${achievement.title}: ${achievement.description}. ${isUnlocked ? "ปลดล็อคแล้ว" : "ยังไม่ปลดล็อค"}, ความคืบหน้า ${(progressValue * 100).round()}%',
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: isUnlocked
              ? _tierColor.withOpacity(0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(
            color: isUnlocked ? _tierColor : AppColors.border,
            width: isUnlocked ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? _tierColor.withOpacity(0.2)
                    : AppColors.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: TextStyle(
                    fontSize: 24,
                    color: isUnlocked ? null : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              achievement.title,
              style: AppTextStyles.titleMedium.copyWith(
                color: isUnlocked ? _tierColor : AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              achievement.description,
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Progress bar
            if (!isUnlocked)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(_tierColor.withOpacity(0.7)),
                  minHeight: 4,
                ),
              )
            else
              Icon(Icons.check_circle, color: _tierColor, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Dialog to show when achievement is unlocked
class AchievementUnlockedDialog extends StatelessWidget {
  final Achievement achievement;

  const AchievementUnlockedDialog({super.key, required this.achievement});

  Color get _tierColor {
    switch (achievement.tier) {
      case AchievementTier.bronze:
        return const Color(0xFFCD7F32);
      case AchievementTier.silver:
        return const Color(0xFFC0C0C0);
      case AchievementTier.gold:
        return const Color(0xFFFFD700);
      case AchievementTier.platinum:
        return const Color(0xFFE5E4E2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          border: Border.all(color: _tierColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: _tierColor.withOpacity(0.3),
              blurRadius: 24,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉 รางวัลใหม่!',
              style: AppTextStyles.headlineLarge,
            ),
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _tierColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: _tierColor, width: 3),
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              achievement.title,
              style: AppTextStyles.titleLarge.copyWith(color: _tierColor),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _tierColor,
                foregroundColor: Colors.black,
              ),
              child: const Text('เยี่ยมมาก!'),
            ),
          ],
        ),
      ),
    );
  }
}
