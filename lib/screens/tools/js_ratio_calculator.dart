import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/constants.dart';

class JSRatioCalculator extends StatefulWidget {
  const JSRatioCalculator({super.key});

  @override
  State<JSRatioCalculator> createState() => _JSRatioCalculatorState();
}

class _JSRatioCalculatorState extends State<JSRatioCalculator>
    with TickerProviderStateMixin {
  // Jammer Parameters
  double _jammerPower = 100.0; // Watts
  double _jammerGain = 10.0; // dBi
  double _jammerDistance = 5.0; // km (distance from jammer to receiver)

  // Signal Parameters
  double _signalPower = 5.0; // Watts
  double _signalGain = 3.0; // dBi
  double _signalDistance = 10.0; // km (distance from transmitter to receiver)

  // Common Parameters
  double _frequency = 150.0; // MHz
  double _jammingBandwidth = 25.0; // kHz
  double _signalBandwidth = 25.0; // kHz (for processing gain calculation)

  // Animation controllers
  late AnimationController _jamAnimController;
  late AnimationController _signalAnimController;
  late AnimationController _pulseController;

  // Jamming mode
  String _jammingMode = 'spot'; // spot, barrage, sweep

  // Preset scenarios for Thai-Cambodia border
  final List<_JammingScenario> _scenarios = [
    _JammingScenario(
      name: 'Spot Jamming VHF',
      description: 'รบกวนความถี่เดียว VHF',
      jammerPower: 50.0,
      jammerGain: 8.0,
      jammerDistance: 3.0,
      signalPower: 5.0,
      signalGain: 0.0,
      signalDistance: 15.0,
      frequency: 150.0,
      jammingBw: 25.0,
      signalBw: 25.0,
      mode: 'spot',
    ),
    _JammingScenario(
      name: 'Barrage Jamming',
      description: 'รบกวนแถบความถี่กว้าง',
      jammerPower: 200.0,
      jammerGain: 6.0,
      jammerDistance: 5.0,
      signalPower: 10.0,
      signalGain: 3.0,
      signalDistance: 20.0,
      frequency: 300.0,
      jammingBw: 5000.0,
      signalBw: 25.0,
      mode: 'barrage',
    ),
    _JammingScenario(
      name: 'Anti-Drone UHF',
      description: 'รบกวนการควบคุม Drone',
      jammerPower: 20.0,
      jammerGain: 12.0,
      jammerDistance: 1.0,
      signalPower: 1.0,
      signalGain: 2.0,
      signalDistance: 5.0,
      frequency: 2400.0,
      jammingBw: 100000.0,
      signalBw: 20000.0,
      mode: 'barrage',
    ),
    _JammingScenario(
      name: 'HF Border Ops',
      description: 'รบกวน HF ชายแดน ไทย-กัมพูชา',
      jammerPower: 500.0,
      jammerGain: 4.0,
      jammerDistance: 20.0,
      signalPower: 100.0,
      signalGain: 2.0,
      signalDistance: 100.0,
      frequency: 8.0,
      jammingBw: 3.0,
      signalBw: 3.0,
      mode: 'spot',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _jamAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _signalAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _jamAnimController.dispose();
    _signalAnimController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // J/S Ratio Calculations (accurate EW formulas)
  double get _jammerPowerDbm => 10 * math.log(_jammerPower * 1000) / math.ln10;
  double get _signalPowerDbm => 10 * math.log(_signalPower * 1000) / math.ln10;

  // EIRP calculations
  double get _jammerEirp => _jammerPowerDbm + _jammerGain;
  double get _signalEirp => _signalPowerDbm + _signalGain;

  // Path loss calculations (Friis formula)
  double _calculateFspl(double distance) {
    if (distance <= 0 || _frequency <= 0) return 0;
    return 20 * math.log(distance) / math.ln10 +
        20 * math.log(_frequency) / math.ln10 +
        32.45;
  }

  double get _jammerPathLoss => _calculateFspl(_jammerDistance);
  double get _signalPathLoss => _calculateFspl(_signalDistance);

  // Power at receiver
  double get _jammerPowerAtRx => _jammerEirp - _jammerPathLoss;
  double get _signalPowerAtRx => _signalEirp - _signalPathLoss;

  // Processing gain (when jammer bandwidth > signal bandwidth)
  double get _processingGain {
    if (_jammingBandwidth <= _signalBandwidth) return 0;
    return 10 * math.log(_jammingBandwidth / _signalBandwidth) / math.ln10;
  }

  // Final J/S ratio (positive = jamming effective, negative = signal stronger)
  double get _jsRatio => _jammerPowerAtRx - _signalPowerAtRx - _processingGain;

  // Interpretation
  String get _jammingEffectiveness {
    if (_jsRatio > 20) return 'ยับยั้งการสื่อสารได้สมบูรณ์';
    if (_jsRatio > 10) return 'รบกวนได้ผลดีมาก';
    if (_jsRatio > 6) return 'รบกวนได้ผล';
    if (_jsRatio > 0) return 'รบกวนได้บางส่วน';
    if (_jsRatio > -6) return 'รบกวนได้น้อย';
    return 'ไม่สามารถรบกวนได้';
  }

  Color get _effectivenessColor {
    if (_jsRatio > 20) return AppColors.danger;
    if (_jsRatio > 10) return const Color(0xFFFF5722);
    if (_jsRatio > 6) return AppColors.warning;
    if (_jsRatio > 0) return const Color(0xFFFFEB3B);
    if (_jsRatio > -6) return AppColors.success;
    return AppColors.primary;
  }

  // Required J/S for different modulation types
  Map<String, double> get _requiredJSRatios => {
    'AM Voice': 10.0,
    'FM Voice': 6.0,
    'FSK Data': 13.0,
    'PSK Data': 10.0,
    'Spread Spectrum': 0.0,
  };

  void _applyScenario(_JammingScenario scenario) {
    setState(() {
      _jammerPower = scenario.jammerPower;
      _jammerGain = scenario.jammerGain;
      _jammerDistance = scenario.jammerDistance;
      _signalPower = scenario.signalPower;
      _signalGain = scenario.signalGain;
      _signalDistance = scenario.signalDistance;
      _frequency = scenario.frequency;
      _jammingBandwidth = scenario.jammingBw;
      _signalBandwidth = scenario.signalBw;
      _jammingMode = scenario.mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('J/S Ratio Calculator'),
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
            // Visual Jamming Diagram
            _buildJammingDiagram(),
            const SizedBox(height: 20),

            // Scenarios
            _buildScenariosSection(),
            const SizedBox(height: 20),

            // Jamming Mode Selection
            _buildJammingModeSection(),
            const SizedBox(height: 20),

            // Jammer Parameters
            _buildJammerSection(),
            const SizedBox(height: 16),

            // Signal Parameters
            _buildSignalSection(),
            const SizedBox(height: 20),

            // Results
            _buildResultsSection(),
            const SizedBox(height: 20),

            // Modulation Reference
            _buildModulationReference(),
            const SizedBox(height: 20),

            // Formula Explanation
            _buildFormulaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildJammingDiagram() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _jamAnimController,
            _signalAnimController,
            _pulseController,
          ]),
          builder: (context, _) {
            return CustomPaint(
              painter: _JammingDiagramPainter(
                jamProgress: _jamAnimController.value,
                signalProgress: _signalAnimController.value,
                pulseValue: _pulseController.value,
                jsRatio: _jsRatio,
                jammerDistance: _jammerDistance,
                signalDistance: _signalDistance,
                jammingMode: _jammingMode,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }

  Widget _buildScenariosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.military_tech, color: AppColors.danger, size: 20),
            SizedBox(width: 8),
            Text(
              'สถานการณ์ปฏิบัติการ EW',
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
            children: _scenarios.map((scenario) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => _applyScenario(scenario),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.danger.withAlpha(100),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario.name,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          scenario.description,
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

  Widget _buildJammingModeSection() {
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
              Icon(Icons.waves, color: AppColors.danger, size: 20),
              SizedBox(width: 8),
              Text(
                'รูปแบบการรบกวน',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildModeChip('spot', 'Spot', 'รบกวนความถี่เดียว'),
              const SizedBox(width: 10),
              _buildModeChip('barrage', 'Barrage', 'รบกวนแถบความถี่'),
              const SizedBox(width: 10),
              _buildModeChip('sweep', 'Sweep', 'กวาดความถี่'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip(String mode, String label, String description) {
    final isSelected = _jammingMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _jammingMode = mode),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.danger.withAlpha(30)
                : AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.danger : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.danger : AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJammerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.danger.withAlpha(20), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.danger.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.wifi_tethering,
                  color: AppColors.danger,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jammer (เครื่องรบกวน)',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'พารามิเตอร์เครื่องรบกวนสัญญาณ',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSlider(
            'กำลังส่ง Jammer',
            _jammerPower,
            0.1,
            1000,
            'W',
            '${_jammerPowerDbm.toStringAsFixed(1)} dBm',
            AppColors.danger,
            (v) => setState(() => _jammerPower = v),
          ),
          _buildSlider(
            'Gain สายอากาศ Jammer',
            _jammerGain,
            0,
            20,
            'dBi',
            null,
            AppColors.danger,
            (v) => setState(() => _jammerGain = v),
          ),
          _buildSlider(
            'ระยะ Jammer ถึง Rx',
            _jammerDistance,
            0.1,
            100,
            'km',
            null,
            AppColors.danger,
            (v) => setState(() => _jammerDistance = v),
          ),
          _buildSlider(
            'Jamming Bandwidth',
            _jammingBandwidth,
            1,
            100000,
            'kHz',
            null,
            AppColors.danger,
            (v) => setState(() => _jammingBandwidth = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.success.withAlpha(20), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.radio,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Signal (สัญญาณเป้าหมาย)',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'พารามิเตอร์สัญญาณที่ต้องการรบกวน',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSlider(
            'กำลังส่ง Signal',
            _signalPower,
            0.1,
            100,
            'W',
            '${_signalPowerDbm.toStringAsFixed(1)} dBm',
            AppColors.success,
            (v) => setState(() => _signalPower = v),
          ),
          _buildSlider(
            'Gain สายอากาศ Tx',
            _signalGain,
            0,
            20,
            'dBi',
            null,
            AppColors.success,
            (v) => setState(() => _signalGain = v),
          ),
          _buildSlider(
            'ระยะ Tx ถึง Rx',
            _signalDistance,
            0.1,
            100,
            'km',
            null,
            AppColors.success,
            (v) => setState(() => _signalDistance = v),
          ),
          _buildSlider(
            'Signal Bandwidth',
            _signalBandwidth,
            1,
            100000,
            'kHz',
            null,
            AppColors.success,
            (v) => setState(() => _signalBandwidth = v),
          ),
          _buildSlider(
            'ความถี่',
            _frequency,
            1,
            18000,
            'MHz',
            null,
            AppColors.primary,
            (v) => setState(() => _frequency = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    String unit,
    String? secondary,
    Color color,
    ValueChanged<double> onChanged,
  ) {
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
                if (secondary != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    '($secondary)',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
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

  Widget _buildResultsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _effectivenessColor.withAlpha(30),
            _effectivenessColor.withAlpha(10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _effectivenessColor.withAlpha(100)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: _effectivenessColor, size: 22),
              const SizedBox(width: 8),
              const Text(
                'ผลการคำนวณ J/S Ratio',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main J/S Result
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'J/S Ratio',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_jsRatio.toStringAsFixed(1)} dB',
                  style: TextStyle(
                    color: _effectivenessColor,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _effectivenessColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _jammingEffectiveness,
                    style: TextStyle(
                      color: _effectivenessColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Breakdown
          Row(
            children: [
              Expanded(
                child: _buildResultItem(
                  'Jammer @ Rx',
                  '${_jammerPowerAtRx.toStringAsFixed(1)} dBm',
                  AppColors.danger,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultItem(
                  'Signal @ Rx',
                  '${_signalPowerAtRx.toStringAsFixed(1)} dBm',
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultItem(
                  'Processing Gain',
                  '${_processingGain.toStringAsFixed(1)} dB',
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildResultItem(
                  'Jammer EIRP',
                  '${_jammerEirp.toStringAsFixed(1)} dBm',
                  AppColors.danger,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultItem(
                  'Signal EIRP',
                  '${_signalEirp.toStringAsFixed(1)} dBm',
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultItem(
                  'Freq',
                  '${_frequency.toStringAsFixed(0)} MHz',
                  AppColors.tabLearning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModulationReference() {
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
              Icon(Icons.table_chart, color: AppColors.warning, size: 20),
              SizedBox(width: 8),
              Text(
                'J/S ที่ต้องการตาม Modulation',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._requiredJSRatios.entries.map((entry) {
            final isEffective = _jsRatio >= entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    isEffective ? Icons.check_circle : Icons.cancel,
                    color: isEffective
                        ? AppColors.success
                        : AppColors.textMuted,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: isEffective
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '≥ ${entry.value.toStringAsFixed(0)} dB',
                    style: TextStyle(
                      color: isEffective
                          ? AppColors.success
                          : AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'หมายเหตุ: Spread Spectrum (CDMA, FHSS) ต้องการ J/S ≈ 0 dB แต่ต้องมีกำลังรบกวนสูงมาก เนื่องจาก Processing Gain ของระบบ',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaSection() {
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
                'สูตรการคำนวณ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormulaItem(
            'J/S Ratio',
            'J/S = Pj + Gj - Lj - (Ps + Gs - Ls) - Gp',
            'Pj = กำลัง Jammer, Gj = Gain Jammer, Lj = Path Loss Jammer\n'
                'Ps = กำลัง Signal, Gs = Gain Signal, Ls = Path Loss Signal\n'
                'Gp = Processing Gain',
          ),
          const SizedBox(height: 12),
          _buildFormulaItem(
            'Processing Gain',
            'Gp = 10·log₁₀(Bj / Bs)',
            'Bj = Jamming Bandwidth, Bs = Signal Bandwidth\n'
                'ใช้เมื่อ Jammer ใช้ Bandwidth กว้างกว่าสัญญาณ (Barrage)',
          ),
          const SizedBox(height: 12),
          _buildFormulaItem(
            'Burn-Through Range',
            'Rb = √(Pj·Gj / Ps·Gs) × Rs',
            'ระยะที่สัญญาณสามารถ "เจาะ" การรบกวนได้\n'
                'Rs = ระยะ Signal ถึง Rx',
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaItem(String title, String formula, String description) {
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
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 6),
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
          'J/S Ratio Calculator',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'J/S Ratio (Jamming-to-Signal Ratio) คืออัตราส่วนกำลังของสัญญาณรบกวนต่อสัญญาณที่ต้องการ ณ ตำแหน่งเครื่องรับ\n\n'
            '• J/S > 20 dB = ยับยั้งการสื่อสารได้สมบูรณ์\n'
            '• J/S > 10 dB = รบกวนได้ผลดีมาก\n'
            '• J/S > 6 dB = รบกวนได้ผล\n'
            '• J/S > 0 dB = รบกวนได้บางส่วน\n'
            '• J/S < 0 dB = สัญญาณแรงกว่า\n\n'
            'การใช้งานในสนาม:\n'
            '- วางแผนตำแหน่ง Jammer\n'
            '- คำนวณกำลังที่ต้องใช้\n'
            '- ประเมินผลกระทบต่อข้าศึก\n'
            '- ป้องกันการถูกรบกวน (ECCM)',
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

class _JammingScenario {
  final String name;
  final String description;
  final double jammerPower;
  final double jammerGain;
  final double jammerDistance;
  final double signalPower;
  final double signalGain;
  final double signalDistance;
  final double frequency;
  final double jammingBw;
  final double signalBw;
  final String mode;

  _JammingScenario({
    required this.name,
    required this.description,
    required this.jammerPower,
    required this.jammerGain,
    required this.jammerDistance,
    required this.signalPower,
    required this.signalGain,
    required this.signalDistance,
    required this.frequency,
    required this.jammingBw,
    required this.signalBw,
    required this.mode,
  });
}

class _JammingDiagramPainter extends CustomPainter {
  final double jamProgress;
  final double signalProgress;
  final double pulseValue;
  final double jsRatio;
  final double jammerDistance;
  final double signalDistance;
  final String jammingMode;

  _JammingDiagramPainter({
    required this.jamProgress,
    required this.signalProgress,
    required this.pulseValue,
    required this.jsRatio,
    required this.jammerDistance,
    required this.signalDistance,
    required this.jammingMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;

    // Positions
    const txX = 50.0;
    final rxX = size.width - 50;
    final jammerX = size.width / 2;
    const jammerY = 50.0;

    // Draw ground
    final groundPaint = Paint()
      ..color = const Color(0xFF2D4A3E)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(0, size.height - 20),
      Offset(size.width, size.height - 20),
      groundPaint,
    );

    // Draw terrain
    _drawTerrain(canvas, size);

    // Draw Signal path (green)
    _drawSignalPath(canvas, txX, rxX, centerY + 30);

    // Draw Jamming (red)
    _drawJammingWaves(canvas, jammerX, jammerY, rxX, centerY + 30);

    // Draw TX (transmitter)
    _drawStation(canvas, txX, centerY + 50, 'TX', AppColors.success);

    // Draw RX (receiver)
    _drawStation(canvas, rxX, centerY + 50, 'RX', AppColors.primary);

    // Draw Jammer
    _drawJammer(canvas, jammerX, jammerY);

    // Draw interference at RX
    if (jsRatio > 0) {
      _drawInterference(canvas, rxX, centerY + 30);
    }

    // Labels
    _drawLabels(canvas, size);
  }

  void _drawTerrain(Canvas canvas, Size size) {
    final terrainPaint = Paint()
      ..color = const Color(0xFF1A3328)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height - 20);
    for (double x = 0; x <= size.width; x += 30) {
      final height = 8 + 10 * math.sin(x * 0.03);
      path.lineTo(x, size.height - 20 - height);
    }
    path.lineTo(size.width, size.height - 20);
    path.close();
    canvas.drawPath(path, terrainPaint);
  }

  void _drawSignalPath(Canvas canvas, double txX, double rxX, double y) {
    // Signal waves
    for (int i = 0; i < 4; i++) {
      final waveProgress = (signalProgress + i * 0.25) % 1.0;
      final x = txX + (rxX - txX) * waveProgress;

      if (x > txX + 20 && x < rxX - 20) {
        final fade = (1.0 - waveProgress * 0.6).clamp(0.0, 1.0);
        final wavePaint = Paint()
          ..color = AppColors.success.withAlpha((fade * 150).toInt())
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawArc(
          Rect.fromCenter(center: Offset(x, y), width: 20, height: 12),
          0,
          math.pi,
          false,
          wavePaint,
        );
      }
    }

    // Path line
    final pathPaint = Paint()
      ..color = AppColors.success.withAlpha(40)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(txX, y), Offset(rxX, y), pathPaint);
  }

  void _drawJammingWaves(
    Canvas canvas,
    double jamX,
    double jamY,
    double rxX,
    double rxY,
  ) {
    const jamColor = AppColors.danger;

    // Jamming waves based on mode
    if (jammingMode == 'barrage') {
      // Wide coverage
      for (int i = 0; i < 6; i++) {
        final angle = -math.pi / 3 + (i * math.pi / 9);
        final waveProgress = (jamProgress + i * 0.15) % 1.0;
        final distance = 80 + waveProgress * 100;

        final endX = jamX + distance * math.cos(angle + math.pi / 2);
        final endY = jamY + distance * math.sin(angle + math.pi / 2);

        final fade = (1.0 - waveProgress * 0.7).clamp(0.0, 1.0);
        final paint = Paint()
          ..color = jamColor.withAlpha((fade * 120).toInt())
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

        canvas.drawLine(Offset(jamX, jamY + 30), Offset(endX, endY), paint);
      }
    } else if (jammingMode == 'sweep') {
      // Sweeping beam
      final sweepAngle = jamProgress * math.pi - math.pi / 2;
      const distance = 150.0;

      for (int i = -2; i <= 2; i++) {
        final angle = sweepAngle + i * 0.1;
        final endX = jamX + distance * math.cos(angle + math.pi / 2);
        final endY = jamY + distance * math.sin(angle + math.pi / 2);

        final fade = 1.0 - (i.abs() * 0.3);
        final paint = Paint()
          ..color = jamColor.withAlpha((fade * 150).toInt())
          ..strokeWidth = 4 - i.abs().toDouble()
          ..style = PaintingStyle.stroke;

        canvas.drawLine(Offset(jamX, jamY + 30), Offset(endX, endY), paint);
      }
    } else {
      // Spot jamming - focused beam
      final targetX = rxX;
      final targetY = rxY;

      for (int i = 0; i < 5; i++) {
        final waveProgress = (jamProgress + i * 0.2) % 1.0;
        final x = jamX + (targetX - jamX) * waveProgress;
        final y = jamY + 30 + (targetY - jamY - 30) * waveProgress;

        final fade = (1.0 - waveProgress * 0.5).clamp(0.0, 1.0);
        final paint = Paint()
          ..color = jamColor.withAlpha((fade * 180).toInt())
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), 5 - waveProgress * 3, paint);
      }

      // Beam line
      final beamPaint = Paint()
        ..color = jamColor.withAlpha(60)
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(jamX, jamY + 30),
        Offset(targetX, targetY),
        beamPaint,
      );
    }
  }

  void _drawStation(
    Canvas canvas,
    double x,
    double y,
    String label,
    Color color,
  ) {
    // Tower
    final towerPaint = Paint()
      ..color = color.withAlpha(200)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(x - 12, y);
    path.lineTo(x - 6, y - 40);
    path.lineTo(x + 6, y - 40);
    path.lineTo(x + 12, y);
    path.close();
    canvas.drawPath(path, towerPaint);

    // Antenna
    final antennaPaint = Paint()
      ..color = color
      ..strokeWidth = 2;
    canvas.drawLine(Offset(x, y - 40), Offset(x, y - 55), antennaPaint);
    canvas.drawCircle(
      Offset(x, y - 55),
      5 + pulseValue * 2,
      Paint()..color = color,
    );

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y + 5));
  }

  void _drawJammer(Canvas canvas, double x, double y) {
    // Jammer body
    final bodyPaint = Paint()
      ..color = AppColors.danger.withAlpha(200)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(x, y), width: 40, height: 30),
        const Radius.circular(5),
      ),
      bodyPaint,
    );

    // Antenna
    final antennaPaint = Paint()
      ..color = AppColors.danger
      ..strokeWidth = 3;
    canvas.drawLine(Offset(x, y + 15), Offset(x, y + 30), antennaPaint);

    // Pulse effect
    final pulsePaint = Paint()
      ..color = AppColors.danger.withAlpha((pulseValue * 100).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(x, y + 30), 15 + pulseValue * 10, pulsePaint);

    // Label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'JAMMER',
        style: TextStyle(
          color: AppColors.danger,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - 25));
  }

  void _drawInterference(Canvas canvas, double x, double y) {
    // Interference symbol at receiver
    final interferencePaint = Paint()
      ..color = AppColors.danger.withAlpha((pulseValue * 150 + 50).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw X marks
    for (int i = 0; i < 3; i++) {
      final offset = (i - 1) * 15.0;
      canvas.drawLine(
        Offset(x + offset - 5, y - 20 - 5),
        Offset(x + offset + 5, y - 20 + 5),
        interferencePaint,
      );
      canvas.drawLine(
        Offset(x + offset + 5, y - 20 - 5),
        Offset(x + offset - 5, y - 20 + 5),
        interferencePaint,
      );
    }
  }

  void _drawLabels(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'J/S: ${jsRatio.toStringAsFixed(1)} dB',
        style: TextStyle(
          color: jsRatio > 0 ? AppColors.danger : AppColors.success,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width / 2 - textPainter.width / 2, size.height - 15),
    );
  }

  @override
  bool shouldRepaint(covariant _JammingDiagramPainter oldDelegate) {
    return jamProgress != oldDelegate.jamProgress ||
        signalProgress != oldDelegate.signalProgress ||
        pulseValue != oldDelegate.pulseValue ||
        jsRatio != oldDelegate.jsRatio ||
        jammingMode != oldDelegate.jammingMode;
  }
}
