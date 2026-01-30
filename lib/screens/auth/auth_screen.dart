import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/constants.dart';
import '../../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthSuccess;

  const AuthScreen({super.key, required this.onAuthSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLogin = true;
  bool _showPinInput = false;
  int _currentStep = 0;

  // Controllers
  final _odIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedRank = MilitaryRanks.enlisted.first;
  String _selectedUnit = MilitaryUnits.units.first;
  String _position = '';

  // PIN input
  final List<String> _pin = ['', '', '', '', '', ''];
  final List<String> _confirmPin = ['', '', '', '', '', ''];
  int _pinIndex = 0;
  bool _isConfirmingPin = false;
  String? _pinError;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    // Check if user exists
    _isLogin = AuthService.hasExistingUser();
    if (_isLogin) {
      _showPinInput = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _odIdController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _showPinInput ? _buildPinScreen() : _buildAuthScreen(),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Logo and Title
          _buildHeader(),

          const SizedBox(height: 40),

          // Toggle Login/Register
          if (!AuthService.hasExistingUser()) _buildToggle(),

          const SizedBox(height: 32),

          // Form
          _isLogin ? _buildLoginForm() : _buildRegisterForm(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(100),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.radar,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'EW SIMULATOR',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isLogin ? 'ยินดีต้อนรับกลับ' : 'ลงทะเบียนผู้ใช้ใหม่',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLogin = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _isLogin ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(
                      color: _isLogin ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLogin = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: !_isLogin ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'ลงทะเบียน',
                    style: TextStyle(
                      color: !_isLogin ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _odIdController,
          label: 'รหัสประจำตัว',
          hint: 'เลขประจำตัวทหาร หรือ รหัสผู้ใช้',
          icon: Icons.badge_outlined,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          label: 'ดำเนินการต่อ',
          icon: Icons.arrow_forward,
          onPressed: () {
            if (_odIdController.text.isNotEmpty) {
              setState(() => _showPinInput = true);
            }
          },
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        // Step Indicator
        _buildStepIndicator(),
        const SizedBox(height: 32),

        // Step Content
        if (_currentStep == 0) _buildStep1(),
        if (_currentStep == 1) _buildStep2(),
        if (_currentStep == 2) _buildStep3(),

        const SizedBox(height: 32),

        // Navigation Buttons
        Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _currentStep--),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('ย้อนกลับ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: _currentStep > 0 ? 2 : 1,
              child: _buildPrimaryButton(
                label: _currentStep < 2 ? 'ถัดไป' : 'ตั้งรหัส PIN',
                icon: _currentStep < 2 ? Icons.arrow_forward : Icons.lock,
                onPressed: _handleNextStep,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index <= _currentStep;
        final isCompleted = index < _currentStep;

        return Expanded(
          child: Row(
            children: [
              if (index > 0)
                Expanded(
                  child: Container(
                    height: 3,
                    color: isActive ? AppColors.primary : AppColors.border,
                  ),
                ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (index < 2)
                Expanded(
                  child: Container(
                    height: 3,
                    color: index < _currentStep ? AppColors.primary : AppColors.border,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ข้อมูลส่วนตัว',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'กรอกข้อมูลเพื่อสร้างบัญชีผู้ใช้',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _odIdController,
          label: 'รหัสประจำตัว *',
          hint: 'เลขประจำตัวทหาร หรือ รหัสอื่น',
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nameController,
          label: 'ชื่อ-นามสกุล *',
          hint: 'ชื่อจริง นามสกุลจริง',
          icon: Icons.person_outline,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ข้อมูลหน่วย',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'ระบุยศและหน่วยสังกัด',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        _buildDropdown(
          label: 'ยศ *',
          value: _selectedRank,
          items: MilitaryRanks.all,
          icon: Icons.military_tech,
          onChanged: (v) => setState(() => _selectedRank = v!),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'หน่วย *',
          value: _selectedUnit,
          items: MilitaryUnits.units,
          icon: Icons.business,
          onChanged: (v) => setState(() => _selectedUnit = v!),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: TextEditingController(text: _position),
          label: 'ตำแหน่ง',
          hint: 'เช่น พลวิทยุ, ผบ.มว.',
          icon: Icons.work_outline,
          onChanged: (v) => _position = v,
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ข้อมูลติดต่อ',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'ข้อมูลเพิ่มเติม (ไม่บังคับ)',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _phoneController,
          label: 'เบอร์โทรศัพท์',
          hint: '08X-XXX-XXXX',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),

        // Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'สรุปข้อมูล',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSummaryRow('รหัส', _odIdController.text),
              _buildSummaryRow('ชื่อ', '$_selectedRank ${_nameController.text}'),
              _buildSummaryRow('หน่วย', _selectedUnit),
              if (_position.isNotEmpty) _buildSummaryRow('ตำแหน่ง', _position),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinScreen() {
    final user = AuthService.getCurrentUser();
    final isNewUser = !AuthService.hasExistingUser() || user == null;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 60),

          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(80),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Icon(
              isNewUser ? Icons.lock : Icons.person,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),

          Text(
            isNewUser
                ? (_isConfirmingPin ? 'ยืนยันรหัส PIN' : 'ตั้งรหัส PIN 6 หลัก')
                : 'ใส่รหัส PIN',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isNewUser
                ? 'รหัสนี้ใช้สำหรับเข้าสู่ระบบ'
                : 'สวัสดี, ${AuthService.getShortName()}',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),

          const SizedBox(height: 40),

          // PIN Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final currentPinList = _isConfirmingPin ? _confirmPin : _pin;
              final isFilled = currentPinList[index].isNotEmpty;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isFilled ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFilled ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
              );
            }),
          ),

          if (_pinError != null) ...[
            const SizedBox(height: 16),
            Text(
              _pinError!,
              style: const TextStyle(color: AppColors.danger, fontSize: 14),
            ),
          ],

          const Spacer(),

          // Number Pad
          _buildNumberPad(),

          const SizedBox(height: 24),

          // Cancel / Switch user
          if (!isNewUser)
            TextButton(
              onPressed: () => setState(() {
                _showPinInput = false;
                _pin.fillRange(0, 6, '');
                _pinIndex = 0;
              }),
              child: const Text(
                'เปลี่ยนผู้ใช้',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            TextButton(
              onPressed: () => setState(() {
                _showPinInput = false;
                _pin.fillRange(0, 6, '');
                _confirmPin.fillRange(0, 6, '');
                _pinIndex = 0;
                _isConfirmingPin = false;
              }),
              child: const Text(
                'ย้อนกลับ',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80, height: 80), // Empty space
            _buildNumberButton('0'),
            _buildDeleteButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onNumberPressed(number),
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onDeletePressed,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.backspace_outlined,
              color: AppColors.textSecondary,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
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
          onChanged: onChanged,
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
              value: value,
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
                      Text(
                        item,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
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

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: AppColors.primary.withAlpha(100),
        ),
      ),
    );
  }

  void _handleNextStep() {
    if (_currentStep == 0) {
      if (_odIdController.text.isEmpty || _nameController.text.isEmpty) {
        _showError('กรุณากรอกข้อมูลให้ครบถ้วน');
        return;
      }
    }
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      setState(() => _showPinInput = true);
    }
  }

  void _onNumberPressed(String number) {
    HapticFeedback.lightImpact();
    setState(() {
      _pinError = null;
      final currentPinList = _isConfirmingPin ? _confirmPin : _pin;

      if (_pinIndex < 6) {
        currentPinList[_pinIndex] = number;
        _pinIndex++;

        if (_pinIndex == 6) {
          _handlePinComplete();
        }
      }
    });
  }

  void _onDeletePressed() {
    HapticFeedback.selectionClick();
    setState(() {
      final currentPinList = _isConfirmingPin ? _confirmPin : _pin;
      if (_pinIndex > 0) {
        _pinIndex--;
        currentPinList[_pinIndex] = '';
      }
    });
  }

  Future<void> _handlePinComplete() async {
    final pinString = (_isConfirmingPin ? _confirmPin : _pin).join();

    if (AuthService.hasExistingUser()) {
      // Existing user - verify PIN
      final success = await AuthService.quickLogin(pinString);
      if (success) {
        widget.onAuthSuccess();
      } else {
        setState(() {
          _pinError = 'รหัส PIN ไม่ถูกต้อง';
          _pin.fillRange(0, 6, '');
          _pinIndex = 0;
        });
        HapticFeedback.heavyImpact();
      }
    } else {
      // New user - set/confirm PIN
      if (!_isConfirmingPin) {
        // First PIN entry - ask for confirmation
        setState(() {
          _isConfirmingPin = true;
          _pinIndex = 0;
        });
      } else {
        // Confirming PIN
        if (_pin.join() == _confirmPin.join()) {
          // PINs match - register user
          await AuthService.register(
            odId: _odIdController.text,
            fullName: _nameController.text,
            rank: _selectedRank,
            unit: _selectedUnit,
            position: _position,
            phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
            pin: pinString,
          );
          widget.onAuthSuccess();
        } else {
          setState(() {
            _pinError = 'รหัส PIN ไม่ตรงกัน ลองใหม่อีกครั้ง';
            _pin.fillRange(0, 6, '');
            _confirmPin.fillRange(0, 6, '');
            _pinIndex = 0;
            _isConfirmingPin = false;
          });
          HapticFeedback.heavyImpact();
        }
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
