import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/constants.dart';

class RangeCalculator extends StatefulWidget {
  const RangeCalculator({super.key});

  @override
  State<RangeCalculator> createState() => _RangeCalculatorState();
}

class _RangeCalculatorState extends State<RangeCalculator>
    with TickerProviderStateMixin {
  // Common Parameters
  double _txPower = 5.0; // Watts
  double _txGain = 3.0; // dBi
  double _rxGain = 3.0; // dBi
  double _frequency = 150.0; // MHz
  double _rxSensitivity = -110.0; // dBm
  double _cableLoss = 2.0; // dB total
  double _margin = 10.0; // dB fade margin

  // Terrain factors
  String _terrainType = 'open';
  double _txHeight = 2.0; // meters
  double _rxHeight = 2.0; // meters

  // Animation controller
  late AnimationController _pulseController;
  late AnimationController _rangeAnimController;

  // Terrain loss factors (dB/km additional loss)
  final Map<String, _TerrainData> _terrainFactors = {
    'open': _TerrainData(
      'พื้นที่โล่ง',
      0,
      'ทุ่งหญ้า, ทะเลทราย',
      Icons.landscape,
    ),
    'rural': _TerrainData('ชนบท', 2, 'นาข้าว, สวน', Icons.grass),
    'suburban': _TerrainData('กึ่งเมือง', 4, 'หมู่บ้าน, ตึกต่ำ', Icons.home),
    'forest': _TerrainData('ป่า', 6, 'ป่าไม้หนาทึบ', Icons.forest),
    'jungle': _TerrainData('ป่าดิบ', 10, 'ป่าชายแดน ไทย-กัมพูชา', Icons.park),
    'urban': _TerrainData(
      'ในเมือง',
      8,
      'ตึกสูง, เมืองใหญ่',
      Icons.location_city,
    ),
    'mountain': _TerrainData('ภูเขา', 12, 'เทือกเขา, หุบเขา', Icons.terrain),
  };

  // Preset radios for Thai military
  final List<_RadioPreset> _radioPresets = [
    _RadioPreset('PRC-77', 2.0, 0, 50.0, -113, 'VHF Manpack'),
    _RadioPreset('AN/PRC-624', 20.0, 2, 8.0, -120, 'HF Tactical'),
    _RadioPreset('Motorola XTS', 5.0, 0, 450.0, -116, 'UHF Handheld'),
    _RadioPreset('Harris 152', 5.0, 0, 50.0, -118, 'VHF/UHF Multi'),
    _RadioPreset('Satcom Manpack', 50.0, 15, 14000.0, -130, 'Satellite'),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _rangeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rangeAnimController.dispose();
    super.dispose();
  }

  // Calculate maximum range based on link budget
  double get _txPowerDbm => 10 * math.log(_txPower * 1000) / math.ln10;
  double get _eirp => _txPowerDbm + _txGain - _cableLoss;
  double get _allowablePathLoss => _eirp + _rxGain - _rxSensitivity - _margin;

  // Reverse Friis formula to find distance
  // FSPL = 20log(d) + 20log(f) + 32.45
  // d = 10^((FSPL - 20log(f) - 32.45) / 20)
  double get _freeSpaceRange {
    if (_frequency <= 0) return 0;
    final fspl = _allowablePathLoss;
    final exponent =
        (fspl - 20 * math.log(_frequency) / math.ln10 - 32.45) / 20;
    return math.pow(10, exponent).toDouble();
  }

  // Apply terrain factor
  double get _terrainLossPerKm => _terrainFactors[_terrainType]?.lossPerKm ?? 0;

  // Practical range considering terrain
  double get _practicalRange {
    if (_terrainLossPerKm == 0) return _freeSpaceRange;

    // Iterative solution since terrain loss depends on distance
    double range = _freeSpaceRange;
    for (int i = 0; i < 10; i++) {
      final terrainLoss = range * _terrainLossPerKm;
      final effectiveFspl = _allowablePathLoss - terrainLoss;
      if (effectiveFspl <= 0) return 0.1;
      final exponent =
          (effectiveFspl - 20 * math.log(_frequency) / math.ln10 - 32.45) / 20;
      range = math.pow(10, exponent).toDouble();
      if (range < 0.1) return 0.1;
    }
    return range;
  }

  // Line of Sight range (Radio Horizon)
  // d(km) = 4.12 * (√h1 + √h2) where h in meters
  double get _losRange {
    return 4.12 * (math.sqrt(_txHeight) + math.sqrt(_rxHeight));
  }

  // Effective range is minimum of practical and LOS
  double get _effectiveRange {
    final practical = _practicalRange;
    final los = _losRange;
    return math.min(practical, los);
  }

  String get _limitingFactor {
    if (_practicalRange < _losRange) return 'กำลังส่ง/ภูมิประเทศ';
    return 'Line of Sight';
  }

  void _applyRadioPreset(_RadioPreset preset) {
    setState(() {
      _txPower = preset.power;
      _txGain = preset.gain;
      _frequency = preset.freq;
      _rxSensitivity = preset.sensitivity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('ระยะทำการ'),
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
            // Visual Range Diagram
            _buildRangeDiagram(),
            const SizedBox(height: 20),

            // Radio Presets
            _buildRadioPresets(),
            const SizedBox(height: 20),

            // Terrain Selection
            _buildTerrainSection(),
            const SizedBox(height: 20),

            // Parameters
            _buildParametersSection(),
            const SizedBox(height: 20),

            // Height Parameters
            _buildHeightSection(),
            const SizedBox(height: 20),

            // Results
            _buildResultsSection(),
            const SizedBox(height: 20),

            // Range Comparison Chart
            _buildRangeChart(),
            const SizedBox(height: 20),

            // Formula
            _buildFormulaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeDiagram() {
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
          animation: Listenable.merge([_pulseController, _rangeAnimController]),
          builder: (context, _) {
            return CustomPaint(
              painter: _RangeDiagramPainter(
                pulseValue: _pulseController.value,
                rangeProgress: _rangeAnimController.value,
                effectiveRange: _effectiveRange,
                losRange: _losRange,
                practicalRange: _practicalRange,
                terrainType: _terrainType,
                txHeight: _txHeight,
                rxHeight: _rxHeight,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }

  Widget _buildRadioPresets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.radio, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'วิทยุมาตรฐาน',
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
            children: _radioPresets.map((preset) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => _applyRadioPreset(preset),
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
                        Text(
                          '${preset.power}W @ ${preset.freq}MHz',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
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

  Widget _buildTerrainSection() {
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
              Icon(Icons.terrain, color: AppColors.success, size: 20),
              SizedBox(width: 8),
              Text(
                'ประเภทภูมิประเทศ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _terrainFactors.entries.map((entry) {
              final isSelected = _terrainType == entry.key;
              final data = entry.value;
              return GestureDetector(
                onTap: () => setState(() => _terrainType = entry.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.success.withAlpha(30)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.success : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        data.icon,
                        color: isSelected
                            ? AppColors.success
                            : AppColors.textMuted,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.success
                                  : AppColors.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '+${data.lossPerKm} dB/km',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textMuted,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _terrainFactors[_terrainType]?.description ?? '',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParametersSection() {
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
          _buildSlider(
            'กำลังส่ง',
            _txPower,
            0.1,
            100,
            'W',
            AppColors.danger,
            (v) => setState(() => _txPower = v),
          ),
          _buildSlider(
            'Gain สายอากาศ Tx',
            _txGain,
            0,
            20,
            'dBi',
            AppColors.primary,
            (v) => setState(() => _txGain = v),
          ),
          _buildSlider(
            'Gain สายอากาศ Rx',
            _rxGain,
            0,
            20,
            'dBi',
            AppColors.success,
            (v) => setState(() => _rxGain = v),
          ),
          _buildSlider(
            'ความถี่',
            _frequency,
            1,
            18000,
            'MHz',
            AppColors.tabLearning,
            (v) => setState(() => _frequency = v),
          ),
          _buildSlider(
            'Rx Sensitivity',
            _rxSensitivity,
            -140,
            -80,
            'dBm',
            AppColors.warning,
            (v) => setState(() => _rxSensitivity = v),
          ),
          _buildSlider(
            'Cable Loss รวม',
            _cableLoss,
            0,
            10,
            'dB',
            AppColors.textMuted,
            (v) => setState(() => _cableLoss = v),
          ),
          _buildSlider(
            'Fade Margin',
            _margin,
            0,
            30,
            'dB',
            AppColors.info,
            (v) => setState(() => _margin = v),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightSection() {
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
              Icon(Icons.height, color: AppColors.warning, size: 20),
              SizedBox(width: 8),
              Text(
                'ความสูงสายอากาศ (Line of Sight)',
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
              Expanded(
                child: _buildHeightInput(
                  'Tx Height',
                  _txHeight,
                  (v) => setState(() => _txHeight = v),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHeightInput(
                  'Rx Height',
                  _rxHeight,
                  (v) => setState(() => _rxHeight = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.remove_red_eye,
                  color: AppColors.warning,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Radio Horizon (LOS): ${_losRange.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightInput(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.warning,
                  inactiveTrackColor: AppColors.warning.withAlpha(50),
                  thumbColor: AppColors.warning,
                ),
                child: Slider(
                  value: value.clamp(0.5, 100),
                  min: 0.5,
                  max: 100,
                  onChanged: onChanged,
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(
                '${value.toStringAsFixed(1)}m',
                style: const TextStyle(
                  color: AppColors.warning,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    String unit,
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
            Text(
              '${value.toStringAsFixed(1)} $unit',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withAlpha(50),
            thumbColor: color,
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
    final effectiveColor = _practicalRange < _losRange
        ? AppColors.primary
        : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [effectiveColor.withAlpha(30), effectiveColor.withAlpha(10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: effectiveColor.withAlpha(100)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, color: effectiveColor, size: 22),
              const SizedBox(width: 8),
              const Text(
                'ผลการคำนวณระยะทำการ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main result
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'ระยะทำการสูงสุด',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_effectiveRange.toStringAsFixed(2)} km',
                  style: TextStyle(
                    color: effectiveColor,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: effectiveColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'จำกัดโดย: $_limitingFactor',
                    style: TextStyle(
                      color: effectiveColor,
                      fontSize: 12,
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
                child: _buildResultCard(
                  'Free Space',
                  '${_freeSpaceRange.toStringAsFixed(1)} km',
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultCard(
                  'พร้อมภูมิประเทศ',
                  '${_practicalRange.toStringAsFixed(1)} km',
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultCard(
                  'LOS',
                  '${_losRange.toStringAsFixed(1)} km',
                  AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildResultCard(
                  'EIRP',
                  '${_eirp.toStringAsFixed(1)} dBm',
                  AppColors.danger,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultCard(
                  'Allowable Loss',
                  '${_allowablePathLoss.toStringAsFixed(1)} dB',
                  AppColors.tabLearning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultCard(
                  'Terrain',
                  '+${_terrainLossPerKm.toStringAsFixed(0)} dB/km',
                  AppColors.textMuted,
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

  Widget _buildRangeChart() {
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
              Icon(Icons.bar_chart, color: AppColors.tabLearning, size: 20),
              SizedBox(width: 8),
              Text(
                'เปรียบเทียบระยะ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRangeBar('Free Space', _freeSpaceRange, AppColors.success),
          const SizedBox(height: 8),
          _buildRangeBar('พร้อมภูมิประเทศ', _practicalRange, AppColors.primary),
          const SizedBox(height: 8),
          _buildRangeBar('Line of Sight', _losRange, AppColors.warning),
          const SizedBox(height: 8),
          _buildRangeBar('ระยะใช้งานจริง', _effectiveRange, AppColors.danger),
        ],
      ),
    );
  }

  Widget _buildRangeBar(String label, double value, Color color) {
    final maxRange = math.max(math.max(_freeSpaceRange, _losRange), 1.0);
    final width = (value / maxRange).clamp(0.0, 1.0);

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
                fontSize: 12,
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)} km',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: width,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, color.withAlpha(150)]),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
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
          _buildFormulaCard(
            'Radio Horizon (LOS)',
            'd = 4.12 × (√h₁ + √h₂)',
            'เมื่อ h₁, h₂ = ความสูงสายอากาศ (เมตร)\nd = ระยะ Line of Sight (กิโลเมตร)',
          ),
          const SizedBox(height: 12),
          _buildFormulaCard(
            'Maximum Range (Link Budget)',
            'd = 10^((FSPL - 20log(f) - 32.45) / 20)',
            'คำนวณจาก Allowable Path Loss\nFSPL = EIRP + Gr - Sensitivity - Margin',
          ),
          const SizedBox(height: 12),
          _buildFormulaCard(
            'Practical Range',
            'คำนวณซ้ำ โดยหัก Terrain Loss',
            'Terrain Loss = ระยะ × (dB/km ตามภูมิประเทศ)\nระยะจริง = min(Practical, LOS)',
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
          'ระยะทำการ',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'คำนวณระยะทำการสูงสุดของวิทยุหรือ Jammer\n\n'
            'ปัจจัยที่มีผล:\n'
            '• กำลังส่ง และ Gain สายอากาศ\n'
            '• ความไว Rx Sensitivity\n'
            '• ความถี่ (ความถี่สูง = ระยะสั้น)\n'
            '• ภูมิประเทศ (ป่า, ภูเขา ลดระยะ)\n'
            '• ความสูงสายอากาศ (LOS)\n\n'
            'การใช้งานในสนาม:\n'
            '- วางแผนตำแหน่งสถานี\n'
            '- คำนวณความสูงเสาที่ต้องการ\n'
            '- ประเมินระยะ Jammer ที่ต้องใช้',
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

class _TerrainData {
  final String name;
  final double lossPerKm;
  final String description;
  final IconData icon;

  _TerrainData(this.name, this.lossPerKm, this.description, this.icon);
}

class _RadioPreset {
  final String name;
  final double power;
  final double gain;
  final double freq;
  final double sensitivity;
  final String description;

  _RadioPreset(
    this.name,
    this.power,
    this.gain,
    this.freq,
    this.sensitivity,
    this.description,
  );
}

class _RangeDiagramPainter extends CustomPainter {
  final double pulseValue;
  final double rangeProgress;
  final double effectiveRange;
  final double losRange;
  final double practicalRange;
  final String terrainType;
  final double txHeight;
  final double rxHeight;

  _RangeDiagramPainter({
    required this.pulseValue,
    required this.rangeProgress,
    required this.effectiveRange,
    required this.losRange,
    required this.practicalRange,
    required this.terrainType,
    required this.txHeight,
    required this.rxHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height * 0.6;
    const txX = 60.0;
    final rxX = size.width - 60;

    // Draw earth curvature
    _drawEarthCurvature(canvas, size);

    // Draw terrain
    _drawTerrain(canvas, size, centerY);

    // Draw LOS arc
    _drawLosArc(canvas, txX, rxX, centerY);

    // Draw signal propagation
    _drawSignalPropagation(canvas, txX, rxX, centerY);

    // Draw TX tower
    _drawTower(canvas, txX, centerY, txHeight, 'TX', AppColors.primary);

    // Draw RX tower
    _drawTower(canvas, rxX, centerY, rxHeight, 'RX', AppColors.success);

    // Draw range indicator
    _drawRangeIndicator(canvas, size);
  }

  void _drawEarthCurvature(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A2634)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height - 30,
      size.width,
      size.height,
    );
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawTerrain(Canvas canvas, Size size, double baseY) {
    Color terrainColor;
    double terrainHeight;

    switch (terrainType) {
      case 'forest':
      case 'jungle':
        terrainColor = const Color(0xFF1B4D3E);
        terrainHeight = 25;
        break;
      case 'mountain':
        terrainColor = const Color(0xFF3D3D3D);
        terrainHeight = 40;
        break;
      case 'urban':
      case 'suburban':
        terrainColor = const Color(0xFF2D3748);
        terrainHeight = 20;
        break;
      default:
        terrainColor = const Color(0xFF2D4A3E);
        terrainHeight = 10;
    }

    final paint = Paint()
      ..color = terrainColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height - 10);

    for (double x = 0; x <= size.width; x += 20) {
      final noise = terrainHeight * math.sin(x * 0.05) * math.cos(x * 0.03);
      path.lineTo(x, baseY + 10 - noise);
    }

    path.lineTo(size.width, size.height - 10);
    path.lineTo(0, size.height - 10);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawLosArc(Canvas canvas, double txX, double rxX, double centerY) {
    final losPaint = Paint()
      ..color = AppColors.warning.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midX = (txX + rxX) / 2;
    const arcHeight = 30.0;

    path.moveTo(txX, centerY - txHeight * 2);
    path.quadraticBezierTo(
      midX,
      centerY - arcHeight - txHeight * 2,
      rxX,
      centerY - rxHeight * 2,
    );

    // Draw dashed line
    final dashPath = Path();
    for (double t = 0; t < 1; t += 0.05) {
      if ((t * 20).toInt() % 2 == 0) {
        final x = txX + (rxX - txX) * t;
        final y = centerY - txHeight * 2 - arcHeight * 4 * t * (1 - t);
        if (t == 0) {
          dashPath.moveTo(x, y);
        } else {
          dashPath.lineTo(x, y);
        }
      }
    }

    canvas.drawPath(dashPath, losPaint);
  }

  void _drawSignalPropagation(
    Canvas canvas,
    double txX,
    double rxX,
    double centerY,
  ) {
    final signalY = centerY - 40;

    for (int i = 0; i < 4; i++) {
      final progress = (rangeProgress + i * 0.25) % 1.0;
      final x = txX + (rxX - txX) * progress;

      if (x > txX + 20 && x < rxX - 20) {
        final fade = 1.0 - progress * 0.7;
        final paint = Paint()
          ..color = AppColors.primary.withAlpha((fade * 150).toInt())
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawArc(
          Rect.fromCenter(center: Offset(x, signalY), width: 20, height: 12),
          0,
          math.pi,
          false,
          paint,
        );
      }
    }
  }

  void _drawTower(
    Canvas canvas,
    double x,
    double baseY,
    double height,
    String label,
    Color color,
  ) {
    final scaledHeight = height * 2;
    final towerY = baseY;

    // Tower structure
    final towerPaint = Paint()
      ..color = color.withAlpha(200)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(x - 10, towerY);
    path.lineTo(x - 5, towerY - scaledHeight - 20);
    path.lineTo(x + 5, towerY - scaledHeight - 20);
    path.lineTo(x + 10, towerY);
    path.close();
    canvas.drawPath(path, towerPaint);

    // Antenna
    canvas.drawCircle(
      Offset(x, towerY - scaledHeight - 25),
      5 + pulseValue * 3,
      Paint()..color = color,
    );

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$label\n${height.toStringAsFixed(0)}m',
        style: TextStyle(color: color, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, towerY + 5));
  }

  void _drawRangeIndicator(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'ระยะ: ${effectiveRange.toStringAsFixed(1)} km',
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width / 2 - textPainter.width / 2, 10),
    );
  }

  @override
  bool shouldRepaint(covariant _RangeDiagramPainter oldDelegate) {
    return pulseValue != oldDelegate.pulseValue ||
        rangeProgress != oldDelegate.rangeProgress ||
        effectiveRange != oldDelegate.effectiveRange ||
        terrainType != oldDelegate.terrainType;
  }
}
