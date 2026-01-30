import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/constants.dart';

class FrequencyConverter extends StatefulWidget {
  const FrequencyConverter({super.key});

  @override
  State<FrequencyConverter> createState() => _FrequencyConverterState();
}

class _FrequencyConverterState extends State<FrequencyConverter>
    with SingleTickerProviderStateMixin {
  // Input
  String _inputMode = 'mhz';
  double _inputValue = 150.0;

  late AnimationController _animController;

  // Frequency bands reference
  final List<_FrequencyBand> _bands = [
    _FrequencyBand(
      'ELF',
      3,
      30,
      'Hz',
      'การสื่อสารใต้น้ำ',
      const Color(0xFF1A237E),
    ),
    _FrequencyBand('VLF', 3, 30, 'kHz', 'เรือดำน้ำ', const Color(0xFF283593)),
    _FrequencyBand('LF', 30, 300, 'kHz', 'Navigation', const Color(0xFF303F9F)),
    _FrequencyBand('MF', 300, 3000, 'kHz', 'AM Radio', const Color(0xFF3949AB)),
    _FrequencyBand(
      'HF',
      3,
      30,
      'MHz',
      'วิทยุทหาร ชายแดน',
      const Color(0xFF5C6BC0),
    ),
    _FrequencyBand(
      'VHF',
      30,
      300,
      'MHz',
      'วิทยุยุทธวิธี',
      const Color(0xFF7986CB),
    ),
    _FrequencyBand(
      'UHF',
      300,
      3000,
      'MHz',
      'Tactical, Drone',
      const Color(0xFF9FA8DA),
    ),
    _FrequencyBand(
      'SHF',
      3,
      30,
      'GHz',
      'Radar, Satcom',
      const Color(0xFFC5CAE9),
    ),
    _FrequencyBand(
      'EHF',
      30,
      300,
      'GHz',
      'ดาวเทียมทหาร',
      const Color(0xFFE8EAF6),
    ),
  ];

  // Military frequency allocations
  final List<_MilitaryBand> _militaryBands = [
    _MilitaryBand(
      'HF Tactical',
      2,
      30,
      'MHz',
      'AN/PRC-624, HF Radio',
      AppColors.primary,
    ),
    _MilitaryBand(
      'VHF Low',
      30,
      88,
      'MHz',
      'PRC-77, Legacy',
      AppColors.success,
    ),
    _MilitaryBand('VHF High', 88, 174, 'MHz', 'FM Radio', AppColors.warning),
    _MilitaryBand(
      'UHF Tactical',
      225,
      400,
      'MHz',
      'SINCGARS, UHF Tactical',
      AppColors.danger,
    ),
    _MilitaryBand(
      'Drone Control',
      2400,
      2483,
      'MHz',
      '2.4 GHz Band',
      const Color(0xFFE91E63),
    ),
    _MilitaryBand(
      'Drone Video',
      5725,
      5875,
      'MHz',
      '5.8 GHz Band',
      const Color(0xFF9C27B0),
    ),
    _MilitaryBand(
      'GPS L1',
      1575.42,
      1575.42,
      'MHz',
      'GPS หลัก',
      const Color(0xFF00BCD4),
    ),
    _MilitaryBand(
      'GPS L2',
      1227.60,
      1227.60,
      'MHz',
      'GPS ทหาร',
      const Color(0xFF009688),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Conversions
  double get _hz {
    switch (_inputMode) {
      case 'hz':
        return _inputValue;
      case 'khz':
        return _inputValue * 1e3;
      case 'mhz':
        return _inputValue * 1e6;
      case 'ghz':
        return _inputValue * 1e9;
      default:
        return _inputValue * 1e6;
    }
  }

  double get _khz => _hz / 1e3;
  double get _mhz => _hz / 1e6;
  double get _ghz => _hz / 1e9;

  // Wavelength (speed of light / frequency)
  double get _wavelengthM => 299792458 / _hz;
  double get _wavelengthCm => _wavelengthM * 100;
  double get _wavelengthMm => _wavelengthM * 1000;

  // Period
  double get _periodS => 1 / _hz;
  double get _periodUs => _periodS * 1e6;
  double get _periodNs => _periodS * 1e9;

  // Determine frequency band
  String get _currentBand {
    if (_mhz < 0.003) return 'ELF';
    if (_mhz < 0.03) return 'VLF';
    if (_mhz < 0.3) return 'LF';
    if (_mhz < 3) return 'MF';
    if (_mhz < 30) return 'HF';
    if (_mhz < 300) return 'VHF';
    if (_mhz < 3000) return 'UHF';
    if (_mhz < 30000) return 'SHF';
    return 'EHF';
  }

  void _setInputValue(double value) {
    setState(() => _inputValue = value);
  }

  void _setInputMode(String mode) {
    final currentHz = _hz;
    setState(() {
      _inputMode = mode;
      switch (mode) {
        case 'hz':
          _inputValue = currentHz;
          break;
        case 'khz':
          _inputValue = currentHz / 1e3;
          break;
        case 'mhz':
          _inputValue = currentHz / 1e6;
          break;
        case 'ghz':
          _inputValue = currentHz / 1e9;
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
        title: const Text('Frequency Converter'),
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
            // Spectrum visualization
            _buildSpectrumVisualization(),
            const SizedBox(height: 20),

            // Input Section
            _buildInputSection(),
            const SizedBox(height: 20),

            // Conversion Results
            _buildConversionResults(),
            const SizedBox(height: 20),

            // Wavelength & Period
            _buildWavelengthSection(),
            const SizedBox(height: 20),

            // Military Bands Reference
            _buildMilitaryBands(),
            const SizedBox(height: 20),

            // Frequency Bands
            _buildFrequencyBands(),
            const SizedBox(height: 20),

            // Formulas
            _buildFormulas(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpectrumVisualization() {
    return Container(
      height: 160,
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
              painter: _SpectrumPainter(
                currentMhz: _mhz,
                animValue: _animController.value,
                currentBand: _currentBand,
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
          Row(
            children: [
              const Icon(Icons.waves, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'ป้อนความถี่',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tabLearning.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _currentBand,
                  style: const TextStyle(
                    color: AppColors.tabLearning,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Unit selection
          Row(
            children: [
              _buildUnitChip('hz', 'Hz'),
              const SizedBox(width: 8),
              _buildUnitChip('khz', 'kHz'),
              const SizedBox(width: 8),
              _buildUnitChip('mhz', 'MHz'),
              const SizedBox(width: 8),
              _buildUnitChip('ghz', 'GHz'),
            ],
          ),
          const SizedBox(height: 16),

          // Value input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      if (parsed != null && parsed > 0) {
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
          const SizedBox(height: 16),

          // Quick frequency buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickFreq('2.4G', 2400),
              _buildQuickFreq('5.8G', 5800),
              _buildQuickFreq('150M', 150),
              _buildQuickFreq('400M', 400),
              _buildQuickFreq('30M', 30),
              _buildQuickFreq('8M', 8),
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withAlpha(30)
                : AppColors.background,
            borderRadius: BorderRadius.circular(8),
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

  Widget _buildQuickFreq(String label, double mhz) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _inputMode = 'mhz';
          _inputValue = mhz;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ),
    );
  }

  String _getUnitLabel() {
    switch (_inputMode) {
      case 'hz':
        return 'Hz';
      case 'khz':
        return 'kHz';
      case 'mhz':
        return 'MHz';
      case 'ghz':
        return 'GHz';
      default:
        return 'MHz';
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

          Row(
            children: [
              Expanded(
                child: _buildResultCard(
                  'Hz',
                  _formatNumber(_hz),
                  AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultCard(
                  'kHz',
                  _formatNumber(_khz),
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildResultCard(
                  'MHz',
                  _formatNumber(_mhz),
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildResultCard(
                  'GHz',
                  _formatNumber(_ghz),
                  AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(3)}G';
    if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(3)}M';
    if (value >= 1e3) return '${(value / 1e3).toStringAsFixed(3)}k';
    if (value >= 1) return value.toStringAsFixed(3);
    if (value >= 1e-3) return '${(value * 1e3).toStringAsFixed(3)}m';
    if (value >= 1e-6) return '${(value * 1e6).toStringAsFixed(3)}µ';
    if (value >= 1e-9) return '${(value * 1e9).toStringAsFixed(3)}n';
    return value.toStringAsExponential(2);
  }

  Widget _buildResultCard(String label, String value, Color color) {
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
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
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
        ],
      ),
    );
  }

  Widget _buildWavelengthSection() {
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
              Icon(Icons.straighten, color: AppColors.success, size: 20),
              SizedBox(width: 8),
              Text(
                'ความยาวคลื่น & คาบ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Wavelength
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ความยาวคลื่น (λ)',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWaveItem(_formatNumber(_wavelengthM), 'm'),
                    _buildWaveItem(_formatNumber(_wavelengthCm), 'cm'),
                    _buildWaveItem(_formatNumber(_wavelengthMm), 'mm'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Period
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'คาบ (T)',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWaveItem(_formatNumber(_periodUs), 'µs'),
                    _buildWaveItem(_formatNumber(_periodNs), 'ns'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Antenna length tip
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.settings_input_antenna,
                  color: AppColors.textMuted,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ความยาวสายอากาศ λ/4 ≈ ${(_wavelengthM / 4 * 100).toStringAsFixed(1)} cm',
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

  Widget _buildWaveItem(String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildMilitaryBands() {
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
              Icon(Icons.military_tech, color: AppColors.danger, size: 20),
              SizedBox(width: 8),
              Text(
                'ความถี่ทางทหาร',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ..._militaryBands.map((band) {
            final isInBand = _mhz >= band.startMhz && _mhz <= band.endMhz;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _inputMode = 'mhz';
                    _inputValue = (band.startMhz + band.endMhz) / 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isInBand
                        ? band.color.withAlpha(30)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isInBand ? band.color : Colors.transparent,
                      width: isInBand ? 2 : 0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: band.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              band.name,
                              style: TextStyle(
                                color: isInBand
                                    ? band.color
                                    : AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              band.description,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        band.startMhz == band.endMhz
                            ? '${band.startMhz} ${band.unit}'
                            : '${band.startMhz}-${band.endMhz} ${band.unit}',
                        style: TextStyle(
                          color: isInBand
                              ? band.color
                              : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFrequencyBands() {
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
              Icon(Icons.radio, color: AppColors.tabLearning, size: 20),
              SizedBox(width: 8),
              Text(
                'แถบความถี่มาตรฐาน',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ..._bands.map((band) {
            final isCurrentBand = _currentBand == band.name;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isCurrentBand
                          ? band.color
                          : band.color.withAlpha(50),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      band.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isCurrentBand ? Colors.white : band.color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${band.start}-${band.end} ${band.unit}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Text(
                      band.description,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFormulas() {
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
                'สูตรที่เกี่ยวข้อง',
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
            'ความยาวคลื่น',
            'λ = c / f',
            'c = 3×10⁸ m/s (ความเร็วแสง)',
          ),
          const SizedBox(height: 10),
          _buildFormulaItem(
            'คาบ',
            'T = 1 / f',
            'T = คาบ (วินาที), f = ความถี่ (Hz)',
          ),
          const SizedBox(height: 10),
          _buildFormulaItem(
            'สายอากาศ λ/4',
            'L = 75 / f(MHz)',
            'L = ความยาว (เมตร)',
          ),
          const SizedBox(height: 10),
          _buildFormulaItem(
            'สายอากาศ λ/2',
            'L = 150 / f(MHz)',
            'L = ความยาว (เมตร)',
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaItem(String title, String formula, String description) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formula,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
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
          'Frequency Converter',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'แปลงหน่วยความถี่และคำนวณความยาวคลื่น\n\n'
            'หน่วยความถี่:\n'
            '• Hz (เฮิรตซ์) - หน่วยพื้นฐาน\n'
            '• kHz - พันเฮิรตซ์\n'
            '• MHz - ล้านเฮิรตซ์\n'
            '• GHz - พันล้านเฮิรตซ์\n\n'
            'ความยาวคลื่น:\n'
            '• λ = c/f = 300/f(MHz) เมตร\n'
            '• สายอากาศ quarter-wave = λ/4\n\n'
            'การใช้งานในสนาม:\n'
            '- คำนวณความยาวสายอากาศ\n'
            '- ระบุแถบความถี่\n'
            '- วางแผนการ Jamming',
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

class _FrequencyBand {
  final String name;
  final double start;
  final double end;
  final String unit;
  final String description;
  final Color color;

  _FrequencyBand(
    this.name,
    this.start,
    this.end,
    this.unit,
    this.description,
    this.color,
  );
}

class _MilitaryBand {
  final String name;
  final double startMhz;
  final double endMhz;
  final String unit;
  final String description;
  final Color color;

  _MilitaryBand(
    this.name,
    this.startMhz,
    this.endMhz,
    this.unit,
    this.description,
    this.color,
  );
}

class _SpectrumPainter extends CustomPainter {
  final double currentMhz;
  final double animValue;
  final String currentBand;

  _SpectrumPainter({
    required this.currentMhz,
    required this.animValue,
    required this.currentBand,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 20.0;
    const barHeight = 40.0;
    final barY = size.height / 2;

    // Draw spectrum bar (log scale from 1 Hz to 300 GHz)
    const gradient = LinearGradient(
      colors: [
        Color(0xFF1A237E), // ELF
        Color(0xFF303F9F), // LF
        Color(0xFF3F51B5), // MF
        Color(0xFF5C6BC0), // HF
        Color(0xFF7986CB), // VHF
        Color(0xFF9FA8DA), // UHF
        Color(0xFFC5CAE9), // SHF
        Color(0xFFE8EAF6), // EHF
      ],
    );

    final rect = Rect.fromLTWH(
      padding,
      barY - barHeight / 2,
      size.width - padding * 2,
      barHeight,
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );

    // Draw frequency marker
    // Log scale: position = log10(freq) mapped to bar width
    const minLog = 0.0; // 1 Hz
    const maxLog = 11.5; // ~300 GHz
    final currentLog = math.log(currentMhz * 1e6) / math.ln10;
    final markerX =
        padding +
        ((currentLog - minLog) / (maxLog - minLog)) *
            (size.width - padding * 2);

    // Marker glow
    final glowPaint = Paint()
      ..color = Colors.white.withAlpha((150 + animValue * 50).toInt())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(
      Offset(markerX.clamp(padding, size.width - padding), barY),
      15,
      glowPaint,
    );

    // Marker line
    final markerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(
        markerX.clamp(padding, size.width - padding),
        barY - barHeight / 2 - 10,
      ),
      Offset(
        markerX.clamp(padding, size.width - padding),
        barY + barHeight / 2 + 10,
      ),
      markerPaint,
    );

    // Draw frequency labels
    final labels = ['1Hz', '1kHz', '1MHz', '1GHz', '300GHz'];
    final logPositions = [0.0, 3.0, 6.0, 9.0, 11.5];

    for (int i = 0; i < labels.length; i++) {
      final x =
          padding +
          (logPositions[i] / (maxLog - minLog)) * (size.width - padding * 2);
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, barY + barHeight / 2 + 15),
      );
    }

    // Current frequency display
    final freqText = currentMhz >= 1000
        ? '${(currentMhz / 1000).toStringAsFixed(2)} GHz'
        : '${currentMhz.toStringAsFixed(2)} MHz';

    final freqPainter = TextPainter(
      text: TextSpan(
        text: freqText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    freqPainter.layout();
    freqPainter.paint(
      canvas,
      Offset(
        markerX.clamp(
              padding + freqPainter.width / 2,
              size.width - padding - freqPainter.width / 2,
            ) -
            freqPainter.width / 2,
        barY - barHeight / 2 - 30,
      ),
    );

    // Band label
    final bandPainter = TextPainter(
      text: TextSpan(
        text: currentBand,
        style: const TextStyle(
          color: AppColors.warning,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    bandPainter.layout();
    bandPainter.paint(
      canvas,
      Offset(size.width / 2 - bandPainter.width / 2, 10),
    );
  }

  @override
  bool shouldRepaint(covariant _SpectrumPainter oldDelegate) {
    return currentMhz != oldDelegate.currentMhz ||
        animValue != oldDelegate.animValue;
  }
}
