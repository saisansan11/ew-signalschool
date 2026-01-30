import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/constants.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../services/settings_service.dart';
import '../../services/theme_provider.dart';
import '../auth/auth_screen.dart';
import '../main_shell.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _fontSize = 'normal';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await SettingsService.init();
    setState(() {
      _notificationsEnabled = SettingsService.getNotificationsEnabled();
      _soundEnabled = SettingsService.getSoundEnabled();
      _vibrationEnabled = SettingsService.getVibrationEnabled();
      _darkMode = SettingsService.getDarkMode();
      _fontSize = SettingsService.getFontSize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
        title: Text('ตั้งค่า', style: TextStyle(color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary)),
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _buildSectionHeader('บัญชี', Icons.person_outline),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: 'เปลี่ยนรหัส PIN',
                subtitle: 'เปลี่ยนรหัสผ่านเข้าสู่ระบบ',
                onTap: () => _showChangePinDialog(),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.fingerprint,
                title: 'ใช้ลายนิ้วมือ',
                subtitle: 'เปิด/ปิดการใช้ Biometric',
                trailing: Switch(
                  value: AuthService.useBiometric(),
                  onChanged: (value) async {
                    await AuthService.setBiometric(value);
                    setState(() {});
                    _showSnackBar(value ? 'เปิดใช้งาน Biometric' : 'ปิดใช้งาน Biometric');
                  },
                  activeTrackColor: AppColors.primary.withAlpha(100),
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ]),

            const SizedBox(height: 24),

            // Notifications Section
            _buildSectionHeader('การแจ้งเตือน', Icons.notifications_outlined),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.notifications_active_outlined,
                title: 'การแจ้งเตือน',
                subtitle: 'รับการแจ้งเตือนจากแอป',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) async {
                    await SettingsService.setNotificationsEnabled(value);
                    setState(() => _notificationsEnabled = value);
                    _showSnackBar(value ? 'เปิดการแจ้งเตือน' : 'ปิดการแจ้งเตือน');
                  },
                  activeTrackColor: AppColors.primary.withAlpha(100),
                  activeThumbColor: AppColors.primary,
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.volume_up_outlined,
                title: 'เสียง',
                subtitle: 'เปิด/ปิดเสียงในแอป',
                trailing: Switch(
                  value: _soundEnabled,
                  onChanged: (value) async {
                    await SettingsService.setSoundEnabled(value);
                    setState(() => _soundEnabled = value);
                    _showSnackBar(value ? 'เปิดเสียง' : 'ปิดเสียง');
                  },
                  activeTrackColor: AppColors.primary.withAlpha(100),
                  activeThumbColor: AppColors.primary,
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.vibration,
                title: 'สั่น',
                subtitle: 'เปิด/ปิดการสั่น',
                trailing: Switch(
                  value: _vibrationEnabled,
                  onChanged: (value) async {
                    await SettingsService.setVibrationEnabled(value);
                    setState(() => _vibrationEnabled = value);
                    _showSnackBar(value ? 'เปิดการสั่น' : 'ปิดการสั่น');
                  },
                  activeTrackColor: AppColors.primary.withAlpha(100),
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ]),

            const SizedBox(height: 24),

            // Display Section
            _buildSectionHeader('การแสดงผล', Icons.palette_outlined),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.dark_mode_outlined,
                title: 'โหมดมืด',
                subtitle: _darkMode ? 'กำลังใช้ธีมสีเข้ม' : 'กำลังใช้ธีมสีอ่อน',
                trailing: Switch(
                  value: _darkMode,
                  onChanged: (value) async {
                    await SettingsService.setDarkMode(value);
                    themeProvider.setDarkMode(value);
                    setState(() => _darkMode = value);
                    _showSnackBar(
                      value ? 'เปลี่ยนเป็นโหมดมืด' : 'เปลี่ยนเป็นโหมดสว่าง',
                    );
                  },
                  activeTrackColor: AppColors.primary.withAlpha(100),
                  activeThumbColor: AppColors.primary,
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.text_fields,
                title: 'ขนาดตัวอักษร',
                subtitle: SettingsService.getFontSizeLabel(_fontSize),
                onTap: () => _showFontSizeDialog(),
              ),
            ]),

            const SizedBox(height: 24),

            // Data Section
            _buildSectionHeader('ข้อมูล', Icons.storage_outlined),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.refresh,
                title: 'รีเซ็ตความก้าวหน้า',
                subtitle: 'ล้างประวัติการเรียนทั้งหมด',
                textColor: AppColors.warning,
                onTap: () => _showResetProgressDialog(),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.download_outlined,
                title: 'ส่งออกข้อมูล',
                subtitle: 'ดาวน์โหลดข้อมูลของคุณ',
                onTap: () => _showExportDataDialog(),
              ),
            ]),

            const SizedBox(height: 24),

            // App Info Section
            _buildSectionHeader('เกี่ยวกับแอป', Icons.info_outline),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.apps,
                title: 'เวอร์ชัน',
                subtitle: 'v2.0.0',
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.description_outlined,
                title: 'ข้อกำหนดการใช้งาน',
                subtitle: 'อ่านข้อกำหนดและเงื่อนไข',
                onTap: () => _showTermsDialog(),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.privacy_tip_outlined,
                title: 'นโยบายความเป็นส่วนตัว',
                subtitle: 'อ่านนโยบายความเป็นส่วนตัว',
                onTap: () => _showPrivacyDialog(),
              ),
            ]),

            const SizedBox(height: 24),

            // Danger Zone
            _buildSectionHeader(
              'โซนอันตราย',
              Icons.warning_amber_outlined,
              color: AppColors.danger,
            ),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Icons.logout,
                title: 'ออกจากระบบ',
                subtitle: 'ออกจากระบบปัจจุบัน',
                textColor: AppColors.warning,
                onTap: () => _showLogoutDialog(),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.delete_forever,
                title: 'ลบบัญชี',
                subtitle: 'ลบบัญชีและข้อมูลทั้งหมด',
                textColor: AppColors.danger,
                onTap: () => _showDeleteAccountDialog(),
              ),
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(icon, color: color ?? AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: trailing == null ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (textColor ?? AppColors.primary).withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: textColor ?? AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor ?? AppColors.textPrimary,
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
              if (trailing != null)
                trailing
              else
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surface,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showChangePinDialog() {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'เปลี่ยนรหัส PIN',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'รหัส PIN เดิม',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'รหัส PIN ใหม่',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'ยืนยันรหัส PIN ใหม่',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPinController.text != confirmPinController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('รหัส PIN ไม่ตรงกัน')),
                );
                return;
              }
              if (newPinController.text.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('รหัส PIN ต้องมีอย่างน้อย 4 หลัก')),
                );
                return;
              }
              final success = await AuthService.changePin(
                oldPinController.text,
                newPinController.text,
              );
              if (success) {
                Navigator.pop(context);
                _showSnackBar('เปลี่ยนรหัส PIN สำเร็จ');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('รหัส PIN เดิมไม่ถูกต้อง')),
                );
              }
            },
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'ขนาดตัวอักษร',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFontSizeOption('small', 'เล็ก', 12),
            _buildFontSizeOption('normal', 'ปกติ', 14),
            _buildFontSizeOption('large', 'ใหญ่', 16),
            _buildFontSizeOption('xlarge', 'ใหญ่มาก', 18),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeOption(String value, String label, double previewSize) {
    final isSelected = _fontSize == value;
    return ListTile(
      leading: Container(
        width: 40,
        alignment: Alignment.center,
        child: Text(
          'ก',
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontSize: previewSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(Icons.circle_outlined, color: AppColors.textMuted),
      onTap: () async {
        await SettingsService.setFontSize(value);
        if (!mounted) return;
        setState(() => _fontSize = value);
        Navigator.pop(context);
        _showSnackBar('เปลี่ยนขนาดตัวอักษรเป็น $label');
      },
    );
  }

  void _showResetProgressDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: AppColors.warning),
            SizedBox(width: 10),
            Text(
              'รีเซ็ตความก้าวหน้า',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: const Text(
          'การดำเนินการนี้จะลบประวัติการเรียน, คะแนน Quiz และ XP ทั้งหมด\n\nคุณแน่ใจหรือไม่?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ProgressService.resetProgress();
              Navigator.pop(context);
              _showSnackBar('รีเซ็ตความก้าวหน้าเรียบร้อย');
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            child: const Text('รีเซ็ต'),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final exportData = await SettingsService.exportUserData();
      final summary = SettingsService.getDataSummary();

      if (!mounted) return;
      Navigator.pop(context); // Close loading

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.download_outlined, color: AppColors.primary),
              SizedBox(width: 10),
              Text(
                'ส่งออกข้อมูล',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'สรุปข้อมูล',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow('ชื่อ', summary['userName']),
                      _buildSummaryRow('บทเรียนที่เรียนจบ', '${summary['lessonsCompleted']} บท'),
                      _buildSummaryRow('แบบทดสอบที่ทำ', '${summary['quizzesCompleted']} ข้อ'),
                      _buildSummaryRow('XP รวม', '${summary['totalXp']} XP'),
                      _buildSummaryRow('Level', '${summary['level']}'),
                      _buildSummaryRow('วันที่เข้าใช้งาน', '${summary['loginDays']} วัน'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // JSON Preview
                const Text(
                  'ข้อมูล JSON',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      exportData,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ปิด'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: exportData));
                if (!context.mounted) return;
                Navigator.pop(context);
                _showSnackBar('คัดลอกข้อมูลไปยัง Clipboard แล้ว');
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('คัดลอก'),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading
      _showSnackBar('เกิดข้อผิดพลาด: $e');
    }
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'ข้อกำหนดการใช้งาน',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '''ข้อกำหนดและเงื่อนไขการใช้งาน RTA EW Simulator

1. วัตถุประสงค์
แอปพลิเคชันนี้พัฒนาขึ้นเพื่อการศึกษาและฝึกอบรมด้านสงครามอิเล็กทรอนิกส์ (Electronic Warfare) สำหรับบุคลากรของกองทัพบกไทย

2. การใช้งาน
- ผู้ใช้ต้องเป็นบุคลากรที่ได้รับอนุญาตเท่านั้น
- ห้ามเผยแพร่หรือแชร์ข้อมูลในแอปให้บุคคลภายนอก
- ใช้เพื่อการศึกษาและฝึกอบรมเท่านั้น

3. ความรับผิดชอบ
- ผู้ใช้รับผิดชอบต่อการรักษาความลับของข้อมูล
- การใช้งานผิดวัตถุประสงค์อาจถูกดำเนินการทางวินัย

4. การปรับปรุงแอป
ทางผู้พัฒนาขอสงวนสิทธิ์ในการปรับปรุงแก้ไขแอปโดยไม่ต้องแจ้งล่วงหน้า

พัฒนาโดย: ร.ต. วสันต์ ทัศนามล
โรงเรียนทหารสื่อสาร
เวอร์ชัน: 2.0.0''',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
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

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'นโยบายความเป็นส่วนตัว',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '''นโยบายความเป็นส่วนตัว RTA EW Simulator

1. ข้อมูลที่เก็บรวบรวม
- ข้อมูลส่วนตัว: ชื่อ, ยศ, หน่วย, ตำแหน่ง
- ข้อมูลการใช้งาน: ประวัติการเรียน, คะแนน Quiz
- ข้อมูลเข้าสู่ระบบ: รหัส PIN (เข้ารหัส)

2. การใช้ข้อมูล
- เพื่อติดตามความก้าวหน้าในการเรียน
- เพื่อปรับปรุงประสบการณ์การใช้งาน
- ไม่มีการส่งข้อมูลออกนอกอุปกรณ์

3. การเก็บรักษาข้อมูล
- ข้อมูลเก็บในอุปกรณ์ของผู้ใช้เท่านั้น
- ไม่มีการส่งข้อมูลไปยัง Server ภายนอก
- ผู้ใช้สามารถลบข้อมูลได้ตลอดเวลา

4. ความปลอดภัย
- รหัส PIN ถูกเข้ารหัสก่อนจัดเก็บ
- รองรับการยืนยันตัวตนด้วย Biometric

5. สิทธิ์ของผู้ใช้
- ดูข้อมูลของตนเอง
- ส่งออกข้อมูล
- ลบบัญชีและข้อมูลทั้งหมด

ติดต่อ: ร.ต. วสันต์ ทัศนามล
โรงเรียนทหารสื่อสาร''',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'ออกจากระบบ',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'คุณต้องการออกจากระบบหรือไม่?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService.logout();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AuthScreen(
                      onAuthSuccess: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MainShell(),
                          ),
                        );
                      },
                    ),
                  ),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: AppColors.danger),
            SizedBox(width: 10),
            Text('ลบบัญชี', style: TextStyle(color: AppColors.danger)),
          ],
        ),
        content: const Text(
          'การลบบัญชีจะลบข้อมูลทั้งหมดอย่างถาวร รวมถึง:\n\n'
          '• ข้อมูลส่วนตัว\n'
          '• ประวัติการเรียน\n'
          '• คะแนนและ Achievements\n'
          '• การตั้งค่าทั้งหมด\n\n'
          'การดำเนินการนี้ไม่สามารถยกเลิกได้',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService.deleteAccount();
              await ProgressService.resetProgress();
              await SettingsService.resetSettings();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AuthScreen(
                      onAuthSuccess: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MainShell(),
                          ),
                        );
                      },
                    ),
                  ),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('ลบบัญชี'),
          ),
        ],
      ),
    );
  }
}
