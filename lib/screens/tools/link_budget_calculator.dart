import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/constants.dart';

class LinkBudgetCalculator extends StatefulWidget {
  const LinkBudgetCalculator({super.key});

  @override
  State<LinkBudgetCalculator> createState() => _LinkBudgetCalculatorState();
}

class _LinkBudgetCalculatorState extends State<LinkBudgetCalculator>
    with TickerProviderStateMixin {
  // Input values
  double _txPower = 5.0; // Watts
  double _txGain = 3.0; // dBi
  double _rxGain = 3.0; // dBi
  double _frequency = 150.0; // MHz
  double _distance = 10.0; // km
  double _cableLossTx = 1.0; // dB
  double _cableLossRx = 1.0; // dB
  double _additionalLoss = 0.0; // dB (terrain, foliage, etc.)

  // Animation controllers
  late AnimationController _signalAnimController;
  late AnimationController _pulseController;
  late Animation<double> _signalAnimation;

  // Preset scenarios
  final List<_PresetScenario> _presets = [
    _PresetScenario(
      name: 'PRC-77 ภูมิประเทศราบ',
      description: 'วิทยุ PRC-77 ในพื้นที่ราบ',
      txPower: 2.0,
      txGain: 0,
      rxGain: 0,
      frequency: 50.0,
      distance: 8.0,
      cableLossTx: 0.5,
      cableLossRx: 0.5,
      additionalLoss: 2.0,
    ),
    _PresetScenario(
      name: 'AN/PRC-624 ชายแดน',
      description: 'วิทยุ HF ในพื้นที่ป่าเขา ไทย-กัมพูชา',
      txPower: 20.0,
      txGain: 2.0,
      rxGain: 2.0,
      frequency: 8.0,
      distance: 50.0,
      cableLossTx: 1.0,
      cableLossRx: 1.0,
      additionalLoss: 6.0,
    ),
    _PresetScenario(
      name: 'Tactical UHF',
      description: 'วิทยุ UHF ในยุทธบริเวณ',
      txPower: 10.0,
      txGain: 5.0,
      rxGain: 5.0,
      frequency: 400.0,
      distance: 20.0,
      cableLossTx: 2.0,
      cableLossRx: 2.0,
      additionalLoss: 4.0,
    ),
    _PresetScenario(
      name: 'Manpack Satcom',
      description: 'การสื่อสารผ่านดาวเทียม',
      txPower: 50.0,
      txGain: 15.0,
      rxGain: 40.0,
      frequency: 14000.0,
      distance: 36000.0,
      cableLossTx: 1.5,
      cableLossRx: 1.0,
      additionalLoss: 0.5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _signalAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _signalAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _signalAnimController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _signalAnimController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Link Budget Calculations (accurate formulas)
  double get _txPowerDbm =>
      10 * math.log(_txPower * 1000) / math.ln10; // W to dBm
  double get _eirp => _txPowerDbm + _txGain - _cableLossTx; // dBm

  // Free Space Path Loss (Friis formula)
  double get _fspl {
    // FSPL(dB) = 20log10(d) + 20log10(f) + 32.45
    // where d = km, f = MHz
    if (_distance <= 0 || _frequency <= 0) return 0;
    return 20 * math.log(_distance) / math.ln10 +
        20 * math.log(_frequency) / math.ln10 +
        32.45;
  }

  double get _totalPathLoss => _fspl + _additionalLoss;
  double get _rxPower => _eirp - _totalPathLoss + _rxGain - _cableLossRx;

  // Link margin (typical receiver sensitivity for tactical radio: -110 dBm)
  double get _rxSensitivity => -110.0;
  double get _linkMargin => _rxPower - _rxSensitivity;

  String get _linkQuality {
    if (_linkMargin > 20) return 'ดีมาก';
    if (_linkMargin > 10) return 'ดี';
    if (_linkMargin > 5) return 'พอใช้';
    if (_linkMargin > 0) return 'อ่อน';
    return 'ไม่ได้';
  }

  Color get _linkQualityColor {
    if (_linkMargin > 20) return AppColors.success;
    if (_linkMargin > 10) return const Color(0xFF4CAF50);
    if (_linkMargin > 5) return AppColors.warning;
    if (_linkMargin > 0) return const Color(0xFFFF9800);
    return AppColors.danger;
  }

  void _applyPreset(_PresetScenario preset) {
    setState(() {
      _txPower = preset.txPower;
      _txGain = preset.txGain;
      _rxGain = preset.rxGain;
      _frequency = preset.frequency;
      _distance = preset.distance;
      _cableLossTx = preset.cableLossTx;
      _cableLossRx = preset.cableLossRx;
      _additionalLoss = preset.additionalLoss;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Link Budget Calculator'),
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
            // Visual Propagation Diagram
            _buildPropagationDiagram(),
            const SizedBox(height: 20),

            // Preset Scenarios
            _buildPresetsSection(),
            const SizedBox(height: 20),

            // Input Parameters
            _buildInputSection(),
            const SizedBox(height: 20),

            // Results
            _buildResultsSection(),
            const SizedBox(height: 20),

            // Link Budget Breakdown
            _buildLinkBudgetBreakdown(),
            const SizedBox(height: 20),

            // Formula Explanation
            _buildFormulaExplanation(),
          ],
        ),
      ),
    );
  }

  Widget _buildPropagationDiagram() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedBuilder(
          animation: Listenable.merge([_signalAnimation, _pulseController]),
          builder: (context, _) {
            return CustomPaint(
              painter: _PropagationDiagramPainter(
                signalProgress: _signalAnimation.value,
                pulseValue: _pulseController.value,
                linkQuality: _linkMargin,
                distance: _distance,
                frequency: _frequency,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPresetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.bookmarks, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'สถานการณ์ตัวอย่าง',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _presets.map((preset) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => _applyPreset(preset),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withAlpha(100),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          preset.name,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          preset.description,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
              Icon(Icons.tune, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'พารามิเตอร์',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // TX Power
          _buildSliderInput(
            label: 'กำลังส่ง (Tx Power)',
            value: _txPower,
            min: 0.1,
            max: 100,
            unit: 'W',
            secondaryValue: '${_txPowerDbm.toStringAsFixed(1)} dBm',
            onChanged: (v) => setState(() => _txPower = v),
            color: AppColors.danger,
          ),

          // TX Gain
          _buildSliderInput(
            label: 'Gain สายอากาศส่ง',
            value: _txGain,
            min: 0,
            max: 20,
            unit: 'dBi',
            onChanged: (v) => setState(() => _txGain = v),
            color: AppColors.primary,
          ),

          // RX Gain
          _buildSliderInput(
            label: 'Gain สายอากาศรับ',
            value: _rxGain,
            min: 0,
            max: 20,
            unit: 'dBi',
            onChanged: (v) => setState(() => _rxGain = v),
            color: AppColors.success,
          ),

          // Frequency
          _buildSliderInput(
            label: 'ความถี่',
            value: _frequency,
            min: 1,
            max: 18000,
            unit: 'MHz',
            onChanged: (v) => setState(() => _frequency = v),
            color: AppColors.tabLearning,
          ),

          // Distance
          _buildSliderInput(
            label: 'ระยะทาง',
            value: _distance,
            min: 0.1,
            max: 100,
            unit: 'km',
            onChanged: (v) => setState(() => _distance = v),
            color: AppColors.warning,
          ),

          // Cable Losses
          Row(
            children: [
              Expanded(
                child: _buildNumberInput(
                  label: 'Cable Loss Tx',
                  value: _cableLossTx,
                  unit: 'dB',
                  onChanged: (v) => setState(() => _cableLossTx = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberInput(
                  label: 'Cable Loss Rx',
                  value: _cableLossRx,
                  unit: 'dB',
                  onChanged: (v) => setState(() => _cableLossRx = v),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Additional Loss
          _buildSliderInput(
            label: 'ความสูญเสียเพิ่มเติม (ป่า, อาคาร, ภูเขา)',
            value: _additionalLoss,
            min: 0,
            max: 30,
            unit: 'dB',
            onChanged: (v) => setState(() => _additionalLoss = v),
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderInput({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    String? secondaryValue,
    required ValueChanged<double> onChanged,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            Row(
              children: [
                Text(
                  '${value.toStringAsFixed(1)} $unit',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (secondaryValue != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '($secondaryValue)',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withAlpha(50),
            thumbColor: color,
            overlayColor: color.withAlpha(30),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberInput({
    required String label,
    required double value,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _linkQualityColor.withAlpha(30),
            _linkQualityColor.withAlpha(10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _linkQualityColor.withAlpha(100)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: _linkQualityColor, size: 22),
              const SizedBox(width: 8),
              const Text(
                'ผลการคำนวณ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _linkQualityColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _linkQuality,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Result: Received Power
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'กำลังรับ (Received Power)',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_rxPower.toStringAsFixed(1)} dBm',
                  style: TextStyle(
                    color: _linkQualityColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Link Margin: ${_linkMargin.toStringAsFixed(1)} dB',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Secondary Results
          Row(
            children: [
              Expanded(
                child: _buildResultCard(
                  'EIRP',
                  '${_eirp.toStringAsFixed(1)} dBm',
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultCard(
                  'Path Loss',
                  '${_totalPathLoss.toStringAsFixed(1)} dB',
                  AppColors.danger,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultCard(
                  'FSPL',
                  '${_fspl.toStringAsFixed(1)} dB',
                  AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkBudgetBreakdown() {
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
              Icon(Icons.account_tree, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Link Budget Breakdown',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBreakdownRow('Tx Power', _txPowerDbm, 'dBm', isPositive: true),
          _buildBreakdownRow(
            'Tx Antenna Gain',
            _txGain,
            'dBi',
            isPositive: true,
          ),
          _buildBreakdownRow(
            'Tx Cable Loss',
            -_cableLossTx,
            'dB',
            isPositive: false,
          ),
          const Divider(color: AppColors.border),
          _buildBreakdownRow('= EIRP', _eirp, 'dBm', isTotal: true),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            'Free Space Path Loss',
            -_fspl,
            'dB',
            isPositive: false,
          ),
          _buildBreakdownRow(
            'Additional Loss',
            -_additionalLoss,
            'dB',
            isPositive: false,
          ),
          _buildBreakdownRow(
            'Rx Antenna Gain',
            _rxGain,
            'dBi',
            isPositive: true,
          ),
          _buildBreakdownRow(
            'Rx Cable Loss',
            -_cableLossRx,
            'dB',
            isPositive: false,
          ),
          const Divider(color: AppColors.border),
          _buildBreakdownRow(
            '= Received Power',
            _rxPower,
            'dBm',
            isTotal: true,
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            'Rx Sensitivity',
            _rxSensitivity,
            'dBm',
            isReference: true,
          ),
          _buildBreakdownRow(
            '= Link Margin',
            _linkMargin,
            'dB',
            isTotal: true,
            isMargin: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    String label,
    double value,
    String unit, {
    bool isPositive = false,
    bool isTotal = false,
    bool isReference = false,
    bool isMargin = false,
  }) {
    Color textColor;
    if (isMargin) {
      textColor = _linkQualityColor;
    } else if (isTotal) {
      textColor = AppColors.primary;
    } else if (isReference) {
      textColor = AppColors.textMuted;
    } else if (isPositive) {
      textColor = AppColors.success;
    } else {
      textColor = AppColors.danger;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)} $unit',
            style: TextStyle(
              color: textColor,
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaExplanation() {
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
              Icon(Icons.functions, color: AppColors.tabLearning, size: 20),
              SizedBox(width: 8),
              Text(
                'สูตรที่ใช้',
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
            'Free Space Path Loss (FSPL)',
            'FSPL(dB) = 20·log₁₀(d) + 20·log₁₀(f) + 32.45',
            'เมื่อ d = ระยะทาง (km), f = ความถี่ (MHz)',
          ),
          const SizedBox(height: 12),
          _buildFormulaCard(
            'EIRP (Effective Isotropic Radiated Power)',
            'EIRP = Pt + Gt - Lt',
            'เมื่อ Pt = กำลังส่ง, Gt = Gain สายอากาศส่ง, Lt = Cable Loss',
          ),
          const SizedBox(height: 12),
          _buildFormulaCard(
            'Received Power',
            'Pr = EIRP - PathLoss + Gr - Lr',
            'เมื่อ Gr = Gain สายอากาศรับ, Lr = Cable Loss รับ',
          ),
          const SizedBox(height: 12),
          _buildFormulaCard(
            'Link Margin',
            'Margin = Pr - Sensitivity',
            'ต้องมี Margin > 0 จึงจะสื่อสารได้ แนะนำ > 10 dB',
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
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              formula,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
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
          'Link Budget Calculator',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ใช้สำหรับคำนวณความสามารถในการสื่อสารระหว่างเครื่องส่งและเครื่องรับ\n\n'
                '• Link Margin > 20 dB = ดีมาก\n'
                '• Link Margin > 10 dB = ดี\n'
                '• Link Margin > 5 dB = พอใช้\n'
                '• Link Margin > 0 dB = อ่อน\n'
                '• Link Margin < 0 dB = ไม่สามารถสื่อสารได้\n\n'
                'การใช้งานในสนาม:\n'
                '- คำนวณระยะสูงสุดที่สามารถสื่อสารได้\n'
                '- วางแผนตำแหน่งสถานีทวน\n'
                '- ประเมินผลกระทบจากภูมิประเทศ\n'
                '- วิเคราะห์การถูก Jamming',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
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

class _PresetScenario {
  final String name;
  final String description;
  final double txPower;
  final double txGain;
  final double rxGain;
  final double frequency;
  final double distance;
  final double cableLossTx;
  final double cableLossRx;
  final double additionalLoss;

  _PresetScenario({
    required this.name,
    required this.description,
    required this.txPower,
    required this.txGain,
    required this.rxGain,
    required this.frequency,
    required this.distance,
    required this.cableLossTx,
    required this.cableLossRx,
    required this.additionalLoss,
  });
}

class _PropagationDiagramPainter extends CustomPainter {
  final double signalProgress;
  final double pulseValue;
  final double linkQuality;
  final double distance;
  final double frequency;

  _PropagationDiagramPainter({
    required this.signalProgress,
    required this.pulseValue,
    required this.linkQuality,
    required this.distance,
    required this.frequency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    const txX = 50.0;
    final rxX = size.width - 50;

    // Draw ground line
    final groundPaint = Paint()
      ..color = const Color(0xFF2D4A3E)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(0, size.height - 20),
      Offset(size.width, size.height - 20),
      groundPaint,
    );

    // Draw terrain (hills/trees for Thai-Cambodia border context)
    _drawTerrain(canvas, size);

    // Draw TX Tower
    _drawTower(canvas, txX, centerY + 20, 'TX', AppColors.primary);

    // Draw RX Tower
    _drawTower(canvas, rxX, centerY + 20, 'RX', AppColors.success);

    // Draw signal waves
    _drawSignalWaves(canvas, txX, rxX, centerY);

    // Draw distance label
    _drawDistanceLabel(canvas, size, txX, rxX);
  }

  void _drawTerrain(Canvas canvas, Size size) {
    final terrainPaint = Paint()
      ..color = const Color(0xFF1A3328)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height - 20);

    // Create rolling hills
    for (double x = 0; x <= size.width; x += 40) {
      final height = 10 + 15 * math.sin(x * 0.02) + 8 * math.sin(x * 0.05);
      path.lineTo(x, size.height - 20 - height);
    }

    path.lineTo(size.width, size.height - 20);
    path.close();
    canvas.drawPath(path, terrainPaint);

    // Draw some trees
    final treePaint = Paint()..color = const Color(0xFF234D36);
    for (double x = 80; x < size.width - 80; x += 60) {
      final baseY = size.height - 30;
      _drawTree(canvas, x, baseY, treePaint);
    }
  }

  void _drawTree(Canvas canvas, double x, double y, Paint paint) {
    final path = Path();
    path.moveTo(x, y - 25);
    path.lineTo(x - 10, y);
    path.lineTo(x + 10, y);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawTower(
    Canvas canvas,
    double x,
    double y,
    String label,
    Color color,
  ) {
    // Tower base
    final basePaint = Paint()
      ..color = color.withAlpha(200)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(x - 15, y);
    path.lineTo(x - 8, y - 50);
    path.lineTo(x + 8, y - 50);
    path.lineTo(x + 15, y);
    path.close();
    canvas.drawPath(path, basePaint);

    // Antenna
    final antennaPaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(x, y - 50), Offset(x, y - 70), antennaPaint);

    // Antenna dish
    final dishPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y - 70), 8 + pulseValue * 3, dishPaint);

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y + 5));
  }

  void _drawSignalWaves(Canvas canvas, double txX, double rxX, double centerY) {
    final pathLength = rxX - txX;
    final signalY = centerY - 40;

    Color signalColor;
    if (linkQuality > 20) {
      signalColor = AppColors.success;
    } else if (linkQuality > 10) {
      signalColor = const Color(0xFF4CAF50);
    } else if (linkQuality > 0) {
      signalColor = AppColors.warning;
    } else {
      signalColor = AppColors.danger;
    }

    // Draw multiple waves at different phases
    for (int i = 0; i < 5; i++) {
      final waveProgress = (signalProgress + i * 0.2) % 1.0;
      final x = txX + pathLength * waveProgress;

      if (x > txX && x < rxX) {
        // Fade based on distance (simulate signal weakening)
        final fade = 1.0 - (waveProgress * 0.7);
        final wavePaint = Paint()
          ..color = signalColor.withAlpha((fade * 180).toInt())
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        // Draw arc wave
        final waveSize = 15.0 - waveProgress * 8;
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(x, signalY),
            width: waveSize * 2,
            height: waveSize,
          ),
          0,
          math.pi,
          false,
          wavePaint,
        );
      }
    }

    // Draw signal path line
    final pathPaint = Paint()
      ..color = signalColor.withAlpha(50)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dashPath = Path();
    for (double x = txX; x < rxX; x += 10) {
      dashPath.moveTo(x, signalY);
      dashPath.lineTo(x + 5, signalY);
    }
    canvas.drawPath(dashPath, pathPaint);
  }

  void _drawDistanceLabel(Canvas canvas, Size size, double txX, double rxX) {
    final centerX = (txX + rxX) / 2;

    final textPainter = TextPainter(
      text: TextSpan(
        text:
            '${distance.toStringAsFixed(1)} km @ ${frequency.toStringAsFixed(0)} MHz',
        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, size.height - 15),
    );
  }

  @override
  bool shouldRepaint(covariant _PropagationDiagramPainter oldDelegate) {
    return signalProgress != oldDelegate.signalProgress ||
        pulseValue != oldDelegate.pulseValue ||
        linkQuality != oldDelegate.linkQuality;
  }
}
