import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../services/theme_provider.dart';
import '../game/jamming_simulator.dart';
import '../game/interactive_scenarios_screen.dart';
import '../game/drone_id_training_screen.dart';
import '../game/daily_challenge_screen.dart';
import '../globe/ew_globe_screen.dart';
import '../tools/link_budget_calculator.dart';
import '../tools/signal_library_screen.dart';
import '../learning/learning_screen.dart';
import '../../widgets/streak_notification_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Radar sweep animation
    _radarController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    // Pulse glow animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Scan line animation
    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pulseController.dispose();
    _scanController.dispose();
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
          body: Stack(
            children: [
              // Animated Background
              if (isDark) _buildAnimatedBackground(),

              // Main Content
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Command Center Header
                      _buildCommandHeader(isDark),
                      const SizedBox(height: 16),

                      // Streak Notification
                      StreakNotificationWidget(
                        onAction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DailyChallengeScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Status Dashboard
                      _buildStatusDashboard(isDark),
                      const SizedBox(height: 20),

                      // Review Due Section
                      _buildReviewDueSection(isDark),
                      const SizedBox(height: 20),

                      // Quick Command Grid
                      _buildQuickCommandGrid(context, isDark),
                      const SizedBox(height: 20),

                      // Mission Briefing
                      _buildMissionBriefing(context, isDark),
                      const SizedBox(height: 20),

                      // Intel Feed
                      _buildIntelFeed(isDark),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _radarController,
        builder: (context, child) {
          return CustomPaint(
            painter: RadarBackgroundPainter(
              sweepAngle: _radarController.value * 2 * math.pi,
              pulseValue: _pulseAnimation.value,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommandHeader(bool isDark) {
    final user = AuthService.getCurrentUser();
    final displayName = user?.fullName ?? 'Operator';
    final rank = user?.rank ?? '';
    final unit = user?.unit ?? 'Signal Corps';

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.surface : AppColorsLight.surface).withAlpha(isDark ? 200 : 255),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                ? AppColors.radar.withAlpha((100 * _pulseAnimation.value).toInt())
                : AppColorsLight.border,
              width: isDark ? 2 : 1,
            ),
            boxShadow: isDark ? [
              BoxShadow(
                color: AppColors.radar.withAlpha((30 * _pulseAnimation.value).toInt()),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ] : null,
          ),
          child: Row(
            children: [
              // Avatar with glow
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDark
                      ? [AppColors.radar, AppColors.primary]
                      : [AppColorsLight.primary, AppColorsLight.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: isDark ? [
                    BoxShadow(
                      color: AppColors.radar.withAlpha((80 * _pulseAnimation.value).toInt()),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ] : null,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified_user,
                          color: isDark ? AppColors.radar : AppColorsLight.success,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'OPERATOR ONLINE',
                          style: TextStyle(
                            color: isDark ? AppColors.radar : AppColorsLight.success,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$rank $displayName',
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      unit,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Notification Bell
              _buildNotificationBell(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationBell(bool isDark) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('ไม่มีการแจ้งเตือนใหม่'),
                backgroundColor: isDark ? AppColors.surface : AppColorsLight.textPrimary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                ? AppColors.surfaceLight.withAlpha(150)
                : AppColorsLight.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                  ? AppColors.border
                  : AppColorsLight.border,
              ),
            ),
            child: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.danger.withAlpha((150 * _pulseAnimation.value).toInt()),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewDueSection(bool isDark) {
    final reviewStats = ProgressService.getReviewStats();
    final dueCount = reviewStats['due'] ?? 0;
    final masteredCount = reviewStats['mastered'] ?? 0;
    final learningCount = reviewStats['learning'] ?? 0;
    final totalReviewed = reviewStats['total'] ?? 0;

    // Don't show if no cards have been reviewed yet
    if (totalReviewed == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [
                  AppColors.warning.withAlpha(20),
                  AppColors.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isDark ? null : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dueCount > 0
              ? AppColors.warning.withAlpha(100)
              : (isDark ? AppColors.border : AppColorsLight.border),
          width: dueCount > 0 ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  dueCount > 0 ? Icons.notifications_active : Icons.check_circle,
                  color: dueCount > 0 ? AppColors.warning : AppColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FLASHCARD REVIEW',
                      style: TextStyle(
                        color: isDark ? AppColors.warning : AppColorsLight.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      dueCount > 0
                          ? 'มี $dueCount การ์ดรอทบทวน'
                          : 'ไม่มีการ์ดรอทบทวน',
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (dueCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$dueCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _buildReviewStatItem(
                  icon: Icons.school,
                  value: '$masteredCount',
                  label: 'เชี่ยวชาญ',
                  color: AppColors.success,
                  isDark: isDark,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? AppColors.border : AppColorsLight.border,
              ),
              Expanded(
                child: _buildReviewStatItem(
                  icon: Icons.trending_up,
                  value: '$learningCount',
                  label: 'กำลังเรียน',
                  color: AppColors.primary,
                  isDark: isDark,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? AppColors.border : AppColorsLight.border,
              ),
              Expanded(
                child: _buildReviewStatItem(
                  icon: Icons.history,
                  value: '$totalReviewed',
                  label: 'ทบทวนแล้ว',
                  color: AppColors.accent,
                  isDark: isDark,
                ),
              ),
            ],
          ),

          // Review button if cards are due
          if (dueCount > 0) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to flashcard screen
                  Navigator.pushNamed(context, '/flashcards');
                },
                icon: const Icon(Icons.play_arrow, size: 20),
                label: const Text('เริ่มทบทวนเลย'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDashboard(bool isDark) {
    final stats = ProgressService.getLearningStats();
    final streak = stats['currentStreak'] ?? 0;
    final completedLessons = stats['lessonsCompleted'] ?? 0;
    final totalXp = stats['totalXp'] ?? 0;
    final level = stats['level'] ?? 1;

    // Calculate XP progress for current level
    final levelStartXp = (level - 1) * 100;
    final xpInCurrentLevel = totalXp - levelStartXp;
    const xpForNextLevel = 100; // Each level requires 100 XP
    final levelProgress = (xpInCurrentLevel / xpForNextLevel).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: isDark
              ? LinearGradient(
                  colors: [
                    AppColors.surface,
                    AppColors.surfaceLight.withAlpha(100),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
            color: isDark ? null : AppColorsLight.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.radar.withAlpha(50) : AppColorsLight.border,
            ),
          ),
          child: Column(
            children: [
              // Title with scan effect
              Row(
                children: [
                  Icon(
                    Icons.dashboard,
                    color: isDark ? AppColors.radar : AppColorsLight.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SYSTEM STATUS',
                    style: TextStyle(
                      color: isDark ? AppColors.radar : AppColorsLight.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusIndicator('ACTIVE', AppColors.success, isDark),
                ],
              ),
              const SizedBox(height: 20),

              // Stats Grid
              Row(
                children: [
                  Expanded(child: _buildStatCard(
                    icon: Icons.local_fire_department,
                    value: '$streak',
                    label: 'STREAK',
                    color: AppColors.warning,
                    isDark: isDark,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(
                    icon: Icons.menu_book,
                    value: '$completedLessons',
                    label: 'LESSONS',
                    color: AppColors.primary,
                    isDark: isDark,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(
                    icon: Icons.star,
                    value: '$totalXp',
                    label: 'XP',
                    color: AppColors.accent,
                    isDark: isDark,
                  )),
                ],
              ),

              const SizedBox(height: 16),

              // Level Progress Bar
              _buildLevelProgressBar(
                level: level,
                xpInCurrentLevel: xpInCurrentLevel,
                xpForNextLevel: xpForNextLevel,
                levelProgress: levelProgress,
                isDark: isDark,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLevelProgressBar({
    required int level,
    required int xpInCurrentLevel,
    required int xpForNextLevel,
    required double levelProgress,
    required bool isDark,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppColors.accent.withAlpha(15),
                      AppColors.primary.withAlpha(10),
                    ]
                  : [
                      AppColorsLight.accent.withAlpha(30),
                      AppColorsLight.primary.withAlpha(20),
                    ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? AppColors.accent.withAlpha((40 * _pulseAnimation.value).toInt())
                  : AppColorsLight.accent.withAlpha(60),
            ),
          ),
          child: Column(
            children: [
              // Level info row
              Row(
                children: [
                  // Level badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isDark
                          ? [
                              BoxShadow(
                                color: AppColors.accent.withAlpha((60 * _pulseAnimation.value).toInt()),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.military_tech,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'LV.$level',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // XP progress text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getLevelTitle(level),
                          style: TextStyle(
                            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$xpInCurrentLevel / $xpForNextLevel XP',
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Next level indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceLight.withAlpha(100)
                          : AppColorsLight.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'LV.${level + 1}',
                          style: TextStyle(
                            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Progress bar
              Stack(
                children: [
                  // Background
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceLight.withAlpha(100)
                          : AppColorsLight.surfaceLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Progress fill with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    height: 8,
                    width: (MediaQuery.of(context).size.width - 108) * levelProgress,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, AppColors.primary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: isDark
                          ? [
                              BoxShadow(
                                color: AppColors.accent.withAlpha((80 * _pulseAnimation.value).toInt()),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getLevelTitle(int level) {
    if (level <= 2) return 'Recruit';
    if (level <= 5) return 'Operator';
    if (level <= 10) return 'Specialist';
    if (level <= 15) return 'Expert';
    if (level <= 20) return 'Master';
    return 'Commander';
  }

  Widget _buildStatusIndicator(String label, Color color, bool isDark) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withAlpha((100 * _pulseAnimation.value).toInt()),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha((150 * _pulseAnimation.value).toInt()),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
              ? color.withAlpha(15)
              : color.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                ? color.withAlpha((40 * _pulseAnimation.value).toInt())
                : color.withAlpha(50),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickCommandGrid(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.grid_view,
              color: isDark ? AppColors.radar : AppColorsLight.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'QUICK COMMANDS',
              style: TextStyle(
                color: isDark ? AppColors.radar : AppColorsLight.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: [
            _buildCompactCommandCard(
              icon: Icons.flash_on,
              title: 'EW SIMULATOR',
              color: AppColors.danger,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JammingSimulator()),
                );
              },
            ),
            _buildCompactCommandCard(
              icon: Icons.calculate,
              title: 'EW CALCULATOR',
              color: AppColors.tabTools,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LinkBudgetCalculator()),
                );
              },
            ),
            _buildCompactCommandCard(
              icon: Icons.school,
              title: 'TRAINING',
              color: AppColors.tabLearning,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LearningScreen()),
                );
              },
            ),
            _buildCompactCommandCard(
              icon: Icons.public,
              title: 'GLOBAL OPS',
              color: Colors.cyan,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EWGlobeScreen()),
                );
              },
            ),
            _buildCompactCommandCard(
              icon: Icons.sports_esports,
              title: 'SCENARIOS',
              color: AppColors.warning,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InteractiveScenariosScreen()),
                );
              },
            ),
            _buildCompactCommandCard(
              icon: Icons.flight,
              title: 'DRONE ID',
              color: Colors.orange,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DroneIdTrainingScreen()),
                );
              },
            ),
            _buildCompactCommandCard(
              icon: Icons.waves,
              title: 'SIGNAL LIB',
              color: AppColors.radar,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignalLibraryScreen()),
                );
              },
            ),
            _buildCompactCommandCard(
              icon: Icons.today,
              title: 'DAILY',
              color: Colors.amber,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DailyChallengeScreen()),
                );
              },
            ),
          ],
        ),

      ],
    );
  }

  Widget _buildCompactCommandCard({
    required IconData icon,
    required String title,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
            ? AppColors.surface.withAlpha(200)
            : AppColorsLight.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
              ? color.withAlpha(60)
              : color.withAlpha(100),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(isDark ? 30 : 40),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionBriefing(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.assignment,
              color: isDark ? AppColors.radar : AppColorsLight.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'MISSION BRIEFING',
              style: TextStyle(
                color: isDark ? AppColors.radar : AppColorsLight.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ไปที่แท็บ "เรียนรู้" เพื่อดูบทเรียนทั้งหมด'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'ดูทั้งหมด',
                style: TextStyle(
                  color: isDark ? AppColors.primary : AppColorsLight.primary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _buildMissionCard(
          priority: 'HIGH',
          title: 'เทคนิค Jamming พื้นฐาน',
          description: 'Spot, Barrage, และ Sweep Jamming',
          progress: 0.6,
          color: AppColors.danger,
          isDark: isDark,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ไปที่แท็บ "เรียนรู้" เพื่อเรียนต่อ'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        _buildMissionCard(
          priority: 'MEDIUM',
          title: 'SIGINT Operations',
          description: 'การดักฟังและวิเคราะห์สัญญาณ',
          progress: 0.0,
          color: AppColors.warning,
          isDark: isDark,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ปลดล็อคบทเรียนนี้โดยเรียนบทก่อนหน้าให้จบ'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMissionCard({
    required String priority,
    required String title,
    required String description,
    required double progress,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : AppColorsLight.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                  ? AppColors.border
                  : AppColorsLight.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: color.withAlpha(100)),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (progress > 0)
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Icon(
                        Icons.lock_outline,
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        size: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                    fontSize: 13,
                  ),
                ),
                if (progress > 0) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: isDark
                        ? AppColors.surfaceLight
                        : AppColorsLight.surfaceLight,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntelFeed(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Icon(
                  Icons.rss_feed,
                  color: isDark
                    ? AppColors.radar.withAlpha((150 + 105 * _pulseAnimation.value).toInt())
                    : AppColorsLight.primary,
                  size: 18,
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              'INTEL FEED',
              style: TextStyle(
                color: isDark ? AppColors.radar : AppColorsLight.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            _buildStatusIndicator('LIVE', AppColors.danger, isDark),
          ],
        ),
        const SizedBox(height: 12),

        _buildIntelItem(
          icon: Icons.article,
          title: 'กรณีศึกษา: โดรนในยูเครน 2024',
          time: '2 ชั่วโมงที่แล้ว',
          isNew: true,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _buildIntelItem(
          icon: Icons.update,
          title: 'เพิ่มเนื้อหา GPS Spoofing',
          time: '1 วันที่แล้ว',
          isNew: false,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _buildIntelItem(
          icon: Icons.quiz,
          title: 'Quiz ใหม่: Anti-Drone Systems',
          time: '3 วันที่แล้ว',
          isNew: false,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildIntelItem({
    required IconData icon,
    required String title,
    required String time,
    required bool isNew,
    required bool isDark,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
              ? AppColors.surface.withAlpha(180)
              : AppColorsLight.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isNew && isDark
                ? AppColors.radar.withAlpha((80 * _pulseAnimation.value).toInt())
                : (isDark ? AppColors.border : AppColorsLight.border),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                    ? AppColors.surfaceLight
                    : AppColorsLight.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: TextStyle(
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (isNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isDark ? [
                      BoxShadow(
                        color: AppColors.danger.withAlpha((100 * _pulseAnimation.value).toInt()),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ] : null,
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Custom painter for radar background
class RadarBackgroundPainter extends CustomPainter {
  final double sweepAngle;
  final double pulseValue;

  RadarBackgroundPainter({required this.sweepAngle, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.85, size.height * 0.15);
    final maxRadius = size.width * 0.4;

    // Draw concentric circles
    final circlePaint = Paint()
      ..color = AppColors.radar.withAlpha(10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, maxRadius * (i / 4), circlePaint);
    }

    // Draw radar sweep
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: sweepAngle - 0.5,
        endAngle: sweepAngle,
        colors: [
          AppColors.radar.withAlpha(0),
          AppColors.radar.withAlpha((40 * pulseValue).toInt()),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    canvas.drawCircle(center, maxRadius, sweepPaint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = AppColors.radar.withAlpha(5)
      ..strokeWidth = 0.5;

    // Horizontal grid
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Vertical grid
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant RadarBackgroundPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle || oldDelegate.pulseValue != pulseValue;
  }
}
