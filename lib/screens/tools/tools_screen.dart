import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../game/jamming_simulator.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('เครื่องมือ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calculators Section
            _buildSectionTitle('EW Calculators', Icons.calculate),
            const SizedBox(height: 12),
            _buildCalculatorGrid(),
            const SizedBox(height: 24),

            // Reference Tables Section
            _buildSectionTitle('Reference Tables', Icons.table_chart),
            const SizedBox(height: 12),
            _buildReferenceList(),
            const SizedBox(height: 24),

            // Simulators Section
            _buildSectionTitle('Simulators', Icons.games),
            const SizedBox(height: 12),
            _buildSimulatorCards(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatorGrid() {
    final calculators = [
      _CalcItem(
        icon: Icons.signal_cellular_alt,
        title: 'Link Budget',
        subtitle: 'คำนวณกำลังส่งสัญญาณ',
        color: AppColors.primary,
      ),
      _CalcItem(
        icon: Icons.flash_on,
        title: 'J/S Ratio',
        subtitle: 'อัตราส่วน Jamming',
        color: AppColors.danger,
      ),
      _CalcItem(
        icon: Icons.radar,
        title: 'ระยะทำการ',
        subtitle: 'ระยะ Jammer/Radio',
        color: AppColors.success,
      ),
      _CalcItem(
        icon: Icons.settings_input_antenna,
        title: 'Antenna Gain',
        subtitle: 'คำนวณ Gain & Pattern',
        color: AppColors.warning,
      ),
      _CalcItem(
        icon: Icons.waves,
        title: 'Frequency',
        subtitle: 'แปลงหน่วยความถี่',
        color: AppColors.tabLearning,
      ),
      _CalcItem(
        icon: Icons.power,
        title: 'Power (dB)',
        subtitle: 'แปลง Watt/dBm/dBW',
        color: AppColors.info,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: calculators.length,
      itemBuilder: (context, index) {
        final calc = calculators[index];
        return _buildCalcCard(calc);
      },
    );
  }

  Widget _buildCalcCard(_CalcItem calc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: calc.color.withAlpha(30),
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: Icon(calc.icon, color: calc.color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            calc.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            calc.subtitle,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceList() {
    final references = [
      _RefItem(
        icon: Icons.radio,
        title: 'Frequency Chart',
        subtitle: 'ตารางความถี่มาตรฐาน',
        color: AppColors.primary,
      ),
      _RefItem(
        icon: Icons.book,
        title: 'Glossary',
        subtitle: 'พจนานุกรมศัพท์ EW',
        color: AppColors.success,
      ),
      _RefItem(
        icon: Icons.grid_on,
        title: 'NATO Symbols',
        subtitle: 'สัญลักษณ์ทางทหาร',
        color: AppColors.warning,
      ),
      _RefItem(
        icon: Icons.abc,
        title: 'Phonetic Alphabet',
        subtitle: 'อักษรรหัส NATO',
        color: AppColors.tabLearning,
      ),
    ];

    return Column(
      children: references
          .map((ref) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildRefCard(ref),
              ))
          .toList(),
    );
  }

  Widget _buildRefCard(_RefItem ref) {
    return Container(
      padding: const EdgeInsets.all(14),
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
              color: ref.color.withAlpha(30),
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: Icon(ref.icon, color: ref.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ref.subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatorCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSimCard(
            icon: Icons.games,
            title: 'EW Game',
            subtitle: 'เกมฝึก Jamming',
            color: AppColors.danger,
            isPrimary: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JammingSimulator(),
                ),
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
            onTap: () {
              // TODO: Add Signal Simulator
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isPrimary
            ? LinearGradient(
                colors: [color, color.withAlpha(200)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPrimary ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: isPrimary ? null : Border.all(color: AppColors.border),
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
              color: isPrimary ? Colors.white.withAlpha(30) : color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isPrimary ? Colors.white : color,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: isPrimary ? Colors.white : AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: isPrimary ? Colors.white.withAlpha(200) : AppColors.textMuted,
              fontSize: 12,
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

  _CalcItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _RefItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  _RefItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
