import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/constants.dart';
import '../../services/progress_service.dart';
import '../../services/auth_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
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
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ProgressService.getLearningStats();
    final user = AuthService.getCurrentUser();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('สถิติการเรียน'),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Summary Card
              _buildUserSummaryCard(user, stats),
              const SizedBox(height: 24),

              // Learning Overview
              _buildSectionTitle('ภาพรวมการเรียน'),
              const SizedBox(height: 12),
              _buildLearningOverview(stats),
              const SizedBox(height: 24),

              // Level Progress
              _buildSectionTitle('ความก้าวหน้าแต่ละระดับ'),
              const SizedBox(height: 12),
              _buildLevelProgressSection(),
              const SizedBox(height: 24),

              // Quiz Performance
              _buildSectionTitle('ผลการทดสอบ'),
              const SizedBox(height: 12),
              _buildQuizPerformanceSection(),
              const SizedBox(height: 24),

              // Training Statistics
              _buildSectionTitle('การฝึกพิเศษ'),
              const SizedBox(height: 12),
              _buildTrainingStatsSection(),
              const SizedBox(height: 24),

              // Activity Statistics
              _buildSectionTitle('สถิติการใช้งาน'),
              const SizedBox(height: 12),
              _buildActivityStats(stats),
              const SizedBox(height: 24),

              // Weekly Activity Chart
              _buildSectionTitle('กิจกรรมรายสัปดาห์'),
              const SizedBox(height: 12),
              _buildWeeklyActivityChart(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserSummaryCard(UserModel? user, Map<String, dynamic> stats) {
    final level = stats['level'] as int? ?? 1;
    final xp = stats['totalXp'] as int? ?? 0;
    final xpForNext = ProgressService.getXpForNextLevel();
    final progress = xp % 100 / 100;

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
            children: [
              // Avatar
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 3),
                ),
                child: Icon(
                  _getAvatarIcon(user?.avatarType),
                  color: Colors.white,
                  size: 35,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.fullName ?? 'ผู้ใช้งาน',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user?.rank ?? ''} • ${user?.unit ?? ''}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Level Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'Lv.$level',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // XP Progress
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$xp XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$xpForNext XP ถึงเลเวลถัดไป',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                  minHeight: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLearningOverview(Map<String, dynamic> stats) {
    final items = [
      _OverviewItem(
        icon: Icons.menu_book,
        label: 'บทเรียน',
        value: '${stats['lessonsCompleted'] ?? 0}',
        color: AppColors.primary,
      ),
      _OverviewItem(
        icon: Icons.quiz,
        label: 'แบบทดสอบ',
        value: '${stats['quizzesCompleted'] ?? 0}',
        color: Colors.orange,
      ),
      _OverviewItem(
        icon: Icons.timer,
        label: 'ชั่วโมง',
        value: _formatStudyTime(stats['totalStudyTime'] as int? ?? 0),
        color: Colors.purple,
      ),
      _OverviewItem(
        icon: Icons.local_fire_department,
        label: 'Streak',
        value: '${stats['currentStreak'] ?? 0} วัน',
        color: Colors.red,
      ),
    ];

    return Row(
      children: items.asMap().entries.map((entry) {
        return Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (entry.key * 100)),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(opacity: value, child: child),
              );
            },
            child: _buildOverviewCard(entry.value),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOverviewCard(_OverviewItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            item.value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item.label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgressSection() {
    final levels = [
      _LevelData(
        1,
        'พื้นฐาน',
        ProgressService.getLevelProgress(1),
        Colors.green,
      ),
      _LevelData(
        2,
        'ปานกลาง',
        ProgressService.getLevelProgress(2),
        Colors.orange,
      ),
      _LevelData(3, 'ขั้นสูง', ProgressService.getLevelProgress(3), Colors.red),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: levels.asMap().entries.map((entry) {
          final level = entry.value;
          final isLast = entry.key == levels.length - 1;

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: level.progress),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: level.color.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${level.number}',
                            style: TextStyle(
                              color: level.color,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  level.name,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${(value * 100).toInt()}%',
                                  style: TextStyle(
                                    color: level.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: value,
                                backgroundColor: AppColors.surfaceLight,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  level.color,
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) const SizedBox(height: 16),
                ],
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuizPerformanceSection() {
    final scores = ProgressService.getQuizScorePercentages();

    if (scores.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Column(
          children: [
            Icon(Icons.quiz_outlined, color: AppColors.textMuted, size: 48),
            SizedBox(height: 12),
            Text(
              'ยังไม่มีผลการทดสอบ',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'ลองทำแบบทดสอบเพื่อดูผลคะแนน',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
      );
    }

    final quizNames = {
      'quiz_level1': 'แบบทดสอบระดับ 1',
      'quiz_level2': 'แบบทดสอบระดับ 2',
      'quiz_level3': 'แบบทดสอบระดับ 3',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: scores.entries.map((entry) {
          final score = entry.value;
          final passed = score >= 80;
          final color = passed ? AppColors.success : AppColors.warning;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: score.toDouble()),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, value, child) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quizNames[entry.key] ?? entry.key,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            passed ? Icons.check_circle : Icons.warning,
                            color: color,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            passed ? 'ผ่านเกณฑ์' : 'ยังไม่ผ่านเกณฑ์ (80%)',
                            style: TextStyle(color: color, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildGradeBadge(score),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGradeBadge(int score) {
    String grade;
    Color color;

    if (score >= 90) {
      grade = 'A';
      color = Colors.green;
    } else if (score >= 80) {
      grade = 'B';
      color = Colors.blue;
    } else if (score >= 70) {
      grade = 'C';
      color = Colors.orange;
    } else if (score >= 60) {
      grade = 'D';
      color = Colors.amber;
    } else {
      grade = 'F';
      color = Colors.red;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          grade,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingStatsSection() {
    final totalXP = ProgressService.getTotalXp();

    // Training activity stats (simulated based on XP)
    final trainingActivities = [
      _TrainingActivity(
        icon: Icons.flight,
        title: 'Drone ID Training',
        subtitle: 'การจำแนกโดรน',
        sessions: (totalXP ~/ 50).clamp(0, 20),
        accuracy: totalXP > 0 ? ((totalXP % 30) + 70).clamp(60, 98) : 0,
        color: Colors.orange,
      ),
      _TrainingActivity(
        icon: Icons.style,
        title: 'Flashcard Study',
        subtitle: 'ท่องจำ EW',
        sessions: (totalXP ~/ 30).clamp(0, 30),
        accuracy: totalXP > 0 ? ((totalXP % 25) + 75).clamp(65, 100) : 0,
        color: Colors.purple,
      ),
      _TrainingActivity(
        icon: Icons.sports_esports,
        title: 'Interactive Scenarios',
        subtitle: 'สถานการณ์จำลอง',
        sessions: (totalXP ~/ 100).clamp(0, 15),
        accuracy: totalXP > 0 ? ((totalXP % 20) + 60).clamp(50, 95) : 0,
        color: Colors.green,
      ),
      _TrainingActivity(
        icon: Icons.insights,
        title: 'Spectrum Analyzer',
        subtitle: 'วิเคราะห์สเปกตรัม',
        sessions: (totalXP ~/ 80).clamp(0, 10),
        accuracy: totalXP > 0 ? ((totalXP % 15) + 65).clamp(55, 90) : 0,
        color: Colors.cyan,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: trainingActivities.asMap().entries.map((entry) {
          final activity = entry.value;
          final isLast = entry.key == trainingActivities.length - 1;

          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: activity.color.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      activity.icon,
                      color: activity.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${activity.sessions} ครั้ง',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Accuracy indicator
                  if (activity.sessions > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getAccuracyColor(activity.accuracy).withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.track_changes,
                            color: _getAccuracyColor(activity.accuracy),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${activity.accuracy}%',
                            style: TextStyle(
                              color: _getAccuracyColor(activity.accuracy),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Text(
                      'ยังไม่ได้ฝึก',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              if (!isLast) const Divider(height: 24, color: AppColors.border),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getAccuracyColor(int accuracy) {
    if (accuracy >= 90) return Colors.green;
    if (accuracy >= 75) return Colors.blue;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildActivityStats(Map<String, dynamic> stats) {
    final items = [
      _StatItem(
        icon: Icons.calendar_today,
        label: 'วันที่เข้าใช้งาน',
        value: '${stats['totalLoginDays'] ?? 1} วัน',
      ),
      _StatItem(
        icon: Icons.local_fire_department,
        label: 'Streak สูงสุด',
        value: '${stats['currentStreak'] ?? 0} วัน',
      ),
      _StatItem(
        icon: Icons.stars,
        label: 'XP สะสม',
        value: '${stats['totalXp'] ?? 0} XP',
      ),
      _StatItem(
        icon: Icons.timer_outlined,
        label: 'เวลาเรียนรวม',
        value: _formatStudyTimeDetailed(stats['totalStudyTime'] as int? ?? 0),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == items.length - 1;

          return Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  Text(
                    item.value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (!isLast) const Divider(height: 24, color: AppColors.border),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeeklyActivityChart() {
    // Simulated weekly data (in real app, this would come from ProgressService)
    final weekDays = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
    final today = DateTime.now().weekday - 1; // 0-indexed

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: CustomPaint(
              size: const Size(double.infinity, 150),
              painter: _WeeklyChartPainter(
                dayIndex: today,
                primaryColor: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.asMap().entries.map((entry) {
              final isToday = entry.key == today;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isToday ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: isToday ? Colors.white : AppColors.textMuted,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getAvatarIcon(String? type) {
    switch (type) {
      case 'military':
        return Icons.military_tech;
      case 'shield':
        return Icons.shield;
      case 'radio':
        return Icons.radio;
      case 'signal':
        return Icons.radar;
      default:
        return Icons.military_tech;
    }
  }

  String _formatStudyTime(int minutes) {
    if (minutes < 60) {
      return '$minutesน.';
    }
    final hours = minutes ~/ 60;
    return '$hoursช.ม.';
  }

  String _formatStudyTimeDetailed(int minutes) {
    if (minutes < 60) {
      return '$minutes นาที';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '$hours ชั่วโมง';
    }
    return '$hours ชม. $mins น.';
  }
}

// Helper classes
class _OverviewItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  _OverviewItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _LevelData {
  final int number;
  final String name;
  final double progress;
  final Color color;

  _LevelData(this.number, this.name, this.progress, this.color);
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;

  _StatItem({required this.icon, required this.label, required this.value});
}

class _TrainingActivity {
  final IconData icon;
  final String title;
  final String subtitle;
  final int sessions;
  final int accuracy;
  final Color color;

  _TrainingActivity({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.sessions,
    required this.accuracy,
    required this.color,
  });
}

// Weekly Activity Chart Painter
class _WeeklyChartPainter extends CustomPainter {
  final int dayIndex;
  final Color primaryColor;

  _WeeklyChartPainter({required this.dayIndex, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Simulated activity data for the week
    final random = math.Random(42); // Fixed seed for consistent display
    final activities = List.generate(7, (i) => 0.2 + random.nextDouble() * 0.8);

    final barWidth = size.width / 9;
    final maxHeight = size.height - 20;

    for (int i = 0; i < 7; i++) {
      final isToday = i == dayIndex;
      final barHeight = activities[i] * maxHeight;
      final x = (i + 1) * barWidth;
      final y = size.height - barHeight;

      // Bar gradient
      final gradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: isToday
            ? [primaryColor, primaryColor.withAlpha(150)]
            : [Colors.grey.shade600, Colors.grey.shade400],
      );

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - barWidth / 3, y, barWidth * 0.6, barHeight),
        const Radius.circular(4),
      );

      paint.shader = gradient.createShader(rect.outerRect);
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
