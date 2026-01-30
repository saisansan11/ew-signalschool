import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _positionController;

  String _selectedRank = '';
  String _selectedUnit = '';
  String _selectedAvatar = 'military';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.getCurrentUser();
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _positionController = TextEditingController(text: user?.position ?? '');
    _selectedRank = user?.rank ?? MilitaryRanks.enlisted.first;
    _selectedUnit = user?.unit ?? MilitaryUnits.units.first;
    _selectedAvatar = user?.avatarType ?? 'military';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('แก้ไขโปรไฟล์'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('บันทึก', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Selection
            _buildAvatarSection(),
            const SizedBox(height: 32),

            // Personal Info
            _buildSectionHeader('ข้อมูลส่วนตัว'),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _nameController,
              label: 'ชื่อ-นามสกุล',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            _buildDropdown(
              label: 'ยศ',
              value: _selectedRank,
              items: MilitaryRanks.all,
              icon: Icons.military_tech,
              onChanged: (v) => setState(() => _selectedRank = v!),
            ),
            const SizedBox(height: 16),

            _buildDropdown(
              label: 'หน่วย',
              value: _selectedUnit,
              items: MilitaryUnits.units,
              icon: Icons.business,
              onChanged: (v) => setState(() => _selectedUnit = v!),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _positionController,
              label: 'ตำแหน่ง',
              icon: Icons.work_outline,
              hint: 'เช่น พลวิทยุ, ผบ.มว.',
            ),

            const SizedBox(height: 32),

            // Contact Info
            _buildSectionHeader('ข้อมูลติดต่อ'),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              label: 'เบอร์โทรศัพท์',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              hint: '08X-XXX-XXXX',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Text(
            'เลือกไอคอนโปรไฟล์',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAvatarOption('military', Icons.military_tech, 'ทหาร'),
              _buildAvatarOption('shield', Icons.shield, 'โล่'),
              _buildAvatarOption('radio', Icons.radio, 'วิทยุ'),
              _buildAvatarOption('signal', Icons.radar, 'เรดาร์'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarOption(String type, IconData icon, String label) {
    final isSelected = _selectedAvatar == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedAvatar = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: AppColors.primary.withAlpha(50), blurRadius: 10)]
                    : null,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textMuted,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              dropdownColor: AppColors.surface,
              icon: const Icon(Icons.expand_more, color: AppColors.textSecondary),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, color: AppColors.textSecondary, size: 20),
                      const SizedBox(width: 12),
                      Text(item, style: const TextStyle(color: AppColors.textPrimary)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      await AuthService.updateProfile(
        fullName: _nameController.text,
        rank: _selectedRank,
        unit: _selectedUnit,
        position: _positionController.text,
        phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        avatarType: _selectedAvatar,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('บันทึกข้อมูลเรียบร้อย'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
