import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/constants.dart';
import '../data/signal_corps_data.dart';
import '../data/learning_data.dart';
import '../services/progress_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    final progress = ProgressService.instance;
    final stats = progress.getStats();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('สถิติการเรียนรู้'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Progress Card
              _buildOverallProgress(stats, progress),
              const SizedBox(height: 24),

              // Study Streak
              _buildStreakCard(stats),
              const SizedBox(height: 24),

              // Detailed Stats
              _buildDetailedStats(stats),
              const SizedBox(height: 24),

              // Learning Path Progress
              _buildLearningPathProgress(progress),
              const SizedBox(height: 24),

              // Category Progress
              _buildCategoryProgress(progress),
              const SizedBox(height: 24),

              // Due Cards Info
              _buildDueCardsInfo(progress),
              const SizedBox(height: 24),

              // Reset Button
              _buildResetButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallProgress(StudyStats stats, ProgressService progress) {
    final totalFlashcards = SignalCorpsData.flashcards.length;
    final totalUnits = SignalCorpsData.units.length;
    final overallProgress = progress.getOverallProgress(
      totalFlashcards: totalFlashcards,
      totalUnits: totalUnits,
    );

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.accent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Circular progress
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: overallProgress,
                        strokeWidth: 10,
                        backgroundColor: AppColors.surface,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                    Text(
                      '${(overallProgress * 100).round()}%',
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ความก้าวหน้าโดยรวม',
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'เรียนรู้แล้ว ${stats.flashcardsKnown} จาก $totalFlashcards การ์ด',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      'ดูแล้ว ${stats.unitsViewed} จาก $totalUnits หน่วย',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildStreakCard(StudyStats stats) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: AppColors.warning,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${stats.currentStreak}',
                      style: AppTextStyles.displayLarge.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'วัน Streak',
                      style: AppTextStyles.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  stats.currentStreak > 0
                      ? 'เข้าเรียนติดต่อกัน ${stats.currentStreak} วัน!'
                      : 'เริ่มเรียนวันนี้เพื่อสร้าง Streak!',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          // Streak badges
          Column(
            children: [
              _buildStreakBadge(3, stats.currentStreak >= 3),
              const SizedBox(height: 4),
              _buildStreakBadge(7, stats.currentStreak >= 7),
              const SizedBox(height: 4),
              _buildStreakBadge(30, stats.currentStreak >= 30),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildStreakBadge(int days, bool achieved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: achieved
            ? AppColors.warning.withValues(alpha: 0.2)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        border: Border.all(
          color: achieved ? AppColors.warning : AppColors.border,
        ),
      ),
      child: Text(
        '$days',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: achieved ? AppColors.warning : AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildDetailedStats(StudyStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('สถิติรายละเอียด', style: AppTextStyles.titleLarge),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.style,
                label: 'Flashcard ที่เรียน',
                value: '${stats.totalFlashcardsStudied}',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                icon: Icons.check_circle,
                label: 'จำได้แล้ว',
                value: '${stats.flashcardsKnown}',
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.quiz,
                label: 'Quiz ที่ทำ',
                value: '${stats.quizzesTaken}',
                color: AppColors.accentOrange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                icon: Icons.percent,
                label: 'คะแนนเฉลี่ย',
                value: '${stats.averageQuizScore.round()}%',
                color: AppColors.accentPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.visibility,
                label: 'หน่วยที่ดู',
                value: '${stats.unitsViewed}',
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                icon: Icons.psychology,
                label: 'อัตราความจำ',
                value: '${(stats.masteryRate * 100).round()}%',
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildLearningPathProgress(ProgressService progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('เส้นทางการเรียนรู้', style: AppTextStyles.titleLarge),
        const SizedBox(height: 16),
        ...LearningData.learningPaths.map((path) {
          final pathProgress = progress.getPathProgress(path.id);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(path.title, style: AppTextStyles.titleMedium),
                    ),
                    Text(
                      '${(pathProgress * 100).round()}%',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: pathProgress >= 1
                            ? AppColors.success
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  child: LinearProgressIndicator(
                    value: pathProgress,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation(
                      pathProgress >= 1 ? AppColors.success : AppColors.primary,
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${path.lessons.length} บทเรียน • ${path.totalMinutes} นาที',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          );
        }),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildCategoryProgress(ProgressService progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('หมวดหมู่ Flashcard', style: AppTextStyles.titleLarge),
        const SizedBox(height: 16),
        ...SignalCorpsData.flashcardCategories.map((category) {
          final cards = SignalCorpsData.getFlashcardsByCategory(category);
          final knownCount = cards.where((c) => progress.isFlashcardKnown(c.id)).length;
          final progressValue = cards.isNotEmpty ? knownCount / cards.length : 0.0;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    category,
                    style: AppTextStyles.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$knownCount/${cards.length}',
                  style: AppTextStyles.labelMedium,
                ),
              ],
            ),
          );
        }),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildDueCardsInfo(ProgressService progress) {
    final allCardIds = SignalCorpsData.flashcards.map((c) => c.id).toList();
    final dueCards = progress.getDueCards(allCardIds);

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: dueCards.isNotEmpty
            ? AppColors.warning.withValues(alpha: 0.1)
            : AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: dueCards.isNotEmpty
              ? AppColors.warning.withValues(alpha: 0.3)
              : AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            dueCards.isNotEmpty ? Icons.schedule : Icons.check_circle,
            color: dueCards.isNotEmpty ? AppColors.warning : AppColors.success,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dueCards.isNotEmpty
                      ? 'มีการ์ดที่ต้องทบทวน'
                      : 'ทบทวนครบแล้ว!',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: dueCards.isNotEmpty ? AppColors.warning : AppColors.success,
                  ),
                ),
                Text(
                  dueCards.isNotEmpty
                      ? '${dueCards.length} การ์ดรอการทบทวน'
                      : 'ไม่มีการ์ดที่ต้องทบทวนในตอนนี้',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  Widget _buildResetButton() {
    return Center(
      child: TextButton.icon(
        onPressed: () => _showResetConfirmation(),
        icon: const Icon(Icons.delete_outline, color: AppColors.error),
        label: const Text(
          'รีเซ็ตความก้าวหน้าทั้งหมด',
          style: TextStyle(color: AppColors.error),
        ),
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('รีเซ็ตความก้าวหน้า?'),
        content: const Text(
          'การดำเนินการนี้จะลบข้อมูลการเรียนรู้ทั้งหมด รวมถึง Streak, รางวัล และสถิติทั้งหมด',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ProgressService.instance.resetProgress();
              if (mounted) {
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('รีเซ็ตความก้าวหน้าเรียบร้อยแล้ว')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('รีเซ็ต'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.titleLarge.copyWith(color: color),
                ),
                Text(
                  label,
                  style: AppTextStyles.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
