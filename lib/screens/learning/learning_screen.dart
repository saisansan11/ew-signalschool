import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../knowledge_base.dart';
import '../../services/progress_service.dart';
import '../quiz/quiz_level1_screen.dart';
import '../quiz/quiz_level2_screen.dart';
import '../quiz/quiz_level3_screen.dart';
import '../game/tactical_simulator.dart';
import '../game/spectrum_analyzer.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedLevel = 0;

  // ewLessons index mapping:
  // 0=ภาพรวม EW, 1=สเปกตรัม, 2=ESM, 3=ECM, 4=ECCM, 5=วิทยุ, 6=Anti-Drone, 7=GPS, 8=กรณีศึกษา

  final List<LevelData> _levels = [
    LevelData(
      title: 'พื้นฐาน',
      icon: Icons.school,
      color: AppColors.success,
      lessons: [
        LessonData(
          title: 'EW คืออะไร?',
          subtitle: 'ทำความรู้จักกับสงครามอิเล็กทรอนิกส์',
          duration: '15 นาที',
          isCompleted: true,
          isLocked: false,
          ewLessonIndex: 0, // ภาพรวม EW
        ),
        LessonData(
          title: 'สเปกตรัมแม่เหล็กไฟฟ้า',
          subtitle: 'คลื่นความถี่และการใช้งาน',
          duration: '20 นาที',
          isCompleted: true,
          isLocked: false,
          ewLessonIndex: 1, // สเปกตรัม
        ),
        LessonData(
          title: 'อุปกรณ์ EW เบื้องต้น',
          subtitle: 'รู้จักอุปกรณ์ที่ใช้ในภารกิจ',
          duration: '25 นาที',
          isCompleted: false,
          isLocked: false,
          ewLessonIndex: 5, // วิทยุสื่อสาร
        ),
        LessonData(
          title: 'แบบทดสอบ Level 1',
          subtitle: 'ทดสอบความรู้พื้นฐาน',
          duration: '10 นาที',
          isCompleted: false,
          isLocked: false,
          isQuiz: true, // Quiz screen
        ),
      ],
    ),
    LevelData(
      title: 'ยุทธวิธี',
      icon: Icons.flash_on,
      color: AppColors.warning,
      lessons: [
        LessonData(
          title: 'เทคนิค Jamming',
          subtitle: 'Spot, Barrage, Sweep Jamming',
          duration: '30 นาที',
          isCompleted: false,
          isLocked: false,
          ewLessonIndex: 3, // ECM
        ),
        LessonData(
          title: 'SIGINT Operations',
          subtitle: 'การดักฟังและวิเคราะห์สัญญาณ',
          duration: '35 นาที',
          isCompleted: false,
          isLocked: false,
          ewLessonIndex: 2, // ESM
        ),
        LessonData(
          title: 'Anti-Drone / C-UAS',
          subtitle: 'การต่อต้านโดรน',
          duration: '30 นาที',
          isCompleted: false,
          isLocked: false,
          ewLessonIndex: 6, // Anti-Drone
        ),
        LessonData(
          title: 'GPS Jamming & Spoofing',
          subtitle: 'การรบกวนและหลอกระบบ GPS',
          duration: '25 นาที',
          isCompleted: false,
          isLocked: false,
          ewLessonIndex: 7, // GPS Warfare
        ),
        LessonData(
          title: 'Tactical Simulator',
          subtitle: 'ฝึกภารกิจ EW แบบ Interactive',
          duration: '∞',
          isCompleted: false,
          isLocked: false,
          screenType: 'tactical_simulator',
        ),
        LessonData(
          title: 'แบบทดสอบ Level 2',
          subtitle: 'ทดสอบความรู้ระดับยุทธวิธี',
          duration: '15 นาที',
          isCompleted: false,
          isLocked: false,
          screenType: 'quiz_level2',
        ),
      ],
    ),
    LevelData(
      title: 'ขั้นสูง',
      icon: Icons.shield,
      color: AppColors.danger,
      lessons: [
        LessonData(
          title: 'EPM - การป้องกัน',
          subtitle: 'Electronic Protective Measures',
          duration: '40 นาที',
          isCompleted: false,
          isLocked: false,
          ewLessonIndex: 4, // ECCM
        ),
        LessonData(
          title: 'Frequency Hopping',
          subtitle: 'เทคนิคการกระโดดความถี่',
          duration: '35 นาที',
          isCompleted: false,
          isLocked: false,
          ewLessonIndex: 4, // ECCM (มี FHSS)
        ),
        LessonData(
          title: 'Direction Finding',
          subtitle: 'การหาทิศทางสัญญาณ',
          duration: '30 นาที',
          isCompleted: false,
          isLocked: false,
          ewLessonIndex: 2, // ESM (มี DF)
        ),
        LessonData(
          title: 'ระบบเรดาร์',
          subtitle: 'Pulse, Doppler, SAR และสมการเรดาร์',
          duration: '35 นาที',
          isCompleted: false,
          isLocked: false,
          ewLessonIndex: 9, // Radar Systems
        ),
        LessonData(
          title: 'กรณีศึกษา EW',
          subtitle: 'เรียนรู้จากปฏิบัติการจริง',
          duration: '25 นาที',
          isCompleted: false,
          isLocked: false,
          ewLessonIndex: 8, // Case Studies
        ),
        LessonData(
          title: 'Spectrum Analyzer',
          subtitle: 'วิเคราะห์สัญญาณและระบุภัยคุกคาม',
          duration: '∞',
          isCompleted: false,
          isLocked: false,
          screenType: 'spectrum_analyzer',
        ),
        LessonData(
          title: 'แบบทดสอบ Level 3',
          subtitle: 'ทดสอบความรู้ขั้นสูง',
          duration: '20 นาที',
          isCompleted: false,
          isLocked: false,
          screenType: 'quiz_level3',
        ),
      ],
    ),
  ];

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('คลังความรู้'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Level Tabs
          _buildLevelTabs(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level Header
                  _buildLevelHeader(_levels[_selectedLevel]),
                  const SizedBox(height: 20),

                  // Lessons List
                  ..._levels[_selectedLevel].lessons.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildLessonCard(entry.key + 1, entry.value),
                        ),
                      ),

                  const SizedBox(height: 24),

                  // Other Categories
                  _buildOtherCategories(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelTabs() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: _levels.asMap().entries.map((entry) {
          final index = entry.key;
          final level = entry.value;
          final isSelected = _selectedLevel == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLevel = index;
                });
              },
              child: AnimatedContainer(
                duration: AppDurations.animationFast,
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? level.color.withAlpha(30)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(
                    color: isSelected ? level.color : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      level.icon,
                      color: isSelected ? level.color : AppColors.textMuted,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.title,
                      style: TextStyle(
                        color: isSelected ? level.color : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLevelHeader(LevelData level) {
    final completedCount = level.lessons.where((l) => _isLessonCompleted(l)).length;
    final totalCount = level.lessons.length;
    final progress = completedCount / totalCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: level.color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: level.color.withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: level.color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(level.icon, color: level.color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LEVEL ${_selectedLevel + 1}: ${level.title}',
                  style: TextStyle(
                    color: level.color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.surface,
                          valueColor: AlwaysStoppedAnimation<Color>(level.color),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$completedCount/$totalCount',
                      style: TextStyle(
                        color: level.color,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Check if lesson is completed from ProgressService
  bool _isLessonCompleted(LessonData lesson) {
    // Check screenType first
    if (lesson.screenType != null) {
      switch (lesson.screenType) {
        case 'quiz_level1':
          final score = ProgressService.getQuizScore('quiz_level1');
          return score != null && (score['percent'] ?? 0) >= 70;
        case 'quiz_level2':
          final score = ProgressService.getQuizScore('quiz_level2');
          return score != null && (score['percent'] ?? 0) >= 70;
        case 'quiz_level3':
          final score = ProgressService.getQuizScore('quiz_level3');
          return score != null && (score['percent'] ?? 0) >= 70;
        case 'tactical_simulator':
        case 'spectrum_analyzer':
          // Simulators are never "completed" - always available
          return false;
      }
    }
    // Legacy isQuiz flag
    if (lesson.isQuiz) {
      final score = ProgressService.getQuizScore('quiz_level1');
      return score != null && (score['percent'] ?? 0) >= 70;
    }
    if (lesson.ewLessonIndex != null && lesson.ewLessonIndex! < ewLessons.length) {
      return ProgressService.isLessonCompleted(ewLessons[lesson.ewLessonIndex!].id);
    }
    return false;
  }

  Widget _buildLessonCard(int number, LessonData lesson) {
    final isCompleted = _isLessonCompleted(lesson);

    return GestureDetector(
      onTap: lesson.isLocked ? null : () async {
        // Check screenType first
        if (lesson.screenType != null) {
          switch (lesson.screenType) {
            case 'quiz_level1':
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizLevel1Screen()),
              );
              break;
            case 'quiz_level2':
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizLevel2Screen()),
              );
              break;
            case 'tactical_simulator':
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TacticalSimulator()),
              );
              break;
            case 'quiz_level3':
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizLevel3Screen()),
              );
              break;
            case 'spectrum_analyzer':
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SpectrumAnalyzer()),
              );
              break;
          }
        }
        // Legacy isQuiz flag
        else if (lesson.isQuiz) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const QuizLevel1Screen(),
            ),
          );
        }
        // Use direct index mapping to ewLessons
        else if (lesson.ewLessonIndex != null && lesson.ewLessonIndex! < ewLessons.length) {
          final targetLesson = ewLessons[lesson.ewLessonIndex!];
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonDetailPage(lesson: targetLesson),
            ),
          );
        } else {
          // No content yet - show knowledge base
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const KnowledgeBasePage(),
            ),
          );
        }
        // Refresh state after returning
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: isCompleted ? AppColors.success : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success
                    : lesson.isLocked
                        ? AppColors.surfaceLight
                        : AppColors.primary.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : lesson.isLocked
                        ? const Icon(Icons.lock, color: AppColors.textMuted, size: 18)
                        : Text(
                            '$number',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: TextStyle(
                      color: lesson.isLocked
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.subtitle,
                    style: TextStyle(
                      color: lesson.isLocked
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: lesson.isLocked
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      lesson.duration,
                      style: TextStyle(
                        fontSize: 12,
                        color: lesson.isLocked
                            ? AppColors.textMuted
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Icon(
                  lesson.isLocked ? Icons.lock_outline : Icons.chevron_right,
                  color: lesson.isLocked
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'หมวดอื่นๆ',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCategoryCard(
                icon: Icons.radio,
                label: 'วิทยุสื่อสาร',
                count: 4,
                color: AppColors.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LessonDetailPage(lesson: ewLessons[5])), // วิทยุสื่อสาร
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryCard(
                icon: Icons.settings_input_antenna,
                label: 'คู่มืออุปกรณ์',
                count: 4,
                color: AppColors.warning,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KnowledgeBasePage()), // TODO: Equipment page
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCategoryCard(
                icon: Icons.checklist,
                label: 'SOP',
                count: 4,
                color: AppColors.danger,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KnowledgeBasePage()), // TODO: SOP page
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryCard(
                icon: Icons.cases_outlined,
                label: 'กรณีศึกษา',
                count: 3,
                color: AppColors.tabLearning,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LessonDetailPage(lesson: ewLessons[8])), // Case Studies
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$count บทเรียน',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
            size: 20,
          ),
        ],
      ),
      ),
    );
  }
}

class LevelData {
  final String title;
  final IconData icon;
  final Color color;
  final List<LessonData> lessons;

  LevelData({
    required this.title,
    required this.icon,
    required this.color,
    required this.lessons,
  });
}

class LessonData {
  final String title;
  final String subtitle;
  final String duration;
  final bool isCompleted;
  final bool isLocked;
  final int? ewLessonIndex; // Index to ewLessons list (0-8)
  final bool isQuiz; // Flag for quiz screens (deprecated, use screenType)
  final String? screenType; // 'quiz_level1', 'quiz_level2', 'tactical_simulator'

  LessonData({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.isCompleted,
    required this.isLocked,
    this.ewLessonIndex,
    this.isQuiz = false,
    this.screenType,
  });
}
