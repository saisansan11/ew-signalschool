import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';
import '../radio/prc624_menu.dart';
import '../radio/prc710_menu.dart';
import '../radio/cnr900_menu.dart';
import '../radio/cnr900t_menu.dart';
import 'drone_field_screen.dart';
import 'gps_jam_screen.dart';
import 'comm_jam_screen.dart';
import 'checklist_screen.dart';

class FieldScreen extends StatelessWidget {
  const FieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.danger,
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield, size: 22),
                SizedBox(width: 8),
                Text('FIELD MODE'),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.nightlight_round),
                onPressed: () {
                  themeProvider.toggleDarkMode();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        themeProvider.isDarkMode ? 'โหมดมืด (Night Mode)' : 'โหมดสว่าง (Day Mode)',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                tooltip: isDark ? 'Day Mode' : 'Night Mode',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning Banner
                _buildWarningBanner(),
                const SizedBox(height: 20),

                // Emergency Section
                _buildEmergencySection(context),
                const SizedBox(height: 24),

                // Checklists Section
                _buildChecklistsSection(context),
                const SizedBox(height: 24),

                // Quick Equipment Guide
                _buildEquipmentSection(context),
                const SizedBox(height: 24),

                // EPM Procedures
                _buildEpmSection(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withAlpha(30),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.warning),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber, color: AppColors.warning, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'โหมดนี้ออกแบบสำหรับใช้งานในภารกิจจริง\nข้อมูลจะแสดงแบบกระชับ อ่านง่าย',
              style: TextStyle(color: AppColors.warning, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.emergency, color: AppColors.danger, size: 22),
            SizedBox(width: 8),
            Text(
              'EMERGENCY',
              style: TextStyle(
                color: AppColors.danger,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildEmergencyButton(
          context: context,
          icon: Icons.gps_off,
          title: 'ถูก GPS Jam',
          subtitle: 'ขั้นตอนเมื่อสูญเสีย GPS',
          color: AppColors.danger,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GpsJamScreen()),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildEmergencyButton(
          context: context,
          icon: Icons.signal_wifi_off,
          title: 'ถูก Comm Jam',
          subtitle: 'ขั้นตอนเมื่อถูกรบกวนการสื่อสาร',
          color: AppColors.warning,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CommJamScreen()),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildEmergencyButton(
          context: context,
          icon: Icons.flight,
          title: 'พบโดรนข้าศึก',
          subtitle: 'ขั้นตอนต่อต้านโดรน',
          color: AppColors.primary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DroneFieldScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmergencyButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: color.withAlpha(100)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: color.withAlpha(180), fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.checklist, color: AppColors.success, size: 22),
            SizedBox(width: 8),
            Text(
              'CHECKLISTS',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildChecklistCard(
                context: context,
                icon: Icons.play_arrow,
                title: 'ก่อน\nปฏิบัติ',
                items: 8,
                color: AppColors.primary,
                type: ChecklistType.pre,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildChecklistCard(
                context: context,
                icon: Icons.loop,
                title: 'ระหว่าง\nปฏิบัติ',
                items: 6,
                color: AppColors.warning,
                type: ChecklistType.during,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildChecklistCard(
                context: context,
                icon: Icons.stop,
                title: 'หลัง\nปฏิบัติ',
                items: 5,
                color: AppColors.success,
                type: ChecklistType.post,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChecklistCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int items,
    required Color color,
    required ChecklistType type,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChecklistScreen(type: type),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '0/$items',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.settings_input_antenna,
              color: AppColors.primary,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'EQUIPMENT QUICK GUIDE',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildEquipmentChip('PRC-624', AppColors.primary, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Prc624MenuScreen()),
                );
              }),
              const SizedBox(width: 8),
              _buildEquipmentChip('PRC-710', AppColors.success, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Prc710MenuScreen()),
                );
              }),
              const SizedBox(width: 8),
              _buildEquipmentChip('CNR-900', AppColors.warning, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Cnr900MenuScreen()),
                );
              }),
              const SizedBox(width: 8),
              _buildEquipmentChip('CNR-900T', AppColors.danger, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Cnr900tMenuScreen()),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.radio, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'PRC-624',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildQuickInfo('ความถี่', '30-88 MHz'),
              _buildQuickInfo('กำลังส่ง', '2/10/25W'),
              _buildQuickInfo('Mode', 'AM/FM'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Prc624MenuScreen()),
                        );
                      },
                      icon: const Icon(Icons.menu_book, size: 18),
                      label: const Text('คู่มือเต็ม'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Prc624MenuScreen()),
                        );
                      },
                      icon: const Icon(Icons.play_circle, size: 18),
                      label: const Text('จำลอง'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentChip(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildQuickInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpmSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.tabLearning.withAlpha(40),
            AppColors.tabLearning.withAlpha(20),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.tabLearning.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.security, color: AppColors.tabLearning, size: 22),
              SizedBox(width: 8),
              Text(
                'EPM PROCEDURES',
                style: TextStyle(
                  color: AppColors.tabLearning,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Electronic Protective Measures - ขั้นตอนป้องกันเมื่อถูกรบกวน',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildEpmStep(1, 'ลดกำลังส่ง / เปลี่ยนความถี่'),
          _buildEpmStep(2, 'เปิด Frequency Hopping'),
          _buildEpmStep(3, 'ใช้สายอากาศทิศทาง'),
          _buildEpmStep(4, 'รายงานตามสายการบังคับบัญชา'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CommJamScreen()),
                );
              },
              icon: const Icon(Icons.menu_book),
              label: const Text('ดูขั้นตอนเต็ม'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tabLearning,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpmStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.tabLearning.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: AppColors.tabLearning,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
