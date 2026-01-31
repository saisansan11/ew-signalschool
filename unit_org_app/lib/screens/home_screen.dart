import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/constants.dart';
import '../data/signal_corps_data.dart';
import '../data/rta_signal_corps.dart';
import '../services/progress_service.dart';
import '../widgets/glass_card.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';
import 'animated_org_chart.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initProgress();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _initProgress() async {
    await ProgressService.instance.init();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient effect
          _buildBackgroundEffects(),

          // Main content
          SafeArea(
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
                        const SizedBox(height: 24),
                        _buildBranchCard(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('เครื่องมือเรียนรู้', Icons.school),
                        const SizedBox(height: 16),
                        _buildFeatureGrid(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('สถิติการเรียน', Icons.analytics),
                        const SizedBox(height: 16),
                        _buildStatsRow(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('ความก้าวหน้า', Icons.trending_up),
                        const SizedBox(height: 16),
                        _buildProgressSection(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('หมวดหมู่', Icons.category),
                        const SizedBox(height: 16),
                        _buildCategoryList(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Stack(
      children: [
        // Top right glow
        Positioned(
          top: -100,
          right: -100,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 300 * _pulseAnimation.value,
                height: 300 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.signalCorps.withValues(alpha: 0.15),
                      AppColors.signalCorps.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Bottom left glow
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Logo with glow effect
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.signalGradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.signalCorps.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.radar,
            color: Colors.white,
            size: 28,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'การจัดหน่วยทหาร',
                style: AppTextStyles.headlineLarge,
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
              const SizedBox(height: 4),
              Text(
                'Royal Thai Army Signal Corps',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
            ],
          ),
        ),
        // Settings button
        IconButton(
          onPressed: () => _showSettingsSheet(context),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.tune,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _buildBranchCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.signalCorps.withValues(alpha: 0.15),
            AppColors.signalCorps.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(
          color: AppColors.signalCorps.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.signalCorps.withValues(alpha: 0.1),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Branch emblem
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.signalCorps.withValues(alpha: 0.3),
                  AppColors.signalCorps.withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.signalCorps,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.signalCorps.withValues(alpha: 0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              Icons.cell_tower,
              color: AppColors.signalCorps,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เหล่าทหารสื่อสาร',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.signalCorps,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'กรมการทหารสื่อสาร',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Signal Department • กส.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.signalGradient,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.signalCorps.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Text(
                  'กส.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 12,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'สะพานแดง',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 400.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.titleLarge),
      ],
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      _FeatureItem(
        icon: Icons.map_outlined,
        title: 'แผนที่หน่วย',
        subtitle: 'ที่ตั้งทั่วประเทศ',
        color: AppColors.primary,
        screen: const MapScreen(),
      ),
      _FeatureItem(
        icon: Icons.account_tree_outlined,
        title: 'ผังการจัด',
        subtitle: 'โครงสร้างหน่วย',
        color: AppColors.signalCorps,
        screen: const AnimatedOrgChartScreen(),
      ),
      _FeatureItem(
        icon: Icons.style_outlined,
        title: 'Flashcards',
        subtitle: 'ท่องจำการ์ดพลิก',
        color: AppColors.accent,
        onTap: () => _showFlashcardOptions(context),
      ),
      _FeatureItem(
        icon: Icons.quiz_outlined,
        title: 'ทดสอบ',
        subtitle: 'ทดสอบความรู้',
        color: AppColors.warning,
        onTap: () => _showQuizOptions(context),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return FeatureCard(
          icon: feature.icon,
          title: feature.title,
          subtitle: feature.subtitle,
          color: feature.color,
          onTap: feature.onTap ??
              () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => feature.screen!,
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.05),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            )),
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: AppDurations.pageTransition,
                    ),
                  ),
        )
            .animate()
            .fadeIn(delay: (300 + index * 50).ms, duration: 400.ms)
            .slideY(begin: 0.1, curve: Curves.easeOut);
      },
    );
  }

  Widget _buildStatsRow() {
    final totalUnits = RTASignalCorps.allCombinedUnits.length;
    final totalFlashcards = SignalCorpsData.flashcards.length;
    final totalQuestions = SignalCorpsData.quizQuestions.length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.account_tree,
            value: totalUnits.toString(),
            label: 'หน่วย',
            color: AppColors.signalCorps,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.style,
            value: totalFlashcards.toString(),
            label: 'Flashcards',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.quiz,
            value: totalQuestions.toString(),
            label: 'คำถาม',
            color: AppColors.warning,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          AnimatedCounter(
            value: int.parse(value),
            style: AppTextStyles.headlineMedium.copyWith(color: color),
            duration: const Duration(milliseconds: 1000),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final progress = ProgressService.instance;
    final stats = progress.getStats();

    return Column(
      children: [
        // Streak card
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.warning.withValues(alpha: 0.15),
                AppColors.warning.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(
              color: AppColors.warning.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: AppColors.warning,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Streak ปัจจุบัน',
                      style: AppTextStyles.labelMedium,
                    ),
                    Row(
                      children: [
                        Text(
                          '${stats.currentStreak}',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'วัน',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'เรียนแล้ว',
                    style: AppTextStyles.labelSmall,
                  ),
                  Text(
                    '${stats.flashcardsKnown} การ์ด',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Progress bars
        Row(
          children: [
            Expanded(
              child: _buildMiniProgress(
                label: 'Flashcard',
                value: stats.flashcardsKnown,
                total: SignalCorpsData.flashcards.length,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMiniProgress(
                label: 'Quiz',
                value: stats.quizzesTaken,
                total: 10,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildMiniProgress({
    required String label,
    required int value,
    required int total,
    required Color color,
  }) {
    final progress = total > 0 ? (value / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.titleSmall),
              Text(
                '$value/$total',
                style: AppTextStyles.labelMedium.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      children: SignalCorpsData.flashcardCategories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final flashcardCount =
            SignalCorpsData.getFlashcardsByCategory(category).length;
        final quizCount = SignalCorpsData.getQuizByCategory(category).length;

        return _buildCategoryTile(
          category: category,
          flashcardCount: flashcardCount,
          quizCount: quizCount,
          index: index,
        );
      }).toList(),
    );
  }

  Widget _buildCategoryTile({
    required String category,
    required int flashcardCount,
    required int quizCount,
    required int index,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: AppColors.primary,
              size: 22,
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
                    _buildCategoryChip(
                      '$flashcardCount การ์ด',
                      AppColors.accent,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      '$quizCount คำถาม',
                      AppColors.warning,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                icon: Icons.style,
                color: AppColors.accent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FlashcardScreen(category: category),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.quiz,
                color: AppColors.warning,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(category: category),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (700 + index * 50).ms, duration: 300.ms)
        .slideX(begin: 0.05);
  }

  Widget _buildCategoryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'โครงสร้าง':
        return Icons.account_tree;
      case 'ยศ':
        return Icons.military_tech;
      case 'อุปกรณ์':
        return Icons.settings_input_antenna;
      case 'ภารกิจ':
        return Icons.flag;
      default:
        return Icons.folder;
    }
  }

  void _showFlashcardOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _OptionsBottomSheet(
        title: 'เลือกหมวด Flashcard',
        icon: Icons.style,
        color: AppColors.accent,
        options: [
          _SheetOption(
            icon: Icons.all_inclusive,
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
      builder: (context) => _OptionsBottomSheet(
        title: 'เลือกหมวด Quiz',
        icon: Icons.quiz,
        color: AppColors.warning,
        options: [
          _SheetOption(
            icon: Icons.all_inclusive,
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

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                  Icon(Icons.tune, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('ตั้งค่า', style: AppTextStyles.headlineMedium),
                ],
              ),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.refresh, color: AppColors.error),
              ),
              title: const Text('รีเซ็ตความก้าวหน้า'),
              subtitle: Text(
                'ลบข้อมูลการเรียนทั้งหมด',
                style: AppTextStyles.labelSmall,
              ),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: const Text('ยืนยันการรีเซ็ต'),
                    content: const Text(
                        'คุณต้องการลบข้อมูลความก้าวหน้าทั้งหมดหรือไม่?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('ยกเลิก'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          'รีเซ็ต',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ProgressService.instance.resetProgress();
                  if (mounted) setState(() {});
                }
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.info_outline, color: AppColors.info),
              ),
              title: const Text('เกี่ยวกับแอป'),
              subtitle: Text('เวอร์ชัน 1.0.0', style: AppTextStyles.labelSmall),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Unit Org App',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2025 Royal Thai Army',
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget? screen;
  final VoidCallback? onTap;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.screen,
    this.onTap,
  });
}

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

class _OptionsBottomSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_SheetOption> options;

  const _OptionsBottomSheet({
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
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
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(option.icon, color: AppColors.primary),
                  ),
                  title: Text(option.title, style: AppTextStyles.titleMedium),
                  subtitle:
                      Text(option.subtitle, style: AppTextStyles.labelSmall),
                  trailing: Icon(
                    Icons.chevron_right,
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
