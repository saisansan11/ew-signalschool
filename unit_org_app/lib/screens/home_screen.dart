import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/constants.dart';
import '../data/signal_corps_data.dart';
import '../data/rta_signal_corps.dart';
import '../data/learning_data.dart';
import '../services/progress_service.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';
import 'animated_org_chart.dart';
import 'map_screen.dart';
import 'settings_screen.dart';
import 'achievement_screen.dart';
import 'learning_path_screen.dart';
import 'statistics_screen.dart';
import 'unit_detail_screen.dart';
import 'unit_statistics_screen.dart';
import 'unit_comparison_screen.dart';
import 'favorites_screen.dart';
import 'notes_screen.dart';
import '../services/favorites_service.dart';
import '../services/recent_units_service.dart';
import '../services/notes_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initProgress();
  }

  void _initProgress() async {
    await ProgressService.instance.init();
    await FavoritesService.instance.init();
    await RecentUnitsService.instance.init();
    if (mounted) setState(() {});
  }

  Future<int> _getFavoritesCount() async {
    await FavoritesService.instance.init();
    return FavoritesService.instance.count;
  }

  Future<int> _getNotesCount() async {
    await NotesService.instance.init();
    return NotesService.instance.count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildQuickUnitSearch(),
                    const SizedBox(height: 20),
                    _buildRecentUnits(),
                    _buildDailyGoalsCard(),
                    const SizedBox(height: 16),
                    _buildReviewReminder(),
                    const SizedBox(height: 20),
                    _buildHeroCard(),
                    const SizedBox(height: 20),
                    _buildBentoGrid(),
                    const SizedBox(height: 28),
                    _buildStatsSection(),
                    const SizedBox(height: 28),
                    _buildCategoriesSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'สวัสดี 👋',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textMuted,
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 4),
              const Text(
                'เรียนรู้การจัดหน่วย',
                style: AppTextStyles.displayLarge,
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
            ],
          ),
        ),
Row(
          children: [
            // Favorites button
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              ),
              child: Container(
                width: 48,
                height: 48,
                decoration: BentoDecoration.card(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.accentPink,
                    ),
                    // Badge showing count
                    FutureBuilder<int>(
                      future: _getFavoritesCount(),
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        if (count == 0) return const SizedBox.shrink();
                        return Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.accentPink,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
            const SizedBox(width: 8),
            // Notes button
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotesScreen()),
              ),
              child: Container(
                width: 48,
                height: 48,
                decoration: BentoDecoration.card(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.note_alt_outlined,
                      color: AppColors.accentTeal,
                    ),
                    // Badge showing count
                    FutureBuilder<int>(
                      future: _getNotesCount(),
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        if (count == 0) return const SizedBox.shrink();
                        return Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.accentTeal,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 225.ms).scale(begin: const Offset(0.8, 0.8)),
            const SizedBox(width: 8),
            // Settings button
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
              child: Container(
                width: 48,
                height: 48,
                decoration: BentoDecoration.card(),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.textSecondary,
                ),
              ),
            ).animate().fadeIn(delay: 250.ms).scale(begin: const Offset(0.8, 0.8)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickUnitSearch() {
    return GestureDetector(
      onTap: () => _showUnitSearchDialog(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'ค้นหาหน่วยทหารสื่อสาร...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.signalCorps.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${RTASignalCorps.allCombinedUnits.length} หน่วย',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.signalCorps,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1);
  }

  void _showUnitSearchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _UnitSearchSheet(
        onUnitSelected: (unit) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UnitDetailScreen(unit: unit),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentUnits() {
    final recentIds = RecentUnitsService.instance.recentIds;
    if (recentIds.isEmpty) {
      return const SizedBox.shrink();
    }

    final recentUnits = recentIds
        .map((id) => RTASignalCorps.getUnitById(id))
        .where((u) => u != null)
        .cast<SignalUnit>()
        .take(5)
        .toList();

    if (recentUnits.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.accentIndigo.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: AppColors.accentIndigo,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text('ดูล่าสุด', style: AppTextStyles.titleMedium),
            const Spacer(),
            if (recentIds.length > 5)
              GestureDetector(
                onTap: () => _showAllRecentUnits(),
                child: Text(
                  'ดูทั้งหมด',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentUnits.length,
            itemBuilder: (context, index) {
              final unit = recentUnits[index];
              return Padding(
                padding: EdgeInsets.only(right: index < recentUnits.length - 1 ? 10 : 0),
                child: _buildRecentUnitChip(unit),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    ).animate().fadeIn(delay: 180.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildRecentUnitChip(SignalUnit unit) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UnitDetailScreen(unit: unit)),
      ),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: unit.color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: unit.color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: unit.color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      unit.level.symbol,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: unit.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    unit.abbreviation,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: unit.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              unit.location.province,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAllRecentUnits() {
    final recentIds = RecentUnitsService.instance.recentIds;
    final recentUnits = recentIds
        .map((id) => RTASignalCorps.getUnitById(id))
        .where((u) => u != null)
        .cast<SignalUnit>()
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RecentUnitsSheet(
        units: recentUnits,
        onUnitSelected: (unit) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UnitDetailScreen(unit: unit)),
          );
        },
        onClearAll: () async {
          Navigator.pop(context);
          await RecentUnitsService.instance.clearAll();
          setState(() {});
        },
      ),
    );
  }

  Widget _buildReviewReminder() {
    final progress = ProgressService.instance;
    final allCardIds = SignalCorpsData.flashcards.map((c) => c.id).toList();
    final dueCards = progress.getDueCards(allCardIds);

    if (dueCards.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FlashcardScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.warning.withOpacity(0.15),
              AppColors.accentOrange.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(
            color: AppColors.warning.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
              child: const Icon(
                Icons.schedule,
                color: AppColors.warning,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⏰ ถึงเวลาทบทวน!',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'มี ${dueCards.length} การ์ดรอการทบทวน',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: const Text(
                'ทบทวนเลย',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildDailyGoalsCard() {
    final progress = ProgressService.instance;
    final goals = progress.getDailyGoalsSummary();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: goals.allGoalsMet
              ? AppColors.success.withOpacity(0.5)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: goals.allGoalsMet
                      ? AppColors.success.withOpacity(0.15)
                      : AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Icon(
                  goals.allGoalsMet ? Icons.check_circle : Icons.flag_rounded,
                  color: goals.allGoalsMet ? AppColors.success : AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goals.allGoalsMet ? '🎉 เป้าหมายวันนี้สำเร็จ!' : 'เป้าหมายวันนี้',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: goals.allGoalsMet ? AppColors.success : AppColors.textPrimary,
                      ),
                    ),
                    if (progress.hasStreakFreeze)
                      Row(
                        children: [
                          Icon(Icons.ac_unit, size: 12, color: AppColors.info),
                          const SizedBox(width: 4),
                          Text(
                            'Streak Freeze: ${progress.streakFreezeCount}',
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.info),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // Overall progress ring
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: goals.overallProgress,
                      strokeWidth: 5,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: AlwaysStoppedAnimation(
                        goals.allGoalsMet ? AppColors.success : AppColors.primary,
                      ),
                    ),
                    Text(
                      '${(goals.overallProgress * 100).round()}%',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Flashcard goal
          _DailyGoalRow(
            icon: Icons.style_rounded,
            label: 'Flashcard',
            current: goals.flashcardsCompleted,
            goal: goals.flashcardGoal,
            progress: goals.flashcardProgress,
            color: AppColors.accent,
            isCompleted: goals.flashcardGoalMet,
          ),
          const SizedBox(height: 10),
          // Quiz goal
          _DailyGoalRow(
            icon: Icons.quiz_rounded,
            label: 'Quiz',
            current: goals.quizzesCompleted,
            goal: goals.quizGoal,
            progress: goals.quizProgress,
            color: AppColors.accentOrange,
            isCompleted: goals.quizGoalMet,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildHeroCard() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AnimatedOrgChartScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BentoDecoration.gradientCard(
          gradient: AppColors.sunsetGradient,
          borderRadius: AppSizes.radiusXL,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: const Text(
                      'กรมการทหารสื่อสาร',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ดูผังการจัด\nหน่วยทหาร',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '${RTASignalCorps.allCombinedUnits.length} หน่วย',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
              ),
              child: const Icon(
                Icons.account_tree_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 500.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildBentoGrid() {
    final progress = ProgressService.instance;
    final unlockedCount = progress.unlockedAchievements.length;
    final totalAchievements = LearningData.achievements.length;

    return Column(
      children: [
        // Row 1: Two cards side by side
        Row(
          children: [
            Expanded(
              child: _BentoCard(
                height: 160,
                backgroundColor: AppColors.bentoSky,
                icon: Icons.map_rounded,
                iconColor: AppColors.primary,
                title: 'แผนที่',
                subtitle: 'ที่ตั้งหน่วยทั่วประเทศ',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MapScreen()),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.bentoGap),
            Expanded(
              child: _BentoCard(
                height: 160,
                backgroundColor: AppColors.bentoMint,
                icon: Icons.style_rounded,
                iconColor: AppColors.accent,
                title: 'Flashcards',
                subtitle: '${SignalCorpsData.flashcards.length} การ์ด',
                onTap: () => _showFlashcardOptions(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.bentoGap),
        // Row 2: Quiz and Learning Path
        Row(
          children: [
            Expanded(
              child: _BentoCard(
                height: 140,
                backgroundColor: AppColors.bentoCream,
                icon: Icons.quiz_rounded,
                iconColor: AppColors.accentOrange,
                title: 'Quiz',
                subtitle: '${SignalCorpsData.quizQuestions.length} คำถาม',
                onTap: () => _showQuizOptions(context),
              ),
            ),
            const SizedBox(width: AppSizes.bentoGap),
            Expanded(
              child: _BentoCard(
                height: 140,
                backgroundColor: AppColors.bentoLavender,
                icon: Icons.route_rounded,
                iconColor: AppColors.accentPurple,
                title: 'เส้นทางเรียนรู้',
                subtitle: '${LearningData.learningPaths.length} เส้นทาง',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LearningPathScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.bentoGap),
        // Row 3: Unit Statistics and Comparison
        Row(
          children: [
            Expanded(
              child: _BentoCard(
                height: 120,
                backgroundColor: const Color(0xFFE8F5E9),
                icon: Icons.analytics_rounded,
                iconColor: AppColors.signalCorps,
                title: 'สถิติหน่วย',
                subtitle: 'ภาพรวมการจัด',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UnitStatisticsScreen()),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.bentoGap),
            Expanded(
              child: _BentoCard(
                height: 120,
                backgroundColor: const Color(0xFFE3F2FD),
                icon: Icons.compare_arrows_rounded,
                iconColor: AppColors.primary,
                title: 'เปรียบเทียบ',
                subtitle: 'เทียบหน่วยคู่กัน',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UnitComparisonScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.bentoGap),
        // Row 4: Achievements (wide card)
        _BentoCard(
          height: 90,
          backgroundColor: const Color(0xFFFFF8E1),
          icon: Icons.emoji_events_rounded,
          iconColor: AppColors.warning,
          title: 'รางวัลและความสำเร็จ',
          subtitle: '$unlockedCount / $totalAchievements รางวัล',
          isWide: true,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AchievementScreen()),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 350.ms, duration: 500.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildStatsSection() {
    final progress = ProgressService.instance;
    final stats = progress.getStats();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StatisticsScreen()),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.accentPink.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppColors.accentPink,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('ความก้าวหน้า', style: AppTextStyles.headlineSmall),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted,
                size: 16,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department_rounded,
                value: '${stats.currentStreak}',
                label: 'Streak',
                color: AppColors.accentOrange,
                bgColor: AppColors.bentoCream,
              ),
            ),
            const SizedBox(width: AppSizes.bentoGap),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle_rounded,
                value: '${stats.flashcardsKnown}',
                label: 'เรียนแล้ว',
                color: AppColors.accent,
                bgColor: AppColors.bentoMint,
              ),
            ),
            const SizedBox(width: AppSizes.bentoGap),
            Expanded(
              child: _StatCard(
                icon: Icons.emoji_events_rounded,
                value: '${stats.quizzesTaken}',
                label: 'Quiz',
                color: AppColors.accentPurple,
                bgColor: AppColors.bentoLavender,
              ),
            ),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 500.ms, duration: 400.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accentIndigo.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: const Icon(
                Icons.category_rounded,
                color: AppColors.accentIndigo,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Text('หมวดหมู่', style: AppTextStyles.headlineSmall),
          ],
        ),
        const SizedBox(height: 16),
        ...SignalCorpsData.flashcardCategories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          return _CategoryTile(
            category: category,
            flashcardCount:
                SignalCorpsData.getFlashcardsByCategory(category).length,
            quizCount: SignalCorpsData.getQuizByCategory(category).length,
            delay: 600 + index * 80,
            onFlashcardTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FlashcardScreen(category: category),
              ),
            ),
            onQuizTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuizScreen(category: category),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showFlashcardOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _OptionsSheet(
        title: 'เลือกหมวด Flashcard',
        icon: Icons.style_rounded,
        color: AppColors.accent,
        options: [
          _SheetOption(
            icon: Icons.all_inclusive_rounded,
            title: 'ทั้งหมด',
            subtitle: '${SignalCorpsData.flashcards.length} การ์ด',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FlashcardScreen()),
              );
            },
          ),
          ...SignalCorpsData.flashcardCategories.map(
            (cat) => _SheetOption(
              icon: _getCategoryIcon(cat),
              title: cat,
              subtitle:
                  '${SignalCorpsData.getFlashcardsByCategory(cat).length} การ์ด',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FlashcardScreen(category: cat),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showQuizOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _OptionsSheet(
        title: 'เลือกหมวด Quiz',
        icon: Icons.quiz_rounded,
        color: AppColors.accentOrange,
        options: [
          _SheetOption(
            icon: Icons.all_inclusive_rounded,
            title: 'ทั้งหมด',
            subtitle: '${SignalCorpsData.quizQuestions.length} คำถาม',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizScreen()),
              );
            },
          ),
          ...SignalCorpsData.quizCategories.map(
            (cat) => _SheetOption(
              icon: _getCategoryIcon(cat),
              title: cat,
              subtitle:
                  '${SignalCorpsData.getQuizByCategory(cat).length} คำถาม',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(category: cat),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'โครงสร้าง':
        return Icons.account_tree_rounded;
      case 'ยศ':
        return Icons.military_tech_rounded;
      case 'อุปกรณ์':
        return Icons.settings_input_antenna_rounded;
      case 'ภารกิจ':
        return Icons.flag_rounded;
      default:
        return Icons.folder_rounded;
    }
  }
}

// Bento Card Widget
class _BentoCard extends StatelessWidget {
  final double height;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isWide;
  final VoidCallback? onTap;

  const _BentoCard({
    required this.height,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.isWide = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BentoDecoration.coloredCard(
          backgroundColor: backgroundColor,
          borderRadius: AppSizes.radiusXL,
        ),
        child: isWide ? _buildWideLayout() : _buildCompactLayout(),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: iconColor,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BentoDecoration.coloredCard(
        backgroundColor: bgColor,
        borderRadius: AppSizes.radiusL,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.headlineLarge.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}

// Category Tile Widget
class _CategoryTile extends StatelessWidget {
  final String category;
  final int flashcardCount;
  final int quizCount;
  final int delay;
  final VoidCallback onFlashcardTap;
  final VoidCallback onQuizTap;

  const _CategoryTile({
    required this.category,
    required this.flashcardCount,
    required this.quizCount,
    required this.delay,
    required this.onFlashcardTap,
    required this.onQuizTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BentoDecoration.card(borderRadius: AppSizes.radiusL),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildChip('$flashcardCount การ์ด', AppColors.accent),
                    const SizedBox(width: 8),
                    _buildChip('$quizCount คำถาม', AppColors.accentOrange),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionBtn(
                Icons.style_rounded,
                AppColors.accent,
                onFlashcardTap,
              ),
              const SizedBox(width: 8),
              _buildActionBtn(
                Icons.quiz_rounded,
                AppColors.accentOrange,
                onQuizTap,
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 300.ms)
        .slideX(begin: 0.05);
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'โครงสร้าง':
        return Icons.account_tree_rounded;
      case 'ยศ':
        return Icons.military_tech_rounded;
      case 'อุปกรณ์':
        return Icons.settings_input_antenna_rounded;
      case 'ภารกิจ':
        return Icons.flag_rounded;
      default:
        return Icons.folder_rounded;
    }
  }
}

// Options Sheet
class _SheetOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

// Daily Goal Row Widget
class _DailyGoalRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int current;
  final int goal;
  final double progress;
  final Color color;
  final bool isCompleted;

  const _DailyGoalRow({
    required this.icon,
    required this.label,
    required this.current,
    required this.goal,
    required this.progress,
    required this.color,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isCompleted ? AppColors.success : color,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: AppTextStyles.bodySmall,
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation(
                isCompleted ? AppColors.success : color,
              ),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 50,
          child: Text(
            '$current/$goal',
            style: AppTextStyles.labelMedium.copyWith(
              color: isCompleted ? AppColors.success : AppColors.textSecondary,
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        if (isCompleted) ...[
          const SizedBox(width: 4),
          const Icon(Icons.check_circle, size: 16, color: AppColors.success),
        ],
      ],
    );
  }
}

class _OptionsSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_SheetOption> options;

  const _OptionsSheet({
    required this.title,
    required this.icon,
    required this.color,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Text(title, style: AppTextStyles.headlineMedium),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    child: Icon(option.icon, color: AppColors.primary),
                  ),
                  title: Text(option.title, style: AppTextStyles.titleMedium),
                  subtitle:
                      Text(option.subtitle, style: AppTextStyles.labelSmall),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                  ),
                  onTap: option.onTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Unit Search Sheet for quick navigation to units
class _UnitSearchSheet extends StatefulWidget {
  final Function(SignalUnit) onUnitSelected;

  const _UnitSearchSheet({required this.onUnitSelected});

  @override
  State<_UnitSearchSheet> createState() => _UnitSearchSheetState();
}

class _UnitSearchSheetState extends State<_UnitSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<SignalUnit> _filteredUnits = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredUnits = RTASignalCorps.allCombinedUnits;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredUnits = RTASignalCorps.allCombinedUnits;
      } else {
        _filteredUnits = RTASignalCorps.allCombinedUnits.where((unit) {
          return unit.name.toLowerCase().contains(_searchQuery) ||
              unit.abbreviation.toLowerCase().contains(_searchQuery) ||
              unit.nameEn.toLowerCase().contains(_searchQuery) ||
              unit.location.province.toLowerCase().contains(_searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.signalCorps.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: AppColors.signalCorps,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ค้นหาหน่วย',
                                style: AppTextStyles.titleLarge,
                              ),
                              Text(
                                'พบ ${_filteredUnits.length} หน่วย',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search field
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'ค้นหาชื่อหน่วย, ชื่อย่อ, จังหวัด...',
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Results list
              Expanded(
                child: _filteredUnits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'ไม่พบหน่วยที่ค้นหา',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredUnits.length,
                        itemBuilder: (context, index) {
                          final unit = _filteredUnits[index];
                          return _buildUnitItem(unit);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnitItem(SignalUnit unit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onUnitSelected(unit),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: unit.color.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: unit.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      unit.level.symbol,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: unit.color,
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
                        children: [
                          Text(
                            unit.abbreviation,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: unit.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (unit.armyArea != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: unit.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'ทภ.${unit.armyArea}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: unit.color,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unit.name,
                        style: AppTextStyles.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            unit.location.province,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.military_tech,
                            size: 12,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            unit.commanderRank,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: unit.color.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Recent Units Sheet for viewing all recently viewed units
class _RecentUnitsSheet extends StatelessWidget {
  final List<SignalUnit> units;
  final Function(SignalUnit) onUnitSelected;
  final VoidCallback onClearAll;

  const _RecentUnitsSheet({
    required this.units,
    required this.onUnitSelected,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accentIndigo.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                      child: const Icon(
                        Icons.history_rounded,
                        color: AppColors.accentIndigo,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ดูล่าสุด',
                            style: AppTextStyles.titleLarge,
                          ),
                          Text(
                            '${units.length} หน่วย',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Clear all button
                    if (units.isNotEmpty)
                      TextButton.icon(
                        onPressed: () => _showClearConfirmation(context),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('ล้าง'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                      ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
              // List
              Expanded(
                child: units.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_rounded,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'ยังไม่มีประวัติการดู',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: units.length,
                        itemBuilder: (context, index) {
                          final unit = units[index];
                          return _buildRecentUnitItem(unit, index);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('ล้างประวัติ?'),
        content: const Text('ต้องการล้างประวัติการดูหน่วยทั้งหมดหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onClearAll();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('ล้างทั้งหมด'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentUnitItem(SignalUnit unit, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onUnitSelected(unit),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: unit.color.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                // Order indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.accentIndigo.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentIndigo,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Unit icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: unit.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      unit.level.symbol,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: unit.color,
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
                        children: [
                          Text(
                            unit.abbreviation,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: unit.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (unit.armyArea != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: unit.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'ทภ.${unit.armyArea}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: unit.color,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unit.name,
                        style: AppTextStyles.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            unit.location.province,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: unit.color.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
