import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../services/theme_provider.dart';
import '../game/jamming_simulator.dart';

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
                      const SizedBox(height: 20),

                      // Status Dashboard
                      _buildStatusDashboard(isDark),
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

  Widget _buildStatusDashboard(bool isDark) {
    final stats = ProgressService.getLearningStats();
    final streak = stats['currentStreak'] ?? 0;
    final completedLessons = stats['lessonsCompleted'] ?? 0;
    final totalXp = stats['totalXp'] ?? 0;

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
            ],
          ),
        );
      },
    );
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
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildCommandCard(
              icon: Icons.flash_on,
              title: 'EW SIMULATOR',
              subtitle: 'Jamming Practice',
              color: AppColors.danger,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JammingSimulator()),
                );
              },
            ),
            _buildCommandCard(
              icon: Icons.calculate,
              title: 'EW CALCULATOR',
              subtitle: 'Signal Analysis',
              color: AppColors.tabTools,
              isDark: isDark,
              onTap: () {
                // Navigate to Tools tab
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ไปที่แท็บ "เครื่องมือ" เพื่อใช้งาน'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            _buildCommandCard(
              icon: Icons.school,
              title: 'TRAINING',
              subtitle: 'Start Learning',
              color: AppColors.tabLearning,
              isDark: isDark,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ไปที่แท็บ "เรียนรู้" เพื่อเริ่มบทเรียน'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            _buildCommandCard(
              icon: Icons.shield,
              title: 'FIELD MODE',
              subtitle: 'Operations',
              color: AppColors.warning,
              isDark: isDark,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ไปที่แท็บ "ภาคสนาม" สำหรับปฏิบัติการ'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommandCard({
    required IconData icon,
    required String title,
    required String subtitle,
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
              color: isDark
                ? AppColors.surface.withAlpha(200)
                : AppColorsLight.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                  ? color.withAlpha((60 * _pulseAnimation.value).toInt())
                  : color.withAlpha(100),
                width: isDark ? 1.5 : 1,
              ),
              boxShadow: isDark ? [
                BoxShadow(
                  color: color.withAlpha((20 * _pulseAnimation.value).toInt()),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ] : [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withAlpha(isDark ? 30 : 40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                      size: 14,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
