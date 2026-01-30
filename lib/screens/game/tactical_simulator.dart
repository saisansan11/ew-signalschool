import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../../app/constants.dart';

// ==========================================
// TACTICAL EW SIMULATOR
// ระดับยุทธวิธี: Anti-Drone, SIGINT, Coordinated Ops
// ==========================================

class TacticalSimulator extends StatefulWidget {
  final String missionType; // 'anti_drone', 'sigint', 'convoy_protection'
  const TacticalSimulator({super.key, this.missionType = 'anti_drone'});

  @override
  State<TacticalSimulator> createState() => _TacticalSimulatorState();
}

class _TacticalSimulatorState extends State<TacticalSimulator>
    with TickerProviderStateMixin {
  // === Animation Controllers ===
  late AnimationController _radarController;
  late AnimationController _pulseController;
  late AnimationController _scanController;

  // === Mission State ===
  String _currentMission = 'anti_drone';
  bool _missionStarted = false;
  bool _missionComplete = false;
  bool _missionFailed = false;
  double _missionProgress = 0.0;
  int _score = 0;
  int _startTime = 0;

  // === EW System State ===
  bool _jammingActive = false;
  bool _scanningActive = false;
  double _jammerFreq = 2400.0; // MHz
  double _jammerPower = 50.0; // Watts
  double _batteryLevel = 100.0;
  double _systemTemp = 35.0;
  bool _isOverheated = false;
  String _jammingMode = 'spot'; // spot, barrage, sweep
  String _antennaMode = 'omni'; // omni, directional

  // === Detected Signals ===
  List<DetectedSignal> _signals = [];
  DetectedSignal? _selectedSignal;
  List<Drone> _drones = [];
  List<String> _eventLog = [];

  // === Timers ===
  Timer? _gameTimer;
  Timer? _droneSpawnTimer;
  Timer? _signalUpdateTimer;
  final Random _rng = Random();

  // === Map ===
  Offset _jammerPos = const Offset(50, 50);
  Offset _protectedArea = const Offset(50, 50);
  double _protectionRadius = 20.0;

  @override
  void initState() {
    super.initState();
    _currentMission = widget.missionType;

    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _initializeMission();
  }

  void _initializeMission() {
    _signals.clear();
    _drones.clear();
    _eventLog.clear();

    switch (_currentMission) {
      case 'anti_drone':
        _addLog('📡 ภารกิจ: ป้องกันพื้นที่จากโดรน');
        _addLog('🎯 เป้าหมาย: ทำลายโดรน 5 ลำ');
        _protectionRadius = 25.0;
        break;
      case 'sigint':
        _addLog('📡 ภารกิจ: SIGINT - ดักฟังและหาตำแหน่ง');
        _addLog('🎯 เป้าหมาย: ระบุสัญญาณ 5 สัญญาณ');
        _generateRandomSignals(8);
        break;
      case 'convoy_protection':
        _addLog('📡 ภารกิจ: ป้องกันขบวน');
        _addLog('🎯 เป้าหมาย: ป้องกัน IED และโดรน');
        _protectionRadius = 15.0;
        break;
    }
  }

  void _startMission() {
    setState(() {
      _missionStarted = true;
      _startTime = DateTime.now().millisecondsSinceEpoch;
    });

    _addLog('🚀 เริ่มภารกิจ!');

    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), _gameLoop);

    if (_currentMission == 'anti_drone' ||
        _currentMission == 'convoy_protection') {
      _droneSpawnTimer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _spawnDrone(),
      );
    }

    if (_currentMission == 'sigint') {
      _signalUpdateTimer = Timer.periodic(
        const Duration(seconds: 2),
        (_) => _updateSignals(),
      );
    }
  }

  void _gameLoop(Timer timer) {
    if (!mounted || _missionComplete || _missionFailed) return;

    setState(() {
      // Update battery and temperature
      if (_jammingActive && !_isOverheated) {
        _batteryLevel -= (_jammerPower / 2000.0) * 0.3;
        _systemTemp += (_jammerPower / 2000.0) * 0.5;
      } else {
        _systemTemp -= 0.2;
      }
      _systemTemp = _systemTemp.clamp(25.0, 100.0);
      _batteryLevel = _batteryLevel.clamp(0.0, 100.0);

      if (_systemTemp >= 90 && !_isOverheated) {
        _isOverheated = true;
        _jammingActive = false;
        _addLog('⚠️ ระบบร้อนจัด! ต้องรอให้เย็นลง');
      }
      if (_isOverheated && _systemTemp <= 50) {
        _isOverheated = false;
        _addLog('✅ ระบบพร้อมใช้งาน');
      }

      if (_batteryLevel <= 0) {
        _jammingActive = false;
        _scanningActive = false;
        _addLog('🔋 แบตเตอรี่หมด!');
      }

      // Update drones
      _updateDrones();

      // Check win/lose conditions
      _checkMissionStatus();
    });
  }

  void _spawnDrone() {
    if (!_missionStarted || _missionComplete || _missionFailed) return;
    if (_drones.length >= 3) return;

    // Spawn drone from edge of map
    double angle = _rng.nextDouble() * 2 * pi;
    double dist = 45 + _rng.nextDouble() * 5;
    Offset spawnPos = Offset(
      50 + cos(angle) * dist,
      50 + sin(angle) * dist,
    );

    Drone newDrone = Drone(
      id: DateTime.now().millisecondsSinceEpoch,
      position: spawnPos,
      targetPos: _protectedArea,
      frequency: 2400 + _rng.nextInt(100).toDouble(),
      speed: 0.3 + _rng.nextDouble() * 0.2,
      type: _rng.nextBool() ? DroneType.fpv : DroneType.reconnaissance,
    );

    setState(() {
      _drones.add(newDrone);
      _signals.add(DetectedSignal(
        id: newDrone.id,
        frequency: newDrone.frequency,
        bandwidth: 20.0,
        signalStrength: -60 - _rng.nextInt(20).toDouble(),
        azimuth: (atan2(
                  newDrone.position.dy - _jammerPos.dy,
                  newDrone.position.dx - _jammerPos.dx,
                ) *
                180 /
                pi +
            360) %
            360,
        type: SignalType.drone,
        isIdentified: false,
      ));
    });

    _addLog('🔴 ตรวจพบโดรน! ทิศ ${((atan2(spawnPos.dy - _jammerPos.dy, spawnPos.dx - _jammerPos.dx) * 180 / pi + 360) % 360).toStringAsFixed(0)}°');
  }

  void _updateDrones() {
    List<Drone> toRemove = [];

    for (var drone in _drones) {
      // Check if jammed
      bool isJammed = _checkDroneJammed(drone);
      drone.isJammed = isJammed;

      if (isJammed) {
        drone.jammedDuration++;
        if (drone.jammedDuration >= 30) {
          // 3 seconds of jamming
          toRemove.add(drone);
          _score += 100;
          _missionProgress += 0.2;
          _addLog('✅ โดรนถูกทำลาย! +100 คะแนน');
        }
      } else {
        drone.jammedDuration = max(0, drone.jammedDuration - 1);
        // Move towards target
        Offset dir = drone.targetPos - drone.position;
        if (dir.distance > 0.5) {
          drone.position += Offset(
            dir.dx / dir.distance * drone.speed,
            dir.dy / dir.distance * drone.speed,
          );
        }
      }

      // Check if drone reached protected area
      if ((drone.position - _protectedArea).distance < _protectionRadius * 0.3) {
        _missionFailed = true;
        _addLog('❌ โดรนเข้าถึงพื้นที่! ภารกิจล้มเหลว');
      }

      // Update signal position
      for (var sig in _signals) {
        if (sig.id == drone.id) {
          sig.azimuth = (atan2(
                    drone.position.dy - _jammerPos.dy,
                    drone.position.dx - _jammerPos.dx,
                  ) *
                  180 /
                  pi +
              360) %
              360;
          sig.signalStrength = _calculateSignalStrength(drone.position);
        }
      }
    }

    for (var drone in toRemove) {
      _drones.remove(drone);
      _signals.removeWhere((s) => s.id == drone.id);
    }
  }

  bool _checkDroneJammed(Drone drone) {
    if (!_jammingActive || _isOverheated || _batteryLevel <= 0) return false;

    // Check frequency match
    double freqDiff = (_jammerFreq - drone.frequency).abs();
    double bandwidth = _jammingMode == 'spot' ? 20.0 : 100.0;
    if (freqDiff > bandwidth / 2) return false;

    // Check distance
    double dist = (drone.position - _jammerPos).distance;
    double effectiveRange = _calculateEffectiveRange();

    // Directional antenna check
    if (_antennaMode == 'directional' && _selectedSignal != null) {
      double targetAz = _selectedSignal!.azimuth;
      double droneAz = (atan2(
                drone.position.dy - _jammerPos.dy,
                drone.position.dx - _jammerPos.dx,
              ) *
              180 /
              pi +
          360) %
          360;
      double azDiff = (droneAz - targetAz).abs();
      if (azDiff > 30) return false; // 60° beamwidth
      effectiveRange *= 2.0; // Directional bonus
    }

    return dist < effectiveRange;
  }

  double _calculateEffectiveRange() {
    // Simplified J/S calculation
    return sqrt(_jammerPower) * 3; // Rough approximation
  }

  double _calculateSignalStrength(Offset pos) {
    double dist = (pos - _jammerPos).distance;
    return -50 - (dist * 1.5);
  }

  void _generateRandomSignals(int count) {
    for (int i = 0; i < count; i++) {
      _signals.add(DetectedSignal(
        id: i,
        frequency: 30 + _rng.nextDouble() * 3000,
        bandwidth: 5 + _rng.nextDouble() * 50,
        signalStrength: -40 - _rng.nextDouble() * 50,
        azimuth: _rng.nextDouble() * 360,
        type: SignalType.values[_rng.nextInt(SignalType.values.length)],
        isIdentified: false,
      ));
    }
  }

  void _updateSignals() {
    if (!_scanningActive) return;
    for (var sig in _signals) {
      sig.signalStrength += (_rng.nextDouble() - 0.5) * 5;
      sig.azimuth += (_rng.nextDouble() - 0.5) * 2;
      sig.signalStrength = sig.signalStrength.clamp(-100.0, -20.0);
      sig.azimuth = sig.azimuth % 360;
    }
  }

  void _identifySignal(DetectedSignal signal) {
    if (_currentMission != 'sigint') return;
    if (signal.isIdentified) return;

    setState(() {
      signal.isIdentified = true;
      _score += 50;
      _missionProgress += 0.2;
      _addLog('✅ ระบุสัญญาณ ${signal.frequency.toStringAsFixed(0)} MHz');
    });

    if (_missionProgress >= 1.0) {
      _missionComplete = true;
      _endMission(true);
    }
  }

  void _checkMissionStatus() {
    if (_missionProgress >= 1.0 && !_missionComplete) {
      _missionComplete = true;
      _endMission(true);
    }
  }

  void _endMission(bool success) {
    _gameTimer?.cancel();
    _droneSpawnTimer?.cancel();
    _signalUpdateTimer?.cancel();

    int timeBonus =
        success ? (300 - ((DateTime.now().millisecondsSinceEpoch - _startTime) ~/ 1000)).clamp(0, 300) : 0;
    int batteryBonus = (_batteryLevel * 2).toInt();
    int finalScore = _score + timeBonus + batteryBonus;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          success ? '✅ ภารกิจสำเร็จ!' : '❌ ภารกิจล้มเหลว',
          style: TextStyle(
            color: success ? AppColors.success : AppColors.danger,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$finalScore',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: success ? AppColors.success : AppColors.danger,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'คะแนนรวม',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const Divider(color: AppColors.border),
            _scoreRow('คะแนนพื้นฐาน', _score),
            _scoreRow('โบนัสเวลา', timeBonus),
            _scoreRow('โบนัสแบตเตอรี่', batteryBonus),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('กลับเมนู'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _resetMission();
            },
            child: const Text('เล่นใหม่'),
          ),
        ],
      ),
    );
  }

  Widget _scoreRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            '+$value',
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _resetMission() {
    setState(() {
      _missionStarted = false;
      _missionComplete = false;
      _missionFailed = false;
      _missionProgress = 0.0;
      _score = 0;
      _jammingActive = false;
      _scanningActive = false;
      _batteryLevel = 100.0;
      _systemTemp = 35.0;
      _isOverheated = false;
    });
    _initializeMission();
  }

  void _addLog(String message) {
    int secs =
        _missionStarted ? (DateTime.now().millisecondsSinceEpoch - _startTime) ~/ 1000 : 0;
    _eventLog.insert(0, '[${secs}s] $message');
    if (_eventLog.length > 20) _eventLog.removeLast();
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pulseController.dispose();
    _scanController.dispose();
    _gameTimer?.cancel();
    _droneSpawnTimer?.cancel();
    _signalUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(_getMissionTitle()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          _buildStatusBar(),

          // Main content
          Expanded(
            child: Row(
              children: [
                // Radar/Map view
                Expanded(
                  flex: 2,
                  child: _buildRadarView(),
                ),
                // Control panel
                SizedBox(
                  width: 200,
                  child: _buildControlPanel(),
                ),
              ],
            ),
          ),

          // Event log
          _buildEventLog(),
        ],
      ),
    );
  }

  String _getMissionTitle() {
    switch (_currentMission) {
      case 'anti_drone':
        return 'ภารกิจ: Anti-Drone';
      case 'sigint':
        return 'ภารกิจ: SIGINT';
      case 'convoy_protection':
        return 'ภารกิจ: Convoy Protection';
      default:
        return 'Tactical Simulator';
    }
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surface,
      child: Row(
        children: [
          // Mission progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ความคืบหน้า',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${(_missionProgress * 100).toInt()}%',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _missionProgress,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: const AlwaysStoppedAnimation(AppColors.success),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),

          // Battery
          _buildStatusIndicator(
            icon: Icons.battery_std,
            value: '${_batteryLevel.toInt()}%',
            color: _batteryLevel > 20 ? AppColors.success : AppColors.danger,
          ),
          const SizedBox(width: 16),

          // Temperature
          _buildStatusIndicator(
            icon: Icons.thermostat,
            value: '${_systemTemp.toInt()}°C',
            color: _isOverheated ? AppColors.danger : AppColors.success,
          ),
          const SizedBox(width: 16),

          // Score
          _buildStatusIndicator(
            icon: Icons.star,
            value: '$_score',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRadarView() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          // Radar background
          AnimatedBuilder(
            animation: _radarController,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: RadarPainter(
                  sweepAngle: _radarController.value * 2 * pi,
                  isScanning: _scanningActive,
                ),
              );
            },
          ),

          // Protection zone
          if (_currentMission != 'sigint')
            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return Container(
                    width: _protectionRadius * 4 +
                        sin(_pulseController.value * 2 * pi) * 10,
                    height: _protectionRadius * 4 +
                        sin(_pulseController.value * 2 * pi) * 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.success.withAlpha(100),
                        width: 2,
                      ),
                      color: AppColors.success.withAlpha(20),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shield,
                        color: AppColors.success,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Drones
          ..._drones.map((drone) => _buildDroneMarker(drone)),

          // Signals (SIGINT mode)
          if (_currentMission == 'sigint')
            ..._signals.map((sig) => _buildSignalMarker(sig)),

          // Jammer effective range
          if (_jammingActive)
            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  double range = _calculateEffectiveRange() * 3;
                  return Container(
                    width: range + sin(_pulseController.value * 2 * pi) * 5,
                    height: range + sin(_pulseController.value * 2 * pi) * 5,
                    decoration: BoxDecoration(
                      shape: _antennaMode == 'omni'
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.redAccent.withAlpha(150),
                        width: 2,
                      ),
                      color: Colors.redAccent.withAlpha(30),
                    ),
                  );
                },
              ),
            ),

          // Center jammer icon
          const Center(
            child: Icon(
              Icons.cell_tower,
              color: AppColors.primary,
              size: 32,
            ),
          ),

          // Start button overlay
          if (!_missionStarted)
            Center(
              child: ElevatedButton.icon(
                onPressed: _startMission,
                icon: const Icon(Icons.play_arrow),
                label: const Text('เริ่มภารกิจ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDroneMarker(Drone drone) {
    // Calculate screen position (simplified)
    double dx = (drone.position.dx - 50) * 3;
    double dy = (drone.position.dy - 50) * 3;

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Center(
        child: Transform.translate(
          offset: Offset(dx, dy),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                drone.type == DroneType.fpv ? Icons.flight : Icons.visibility,
                color: drone.isJammed ? Colors.grey : Colors.redAccent,
                size: 24,
              ),
              if (drone.isJammed)
                const Text(
                  'JAMMED',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignalMarker(DetectedSignal signal) {
    double angle = signal.azimuth * pi / 180;
    double dist = 80; // Fixed display distance
    double dx = cos(angle) * dist;
    double dy = sin(angle) * dist;

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Center(
        child: Transform.translate(
          offset: Offset(dx, dy),
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedSignal = signal);
              if (_currentMission == 'sigint' && _scanningActive) {
                _identifySignal(signal);
              }
            },
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: signal.isIdentified
                    ? AppColors.success
                    : _getSignalTypeColor(signal.type),
                border: Border.all(
                  color: _selectedSignal?.id == signal.id
                      ? Colors.white
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: signal.isIdentified
                  ? const Icon(Icons.check, size: 10, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Color _getSignalTypeColor(SignalType type) {
    switch (type) {
      case SignalType.drone:
        return Colors.redAccent;
      case SignalType.radio:
        return Colors.amber;
      case SignalType.radar:
        return Colors.cyan;
      case SignalType.friendly:
        return Colors.greenAccent;
      case SignalType.civilian:
        return Colors.yellow;
    }
  }

  Widget _buildControlPanel() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ควบคุมระบบ',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Jamming toggle
            _buildControlButton(
              label: _jammingActive ? 'หยุด JAM' : 'เริ่ม JAM',
              icon: _jammingActive ? Icons.stop : Icons.flash_on,
              color: _jammingActive ? AppColors.danger : AppColors.primary,
              enabled: !_isOverheated && _batteryLevel > 0 && _missionStarted,
              onPressed: () {
                setState(() => _jammingActive = !_jammingActive);
                _addLog(_jammingActive ? '🔴 เริ่มรบกวน' : '🟢 หยุดรบกวน');
              },
            ),

            const SizedBox(height: 8),

            // Scanning toggle
            _buildControlButton(
              label: _scanningActive ? 'หยุด SCAN' : 'เริ่ม SCAN',
              icon: _scanningActive ? Icons.stop : Icons.radar,
              color: _scanningActive ? AppColors.warning : AppColors.success,
              enabled: _batteryLevel > 0 && _missionStarted,
              onPressed: () {
                setState(() => _scanningActive = !_scanningActive);
                _addLog(_scanningActive ? '📡 เริ่มสแกน' : '📴 หยุดสแกน');
              },
            ),

            const Divider(color: AppColors.border, height: 24),

            // Frequency control
            const Text(
              'ความถี่ (MHz)',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            Text(
              _jammerFreq.toStringAsFixed(0),
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _jammerFreq,
              min: 2400,
              max: 5800,
              divisions: 34,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _jammerFreq = v),
            ),

            // Power control
            const Text(
              'กำลังส่ง (W)',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            Text(
              _jammerPower.toStringAsFixed(0),
              style: const TextStyle(
                color: AppColors.warning,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _jammerPower,
              min: 10,
              max: 200,
              divisions: 19,
              activeColor: AppColors.warning,
              onChanged: (v) => setState(() => _jammerPower = v),
            ),

            const Divider(color: AppColors.border, height: 24),

            // Jamming mode
            const Text(
              'โหมด Jamming',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 4),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'spot', label: Text('Spot', style: TextStyle(fontSize: 10))),
                ButtonSegment(value: 'barrage', label: Text('Barrage', style: TextStyle(fontSize: 10))),
              ],
              selected: {_jammingMode},
              onSelectionChanged: (s) => setState(() => _jammingMode = s.first),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary;
                  }
                  return AppColors.surfaceLight;
                }),
              ),
            ),

            const SizedBox(height: 12),

            // Antenna mode
            const Text(
              'สายอากาศ',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 4),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'omni', label: Text('Omni', style: TextStyle(fontSize: 10))),
                ButtonSegment(value: 'directional', label: Text('Dir', style: TextStyle(fontSize: 10))),
              ],
              selected: {_antennaMode},
              onSelectionChanged: (s) => setState(() => _antennaMode = s.first),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary;
                  }
                  return AppColors.surfaceLight;
                }),
              ),
            ),

            // Selected signal info
            if (_selectedSignal != null) ...[
              const Divider(color: AppColors.border, height: 24),
              const Text(
                'สัญญาณที่เลือก',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '${_selectedSignal!.frequency.toStringAsFixed(0)} MHz',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'ทิศ: ${_selectedSignal!.azimuth.toStringAsFixed(0)}°',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              Text(
                'ความแรง: ${_selectedSignal!.signalStrength.toStringAsFixed(0)} dBm',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.surfaceLight,
          disabledForegroundColor: AppColors.textMuted,
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildEventLog() {
    return Container(
      height: 80,
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              'บันทึกเหตุการณ์',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: _eventLog.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8, bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _eventLog[index],
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
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

  void _showHelp() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'วิธีเล่น',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _helpSection(
                'Anti-Drone',
                '• ตรวจจับโดรนที่เข้ามา\n'
                    '• ปรับความถี่ให้ตรงกับโดรน (2.4-5.8 GHz)\n'
                    '• เปิด Jamming เพื่อทำลายโดรน\n'
                    '• ป้องกันไม่ให้โดรนเข้าพื้นที่',
              ),
              _helpSection(
                'SIGINT',
                '• เปิด Scan เพื่อค้นหาสัญญาณ\n'
                    '• คลิกที่สัญญาณเพื่อระบุตัวตน\n'
                    '• ระบุให้ครบตามเป้าหมาย',
              ),
              _helpSection(
                'เคล็ดลับ',
                '• Barrage ครอบคลุมกว้าง แต่ใช้พลังงานมาก\n'
                    '• Directional Antenna ไกลกว่า แต่ต้องเล็ง\n'
                    '• ระวังความร้อนและแบตเตอรี่',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('เข้าใจแล้ว'),
          ),
        ],
      ),
    );
  }

  Widget _helpSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// === Data Models ===

class DetectedSignal {
  final int id;
  double frequency;
  double bandwidth;
  double signalStrength;
  double azimuth;
  SignalType type;
  bool isIdentified;

  DetectedSignal({
    required this.id,
    required this.frequency,
    required this.bandwidth,
    required this.signalStrength,
    required this.azimuth,
    required this.type,
    this.isIdentified = false,
  });
}

enum SignalType { drone, radio, radar, friendly, civilian }

enum DroneType { fpv, reconnaissance }

class Drone {
  final int id;
  Offset position;
  Offset targetPos;
  double frequency;
  double speed;
  DroneType type;
  bool isJammed;
  int jammedDuration;

  Drone({
    required this.id,
    required this.position,
    required this.targetPos,
    required this.frequency,
    required this.speed,
    required this.type,
    this.isJammed = false,
    this.jammedDuration = 0,
  });
}

// === Radar Painter ===

class RadarPainter extends CustomPainter {
  final double sweepAngle;
  final bool isScanning;

  RadarPainter({required this.sweepAngle, required this.isScanning});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20;

    // Draw grid circles
    final gridPaint = Paint()
      ..color = Colors.green.withAlpha(30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4, gridPaint);
    }

    // Draw grid lines
    for (int i = 0; i < 8; i++) {
      double angle = i * pi / 4;
      canvas.drawLine(
        center,
        center + Offset(cos(angle) * radius, sin(angle) * radius),
        gridPaint,
      );
    }

    // Draw sweep line
    if (isScanning) {
      final sweepPaint = Paint()
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: sweepAngle - 0.5,
          endAngle: sweepAngle,
          colors: [
            Colors.green.withAlpha(0),
            Colors.green.withAlpha(100),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        sweepAngle - 0.5,
        0.5,
        true,
        sweepPaint,
      );

      // Draw sweep line
      final linePaint = Paint()
        ..color = Colors.greenAccent
        ..strokeWidth = 2;
      canvas.drawLine(
        center,
        center + Offset(cos(sweepAngle) * radius, sin(sweepAngle) * radius),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) =>
      oldDelegate.sweepAngle != sweepAngle ||
      oldDelegate.isScanning != isScanning;
}
