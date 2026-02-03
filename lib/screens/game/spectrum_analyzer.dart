import 'package:flutter/material.dart';
import 'dart:math';
import '../../app/constants.dart';

class SpectrumAnalyzer extends StatefulWidget {
  const SpectrumAnalyzer({super.key});

  @override
  State<SpectrumAnalyzer> createState() => _SpectrumAnalyzerState();
}

class _SpectrumAnalyzerState extends State<SpectrumAnalyzer>
    with TickerProviderStateMixin {
  late AnimationController _spectrumController;
  late AnimationController _sweepController;
  late AnimationController _pulseController;

  // Spectrum settings
  double _centerFreq = 2400.0; // MHz
  double _span = 500.0; // MHz
  double _refLevel = -20.0; // dBm
  bool _holdMax = false;
  final bool _showMarkers = true;
  int _selectedSignal = -1;

  // Analysis mode
  String _analysisMode = 'spectrum'; // spectrum, waterfall, pulse

  // Signals in the spectrum
  final List<SignalData> _signals = [];
  final List<String> _identifiedThreats = [];
  int _score = 0;
  int _missedThreats = 0;

  // Challenge mode
  bool _challengeMode = false;
  int _challengeLevel = 1;
  int _signalsToIdentify = 0;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _spectrumController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..repeat();

    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _generateSignals();
  }

  void _generateSignals() {
    _signals.clear();

    // Generate realistic signals based on center frequency
    final baseFreq = _centerFreq - _span / 2;
    final endFreq = _centerFreq + _span / 2;

    // WiFi signals (2.4 GHz band)
    if (baseFreq < 2500 && endFreq > 2400) {
      _signals.add(SignalData(
        frequency: 2412,
        bandwidth: 20,
        power: -45 + _random.nextDouble() * 10,
        type: SignalType.wifi,
        name: 'WiFi Ch.1',
        threat: false,
        modulation: 'OFDM',
      ));
      _signals.add(SignalData(
        frequency: 2437,
        bandwidth: 20,
        power: -50 + _random.nextDouble() * 10,
        type: SignalType.wifi,
        name: 'WiFi Ch.6',
        threat: false,
        modulation: 'OFDM',
      ));
    }

    // Drone control signals
    if (baseFreq < 2500 && endFreq > 2400) {
      _signals.add(SignalData(
        frequency: 2462 + _random.nextDouble() * 10,
        bandwidth: 10,
        power: -55 + _random.nextDouble() * 15,
        type: SignalType.droneControl,
        name: 'Unknown Drone RC',
        threat: true,
        modulation: 'FHSS',
        hopping: true,
      ));
    }

    // Radar signal
    if (baseFreq < 3000 && endFreq > 2700) {
      _signals.add(SignalData(
        frequency: 2850 + _random.nextDouble() * 50,
        bandwidth: 5,
        power: -40 + _random.nextDouble() * 10,
        type: SignalType.radar,
        name: 'Search Radar',
        threat: true,
        modulation: 'Pulse',
        prf: 1000 + _random.nextInt(500),
        pulseWidth: 1.0 + _random.nextDouble(),
      ));
    }

    // Communication jammer
    if (_challengeLevel >= 2) {
      _signals.add(SignalData(
        frequency: _centerFreq - 50 + _random.nextDouble() * 100,
        bandwidth: 30 + _random.nextDouble() * 20,
        power: -35 + _random.nextDouble() * 10,
        type: SignalType.jammer,
        name: 'Barrage Jammer',
        threat: true,
        modulation: 'Noise',
      ));
    }

    // GPS jammer (high threat)
    if (_challengeLevel >= 3 && baseFreq < 1600 && endFreq > 1500) {
      _signals.add(SignalData(
        frequency: 1575.42,
        bandwidth: 2,
        power: -30 + _random.nextDouble() * 5,
        type: SignalType.gpsJammer,
        name: 'GPS L1 Jammer',
        threat: true,
        modulation: 'CW/Noise',
      ));
    }

    // Friendly radio
    _signals.add(SignalData(
      frequency: _centerFreq - 100 + _random.nextDouble() * 50,
      bandwidth: 12.5,
      power: -60 + _random.nextDouble() * 10,
      type: SignalType.radio,
      name: 'Friendly VHF',
      threat: false,
      modulation: 'FM',
    ));

    // Unknown signal for identification
    if (_challengeMode) {
      _signals.add(SignalData(
        frequency: _centerFreq + _random.nextDouble() * 100,
        bandwidth: 5 + _random.nextDouble() * 20,
        power: -50 + _random.nextDouble() * 20,
        type: SignalType.unknown,
        name: 'Unknown Signal',
        threat: _random.nextBool(),
        modulation: ['AM', 'FM', 'PSK', 'FSK'][_random.nextInt(4)],
      ));
    }

    _signalsToIdentify = _signals.where((s) => s.threat).length;
  }

  @override
  void dispose() {
    _spectrumController.dispose();
    _sweepController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _identifySignal(int index) {
    if (index < 0 || index >= _signals.length) return;

    final signal = _signals[index];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildSignalAnalysisSheet(signal, index),
    );
  }

  void _markAsThreat(int index, bool isThreat) {
    final signal = _signals[index];
    final correct = signal.threat == isThreat;

    setState(() {
      if (correct) {
        _score += signal.threat ? 100 : 50;
        if (signal.threat && !_identifiedThreats.contains(signal.name)) {
          _identifiedThreats.add(signal.name);
        }
      } else {
        _missedThreats++;
        _score -= 25;
      }
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              correct ? Icons.check_circle : Icons.cancel,
              color: correct ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 10),
            Text(
              correct
                  ? 'ถูกต้อง! ${signal.threat ? "+100" : "+50"} คะแนน'
                  : 'ผิด! -25 คะแนน',
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(50),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green),
              ),
              child: const Text(
                'SPECTRUM ANALYZER',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Threats counter
          if (_challengeMode)
            Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.gps_fixed, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${_identifiedThreats.length}/$_signalsToIdentify',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          // Missed counter
          if (_missedThreats > 0)
            Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cancel, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$_missedThreats',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          // Score display
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_score',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _challengeMode ? Icons.sports_esports : Icons.sports_esports_outlined,
              color: _challengeMode ? Colors.amber : Colors.white54,
            ),
            onPressed: () {
              setState(() {
                _challengeMode = !_challengeMode;
                _generateSignals();
              });
            },
            tooltip: 'Challenge Mode',
          ),
        ],
      ),
      body: Column(
        children: [
          // Control Panel
          _buildControlPanel(),

          // Main Display Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withAlpha(100)),
              ),
              child: Column(
                children: [
                  // Display Header
                  _buildDisplayHeader(),

                  // Spectrum Display
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _spectrumController,
                      builder: (context, _) {
                        return GestureDetector(
                          onTapDown: (details) {
                            _handleSpectrumTap(details.localPosition);
                          },
                          child: CustomPaint(
                            painter: SpectrumPainter(
                              signals: _signals,
                              centerFreq: _centerFreq,
                              span: _span,
                              refLevel: _refLevel,
                              holdMax: _holdMax,
                              showMarkers: _showMarkers,
                              selectedSignal: _selectedSignal,
                              animValue: _spectrumController.value,
                              sweepValue: _sweepController.value,
                              analysisMode: _analysisMode,
                            ),
                            size: Size.infinite,
                          ),
                        );
                      },
                    ),
                  ),

                  // Frequency Scale
                  _buildFrequencyScale(),
                ],
              ),
            ),
          ),

          // Signal List Panel
          _buildSignalListPanel(),

          // Threat Status Bar
          if (_challengeMode) _buildThreatStatusBar(),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        border: Border(
          bottom: BorderSide(color: Colors.green.withAlpha(50)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Center Frequency
            _buildControlKnob(
              label: 'CENTER',
              value: '${_centerFreq.toStringAsFixed(1)} MHz',
              onIncrease: () => setState(() => _centerFreq += 50),
              onDecrease: () => setState(() => _centerFreq -= 50),
            ),
            const SizedBox(width: 16),

            // Span
            _buildControlKnob(
              label: 'SPAN',
              value: '${_span.toStringAsFixed(0)} MHz',
              onIncrease: () => setState(() => _span = min(_span * 2, 2000)),
              onDecrease: () => setState(() => _span = max(_span / 2, 10)),
            ),
            const SizedBox(width: 16),

            // Ref Level
            _buildControlKnob(
              label: 'REF',
              value: '${_refLevel.toStringAsFixed(0)} dBm',
              onIncrease: () => setState(() => _refLevel += 10),
              onDecrease: () => setState(() => _refLevel -= 10),
            ),
            const SizedBox(width: 16),

            // Display Mode
            _buildModeButton(
              icon: Icons.show_chart,
              label: 'Spectrum',
              selected: _analysisMode == 'spectrum',
              onTap: () => setState(() => _analysisMode = 'spectrum'),
            ),
            const SizedBox(width: 8),
            _buildModeButton(
              icon: Icons.waterfall_chart,
              label: 'Waterfall',
              selected: _analysisMode == 'waterfall',
              onTap: () => setState(() => _analysisMode = 'waterfall'),
            ),
            const SizedBox(width: 8),
            _buildModeButton(
              icon: Icons.graphic_eq,
              label: 'Pulse',
              selected: _analysisMode == 'pulse',
              onTap: () => setState(() => _analysisMode = 'pulse'),
            ),

            const SizedBox(width: 16),

            // Hold Max
            _buildToggleButton(
              label: 'HOLD',
              active: _holdMax,
              onTap: () => setState(() => _holdMax = !_holdMax),
            ),

            const SizedBox(width: 8),

            // Refresh signals
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.green),
              onPressed: () {
                setState(() {
                  _generateSignals();
                  _selectedSignal = -1;
                });
              },
              tooltip: 'Refresh Signals',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlKnob({
    required String label,
    required String value,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.green.withAlpha(50)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            color: Colors.green,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            onPressed: onDecrease,
          ),
          Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.green.withAlpha(150),
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            color: Colors.green,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            onPressed: onIncrease,
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.green.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: selected ? Colors.green : Colors.green.withAlpha(50),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: selected ? Colors.green : Colors.green.withAlpha(150)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.green : Colors.green.withAlpha(150),
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.amber.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: active ? Colors.amber : Colors.green.withAlpha(50),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.amber : Colors.green.withAlpha(150),
            fontSize: 11,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black26,
        border: Border(
          bottom: BorderSide(color: Colors.green.withAlpha(30)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RBW: 100 kHz | VBW: 100 kHz | SWT: 20 ms',
            style: TextStyle(
              color: Colors.green.withAlpha(150),
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
          Row(
            children: [
              _buildIndicator('RUN', Colors.green),
              const SizedBox(width: 8),
              _buildIndicator('TRIG', Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(String label, Color color) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            return Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color.withAlpha((150 + (_pulseController.value * 100)).toInt()),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(100),
                    blurRadius: 4,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyScale() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black26,
        border: Border(
          top: BorderSide(color: Colors.green.withAlpha(30)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (i) {
          final freq = _centerFreq - _span / 2 + (_span / 4 * i);
          return Text(
            freq.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.green.withAlpha(150),
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          );
        }),
      ),
    );
  }

  void _handleSpectrumTap(Offset position) {
    // Calculate which signal was tapped based on position
    // This is simplified - in production you'd calculate based on actual signal positions
    final width = MediaQuery.of(context).size.width - 16;
    final tapFreq = _centerFreq - _span / 2 + (_span * position.dx / width);

    int closestSignal = -1;
    double closestDist = double.infinity;

    for (int i = 0; i < _signals.length; i++) {
      final dist = (tapFreq - _signals[i].frequency).abs();
      if (dist < _signals[i].bandwidth && dist < closestDist) {
        closestDist = dist;
        closestSignal = i;
      }
    }

    setState(() {
      _selectedSignal = closestSignal;
    });

    if (closestSignal >= 0) {
      _identifySignal(closestSignal);
    }
  }

  Widget _buildSignalListPanel() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        border: Border(
          top: BorderSide(color: Colors.green.withAlpha(50)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DETECTED SIGNALS (${_signals.length})',
            style: TextStyle(
              color: Colors.green.withAlpha(150),
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _signals.length,
              itemBuilder: (context, index) {
                final signal = _signals[index];
                final isSelected = index == _selectedSignal;
                final isIdentified = _identifiedThreats.contains(signal.name);

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedSignal = index);
                    _identifySignal(index);
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green.withAlpha(30)
                          : Colors.black26,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? Colors.green
                            : signal.threat
                                ? Colors.red.withAlpha(100)
                                : Colors.green.withAlpha(30),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getSignalIcon(signal.type),
                              size: 12,
                              color: _getSignalColor(signal.type),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                signal.name,
                                style: TextStyle(
                                  color: _getSignalColor(signal.type),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isIdentified)
                              const Icon(
                                Icons.check_circle,
                                size: 12,
                                color: Colors.green,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${signal.frequency.toStringAsFixed(2)} MHz',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Text(
                          '${signal.power.toStringAsFixed(1)} dBm',
                          style: TextStyle(
                            color: Colors.green.withAlpha(150),
                            fontSize: 9,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreatStatusBar() {
    final threatsIdentified = _identifiedThreats.length;
    final totalThreats = _signals.where((s) => s.threat).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: threatsIdentified == totalThreats
            ? Colors.green.withAlpha(30)
            : Colors.red.withAlpha(30),
        border: Border(
          top: BorderSide(
            color: threatsIdentified == totalThreats
                ? Colors.green.withAlpha(100)
                : Colors.red.withAlpha(100),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: threatsIdentified < totalThreats ? Colors.red : Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'THREATS: $threatsIdentified / $totalThreats',
                style: TextStyle(
                  color: threatsIdentified == totalThreats
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          Text(
            'Level $_challengeLevel',
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _challengeLevel = max(1, _challengeLevel - 1);
                    _generateSignals();
                    _identifiedThreats.clear();
                  });
                },
                child: const Text('EASIER', style: TextStyle(color: Colors.green)),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _challengeLevel = min(5, _challengeLevel + 1);
                    _generateSignals();
                    _identifiedThreats.clear();
                  });
                },
                child: const Text('HARDER', style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignalAnalysisSheet(SignalData signal, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getSignalColor(signal.type).withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getSignalIcon(signal.type),
                  color: _getSignalColor(signal.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signal.name,
                      style: TextStyle(
                        color: _getSignalColor(signal.type),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getSignalTypeString(signal.type),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (signal.threat)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(30),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'THREAT',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Signal Parameters
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildParamRow('Frequency', '${signal.frequency.toStringAsFixed(3)} MHz'),
                _buildParamRow('Bandwidth', '${signal.bandwidth.toStringAsFixed(1)} MHz'),
                _buildParamRow('Power', '${signal.power.toStringAsFixed(1)} dBm'),
                _buildParamRow('Modulation', signal.modulation),
                if (signal.prf != null)
                  _buildParamRow('PRF', '${signal.prf} Hz'),
                if (signal.pulseWidth != null)
                  _buildParamRow('Pulse Width', '${signal.pulseWidth!.toStringAsFixed(2)} µs'),
                if (signal.hopping)
                  _buildParamRow('Hopping', 'Yes (FHSS)'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Classification Buttons
          if (_challengeMode) ...[
            const Text(
              'ระบุภัยคุกคาม:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsThreat(index, true),
                    icon: const Icon(Icons.warning),
                    label: const Text('เป็นภัยคุกคาม'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsThreat(index, false),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('ปลอดภัย'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('ปิด'),
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildParamRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.green.withAlpha(150),
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSignalIcon(SignalType type) {
    switch (type) {
      case SignalType.wifi:
        return Icons.wifi;
      case SignalType.radar:
        return Icons.radar;
      case SignalType.radio:
        return Icons.radio;
      case SignalType.droneControl:
        return Icons.flight;
      case SignalType.jammer:
        return Icons.wifi_tethering_off;
      case SignalType.gpsJammer:
        return Icons.gps_off;
      case SignalType.unknown:
        return Icons.help_outline;
    }
  }

  Color _getSignalColor(SignalType type) {
    switch (type) {
      case SignalType.wifi:
        return Colors.blue;
      case SignalType.radar:
        return Colors.orange;
      case SignalType.radio:
        return Colors.green;
      case SignalType.droneControl:
        return Colors.purple;
      case SignalType.jammer:
        return Colors.red;
      case SignalType.gpsJammer:
        return Colors.red;
      case SignalType.unknown:
        return Colors.amber;
    }
  }

  String _getSignalTypeString(SignalType type) {
    switch (type) {
      case SignalType.wifi:
        return 'WiFi Network';
      case SignalType.radar:
        return 'Radar System';
      case SignalType.radio:
        return 'Radio Communication';
      case SignalType.droneControl:
        return 'UAV Control Link';
      case SignalType.jammer:
        return 'Electronic Jammer';
      case SignalType.gpsJammer:
        return 'GPS Jammer';
      case SignalType.unknown:
        return 'Unknown Signal';
    }
  }
}

// Signal Data Model
enum SignalType { wifi, radar, radio, droneControl, jammer, gpsJammer, unknown }

class SignalData {
  final double frequency; // MHz
  final double bandwidth; // MHz
  final double power; // dBm
  final SignalType type;
  final String name;
  final bool threat;
  final String modulation;
  final int? prf;
  final double? pulseWidth;
  final bool hopping;

  SignalData({
    required this.frequency,
    required this.bandwidth,
    required this.power,
    required this.type,
    required this.name,
    required this.threat,
    required this.modulation,
    this.prf,
    this.pulseWidth,
    this.hopping = false,
  });
}

// Spectrum Painter
class SpectrumPainter extends CustomPainter {
  final List<SignalData> signals;
  final double centerFreq;
  final double span;
  final double refLevel;
  final bool holdMax;
  final bool showMarkers;
  final int selectedSignal;
  final double animValue;
  final double sweepValue;
  final String analysisMode;

  SpectrumPainter({
    required this.signals,
    required this.centerFreq,
    required this.span,
    required this.refLevel,
    required this.holdMax,
    required this.showMarkers,
    required this.selectedSignal,
    required this.animValue,
    required this.sweepValue,
    required this.analysisMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.green.withAlpha(30)
      ..strokeWidth = 0.5;

    final textPaint = TextPainter(textDirection: TextDirection.ltr);

    // Draw grid
    for (int i = 0; i <= 10; i++) {
      final y = size.height * i / 10;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);

      // dB scale
      final db = refLevel - (i * 10);
      textPaint.text = TextSpan(
        text: '${db.toInt()}',
        style: TextStyle(color: Colors.green.withAlpha(100), fontSize: 9),
      );
      textPaint.layout();
      textPaint.paint(canvas, Offset(2, y - 5));
    }

    for (int i = 0; i <= 10; i++) {
      final x = size.width * i / 10;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw noise floor
    final noisePaint = Paint()
      ..color = Colors.green.withAlpha(80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final noisePath = Path();
    final noiseLevel = size.height * 0.85;
    noisePath.moveTo(0, noiseLevel);

    for (double x = 0; x <= size.width; x += 2) {
      final noise = (sin(x * 0.3 + animValue * 100) * 3 +
              sin(x * 0.7 + animValue * 200) * 2) +
          noiseLevel;
      noisePath.lineTo(x, noise.clamp(0, size.height));
    }
    canvas.drawPath(noisePath, noisePaint);

    // Draw signals
    for (int i = 0; i < signals.length; i++) {
      final signal = signals[i];
      _drawSignal(canvas, size, signal, i == selectedSignal, i);
    }

    // Draw sweep line (for spectrum mode)
    if (analysisMode == 'spectrum') {
      final sweepX = sweepValue * size.width;
      canvas.drawLine(
        Offset(sweepX, 0),
        Offset(sweepX, size.height),
        Paint()
          ..color = Colors.green.withAlpha(100)
          ..strokeWidth = 2,
      );
    }

    // Draw waterfall hint (bottom section)
    if (analysisMode == 'waterfall') {
      _drawWaterfall(canvas, size);
    }
  }

  void _drawSignal(
      Canvas canvas, Size size, SignalData signal, bool selected, int index) {
    final startFreq = centerFreq - span / 2;
    final endFreq = centerFreq + span / 2;

    // Check if signal is in view
    if (signal.frequency < startFreq - signal.bandwidth ||
        signal.frequency > endFreq + signal.bandwidth) {
      return;
    }

    // Calculate position
    final x = (signal.frequency - startFreq) / span * size.width;
    const powerRange = 100.0; // dB range
    final normalizedPower = (refLevel - signal.power) / powerRange;
    final y = normalizedPower.clamp(0.0, 1.0) * size.height;

    // Signal width based on bandwidth
    final signalWidth = (signal.bandwidth / span) * size.width;

    Color signalColor;
    switch (signal.type) {
      case SignalType.wifi:
        signalColor = Colors.blue;
        break;
      case SignalType.radar:
        signalColor = Colors.orange;
        break;
      case SignalType.radio:
        signalColor = Colors.green;
        break;
      case SignalType.droneControl:
        signalColor = Colors.purple;
        break;
      case SignalType.jammer:
      case SignalType.gpsJammer:
        signalColor = Colors.red;
        break;
      case SignalType.unknown:
        signalColor = Colors.amber;
        break;
    }

    // Draw signal shape
    final signalPath = Path();
    signalPath.moveTo(x - signalWidth / 2, size.height);
    signalPath.lineTo(x - signalWidth / 4, y + 10);
    signalPath.quadraticBezierTo(x, y - 5, x + signalWidth / 4, y + 10);
    signalPath.lineTo(x + signalWidth / 2, size.height);
    signalPath.close();

    // Fill
    canvas.drawPath(
      signalPath,
      Paint()
        ..color = signalColor.withAlpha(selected ? 100 : 50)
        ..style = PaintingStyle.fill,
    );

    // Stroke
    canvas.drawPath(
      signalPath,
      Paint()
        ..color = signalColor.withAlpha(selected ? 255 : 150)
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected ? 2 : 1,
    );

    // Draw marker
    if (showMarkers && selected) {
      // Vertical line
      canvas.drawLine(
        Offset(x, y),
        Offset(x, size.height),
        Paint()
          ..color = Colors.white.withAlpha(100)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );

      // Marker point
      canvas.drawCircle(
        Offset(x, y),
        6,
        Paint()..color = signalColor,
      );
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = Colors.white,
      );
    }

    // Hopping effect for FHSS signals
    if (signal.hopping) {
      final hopOffset = sin(animValue * 20 + index) * 10;
      canvas.drawCircle(
        Offset(x + hopOffset, y),
        3,
        Paint()..color = signalColor.withAlpha(150),
      );
    }
  }

  void _drawWaterfall(Canvas canvas, Size size) {
    // Simplified waterfall effect
    for (int row = 0; row < 20; row++) {
      final y = size.height - (row * 5) - 20;
      final alpha = (255 - row * 10).clamp(0, 255);

      for (final signal in signals) {
        final startFreq = centerFreq - span / 2;
        final x = (signal.frequency - startFreq) / span * size.width;
        final width = (signal.bandwidth / span) * size.width;

        Color color;
        switch (signal.type) {
          case SignalType.radar:
            color = Colors.orange;
            break;
          case SignalType.jammer:
          case SignalType.gpsJammer:
            color = Colors.red;
            break;
          default:
            color = Colors.green;
        }

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: width,
            height: 4,
          ),
          Paint()..color = color.withAlpha(alpha),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
