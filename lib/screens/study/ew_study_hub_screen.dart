import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/progress_service.dart';
import '../../knowledge_base.dart';
import 'ew_glossary_screen.dart';
import 'ew_scenarios_screen.dart';
import 'ew_quick_review_screen.dart';
import '../quiz/quiz_level1_screen.dart';
import '../quiz/quiz_level2_screen.dart';
import '../quiz/quiz_level3_screen.dart';
import '../tools/flashcard_study_screen.dart';

/// หน้าหลัก Study Hub - รวมเครื่องมือศึกษาทั้งหมด
class EWStudyHubScreen extends StatelessWidget {
  const EWStudyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('ศูนย์การเรียนรู้ EW'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            _buildWelcomeCard(context),

            const SizedBox(height: 24),

            // Quick Actions
            _buildSectionHeader('⚡ เข้าถึงด่วน'),
            const SizedBox(height: 12),
            _buildQuickActions(context),

            const SizedBox(height: 24),

            // Study Tools
            _buildSectionHeader('📚 เครื่องมือเตรียมสอบ'),
            const SizedBox(height: 12),
            _buildStudyTools(context),

            const SizedBox(height: 24),

            // Quizzes
            _buildSectionHeader('📝 แบบทดสอบ'),
            const SizedBox(height: 12),
            _buildQuizCards(context),

            const SizedBox(height: 24),

            // Learning Progress
            _buildSectionHeader('📊 ความคืบหน้า'),
            const SizedBox(height: 12),
            _buildProgressCard(context),

            const SizedBox(height: 24),

            // Study Tips
            _buildStudyTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withAlpha(40),
            AppColors.primary.withAlpha(20),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สงครามอิเล็กทรอนิกส์',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Electronic Warfare (EW)',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '"ใครครองสเปกตรัมได้ คนนั้นชนะ"',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EWQuickReviewScreen()),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('เริ่มทบทวนก่อนสอบ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.auto_stories,
            label: 'สรุปเนื้อหา',
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EWQuickReviewScreen()),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.quiz,
            label: 'ทำ Quiz',
            color: Colors.amber,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuizLevel1Screen()),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.psychology,
            label: 'สถานการณ์',
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EWScenariosScreen()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyTools(BuildContext context) {
    final tools = [
      _StudyTool(
        icon: Icons.menu_book,
        title: 'คลังความรู้ EW',
        subtitle: '10 บทเรียนครบถ้วน',
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KnowledgeBasePage()),
        ),
      ),
      _StudyTool(
        icon: Icons.library_books,
        title: 'คำศัพท์ EW',
        subtitle: '23+ คำศัพท์สำคัญ',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EWGlossaryScreen()),
        ),
      ),
      _StudyTool(
        icon: Icons.style,
        title: 'Flashcards',
        subtitle: 'ท่องจำด้วย Spaced Repetition',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FlashcardStudyScreen()),
        ),
      ),
      _StudyTool(
        icon: Icons.psychology,
        title: 'สถานการณ์จำลอง',
        subtitle: 'ฝึกแก้ปัญหา EW',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EWScenariosScreen()),
        ),
      ),
      _StudyTool(
        icon: Icons.summarize,
        title: 'สรุปก่อนสอบ',
        subtitle: '5 หมวดหมู่สำคัญ',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EWQuickReviewScreen()),
        ),
      ),
    ];

    return Column(
      children: tools.map((tool) => _buildToolCard(tool)).toList(),
    );
  }

  Widget _buildToolCard(_StudyTool tool) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: tool.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: tool.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tool.icon, color: tool.color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tool.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tool.subtitle,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: tool.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCards(BuildContext context) {
    return Column(
      children: [
        _buildQuizCard(
          context,
          level: 1,
          title: 'Level 1: พื้นฐาน',
          description: 'ความรู้เบื้องต้น EW',
          questions: 10,
          color: AppColors.success,
          screen: const QuizLevel1Screen(),
        ),
        _buildQuizCard(
          context,
          level: 2,
          title: 'Level 2: ยุทธวิธี',
          description: 'เทคนิค Jamming, ESM, ECM',
          questions: 15,
          color: AppColors.warning,
          screen: const QuizLevel2Screen(),
        ),
        _buildQuizCard(
          context,
          level: 3,
          title: 'Level 3: ขั้นสูง',
          description: 'สถานการณ์และการวิเคราะห์',
          questions: 15,
          color: AppColors.danger,
          screen: const QuizLevel3Screen(),
        ),
      ],
    );
  }

  Widget _buildQuizCard(
    BuildContext context, {
    required int level,
    required String title,
    required String description,
    required int questions,
    required Color color,
    required Widget screen,
  }) {
    final quizScore = ProgressService.getQuizScore('quiz_level$level');
    final passed = quizScore != null && (quizScore['percent'] ?? 0) >= 70;
    final score = quizScore?['percent']?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: passed ? color : AppColors.border,
                width: passed ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: passed
                        ? Icon(Icons.check, color: color)
                        : Text(
                            '$level',
                            style: TextStyle(
                              color: color,
                              fontSize: 20,
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
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$score%',
                      style: TextStyle(
                        color: passed ? color : AppColors.textMuted,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$questions ข้อ',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    // Calculate progress
    final completedLessons = ewLessons.where((l) =>
      ProgressService.isLessonCompleted(l.id)
    ).length;
    final totalLessons = ewLessons.length;
    final progress = completedLessons / totalLessons;

    final quiz1 = ProgressService.getQuizScore('quiz_level1');
    final quiz2 = ProgressService.getQuizScore('quiz_level2');
    final quiz3 = ProgressService.getQuizScore('quiz_level3');

    final quizzesPassed = [quiz1, quiz2, quiz3].where((q) =>
      q != null && (q['percent'] ?? 0) >= 70
    ).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Progress Circle
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 0.7 ? AppColors.success : AppColors.primary,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
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
                    const Text(
                      'ความคืบหน้าโดยรวม',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildProgressItem(
                      'บทเรียน',
                      '$completedLessons/$totalLessons',
                      Colors.blue,
                    ),
                    const SizedBox(height: 4),
                    _buildProgressItem(
                      'Quiz ผ่าน',
                      '$quizzesPassed/3',
                      Colors.amber,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),

          // Achievement Preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAchievementBadge(
                '🎯',
                'เริ่มต้น',
                completedLessons >= 1,
              ),
              _buildAchievementBadge(
                '📚',
                '5 บทเรียน',
                completedLessons >= 5,
              ),
              _buildAchievementBadge(
                '🏆',
                'จบหลักสูตร',
                completedLessons >= totalLessons,
              ),
              _buildAchievementBadge(
                '⭐',
                'Quiz Master',
                quizzesPassed >= 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBadge(String emoji, String label, bool unlocked) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: unlocked ? AppColors.primary.withAlpha(30) : AppColors.surfaceLight,
            shape: BoxShape.circle,
            border: Border.all(
              color: unlocked ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: 20,
                color: unlocked ? null : Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildStudyTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                'เคล็ดลับการเรียน EW',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTip('1. เริ่มจากหลักการ 3 เสา: ESM, ECM, ECCM'),
          _buildTip('2. จำคำศัพท์สำคัญให้แม่น'),
          _buildTip('3. ฝึกทำ Quiz ทุกระดับอย่างน้อย 2 รอบ'),
          _buildTip('4. ทำความเข้าใจ Scenario จริง'),
          _buildTip('5. ทบทวนก่อนสอบด้วย Quick Review'),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.textSecondary)),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudyTool {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  _StudyTool({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
