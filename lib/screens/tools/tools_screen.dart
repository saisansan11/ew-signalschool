import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';
import '../game/jamming_simulator.dart';
import 'link_budget_calculator.dart';
import 'js_ratio_calculator.dart';
import 'range_calculator.dart';
import 'power_converter.dart';
import 'frequency_converter.dart';
import 'uav_database_screen.dart';
import 'frequency_chart_screen.dart';
import 'glossary_screen.dart';
import 'nato_symbols_screen.dart';
import 'phonetic_alphabet_screen.dart';
import 'signal_library_screen.dart';
import '../game/drone_id_training_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;
        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.build,
                  size: 20,
                  color: isDark ? AppColors.tabTools : AppColorsLight.tabTools,
                ),
                const SizedBox(width: 8),
                Text(
                  'TOOLS',
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured: UAV Database
                _buildFeaturedSection(context, isDark),
                const SizedBox(height: 24),

                // Calculators Section
                _buildSectionTitle('EW CALCULATORS', Icons.calculate, isDark),
                const SizedBox(height: 12),
                _buildCalculatorGrid(context, isDark),
                const SizedBox(height: 24),

                // Reference Tables Section
                _buildSectionTitle('REFERENCE TABLES', Icons.table_chart, isDark),
                const SizedBox(height: 12),
                _buildReferenceList(context, isDark),
                const SizedBox(height: 24),

                // Simulators Section
                _buildSectionTitle('SIMULATORS', Icons.games, isDark),
                const SizedBox(height: 12),
                _buildSimulatorCards(context, isDark),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedSection(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UAVDatabaseScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
              ? [AppColors.danger, AppColors.danger.withAlpha(180)]
              : [AppColorsLight.danger, AppColorsLight.danger.withAlpha(200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.danger.withAlpha(60),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.flight,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.new_releases, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'UAV DATABASE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ฐานข้อมูล Drone ทั่วโลก พร้อมข้อมูล EW',
                    style: TextStyle(
                      color: Colors.white.withAlpha(220),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDark ? AppColors.radar : AppColorsLight.primary,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.radar : AppColorsLight.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatorGrid(BuildContext context, bool isDark) {
    final calculators = [
      _CalcItem(
        icon: Icons.signal_cellular_alt,
        title: 'Link Budget',
        subtitle: 'คำนวณกำลังส่ง',
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LinkBudgetCalculator()),
        ),
      ),
      _CalcItem(
        icon: Icons.flash_on,
        title: 'J/S Ratio',
        subtitle: 'อัตราส่วน Jam',
        color: AppColors.danger,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JSRatioCalculator()),
        ),
      ),
      _CalcItem(
        icon: Icons.radar,
        title: 'ระยะทำการ',
        subtitle: 'Jammer/Radio',
        color: AppColors.success,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RangeCalculator()),
        ),
      ),
      _CalcItem(
        icon: Icons.waves,
        title: 'Frequency',
        subtitle: 'แปลงความถี่',
        color: AppColors.tabLearning,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FrequencyConverter()),
        ),
      ),
      _CalcItem(
        icon: Icons.power,
        title: 'Power (dB)',
        subtitle: 'W/dBm/dBW',
        color: AppColors.info,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PowerConverter()),
        ),
      ),
      _CalcItem(
        icon: Icons.settings_input_antenna,
        title: 'Antenna',
        subtitle: 'Gain & Pattern',
        color: AppColors.warning,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('เร็วๆ นี้ - Antenna Calculator'),
              backgroundColor: isDark ? AppColors.surface : AppColorsLight.textPrimary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: calculators.length,
      itemBuilder: (context, index) {
        final calc = calculators[index];
        return _buildCalcCard(calc, isDark);
      },
    );
  }

  Widget _buildCalcCard(_CalcItem calc, bool isDark) {
    return GestureDetector(
      onTap: calc.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColorsLight.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.border : AppColorsLight.border,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: calc.color.withAlpha(isDark ? 30 : 40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(calc.icon, color: calc.color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              calc.title,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              calc.subtitle,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceList(BuildContext context, bool isDark) {
    final references = [
      _RefItem(
        icon: Icons.waves,
        title: 'Signal Library',
        subtitle: 'ฐานข้อมูลสัญญาณ RF พร้อม Waveform',
        color: AppColors.radar,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignalLibraryScreen()),
        ),
      ),
      _RefItem(
        icon: Icons.flight,
        title: 'Drone ID Training',
        subtitle: 'ฝึกจำแนกโดรนจาก Visual และ RF',
        color: AppColors.warning,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DroneIdTrainingScreen()),
        ),
      ),
      _RefItem(
        icon: Icons.radio,
        title: 'Frequency Chart',
        subtitle: 'ตารางความถี่มาตรฐาน ITU',
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FrequencyChartScreen()),
        ),
      ),
      _RefItem(
        icon: Icons.book,
        title: 'EW Glossary',
        subtitle: 'พจนานุกรมศัพท์ EW ครบทุกคำ',
        color: AppColors.success,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GlossaryScreen()),
        ),
      ),
      _RefItem(
        icon: Icons.grid_on,
        title: 'NATO Symbols',
        subtitle: 'สัญลักษณ์ทางทหาร MIL-STD-2525',
        color: AppColors.warning,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NatoSymbolsScreen()),
        ),
      ),
      _RefItem(
        icon: Icons.abc,
        title: 'Phonetic Alphabet',
        subtitle: 'อักษรรหัส NATO A-Z',
        color: AppColors.tabLearning,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PhoneticAlphabetScreen()),
        ),
      ),
    ];

    return Column(
      children: references
          .map((ref) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildRefCard(ref, isDark),
              ))
          .toList(),
    );
  }

  Widget _buildRefCard(_RefItem ref, bool isDark) {
    return GestureDetector(
      onTap: ref.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColorsLight.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.border : AppColorsLight.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ref.color.withAlpha(isDark ? 30 : 40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(ref.icon, color: ref.color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref.title,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ref.subtitle,
                    style: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatorCards(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildSimCard(
            icon: Icons.flash_on,
            title: 'EW Game',
            subtitle: 'เกมฝึก Jamming',
            color: AppColors.danger,
            isPrimary: true,
            isDark: isDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const JammingSimulator()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSimCard(
            icon: Icons.waves,
            title: 'Signal Sim',
            subtitle: 'จำลองสัญญาณ',
            color: AppColors.primary,
            isPrimary: false,
            isDark: isDark,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('เร็วๆ นี้ - Signal Simulator'),
                  backgroundColor: isDark ? AppColors.surface : AppColorsLight.textPrimary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isPrimary,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: [color, color.withAlpha(180)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isPrimary ? null : (isDark ? AppColors.surface : AppColorsLight.surface),
          borderRadius: BorderRadius.circular(16),
          border: isPrimary ? null : Border.all(
            color: isDark ? AppColors.border : AppColorsLight.border,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: color.withAlpha(60),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPrimary
                    ? Colors.white.withAlpha(30)
                    : color.withAlpha(isDark ? 30 : 40),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isPrimary ? Colors.white : color,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isPrimary
                    ? Colors.white
                    : (isDark ? AppColors.textPrimary : AppColorsLight.textPrimary),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: isPrimary
                    ? Colors.white.withAlpha(200)
                    : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white : color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'เล่นเลย',
                style: TextStyle(
                  color: isPrimary ? color : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalcItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  _CalcItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });
}

class _RefItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  _RefItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });
}
