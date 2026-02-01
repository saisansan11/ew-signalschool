import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/constants.dart';
import '../data/signal_corps_data.dart';
import '../data/rta_signal_corps.dart';
import '../services/progress_service.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';
import 'animated_org_chart.dart';
import 'map_screen.dart';
import 'settings_screen.dart';

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
    if (mounted) setState(() {});
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
                    const SizedBox(height: 28),
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
        ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
      ],
    );
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
                      color: Colors.white.withValues(alpha: 0.25),
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
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white.withValues(alpha: 0.9),
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
                color: Colors.white.withValues(alpha: 0.2),
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
        // Row 2: One wide card
        _BentoCard(
          height: 120,
          backgroundColor: AppColors.bentoCream,
          icon: Icons.quiz_rounded,
          iconColor: AppColors.accentOrange,
          title: 'ทดสอบความรู้',
          subtitle: '${SignalCorpsData.quizQuestions.length} คำถาม • เริ่มทดสอบ',
          isWide: true,
          onTap: () => _showQuizOptions(context),
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
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accentPink.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: const Icon(
                Icons.insights_rounded,
                color: AppColors.accentPink,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Text('ความก้าวหน้า', style: AppTextStyles.headlineSmall),
          ],
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
                color: AppColors.accentIndigo.withValues(alpha: 0.15),
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
        child: isWide
            ? Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.15),
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
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.15),
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
                      const SizedBox(height: 2),
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
              ),
      ),
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
              color: AppColors.primary.withValues(alpha: 0.1),
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
        color: color.withValues(alpha: 0.12),
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
          color: color.withValues(alpha: 0.12),
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
                    color: color.withValues(alpha: 0.12),
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
