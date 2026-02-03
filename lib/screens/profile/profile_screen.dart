import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../services/theme_provider.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'achievements_screen.dart';
import 'statistics_screen.dart';
import 'certificates_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.getCurrentUser();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(user),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ).then((_) => setState(() {})),
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Stats
                _buildQuickStats(),
                const SizedBox(height: 20),

                // Progress Overview
                _buildProgressOverview(),
                const SizedBox(height: 20),

                // Achievements Preview
                _buildAchievementsPreview(),
                const SizedBox(height: 20),

                // Quiz Scores
                _buildQuizScores(),
                const SizedBox(height: 20),

                // Menu Items
                _buildMenuSection(),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserModel? user) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary.withAlpha(30), AppColors.background],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar with Level Badge
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(80),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getAvatarIcon(user?.avatarType ?? 'military'),
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  // Level Badge
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'Lv.${ProgressService.getLevel()}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name and Rank
              Text(
                user != null ? '${user.rank} ${user.fullName}' : 'ผู้ใช้งาน',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                user?.unit ?? 'กรม ทส.ทบ.',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              if (user?.position != null && user!.position.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  user.position,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // XP Progress Bar
              _buildXpProgress(),

              const SizedBox(height: 12),

              // Edit Profile Button
              OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                ).then((_) => setState(() {})),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('แก้ไขโปรไฟล์'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary.withAlpha(100)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildXpProgress() {
    final xp = ProgressService.getTotalXp();
    final level = ProgressService.getLevel();
    final xpForNext = ProgressService.getXpForNextLevel();
    final xpInLevel = xp % 100;
    final progress = xpInLevel / 100;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: AppColors.warning, size: 18),
            const SizedBox(width: 6),
            Text(
              '$xp XP',
              style: const TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'เหลือ ${xpForNext - xpInLevel} XP สู่ Level ${level + 1}',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.warning,
              ),
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final completedLessons = ProgressService.getCompletedLessons().length;
    final quizScores = ProgressService.getQuizScores();
    final totalXp = ProgressService.getTotalXp();

    // Calculate study time (rough estimate based on XP)
    final studyMinutes = (totalXp / 10).round();
    final studyHours = (studyMinutes / 60).toStringAsFixed(1);

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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'สถิติการเรียน',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                ),
                child: const Text('ดูเพิ่มเติม'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.timer,
                  studyHours,
                  'ชั่วโมง',
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.menu_book,
                  '$completedLessons/9',
                  'บทเรียน',
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.quiz,
                  '${quizScores.length}/3',
                  'Quiz',
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.emoji_events,
                  '${_getAchievementCount()}',
                  'Badges',
                  AppColors.tabLearning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview() {
    final progress = ProgressService.getOverallProgress();

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
          const Text(
            'ความคืบหน้าโดยรวม',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1.0 ? AppColors.success : AppColors.primary,
                    ),
                    minHeight: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Level Progress Indicators
          Row(
            children: [
              _buildLevelIndicator(
                'พื้นฐาน',
                Colors.green,
                _getLevelProgress(0),
              ),
              const SizedBox(width: 12),
              _buildLevelIndicator(
                'ยุทธวิธี',
                Colors.orange,
                _getLevelProgress(1),
              ),
              const SizedBox(width: 12),
              _buildLevelIndicator('ขั้นสูง', Colors.red, _getLevelProgress(2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelIndicator(String label, Color color, double progress) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: progress,
                  backgroundColor: color.withAlpha(30),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 4,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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

  Widget _buildAchievementsPreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.emoji_events, color: AppColors.warning, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Achievements',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                ),
                child: const Text('ดูทั้งหมด'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAchievementBadge(
                Icons.school,
                'เริ่มต้น',
                AppColors.success,
                _hasAchievement('starter'),
              ),
              _buildAchievementBadge(
                Icons.flash_on,
                'Jammer',
                AppColors.danger,
                _hasAchievement('jammer'),
              ),
              _buildAchievementBadge(
                Icons.hearing,
                'SIGINT',
                AppColors.warning,
                _hasAchievement('sigint'),
              ),
              _buildAchievementBadge(
                Icons.gps_off,
                'GPS',
                AppColors.primary,
                _hasAchievement('gps'),
              ),
              _buildAchievementBadge(
                Icons.military_tech,
                'Master',
                AppColors.tabLearning,
                _hasAchievement('master'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(
    IconData icon,
    String label,
    Color color,
    bool unlocked,
  ) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: unlocked ? color.withAlpha(30) : AppColors.surfaceLight,
            shape: BoxShape.circle,
            border: Border.all(
              color: unlocked ? color : AppColors.border,
              width: 2,
            ),
            boxShadow: unlocked
                ? [BoxShadow(color: color.withAlpha(50), blurRadius: 8)]
                : null,
          ),
          child: Icon(
            icon,
            color: unlocked ? color : AppColors.textMuted,
            size: 24,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
            fontSize: 10,
            fontWeight: unlocked ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizScores() {
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
              Icon(Icons.quiz, color: AppColors.warning, size: 24),
              SizedBox(width: 10),
              Text(
                'ผลการทดสอบ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildQuizScoreItem(
            'Level 1: พื้นฐาน',
            quizScores['quiz_level1'],
            Colors.green,
          ),
          const SizedBox(height: 10),
          _buildQuizScoreItem(
            'Level 2: ยุทธวิธี',
            quizScores['quiz_level2'],
            Colors.orange,
          ),
          const SizedBox(height: 10),
          _buildQuizScoreItem(
            'Level 3: ขั้นสูง',
            quizScores['quiz_level3'],
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScoreItem(
    String title,
    Map<String, int>? score,
    Color color,
  ) {
    final hasScore = score != null;
    final percent = score?['percent'] ?? 0;
    final passed = percent >= 70;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasScore
            ? (passed
                  ? Colors.green.withAlpha(20)
                  : Colors.orange.withAlpha(20))
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasScore
              ? (passed
                    ? Colors.green.withAlpha(50)
                    : Colors.orange.withAlpha(50))
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  hasScore
                      ? '${score['score']}/${score['total']} คะแนน'
                      : 'ยังไม่ได้ทำ',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (hasScore)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: passed ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$percent%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            )
          else
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            Icons.history,
            'ประวัติการเรียน',
            'ดูประวัติการเข้าเรียนและทำ Quiz',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatisticsScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.card_membership,
            'ประกาศนียบัตร',
            'ดูประกาศนียบัตรที่ได้รับ',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CertificatesScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.cloud_download_outlined,
            'ดาวน์โหลด Offline',
            'บันทึกบทเรียนเพื่อใช้งาน Offline',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.help_outline,
            'ช่วยเหลือ',
            'คำถามที่พบบ่อย และการติดต่อ',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.info_outline,
            'เกี่ยวกับแอป',
            'เวอร์ชัน 1.0.0 - กรม ทส.ทบ.',
            onTap: () => _showAboutDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppColors.border, indent: 68);
  }

  IconData _getAvatarIcon(String avatarType) {
    switch (avatarType) {
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

  double _getLevelProgress(int level) {
    final completed = ProgressService.getCompletedLessons();
    // Simplified - in production, map lessons to levels properly
    switch (level) {
      case 0: // Basic - lessons 0, 1, 5
        int count = 0;
        if (completed.contains('lesson_1')) count++;
        if (completed.contains('lesson_2')) count++;
        if (completed.contains('lesson_6')) count++;
        return count / 3;
      case 1: // Tactical - lessons 2, 3, 6, 7
        int count = 0;
        if (completed.contains('lesson_3')) count++;
        if (completed.contains('lesson_4')) count++;
        if (completed.contains('lesson_7')) count++;
        if (completed.contains('lesson_8')) count++;
        return count / 4;
      case 2: // Advanced - lessons 4, 8
        int count = 0;
        if (completed.contains('lesson_5')) count++;
        if (completed.contains('lesson_9')) count++;
        return count / 2;
      default:
        return 0;
    }
  }

  bool _hasAchievement(String id) {
    final completed = ProgressService.getCompletedLessons();
    final quizScores = ProgressService.getQuizScores();

    switch (id) {
      case 'starter':
        return completed.isNotEmpty;
      case 'jammer':
        return completed.contains('lesson_4');
      case 'sigint':
        return completed.contains('lesson_3');
      case 'gps':
        return completed.contains('lesson_8');
      case 'master':
        final q1 = quizScores['quiz_level1'];
        final q2 = quizScores['quiz_level2'];
        final q3 = quizScores['quiz_level3'];
        return q1 != null &&
            q2 != null &&
            q3 != null &&
            (q1['percent'] ?? 0) >= 80 &&
            (q2['percent'] ?? 0) >= 80 &&
            (q3['percent'] ?? 0) >= 80;
      default:
        return false;
    }
  }

  int _getAchievementCount() {
    int count = 0;
    if (_hasAchievement('starter')) count++;
    if (_hasAchievement('jammer')) count++;
    if (_hasAchievement('sigint')) count++;
    if (_hasAchievement('gps')) count++;
    if (_hasAchievement('master')) count++;
    return count;
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.radar, color: AppColors.primary),
            SizedBox(width: 10),
            Text(
              'EW SIMULATOR',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 16),
            Text(
              'แอปพลิเคชันฝึกอบรมสงครามอิเล็กทรอนิกส์\n'
              'พัฒนาโดย กรมการทหารสื่อสาร กองทัพบก',
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }
}
