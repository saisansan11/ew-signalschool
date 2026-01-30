import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/progress_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('ความสำเร็จ'),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              _buildSummarySection(),
              const SizedBox(height: 24),

              // Learning Achievements
              _buildCategorySection(
                'การเรียนรู้',
                Icons.school,
                _learningAchievements,
              ),
              const SizedBox(height: 24),

              // Quiz Achievements
              _buildCategorySection(
                'แบบทดสอบ',
                Icons.quiz,
                _quizAchievements,
              ),
              const SizedBox(height: 24),

              // Special Achievements
              _buildCategorySection(
                'พิเศษ',
                Icons.star,
                _specialAchievements,
              ),
              const SizedBox(height: 24),

              // Dedication Achievements
              _buildCategorySection(
                'ความมุ่งมั่น',
                Icons.local_fire_department,
                _dedicationAchievements,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    final unlockedCount = _getAllAchievements().where((a) => a.isUnlocked).length;
    final totalCount = _getAllAchievements().length;
    final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 40),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ความสำเร็จของคุณ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$unlockedCount / $totalCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% เสร็จสมบูรณ์',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    IconData icon,
    List<Achievement> achievements,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${achievements.where((a) => a.isUnlocked).length}/${achievements.length}',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...achievements.asMap().entries.map((entry) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (entry.key * 100)),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: _buildAchievementCard(entry.value),
          );
        }),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: achievement.isUnlocked
              ? achievement.rarityColor.withAlpha(100)
              : AppColors.border,
          width: achievement.isUnlocked ? 2 : 1,
        ),
        boxShadow: achievement.isUnlocked
            ? [
                BoxShadow(
                  color: achievement.rarityColor.withAlpha(30),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showAchievementDetail(achievement),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: achievement.isUnlocked
                        ? achievement.rarityColor.withAlpha(30)
                        : AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: achievement.isUnlocked
                          ? achievement.rarityColor
                          : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    achievement.icon,
                    color: achievement.isUnlocked
                        ? achievement.rarityColor
                        : AppColors.textMuted,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              achievement.title,
                              style: TextStyle(
                                color: achievement.isUnlocked
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildRarityBadge(achievement.rarity),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.description,
                        style: TextStyle(
                          color: achievement.isUnlocked
                              ? AppColors.textSecondary
                              : AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      if (!achievement.isUnlocked && achievement.progress > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: achievement.progress,
                                  backgroundColor: AppColors.surfaceLight,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    achievement.rarityColor.withAlpha(150),
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(achievement.progress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Status
                if (achievement.isUnlocked)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.success,
                      size: 16,
                    ),
                  )
                else
                  const Icon(
                    Icons.lock_outline,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRarityBadge(AchievementRarity rarity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: rarity.color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        rarity.label,
        style: TextStyle(
          color: rarity.color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAchievementDetail(Achievement achievement) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: achievement.isUnlocked
                    ? LinearGradient(
                        colors: [
                          achievement.rarityColor,
                          achievement.rarityColor.withAlpha(150),
                        ],
                      )
                    : null,
                color: achievement.isUnlocked ? null : AppColors.surfaceLight,
                shape: BoxShape.circle,
                boxShadow: achievement.isUnlocked
                    ? [
                        BoxShadow(
                          color: achievement.rarityColor.withAlpha(60),
                          blurRadius: 20,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                achievement.icon,
                color: achievement.isUnlocked ? Colors.white : AppColors.textMuted,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              achievement.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildRarityBadge(achievement.rarity),
            const SizedBox(height: 16),
            Text(
              achievement.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'เงื่อนไข',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                      Expanded(
                        child: Text(
                          achievement.requirement,
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  if (!achievement.isUnlocked) ...[
                    const Divider(height: 24, color: AppColors.border),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ความคืบหน้า',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                        Text(
                          '${(achievement.progress * 100).toInt()}%',
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],
                  if (achievement.isUnlocked && achievement.unlockedAt != null) ...[
                    const Divider(height: 24, color: AppColors.border),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ปลดล็อกเมื่อ',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                        Text(
                          _formatDate(achievement.unlockedAt!),
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  '+${achievement.xpReward} XP',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Achievement> _getAllAchievements() {
    return [
      ..._learningAchievements,
      ..._quizAchievements,
      ..._specialAchievements,
      ..._dedicationAchievements,
    ];
  }

  // Achievement Data with progress from ProgressService
  List<Achievement> get _learningAchievements {
    final totalLessons = ProgressService.getTotalLessonsCompleted();
    final level1 = ProgressService.getLevelProgress(1);
    final level2 = ProgressService.getLevelProgress(2);
    final level3 = ProgressService.getLevelProgress(3);

    return [
      Achievement(
        id: 'first_lesson',
        title: 'ก้าวแรก',
        description: 'เรียนบทเรียนแรกสำเร็จ',
        icon: Icons.play_arrow,
        rarity: AchievementRarity.common,
        requirement: 'เรียนบทเรียนอย่างน้อย 1 บท',
        isUnlocked: totalLessons >= 1,
        progress: totalLessons >= 1 ? 1.0 : 0.0,
        xpReward: 50,
      ),
      Achievement(
        id: 'level1_complete',
        title: 'นักเรียน EW',
        description: 'จบหลักสูตรระดับพื้นฐาน',
        icon: Icons.school,
        rarity: AchievementRarity.uncommon,
        requirement: 'เรียนบทเรียนระดับ 1 ครบทุกบท',
        isUnlocked: level1 >= 1.0,
        progress: level1,
        xpReward: 100,
      ),
      Achievement(
        id: 'level2_complete',
        title: 'ผู้เชี่ยวชาญ EW',
        description: 'จบหลักสูตรระดับกลาง',
        icon: Icons.psychology,
        rarity: AchievementRarity.rare,
        requirement: 'เรียนบทเรียนระดับ 2 ครบทุกบท',
        isUnlocked: level2 >= 1.0,
        progress: level2,
        xpReward: 200,
      ),
      Achievement(
        id: 'level3_complete',
        title: 'ปรมาจารย์ EW',
        description: 'จบหลักสูตรระดับสูง',
        icon: Icons.workspace_premium,
        rarity: AchievementRarity.epic,
        requirement: 'เรียนบทเรียนระดับ 3 ครบทุกบท',
        isUnlocked: level3 >= 1.0,
        progress: level3,
        xpReward: 500,
      ),
      Achievement(
        id: 'all_lessons',
        title: 'นักวิชาการ EW',
        description: 'เรียนครบทุกบทเรียน',
        icon: Icons.auto_awesome,
        rarity: AchievementRarity.legendary,
        requirement: 'เรียนบทเรียนครบทั้ง 3 ระดับ',
        isUnlocked: level1 >= 1.0 && level2 >= 1.0 && level3 >= 1.0,
        progress: (level1 + level2 + level3) / 3,
        xpReward: 1000,
      ),
    ];
  }

  List<Achievement> get _quizAchievements {
    final quizScores = ProgressService.getQuizScorePercentages();
    final quizzesPassed = quizScores.values.where((s) => s >= 80).length;
    final perfectQuizzes = quizScores.values.where((s) => s >= 100).length;

    return [
      Achievement(
        id: 'first_quiz',
        title: 'นักทดสอบ',
        description: 'ทำแบบทดสอบแรกสำเร็จ',
        icon: Icons.quiz,
        rarity: AchievementRarity.common,
        requirement: 'ทำแบบทดสอบอย่างน้อย 1 ครั้ง',
        isUnlocked: quizScores.isNotEmpty,
        progress: quizScores.isNotEmpty ? 1.0 : 0.0,
        xpReward: 50,
      ),
      Achievement(
        id: 'quiz_pass',
        title: 'ผ่านการทดสอบ',
        description: 'ได้คะแนน 80% ขึ้นไป',
        icon: Icons.check_circle,
        rarity: AchievementRarity.uncommon,
        requirement: 'ได้คะแนนตั้งแต่ 80% ในแบบทดสอบ',
        isUnlocked: quizzesPassed >= 1,
        progress: quizzesPassed >= 1 ? 1.0 : 0.0,
        xpReward: 100,
      ),
      Achievement(
        id: 'perfect_quiz',
        title: 'คะแนนเต็ม',
        description: 'ได้ 100% ในแบบทดสอบ',
        icon: Icons.star,
        rarity: AchievementRarity.rare,
        requirement: 'ได้คะแนน 100% ในแบบทดสอบ',
        isUnlocked: perfectQuizzes >= 1,
        progress: perfectQuizzes >= 1 ? 1.0 : 0.0,
        xpReward: 200,
      ),
      Achievement(
        id: 'all_quiz_pass',
        title: 'ผู้พิชิตแบบทดสอบ',
        description: 'ผ่านแบบทดสอบทุกระดับ',
        icon: Icons.military_tech,
        rarity: AchievementRarity.epic,
        requirement: 'ได้ 80%+ ในแบบทดสอบทุกระดับ',
        isUnlocked: quizzesPassed >= 3,
        progress: quizzesPassed / 3,
        xpReward: 500,
      ),
      Achievement(
        id: 'all_perfect',
        title: 'ปราชญ์สงครามอิเล็กทรอนิกส์',
        description: 'ได้คะแนนเต็มทุกแบบทดสอบ',
        icon: Icons.emoji_events,
        rarity: AchievementRarity.legendary,
        requirement: 'ได้ 100% ในแบบทดสอบทั้งหมด',
        isUnlocked: perfectQuizzes >= 3,
        progress: perfectQuizzes / 3,
        xpReward: 1000,
      ),
    ];
  }

  List<Achievement> get _specialAchievements {
    final totalXP = ProgressService.getTotalXp();
    final stats = ProgressService.getLearningStats();
    final studyTime = stats['totalStudyTime'] ?? 0;

    return [
      Achievement(
        id: 'xp_100',
        title: 'เริ่มสะสม XP',
        description: 'สะสม XP ถึง 100',
        icon: Icons.bolt,
        rarity: AchievementRarity.common,
        requirement: 'สะสม XP รวม 100',
        isUnlocked: totalXP >= 100,
        progress: (totalXP / 100).clamp(0.0, 1.0),
        xpReward: 25,
      ),
      Achievement(
        id: 'xp_500',
        title: 'นักสะสม XP',
        description: 'สะสม XP ถึง 500',
        icon: Icons.local_fire_department,
        rarity: AchievementRarity.uncommon,
        requirement: 'สะสม XP รวม 500',
        isUnlocked: totalXP >= 500,
        progress: (totalXP / 500).clamp(0.0, 1.0),
        xpReward: 50,
      ),
      Achievement(
        id: 'xp_1000',
        title: 'ผู้พิชิต XP',
        description: 'สะสม XP ถึง 1,000',
        icon: Icons.whatshot,
        rarity: AchievementRarity.rare,
        requirement: 'สะสม XP รวม 1,000',
        isUnlocked: totalXP >= 1000,
        progress: (totalXP / 1000).clamp(0.0, 1.0),
        xpReward: 100,
      ),
      Achievement(
        id: 'study_1h',
        title: 'นักเรียนขยัน',
        description: 'เรียนรวม 1 ชั่วโมง',
        icon: Icons.timer,
        rarity: AchievementRarity.uncommon,
        requirement: 'ใช้เวลาเรียนรวม 60 นาที',
        isUnlocked: studyTime >= 60,
        progress: (studyTime / 60).clamp(0.0, 1.0),
        xpReward: 100,
      ),
      Achievement(
        id: 'study_5h',
        title: 'นักเรียนมุ่งมั่น',
        description: 'เรียนรวม 5 ชั่วโมง',
        icon: Icons.hourglass_full,
        rarity: AchievementRarity.epic,
        requirement: 'ใช้เวลาเรียนรวม 300 นาที',
        isUnlocked: studyTime >= 300,
        progress: (studyTime / 300).clamp(0.0, 1.0),
        xpReward: 500,
      ),
    ];
  }

  List<Achievement> get _dedicationAchievements {
    final stats = ProgressService.getLearningStats();
    final streak = stats['currentStreak'] ?? 0;
    final loginDays = stats['totalLoginDays'] ?? 1;

    return [
      Achievement(
        id: 'streak_3',
        title: 'เริ่มต้นความต่อเนื่อง',
        description: 'เข้าเรียนติดต่อกัน 3 วัน',
        icon: Icons.trending_up,
        rarity: AchievementRarity.common,
        requirement: 'เข้าใช้งานติดต่อกัน 3 วัน',
        isUnlocked: streak >= 3,
        progress: (streak / 3).clamp(0.0, 1.0),
        xpReward: 50,
      ),
      Achievement(
        id: 'streak_7',
        title: 'นักเรียนสม่ำเสมอ',
        description: 'เข้าเรียนติดต่อกัน 7 วัน',
        icon: Icons.calendar_month,
        rarity: AchievementRarity.uncommon,
        requirement: 'เข้าใช้งานติดต่อกัน 7 วัน',
        isUnlocked: streak >= 7,
        progress: (streak / 7).clamp(0.0, 1.0),
        xpReward: 150,
      ),
      Achievement(
        id: 'streak_30',
        title: 'ความมุ่งมั่นเหนือชั้น',
        description: 'เข้าเรียนติดต่อกัน 30 วัน',
        icon: Icons.rocket_launch,
        rarity: AchievementRarity.epic,
        requirement: 'เข้าใช้งานติดต่อกัน 30 วัน',
        isUnlocked: streak >= 30,
        progress: (streak / 30).clamp(0.0, 1.0),
        xpReward: 500,
      ),
      Achievement(
        id: 'veteran',
        title: 'ทหารผ่านศึก',
        description: 'ใช้งานแอปครบ 30 วัน',
        icon: Icons.shield,
        rarity: AchievementRarity.rare,
        requirement: 'เข้าใช้งานรวม 30 วัน',
        isUnlocked: loginDays >= 30,
        progress: (loginDays / 30).clamp(0.0, 1.0),
        xpReward: 300,
      ),
      Achievement(
        id: 'legend',
        title: 'ตำนาน EW',
        description: 'ใช้งานแอปครบ 100 วัน',
        icon: Icons.diamond,
        rarity: AchievementRarity.legendary,
        requirement: 'เข้าใช้งานรวม 100 วัน',
        isUnlocked: loginDays >= 100,
        progress: (loginDays / 100).clamp(0.0, 1.0),
        xpReward: 1000,
      ),
    ];
  }
}

// Achievement Model
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final AchievementRarity rarity;
  final String requirement;
  final bool isUnlocked;
  final double progress;
  final int xpReward;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.rarity,
    required this.requirement,
    required this.isUnlocked,
    required this.progress,
    required this.xpReward,
    this.unlockedAt,
  });

  Color get rarityColor => rarity.color;
}

// Achievement Rarity
enum AchievementRarity {
  common(Colors.grey, 'ทั่วไป'),
  uncommon(Colors.green, 'ไม่ธรรมดา'),
  rare(Colors.blue, 'หายาก'),
  epic(Colors.purple, 'มหากาพย์'),
  legendary(Colors.amber, 'ตำนาน');

  final Color color;
  final String label;

  const AchievementRarity(this.color, this.label);
}
