import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/progress_service.dart';
import '../../services/theme_provider.dart';

class StudyGoalsScreen extends StatefulWidget {
  const StudyGoalsScreen({super.key});

  @override
  State<StudyGoalsScreen> createState() => _StudyGoalsScreenState();
}

class _StudyGoalsScreenState extends State<StudyGoalsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Weekly goals (in a real app, these would be persisted)
  int _weeklyXpGoal = 500;
  int _weeklyLessonsGoal = 5;
  int _weeklyQuizzesGoal = 3;
  int _weeklyStudyMinutesGoal = 60;

  // Current progress (from ProgressService)
  int _currentWeeklyXp = 0;
  int _currentWeeklyLessons = 0;
  int _currentWeeklyQuizzes = 0;
  int _currentWeeklyMinutes = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
    _loadProgress();
  }

  void _loadProgress() {
    final stats = ProgressService.getLearningStats();
    setState(() {
      _currentWeeklyXp = stats['totalXp'] ?? 0;
      _currentWeeklyLessons = stats['lessonsCompleted'] ?? 0;
      _currentWeeklyQuizzes = stats['quizzesCompleted'] ?? 0;
      _currentWeeklyMinutes = stats['totalStudyTime'] ?? 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: const Text('เป้าหมายการเรียน'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _showEditGoalsDialog,
              ),
            ],
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weekly Summary Card
                  _buildWeeklySummaryCard(isDark),
                  const SizedBox(height: 24),

                  // Goals Progress
                  _buildSectionTitle('เป้าหมายประจำสัปดาห์', isDark),
                  const SizedBox(height: 12),
                  _buildGoalCard(
                    icon: Icons.stars,
                    title: 'XP สะสม',
                    current: _currentWeeklyXp,
                    target: _weeklyXpGoal,
                    unit: 'XP',
                    color: Colors.amber,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildGoalCard(
                    icon: Icons.menu_book,
                    title: 'บทเรียน',
                    current: _currentWeeklyLessons,
                    target: _weeklyLessonsGoal,
                    unit: 'บท',
                    color: AppColors.primary,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildGoalCard(
                    icon: Icons.quiz,
                    title: 'แบบทดสอบ',
                    current: _currentWeeklyQuizzes,
                    target: _weeklyQuizzesGoal,
                    unit: 'ครั้ง',
                    color: Colors.green,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildGoalCard(
                    icon: Icons.timer,
                    title: 'เวลาเรียน',
                    current: _currentWeeklyMinutes,
                    target: _weeklyStudyMinutesGoal,
                    unit: 'นาที',
                    color: Colors.purple,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),

                  // Tips Section
                  _buildTipsSection(isDark),
                  const SizedBox(height: 24),

                  // Achievement Preview
                  _buildAchievementPreview(isDark),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeeklySummaryCard(bool isDark) {
    final completedGoals = _getCompletedGoalsCount();
    final totalGoals = 4;
    final progress = completedGoals / totalGoals;
    final isAllCompleted = completedGoals == totalGoals;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isAllCompleted
            ? const LinearGradient(
                colors: [Colors.amber, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isAllCompleted ? Colors.amber : AppColors.primary).withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Progress Circle
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withAlpha(50),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Center(
                      child: Text(
                        isAllCompleted ? '🎉' : '$completedGoals/$totalGoals',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isAllCompleted ? 28 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAllCompleted ? 'ยอดเยี่ยม!' : 'สัปดาห์นี้',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAllCompleted
                          ? 'คุณทำครบทุกเป้าหมายแล้ว!'
                          : 'ทำสำเร็จ $completedGoals จาก $totalGoals เป้าหมาย',
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getWeekRange(),
                      style: TextStyle(
                        color: Colors.white.withAlpha(180),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isAllCompleted) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getMotivationalMessage(),
                      style: TextStyle(
                        color: Colors.white.withAlpha(230),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGoalCard({
    required IconData icon,
    required String title,
    required int current,
    required int target,
    required String unit,
    required Color color,
    required bool isDark,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);
    final isCompleted = current >= target;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: progress),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surface : AppColorsLight.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCompleted ? color : (isDark ? AppColors.border : AppColorsLight.border),
              width: isCompleted ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withAlpha(30),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check, color: color, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'สำเร็จ',
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$current / $target $unit',
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipsSection(bool isDark) {
    final tips = [
      'ตั้งเป้าหมายที่ท้าทายแต่ทำได้จริง',
      'เรียนทุกวันเพื่อรักษา Streak',
      'ทบทวนด้วย Flashcard ก่อนนอน',
      'ลองทำ Quiz หลายครั้งเพื่อปรับปรุง',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lightbulb, color: AppColors.info, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'เคล็ดลับ',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAchievementPreview(bool isDark) {
    final completedGoals = _getCompletedGoalsCount();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'รางวัลที่จะได้รับ',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRewardItem(
                emoji: '🥉',
                label: '1 เป้าหมาย',
                xp: 25,
                isUnlocked: completedGoals >= 1,
                isDark: isDark,
              ),
              _buildRewardItem(
                emoji: '🥈',
                label: '2 เป้าหมาย',
                xp: 50,
                isUnlocked: completedGoals >= 2,
                isDark: isDark,
              ),
              _buildRewardItem(
                emoji: '🥇',
                label: '3 เป้าหมาย',
                xp: 100,
                isUnlocked: completedGoals >= 3,
                isDark: isDark,
              ),
              _buildRewardItem(
                emoji: '🏆',
                label: 'ครบทุกอัน',
                xp: 200,
                isUnlocked: completedGoals >= 4,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem({
    required String emoji,
    required String label,
    required int xp,
    required bool isUnlocked,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isUnlocked
                ? Colors.amber.withAlpha(30)
                : (isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUnlocked ? Colors.amber : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: 24,
                color: isUnlocked ? null : Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            fontSize: 10,
          ),
        ),
        Text(
          '+$xp XP',
          style: TextStyle(
            color: isUnlocked ? Colors.amber : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showEditGoalsDialog() {
    int tempXp = _weeklyXpGoal;
    int tempLessons = _weeklyLessonsGoal;
    int tempQuizzes = _weeklyQuizzesGoal;
    int tempMinutes = _weeklyStudyMinutesGoal;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: const Text(
                'ตั้งเป้าหมายสัปดาห์',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildGoalSlider(
                      label: 'XP สะสม',
                      value: tempXp,
                      min: 100,
                      max: 2000,
                      step: 100,
                      unit: 'XP',
                      onChanged: (v) => setDialogState(() => tempXp = v),
                    ),
                    const SizedBox(height: 16),
                    _buildGoalSlider(
                      label: 'บทเรียน',
                      value: tempLessons,
                      min: 1,
                      max: 20,
                      step: 1,
                      unit: 'บท',
                      onChanged: (v) => setDialogState(() => tempLessons = v),
                    ),
                    const SizedBox(height: 16),
                    _buildGoalSlider(
                      label: 'แบบทดสอบ',
                      value: tempQuizzes,
                      min: 1,
                      max: 10,
                      step: 1,
                      unit: 'ครั้ง',
                      onChanged: (v) => setDialogState(() => tempQuizzes = v),
                    ),
                    const SizedBox(height: 16),
                    _buildGoalSlider(
                      label: 'เวลาเรียน',
                      value: tempMinutes,
                      min: 15,
                      max: 300,
                      step: 15,
                      unit: 'นาที',
                      onChanged: (v) => setDialogState(() => tempMinutes = v),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ยกเลิก'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _weeklyXpGoal = tempXp;
                      _weeklyLessonsGoal = tempLessons;
                      _weeklyQuizzesGoal = tempQuizzes;
                      _weeklyStudyMinutesGoal = tempMinutes;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('บันทึกเป้าหมายแล้ว'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('บันทึก'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildGoalSlider({
    required String label,
    required int value,
    required int min,
    required int max,
    required int step,
    required String unit,
    required Function(int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$value $unit',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: ((max - min) ~/ step),
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surfaceLight,
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }

  int _getCompletedGoalsCount() {
    int count = 0;
    if (_currentWeeklyXp >= _weeklyXpGoal) count++;
    if (_currentWeeklyLessons >= _weeklyLessonsGoal) count++;
    if (_currentWeeklyQuizzes >= _weeklyQuizzesGoal) count++;
    if (_currentWeeklyMinutes >= _weeklyStudyMinutesGoal) count++;
    return count;
  }

  String _getWeekRange() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return '${startOfWeek.day}/${startOfWeek.month} - ${endOfWeek.day}/${endOfWeek.month}';
  }

  String _getMotivationalMessage() {
    final completedGoals = _getCompletedGoalsCount();
    if (completedGoals == 0) {
      return 'เริ่มต้นวันนี้! ทำเป้าหมายแรกให้สำเร็จ';
    } else if (completedGoals == 1) {
      return 'ดีมาก! อีก 3 เป้าหมายเพื่อรับ Bonus สูงสุด';
    } else if (completedGoals == 2) {
      return 'เก่งมาก! อีกนิดเดียวจะครบ';
    } else {
      return 'สุดยอด! อีก 1 เป้าหมายสุดท้าย!';
    }
  }
}
