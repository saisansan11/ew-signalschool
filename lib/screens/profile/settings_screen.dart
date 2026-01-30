import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('ตั้งค่า'),
        centerTitle: true,
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
                  },
                  activeColor: AppColors.primary,
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
                  onChanged: (value) => setState(() => _notificationsEnabled = value),
                  activeColor: AppColors.primary,
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.volume_up_outlined,
                title: 'เสียง',
                subtitle: 'เปิด/ปิดเสียงในแอป',
                trailing: Switch(
                  value: _soundEnabled,
                  onChanged: (value) => setState(() => _soundEnabled = value),
                  activeColor: AppColors.primary,
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.vibration,
                title: 'สั่น',
                subtitle: 'เปิด/ปิดการสั่น',
                trailing: Switch(
                  value: _vibrationEnabled,
                  onChanged: (value) => setState(() => _vibrationEnabled = value),
                  activeColor: AppColors.primary,
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
                subtitle: 'ใช้ธีมสีเข้ม',
                trailing: Switch(
                  value: _darkMode,
                  onChanged: (value) => setState(() => _darkMode = value),
                  activeColor: AppColors.primary,
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.text_fields,
                title: 'ขนาดตัวอักษร',
                subtitle: 'ปกติ',
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
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 24),

            // Danger Zone
            _buildSectionHeader('โซนอันตราย', Icons.warning_amber_outlined, color: AppColors.danger),
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
                child: Icon(icon, color: textColor ?? AppColors.primary, size: 22),
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

  void _showChangePinDialog() {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('เปลี่ยนรหัส PIN', style: TextStyle(color: AppColors.textPrimary)),
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
              final success = await AuthService.changePin(
                oldPinController.text,
                newPinController.text,
              );
              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เปลี่ยนรหัส PIN สำเร็จ')),
                );
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
        title: const Text('ขนาดตัวอักษร', style: TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFontSizeOption('เล็ก', false),
            _buildFontSizeOption('ปกติ', true),
            _buildFontSizeOption('ใหญ่', false),
            _buildFontSizeOption('ใหญ่มาก', false),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeOption(String label, bool selected) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
      trailing: selected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () => Navigator.pop(context),
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
            Text('รีเซ็ตความก้าวหน้า', style: TextStyle(color: AppColors.textPrimary)),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('รีเซ็ตความก้าวหน้าเรียบร้อย')),
              );
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            child: const Text('รีเซ็ต'),
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
        title: const Text('ออกจากระบบ', style: TextStyle(color: AppColors.textPrimary)),
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
                          MaterialPageRoute(builder: (context) => const MainShell()),
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
          '• คะแนนและ Achievements\n\n'
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
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AuthScreen(
                      onAuthSuccess: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const MainShell()),
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
