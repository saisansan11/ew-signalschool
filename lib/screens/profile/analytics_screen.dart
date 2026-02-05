import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/progress_service.dart';
import '../../services/theme_provider.dart';
import 'dart:math' as math;

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'week';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
        title: const Text(
          'Learning Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard, size: 20)),
            Tab(text: 'Progress', icon: Icon(Icons.trending_up, size: 20)),
            Tab(text: 'Insights', icon: Icon(Icons.lightbulb, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildProgressTab(),
          _buildInsightsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector
          _buildPeriodSelector(),
          const SizedBox(height: 20),

          // Summary Cards
          _buildSummaryCards(),
          const SizedBox(height: 20),

          // Study Activity Chart
          _buildStudyActivityChart(),
          const SizedBox(height: 20),

          // Learning Streak
          _buildLearningStreak(),
          const SizedBox(height: 20),

          // Top Topics
          _buildTopTopics(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildPeriodButton('week', 'สัปดาห์'),
          _buildPeriodButton('month', 'เดือน'),
          _buildPeriodButton('all', 'ทั้งหมด'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period, String label) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalXp = ProgressService.getTotalXp();
    final completedLessons = ProgressService.getCompletedLessons().length;
    final studyMinutes = (totalXp / 10).round();
    final streak = ProgressService.getLoginStreak();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          icon: Icons.timer,
          value: '${(studyMinutes / 60).toStringAsFixed(1)}',
          unit: 'ชั่วโมง',
          label: 'เวลาเรียนรวม',
          color: AppColors.primary,
          trend: '+12%',
          isUp: true,
        ),
        _buildSummaryCard(
          icon: Icons.star,
          value: '$totalXp',
          unit: 'XP',
          label: 'คะแนนสะสม',
          color: AppColors.warning,
          trend: '+${(totalXp * 0.15).round()}',
          isUp: true,
        ),
        _buildSummaryCard(
          icon: Icons.menu_book,
          value: '$completedLessons',
          unit: '/9',
          label: 'บทเรียนเสร็จ',
          color: AppColors.success,
          trend: completedLessons > 0 ? '+$completedLessons' : '0',
          isUp: completedLessons > 0,
        ),
        _buildSummaryCard(
          icon: Icons.local_fire_department,
          value: '$streak',
          unit: 'วัน',
          label: 'Streak ต่อเนื่อง',
          color: AppColors.danger,
          trend: streak > 3 ? 'Hot!' : '',
          isUp: streak > 0,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String value,
    required String unit,
    required String label,
    required Color color,
    required String trend,
    required bool isUp,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              if (trend.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isUp
                        ? Colors.green.withAlpha(30)
                        : Colors.red.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      color: isUp ? Colors.green : Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyActivityChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'กิจกรรมการเรียน',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '7 วันล่าสุด',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: _buildBarChart(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChartLegend(AppColors.primary, 'เรียนบทเรียน'),
              const SizedBox(width: 20),
              _buildChartLegend(AppColors.warning, 'ทำ Quiz'),
              const SizedBox(width: 20),
              _buildChartLegend(AppColors.success, 'ทบทวน'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final days = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
    // Simulated data based on XP
    final random = math.Random(42);
    final lessonData = List.generate(7, (i) => random.nextDouble() * 0.8 + 0.1);
    final quizData = List.generate(7, (i) => random.nextDouble() * 0.5);
    final reviewData = List.generate(7, (i) => random.nextDouble() * 0.3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Stacked bars
            SizedBox(
              height: 110,
              width: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: reviewData[index] * 100,
                    width: 20,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                  Container(
                    height: quizData[index] * 100,
                    width: 20,
                    color: AppColors.warning,
                  ),
                  Container(
                    height: lessonData[index] * 100,
                    width: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          const BorderRadius.vertical(bottom: Radius.circular(4)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              days[index],
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildChartLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildLearningStreak() {
    final streak = ProgressService.getLoginStreak();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.danger.withAlpha(30),
            AppColors.warning.withAlpha(30),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department,
                  color: AppColors.danger, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Learning Streak',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$streak วันติดต่อกัน',
                style: const TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final isActive = index < streak;
              final isToday = index == (streak - 1).clamp(0, 6);
              return Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.danger
                          : AppColors.surfaceLight,
                      shape: BoxShape.circle,
                      border: isToday
                          ? Border.all(color: AppColors.warning, width: 2)
                          : null,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.danger.withAlpha(80),
                                blurRadius: 8,
                              )
                            ]
                          : null,
                    ),
                    child: Icon(
                      isActive ? Icons.check : Icons.close,
                      color: isActive ? Colors.white : AppColors.textMuted,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'][index],
                    style: TextStyle(
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      fontSize: 10,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
          if (streak >= 7) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.emoji_events, color: AppColors.warning, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ยอดเยี่ยม! คุณเรียนครบสัปดาห์แล้ว!',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
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

  Widget _buildTopTopics() {
    final topics = [
      _TopicProgress('การป้องกันการจัมและ ECCM', 0.85, AppColors.primary),
      _TopicProgress('การวิเคราะห์สเปกตรัม', 0.72, AppColors.success),
      _TopicProgress('ESM และ ELINT', 0.65, AppColors.warning),
      _TopicProgress('การรบกวน Radar', 0.58, AppColors.danger),
      _TopicProgress('GPS Warfare', 0.42, AppColors.tabLearning),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.topic, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'หัวข้อที่เรียน',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...topics.map((topic) => _buildTopicItem(topic)),
        ],
      ),
    );
  }

  Widget _buildTopicItem(_TopicProgress topic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  topic.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${(topic.progress * 100).round()}%',
                style: TextStyle(
                  color: topic.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: topic.progress,
              backgroundColor: topic.color.withAlpha(30),
              valueColor: AlwaysStoppedAnimation<Color>(topic.color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz Performance
          _buildQuizPerformance(),
          const SizedBox(height: 20),

          // Skill Radar Chart
          _buildSkillRadar(),
          const SizedBox(height: 20),

          // Learning Timeline
          _buildLearningTimeline(),
          const SizedBox(height: 20),

          // Completion Milestones
          _buildMilestones(),
        ],
      ),
    );
  }

  Widget _buildQuizPerformance() {
    final quizScores = ProgressService.getQuizScores();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.quiz, color: AppColors.warning, size: 20),
              SizedBox(width: 8),
              Text(
                'ผลการทดสอบ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildQuizCircle(
                  'Level 1',
                  quizScores['quiz_level1']?['percent'] ?? 0,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildQuizCircle(
                  'Level 2',
                  quizScores['quiz_level2']?['percent'] ?? 0,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildQuizCircle(
                  'Level 3',
                  quizScores['quiz_level3']?['percent'] ?? 0,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Average Score
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.analytics, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'คะแนนเฉลี่ย: ${_calculateAverageQuizScore(quizScores)}%',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAverageQuizScore(Map<String, Map<String, int>?> scores) {
    int total = 0;
    int count = 0;
    for (final score in scores.values) {
      if (score != null) {
        total += score['percent'] ?? 0;
        count++;
      }
    }
    return count > 0 ? (total / count).round() : 0;
  }

  Widget _buildQuizCircle(String label, int percent, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: percent / 100,
                  backgroundColor: color.withAlpha(30),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 6,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillRadar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.radar, color: AppColors.tabLearning, size: 20),
              SizedBox(width: 8),
              Text(
                'ทักษะด้าน EW',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: _SkillRadarPainter(),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildSkillLabel('Spectrum', AppColors.primary),
              _buildSkillLabel('ESM', AppColors.success),
              _buildSkillLabel('ECM', AppColors.danger),
              _buildSkillLabel('ECCM', AppColors.warning),
              _buildSkillLabel('Radar', AppColors.tabLearning),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillLabel(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildLearningTimeline() {
    final activities = [
      _TimelineItem(
        icon: Icons.menu_book,
        title: 'เรียนบทเรียน GPS Warfare',
        time: 'วันนี้ 14:30',
        xp: 25,
      ),
      _TimelineItem(
        icon: Icons.quiz,
        title: 'ทำ Quiz Level 1 - 85%',
        time: 'เมื่อวาน 10:00',
        xp: 50,
      ),
      _TimelineItem(
        icon: Icons.replay,
        title: 'ทบทวน ESM Techniques',
        time: '2 วันก่อน',
        xp: 15,
      ),
      _TimelineItem(
        icon: Icons.emoji_events,
        title: 'ได้รับ Achievement: Jammer',
        time: '3 วันก่อน',
        xp: 100,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'กิจกรรมล่าสุด',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...activities.asMap().entries.map((entry) =>
              _buildTimelineItem(entry.value, entry.key == activities.length - 1)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(_TimelineItem item, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: AppColors.primary, size: 18),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        item.time,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${item.xp} XP',
                          style: const TextStyle(
                            color: AppColors.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestones() {
    final milestones = [
      _Milestone('เริ่มต้นการเรียน', true, Icons.flag),
      _Milestone('เรียนครบ 3 บท', true, Icons.book),
      _Milestone('ผ่าน Quiz Level 1', true, Icons.check_circle),
      _Milestone('เรียนครบ 6 บท', false, Icons.school),
      _Milestone('ผ่าน Quiz ทุก Level', false, Icons.emoji_events),
      _Milestone('เรียนจบหลักสูตร', false, Icons.military_tech),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flag, color: AppColors.success, size: 20),
              SizedBox(width: 8),
              Text(
                'Milestones',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...milestones.map((m) => _buildMilestoneItem(m)),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem(_Milestone milestone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: milestone.completed
                  ? AppColors.success.withAlpha(30)
                  : AppColors.surfaceLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: milestone.completed
                    ? AppColors.success
                    : AppColors.border,
              ),
            ),
            child: Icon(
              milestone.completed ? Icons.check : milestone.icon,
              color: milestone.completed
                  ? AppColors.success
                  : AppColors.textMuted,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              milestone.title,
              style: TextStyle(
                color: milestone.completed
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
                decoration: milestone.completed
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          if (milestone.completed)
            const Icon(Icons.check_circle, color: AppColors.success, size: 18),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Recommendations
          _buildRecommendations(),
          const SizedBox(height: 20),

          // Strengths & Weaknesses
          _buildStrengthsWeaknesses(),
          const SizedBox(height: 20),

          // Study Tips
          _buildStudyTips(),
          const SizedBox(height: 20),

          // Goal Progress
          _buildGoalProgress(),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    final recommendations = [
      _Recommendation(
        icon: Icons.replay,
        title: 'ทบทวน ESM Techniques',
        description: 'คุณเรียนบทนี้นานแล้ว ควรทบทวนเพื่อความจำที่ดีขึ้น',
        priority: 'สำคัญ',
        color: AppColors.danger,
      ),
      _Recommendation(
        icon: Icons.quiz,
        title: 'ลองทำ Quiz Level 2',
        description: 'คุณเรียนครบบทเรียนระดับยุทธวิธีแล้ว ลองทดสอบความรู้',
        priority: 'แนะนำ',
        color: AppColors.warning,
      ),
      _Recommendation(
        icon: Icons.menu_book,
        title: 'เรียนบท Anti-Drone ต่อ',
        description: 'เหลืออีก 3 บทก่อนจบหลักสูตร เริ่มจากบทนี้',
        priority: 'ต่อไป',
        color: AppColors.primary,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withAlpha(20),
            AppColors.tabLearning.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'แนะนำสำหรับคุณ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recommendations.map((r) => _buildRecommendationItem(r)),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(_Recommendation recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: recommendation.color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              recommendation.icon,
              color: recommendation.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        recommendation.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: recommendation.color.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        recommendation.priority,
                        style: TextStyle(
                          color: recommendation.color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation.description,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsWeaknesses() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.success.withAlpha(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.trending_up, color: AppColors.success, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'จุดแข็ง',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStrengthItem('ECCM Techniques'),
                _buildStrengthItem('Spectrum Analysis'),
                _buildStrengthItem('Basic Concepts'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.danger.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.danger.withAlpha(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.trending_down, color: AppColors.danger, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'ควรปรับปรุง',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildWeaknessItem('Radar Technology'),
                _buildWeaknessItem('GPS Warfare'),
                _buildWeaknessItem('Anti-Drone'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check, color: AppColors.success, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaknessItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.priority_high, color: AppColors.danger, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyTips() {
    final tips = [
      'ทบทวนบทเรียนทุก 3-5 วันเพื่อความจำที่ยาวนาน',
      'ทำ Quiz หลังเรียนจบแต่ละบทเพื่อทดสอบความเข้าใจ',
      'ใช้ Pomodoro Technique เรียน 25 นาที พัก 5 นาที',
      'จดโน้ตสรุปประเด็นสำคัญของแต่ละบท',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates, color: AppColors.warning, size: 20),
              SizedBox(width: 8),
              Text(
                'เคล็ดลับการเรียน',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.warning.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: AppColors.warning,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
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

  Widget _buildGoalProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flag, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'เป้าหมายประจำสัปดาห์',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildGoalItem('เรียน 5 ชั่วโมง', 0.6, '3/5 ชม.'),
          const SizedBox(height: 12),
          _buildGoalItem('เรียน 3 บท', 0.67, '2/3 บท'),
          const SizedBox(height: 12),
          _buildGoalItem('ทำ Quiz 2 ครั้ง', 0.5, '1/2 ครั้ง'),
          const SizedBox(height: 12),
          _buildGoalItem('Streak 7 วัน', 0.57, '4/7 วัน'),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String title, double progress, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
            Text(
              detail,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceLight,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? AppColors.success : AppColors.primary,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

// Helper classes
class _TopicProgress {
  final String name;
  final double progress;
  final Color color;

  _TopicProgress(this.name, this.progress, this.color);
}

class _TimelineItem {
  final IconData icon;
  final String title;
  final String time;
  final int xp;

  _TimelineItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.xp,
  });
}

class _Milestone {
  final String title;
  final bool completed;
  final IconData icon;

  _Milestone(this.title, this.completed, this.icon);
}

class _Recommendation {
  final IconData icon;
  final String title;
  final String description;
  final String priority;
  final Color color;

  _Recommendation({
    required this.icon,
    required this.title,
    required this.description,
    required this.priority,
    required this.color,
  });
}

// Custom Painter for Skill Radar
class _SkillRadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;

    // Draw background circles
    final bgPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4, bgPaint);
    }

    // Draw axes
    const skills = 5;
    final angleStep = 2 * math.pi / skills;
    for (int i = 0; i < skills; i++) {
      final angle = i * angleStep - math.pi / 2;
      final endPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, endPoint, bgPaint);
    }

    // Draw skill polygon (sample data)
    final skillValues = [0.85, 0.65, 0.72, 0.58, 0.42];
    final skillColors = [
      AppColors.primary,
      AppColors.success,
      AppColors.danger,
      AppColors.warning,
      AppColors.tabLearning,
    ];

    final path = Path();
    final fillPaint = Paint()
      ..color = AppColors.primary.withAlpha(50)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < skills; i++) {
      final angle = i * angleStep - math.pi / 2;
      final point = Offset(
        center.dx + radius * skillValues[i] * math.cos(angle),
        center.dy + radius * skillValues[i] * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }

      // Draw point
      final pointPaint = Paint()
        ..color = skillColors[i]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, 5, pointPaint);
    }
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
