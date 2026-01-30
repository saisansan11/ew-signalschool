import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/constants.dart';

class PowerConverter extends StatefulWidget {
  const PowerConverter({super.key});

  @override
  State<PowerConverter> createState() => _PowerConverterState();
}

class _PowerConverterState extends State<PowerConverter>
    with SingleTickerProviderStateMixin {
  // Input mode
  String _inputMode = 'watts'; // watts, dbm, dbw
  double _inputValue = 1.0;

  // Animation controller
  late AnimationController _animController;

  // Common power levels for reference
  final List<_PowerReference> _references = [
    _PowerReference('โทรศัพท์มือถือ', 0.2, AppColors.success),
    _PowerReference('วิทยุ Handheld', 5.0, AppColors.primary),
    _PowerReference('วิทยุ Manpack', 20.0, AppColors.warning),
    _PowerReference('วิทยุ Vehicular', 50.0, const Color(0xFFFF9800)),
    _PowerReference('Base Station', 100.0, AppColors.danger),
    _PowerReference('Jammer ขนาดเล็ก', 10.0, AppColors.tabLearning),
    _PowerReference('Jammer ขนาดกลาง', 100.0, const Color(0xFFE91E63)),
    _PowerReference('Jammer ขนาดใหญ่', 1000.0, const Color(0xFF9C27B0)),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Conversion formulas
  double get _watts {
    switch (_inputMode) {
      case 'watts':
        return _inputValue;
      case 'dbm':
        return math.pow(10, (_inputValue - 30) / 10).toDouble();
      case 'dbw':
        return math.pow(10, _inputValue / 10).toDouble();
      default:
        return _inputValue;
    }
  }

  double get _milliwatts => _watts * 1000;
  double get _dbm => 10 * math.log(_watts * 1000) / math.ln10;
  double get _dbw => 10 * math.log(_watts) / math.ln10;

  // Additional useful conversions
  double get _kilowatts => _watts / 1000;
  double get _microvolts50ohm => math.sqrt(_watts * 50) * 1000000;

  void _setInputValue(double value) {
    setState(() => _inputValue = value);
  }

  void _setInputMode(String mode) {
    // Convert current watts value to new mode's equivalent
    final currentWatts = _watts;
    setState(() {
      _inputMode = mode;
      switch (mode) {
        case 'watts':
          _inputValue = currentWatts;
          break;
        case 'dbm':
          _inputValue = 10 * math.log(currentWatts * 1000) / math.ln10;
          break;
        case 'dbw':
          _inputValue = 10 * math.log(currentWatts) / math.ln10;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Power Converter'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visual Power Scale
            _buildPowerScale(),
            const SizedBox(height: 20),

            // Input Section
            _buildInputSection(),
            const SizedBox(height: 20),

            // Conversion Results
            _buildConversionResults(),
            const SizedBox(height: 20),

            // Quick Reference
            _buildQuickReference(),
            const SizedBox(height: 20),

            // dB Math Helper
            _buildDbMathHelper(),
            const SizedBox(height: 20),

            // Formula Reference
            _buildFormulaReference(),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerScale() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, _) {
            return CustomPaint(
              painter: _PowerScalePainter(
                currentDbm: _dbm,
                animValue: _animController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.input, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'ป้อนค่ากำลัง',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Unit Selection
          Row(
            children: [
              _buildUnitChip('watts', 'Watts (W)'),
              const SizedBox(width: 10),
              _buildUnitChip('dbm', 'dBm'),
              const SizedBox(width: 10),
              _buildUnitChip('dbw', 'dBW'),
            ],
          ),
          const SizedBox(height: 16),

          // Value Input
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withAlpha(100)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: TextStyle(color: AppColors.textMuted),
                          ),
                          controller: TextEditingController(
                            text: _inputValue.toStringAsFixed(2),
                          ),
                          onChanged: (value) {
                            final parsed = double.tryParse(value);
                            if (parsed != null) {
                              _setInputValue(parsed);
                            }
                          },
                        ),
                      ),
                      Text(
                        _getUnitLabel(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickButton('÷10', () => _setInputValue(_inputValue / 10)),
              _buildQuickButton('÷2', () => _setInputValue(_inputValue / 2)),
              _buildQuickButton('×2', () => _setInputValue(_inputValue * 2)),
              _buildQuickButton('×10', () => _setInputValue(_inputValue * 10)),
              _buildQuickButton('-10dB', () {
                if (_inputMode == 'watts') {
                  _setInputValue(_watts / 10);
                } else {
                  _setInputValue(_inputValue - 10);
                }
              }),
              _buildQuickButton('+10dB', () {
                if (_inputMode == 'watts') {
                  _setInputValue(_watts * 10);
                } else {
                  _setInputValue(_inputValue + 10);
                }
              }),
              _buildQuickButton('-3dB', () {
                if (_inputMode == 'watts') {
                  _setInputValue(_watts / 2);
                } else {
                  _setInputValue(_inputValue - 3);
                }
              }),
              _buildQuickButton('+3dB', () {
                if (_inputMode == 'watts') {
                  _setInputValue(_watts * 2);
                } else {
                  _setInputValue(_inputValue + 3);
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitChip(String mode, String label) {
    final isSelected = _inputMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => _setInputMode(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withAlpha(30)
                : AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getUnitLabel() {
    switch (_inputMode) {
      case 'watts':
        return 'W';
      case 'dbm':
        return 'dBm';
      case 'dbw':
        return 'dBW';
      default:
        return '';
    }
  }

  Widget _buildConversionResults() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withAlpha(20), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.swap_horiz, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'ผลการแปลง',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main conversions
          Row(
            children: [
              Expanded(
                child: _buildConversionCard(
                  'Watts',
                  _formatPower(_watts),
                  'W',
                  AppColors.danger,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildConversionCard(
                  'dBm',
                  _dbm.toStringAsFixed(2),
                  'dBm',
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildConversionCard(
                  'dBW',
                  _dbw.toStringAsFixed(2),
                  'dBW',
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Secondary conversions
          Row(
            children: [
              Expanded(
                child: _buildConversionCard(
                  'mW',
                  _formatPower(_milliwatts),
                  'mW',
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildConversionCard(
                  'kW',
                  _formatPower(_kilowatts),
                  'kW',
                  AppColors.tabLearning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildConversionCard(
                  'µV @50Ω',
                  _formatPower(_microvolts50ohm),
                  'µV',
                  AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPower(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}k';
    } else if (value >= 1) {
      return value.toStringAsFixed(2);
    } else if (value >= 0.001) {
      return '${(value * 1000).toStringAsFixed(2)}m';
    } else if (value >= 0.000001) {
      return '${(value * 1000000).toStringAsFixed(2)}µ';
    } else {
      return value.toStringAsExponential(2);
    }
  }

  Widget _buildConversionCard(
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            unit,
            style: TextStyle(color: color.withAlpha(180), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReference() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flash_on, color: AppColors.warning, size: 20),
              SizedBox(width: 8),
              Text(
                'ค่าอ้างอิง',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...List.generate(_references.length, (index) {
            final ref = _references[index];
            final refDbm = 10 * math.log(ref.watts * 1000) / math.ln10;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _inputMode = 'watts';
                    _inputValue = ref.watts;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: ref.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ref.name,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      '${ref.watts}W',
                      style: TextStyle(
                        color: ref.color,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '(${refDbm.toStringAsFixed(1)} dBm)',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDbMathHelper() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calculate, color: AppColors.tabLearning, size: 20),
              SizedBox(width: 8),
              Text(
                'คณิตศาสตร์ dB ที่ใช้บ่อย',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildDbMathRow('+3 dB', '× 2', 'เพิ่มกำลังเป็น 2 เท่า'),
          _buildDbMathRow('+6 dB', '× 4', 'เพิ่มกำลังเป็น 4 เท่า'),
          _buildDbMathRow('+10 dB', '× 10', 'เพิ่มกำลังเป็น 10 เท่า'),
          _buildDbMathRow('+20 dB', '× 100', 'เพิ่มกำลังเป็น 100 เท่า'),
          _buildDbMathRow('-3 dB', '÷ 2', 'ลดกำลังลงครึ่งหนึ่ง'),
          _buildDbMathRow('-10 dB', '÷ 10', 'ลดกำลังลง 10 เท่า'),

          const Divider(color: AppColors.border, height: 24),

          const Text(
            'ตัวอย่าง: ถ้า 10W = 40 dBm',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text(
            '• 20W = 40 + 3 = 43 dBm',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const Text(
            '• 100W = 40 + 10 = 50 dBm',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const Text(
            '• 5W = 40 - 3 = 37 dBm',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDbMathRow(String db, String factor, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              db,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 50,
            child: Text(
              factor,
              style: const TextStyle(
                color: AppColors.warning,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaReference() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.functions, color: AppColors.success, size: 20),
              SizedBox(width: 8),
              Text(
                'สูตรการแปลง',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildFormulaCard(
            'Watts → dBm',
            'dBm = 10 × log₁₀(P × 1000)',
            'P = กำลังเป็น Watts',
          ),
          const SizedBox(height: 10),
          _buildFormulaCard(
            'dBm → Watts',
            'P = 10^((dBm - 30) / 10)',
            'ผลลัพธ์เป็น Watts',
          ),
          const SizedBox(height: 10),
          _buildFormulaCard(
            'Watts → dBW',
            'dBW = 10 × log₁₀(P)',
            'P = กำลังเป็น Watts',
          ),
          const SizedBox(height: 10),
          _buildFormulaCard(
            'dBm → dBW',
            'dBW = dBm - 30',
            'หรือ dBm = dBW + 30',
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaCard(String title, String formula, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formula,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Power Converter',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'แปลงหน่วยกำลังไฟฟ้า\n\n'
            'หน่วยที่ใช้:\n'
            '• Watts (W) - หน่วยกำลังสากล\n'
            '• dBm - เดซิเบลเทียบ 1 มิลลิวัตต์\n'
            '• dBW - เดซิเบลเทียบ 1 วัตต์\n\n'
            'การจำง่ายๆ:\n'
            '• 0 dBm = 1 mW\n'
            '• 30 dBm = 1 W\n'
            '• 0 dBW = 1 W\n'
            '• dBm = dBW + 30\n\n'
            'ใช้งานในสนาม:\n'
            '- คำนวณกำลังส่งที่ต้องใช้\n'
            '- เปรียบเทียบประสิทธิภาพอุปกรณ์\n'
            '- คำนวณ Link Budget',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
}

class _PowerReference {
  final String name;
  final double watts;
  final Color color;

  _PowerReference(this.name, this.watts, this.color);
}

class _PowerScalePainter extends CustomPainter {
  final double currentDbm;
  final double animValue;

  _PowerScalePainter({required this.currentDbm, required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 40.0;
    final scaleWidth = size.width - padding * 2;
    final centerY = size.height / 2;

    // Draw scale background
    final scaleBgPaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(padding, centerY - 20, scaleWidth, 40),
        const Radius.circular(8),
      ),
      scaleBgPaint,
    );

    // Draw gradient scale
    final scaleGradientPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.success, AppColors.warning, AppColors.danger],
      ).createShader(Rect.fromLTWH(padding, centerY - 18, scaleWidth, 36));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(padding, centerY - 18, scaleWidth, 36),
        const Radius.circular(6),
      ),
      scaleGradientPaint,
    );

    // Draw scale markers
    final markerPaint = Paint()
      ..color = Colors.white.withAlpha(150)
      ..strokeWidth = 1;

    // dBm range: -30 to 60 (typical range)
    const minDbm = -30.0;
    const maxDbm = 60.0;
    const range = maxDbm - minDbm;

    for (int dbm = -30; dbm <= 60; dbm += 10) {
      final x = padding + ((dbm - minDbm) / range) * scaleWidth;
      canvas.drawLine(
        Offset(x, centerY - 18),
        Offset(x, centerY - 10),
        markerPaint,
      );
      canvas.drawLine(
        Offset(x, centerY + 10),
        Offset(x, centerY + 18),
        markerPaint,
      );

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$dbm',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, centerY + 22),
      );
    }

    // Draw unit label
    final unitPainter = TextPainter(
      text: const TextSpan(
        text: 'dBm',
        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    unitPainter.layout();
    unitPainter.paint(canvas, Offset(size.width - padding + 5, centerY - 6));

    // Draw current position marker
    final clampedDbm = currentDbm.clamp(minDbm, maxDbm);
    final markerX = padding + ((clampedDbm - minDbm) / range) * scaleWidth;

    // Marker glow
    final glowPaint = Paint()
      ..color = Colors.white.withAlpha((100 + animValue * 55).toInt())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(markerX, centerY), 12, glowPaint);

    // Marker triangle
    final trianglePath = Path();
    trianglePath.moveTo(markerX, centerY - 30);
    trianglePath.lineTo(markerX - 8, centerY - 40);
    trianglePath.lineTo(markerX + 8, centerY - 40);
    trianglePath.close();

    canvas.drawPath(trianglePath, Paint()..color = Colors.white);

    // Marker circle
    canvas.drawCircle(
      Offset(markerX, centerY),
      8,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(markerX, centerY),
      5,
      Paint()..color = AppColors.primary,
    );

    // Current value label
    final valuePainter = TextPainter(
      text: TextSpan(
        text: '${currentDbm.toStringAsFixed(1)} dBm',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    valuePainter.layout();
    valuePainter.paint(
      canvas,
      Offset(markerX - valuePainter.width / 2, centerY - 60),
    );

    // Draw reference markers
    _drawReferenceMarker(
      canvas,
      padding,
      scaleWidth,
      centerY,
      minDbm,
      range,
      0,
      '1mW',
    );
    _drawReferenceMarker(
      canvas,
      padding,
      scaleWidth,
      centerY,
      minDbm,
      range,
      30,
      '1W',
    );
    _drawReferenceMarker(
      canvas,
      padding,
      scaleWidth,
      centerY,
      minDbm,
      range,
      50,
      '100W',
    );
  }

  void _drawReferenceMarker(
    Canvas canvas,
    double padding,
    double scaleWidth,
    double centerY,
    double minDbm,
    double range,
    double dbm,
    String label,
  ) {
    final x = padding + ((dbm - minDbm) / range) * scaleWidth;

    final dotPaint = Paint()..color = Colors.white.withAlpha(200);
    canvas.drawCircle(Offset(x, centerY + 45), 3, dotPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, centerY + 52));
  }

  @override
  bool shouldRepaint(covariant _PowerScalePainter oldDelegate) {
    return currentDbm != oldDelegate.currentDbm ||
        animValue != oldDelegate.animValue;
  }
}
