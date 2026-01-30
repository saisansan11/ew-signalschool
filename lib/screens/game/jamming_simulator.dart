import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../../models/particle.dart';
import '../../models/decoy.dart';
import '../../models/civilian_signal.dart';

// Global variable for high scores (สามารถย้ายไปจัดการใน State Management ภายหลังได้)
List<Map<String, dynamic>> globalHighScores = [];

class JammingSimulator extends StatefulWidget {
  final bool isChallengeMode;
  final String? playerName;
  final String? initialDifficulty;
  const JammingSimulator({
    super.key,
    this.isChallengeMode = false,
    this.playerName,
    this.initialDifficulty,
  });
  @override
  State<JammingSimulator> createState() => _JammingSimulatorState();
}

class _JammingSimulatorState extends State<JammingSimulator>
    with SingleTickerProviderStateMixin {
  // State
  Offset jammerPos = const Offset(20, 25);
  Offset targetPos = const Offset(70, 25);
  Offset hqPos = const Offset(5, 40);
  Offset obstaclePos = const Offset(45, 25);
  Offset rainPos = const Offset(50, 10);
  Offset friendlyPos = const Offset(30, 40);
  double targetSignalPowerWatts = 50.0;
  bool isTargetHopping = false;
  bool isTargetMoving = false;
  bool isRaining = false;
  String targetType = 'radio';
  double targetFreqMHz = 50.0;
  double friendlyFreqMHz = 60.0;
  bool isTargetSilent = false;
  int silentDuration = 0;
  double jammerPowerWatts = 50.0;
  bool isUHF = false;
  bool isObstacleActive = false;
  double jammerFreqMHz = 45.0;
  bool isFogOfWar = false;
  double systemTemp = 40.0;
  double batteryLevel = 100.0;
  bool isOverheated = false;
  bool isSoundEnabled = true;
  bool isTransmitting = false;
  String jammingTechnique = 'continuous';
  double sweepDirection = 1.0;
  String selectedEquipmentType = 'manpack';
  String antennaType = 'omni';
  String jammingType = 'spot';
  double missionProgress = 0.0;
  bool isMissionComplete = false;
  bool isMissionFailed = false;
  String difficulty = 'normal';
  int scorePenalty = 0;
  int penaltyFriendlyFire = 0;
  int penaltyCivilian = 0;
  int decoysUsed = 0;
  double detectionRisk = 0.0;
  Offset? missilePos;
  bool isMissileLocked = false;
  List<Decoy> activeDecoys = [];
  int decoyAmmo = 3;
  List<CivilianSignal> civilians = [];
  bool wasCivilianHit = false;
  List<String> eventLog = [];
  int startTime = 0;
  Timer? _gameTimer;
  Timer? movementTimer;
  Timer? hoppingTimer;
  late AnimationController _animController;
  List<Particle> particles = [];
  Random rng = Random();
  List<Map<String, dynamic>> waterfallHistory = [];
  Offset moveDirection = const Offset(1, 0.5);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _animController.addListener(_onAnimationTick);
    startTime = DateTime.now().millisecondsSinceEpoch;
    if (widget.isChallengeMode) {
      _setupChallenge(widget.initialDifficulty ?? 'normal');
    } else {
      _addSafeLog("เริ่มภารกิจฝึก (Start)");
    }
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), _gameLoop);
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    movementTimer?.cancel();
    hoppingTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  // Logic
  void _addSafeLog(String msg) {
    if (!mounted) return;
    int s = (DateTime.now().millisecondsSinceEpoch - startTime) ~/ 1000;
    eventLog.insert(0, "[${s}s] $msg");
    if (eventLog.length > 30) eventLog.removeLast();
  }

  double _distPointToSegment(Offset p, Offset a, Offset b) {
    double l2 = (a - b).distanceSquared;
    if (l2 == 0) return (p - a).distance;
    double t =
        ((p.dx - a.dx) * (b.dx - a.dx) + (p.dy - a.dy) * (b.dy - a.dy)) / l2;
    t = max(0, min(1, t));
    return (p - Offset(a.dx + t * (b.dx - a.dx), a.dy + t * (b.dy - a.dy)))
        .distance;
  }

  bool isLineOfSightBlocked() =>
      isObstacleActive &&
      _distPointToSegment(obstaclePos, jammerPos, targetPos) < 8.0;

  double _calcReceivedPowerSafe() {
    if (!isTransmitting || isOverheated || batteryLevel <= 0) return -999.0;
    double dist = (jammerPos - targetPos).distance;
    if (dist < 0.1) dist = 0.1;
    double loss =
        32.44 + (20 * log(targetFreqMHz) / ln10) + (20 * log(dist) / ln10);
    if (isLineOfSightBlocked()) loss += 20.0;
    if (isRaining &&
        _distPointToSegment(rainPos, jammerPos, targetPos) < 15.0) {
      loss += 2.0;
    }
    double antennaGain = (antennaType == 'directional') ? 12.0 : 2.0;
    double jammerEirp =
        (10 * (log(jammerPowerWatts * 1000) / ln10)) + antennaGain;
    if (jammingType == 'barrage') jammerEirp -= 15.0;
    return jammerEirp - loss;
  }

  bool _checkJamSuccess() {
    if (isTargetSilent ||
        !isTransmitting ||
        isOverheated ||
        batteryLevel <= 0) {
      return false;
    }
    double bandwidth = (jammingType == 'spot') ? 2.0 : 10.0;
    if ((jammerFreqMHz - targetFreqMHz).abs() > (bandwidth / 2)) return false;
    double jammerPowerAtTarget = _calcReceivedPowerSafe();
    double targetSignalPower =
        (10 * (log(targetSignalPowerWatts * 1000) / ln10)) - 80.0;
    return (jammerPowerAtTarget - targetSignalPower) > 0;
  }

  double getReceivedJammerPower_dBm() => _calcReceivedPowerSafe();
  double getReceivedSignalPower_dBm() =>
      (10 * (log(targetSignalPowerWatts * 1000) / ln10)) - 80.0;
  double get currentJSRatio =>
      getReceivedJammerPower_dBm() - getReceivedSignalPower_dBm();
  double get burnThroughRangeKm {
    if (!isTransmitting || isOverheated || batteryLevel <= 0) return 0;
    double maxL =
        (wattsToDbm(jammerPowerWatts) +
            (antennaType == 'directional' ? 12 : 2)) -
        getReceivedSignalPower_dBm();
    if (isLineOfSightBlocked()) maxL -= 20;
    if (isRaining) maxL -= 2;
    return pow(
      10,
      (maxL - (32.44 + 20 * log(targetFreqMHz) / ln10)) / 20,
    ).toDouble();
  }

  double wattsToDbm(double w) => 10 * (log(w * 1000) / ln10);

  void _setupChallenge(String diff) {
    difficulty = diff;
    _addSafeLog("🏆 แข่งขันระดับ: $difficulty");
    targetFreqMHz = 30.0 + rng.nextInt(50);
    isFogOfWar = true;
    if (difficulty == 'easy') {
      targetType = 'radio';
      isTargetHopping = false;
      isTargetMoving = false;
      isRaining = false;
      isObstacleActive = false;
    } else if (difficulty == 'normal') {
      targetType = rng.nextBool() ? 'radio' : 'uav';
      isTargetHopping = rng.nextBool();
      isTargetMoving = true;
      isRaining = rng.nextBool();
      isObstacleActive = false;
    } else {
      targetType = rng.nextBool() ? 'uav' : 'radar';
      isTargetHopping = true;
      isTargetMoving = true;
      isRaining = true;
      isObstacleActive = true;
    }
  }

  void _endGame(bool success) {
    int time = (DateTime.now().millisecondsSinceEpoch - startTime) ~/ 1000;
    int base = success ? 1000 : 0;
    int tb = success ? (300 - time).clamp(0, 300) * 2 : 0;
    int bb = batteryLevel.toInt() * 5;
    int dp = decoysUsed * 50;
    int totalP = penaltyFriendlyFire + penaltyCivilian + dp;
    int total = base + tb + bb - totalP;
    if (total < 0) total = 0;
    String rank = total >= 1500
        ? "S (จอมพล)"
        : (total >= 1200
              ? "A (ผู้พัน)"
              : (total >= 900
                    ? "B (ร้อยเอก)"
                    : (total >= 500 ? "C (จ่าสิบเอก)" : "F (พลทหาร)")));
    Color rc = total >= 1200 ? Colors.amber : Colors.white;
    if (widget.isChallengeMode && widget.playerName != null) {
      globalHighScores.add({
        'name': widget.playerName,
        'score': total,
        'rank': success ? 'ผ่าน ($rank)' : 'ไม่ผ่าน',
        'date': 'Now',
      });
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF263238),
        title: Text(
          success ? "ภารกิจสำเร็จ!" : "ล้มเหลว",
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "$total",
                style: TextStyle(
                  fontSize: 40,
                  color: rc,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(rank, style: TextStyle(color: rc)),
              const Divider(color: Colors.white24),
              _row("คะแนนฐาน:", base, Colors.white),
              _row("เวลา:", tb, Colors.green),
              _row("แบตเตอรี่:", bb, Colors.green),
              if (totalP > 0) _row("หักคะแนน:", -totalP, Colors.red),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(c);
              _resetScenario();
            },
            child: const Text("เริ่มใหม่"),
          ),
        ],
      ),
    );
  }

  void _toggleMovement(bool v) {
    setState(() {
      isTargetMoving = v;
      if (v) {
        movementTimer = Timer.periodic(const Duration(milliseconds: 50), (t) {
          if (!isMissionComplete && !isMissionFailed) {
            setState(() {
              Offset d = hqPos - targetPos;
              if (d.distance > 0) targetPos += d * (0.1 / d.distance);
            });
          }
        });
      } else {
        movementTimer?.cancel();
      }
    });
  }

  void _toggleHopping(bool v) {
    setState(() {
      isTargetHopping = v;
      if (v) {
        hoppingTimer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (!isMissionComplete && !isMissionFailed && !isTargetSilent) {
            setState(() {
              targetFreqMHz = 30.0 + rng.nextInt(50);
              _addSafeLog("📡 Hopping -> ${targetFreqMHz.toInt()}");
            });
          }
        });
      } else {
        hoppingTimer?.cancel();
      }
    });
  }

  void _toggleTx(bool value) {
    if (isOverheated || batteryLevel <= 0) return;
    setState(() {
      isTransmitting = value;
      _addSafeLog(value ? "🔴 กำลังส่งสัญญาณ (TX)" : "🟢 เตรียมพร้อม (RX)");
    });
  }

  void _setJammingTechnique(String t) {
    setState(() {
      jammingTechnique = t;
      isTransmitting = false;
    });
  }

  void _handleMapDrag(
    String type,
    DragUpdateDetails details,
    double mapWidth,
    double mapHeight,
  ) {
    double pxPerKmX = mapWidth / 100.0;
    double pxPerKmY = mapHeight / 50.0;
    double dx = details.delta.dx / pxPerKmX;
    double dy = details.delta.dy / pxPerKmY;
    setState(() {
      if (type == 'jammer') jammerPos = _clampPos(jammerPos + Offset(dx, dy));
      if (type == 'target' && !isFogOfWar && !isTargetSilent) {
        targetPos = _clampPos(targetPos + Offset(dx, dy));
      }
      if (type == 'obstacle') {
        obstaclePos = _clampPos(obstaclePos + Offset(dx, dy));
      }
      if (type == 'hq') hqPos = _clampPos(hqPos + Offset(dx, dy));
      if (type == 'rain') rainPos = _clampPos(rainPos + Offset(dx, dy));
      if (type == 'friendly') {
        friendlyPos = _clampPos(friendlyPos + Offset(dx, dy));
      }
    });
  }

  Offset _clampPos(Offset pos) =>
      Offset(pos.dx.clamp(0.0, 100.0), pos.dy.clamp(0.0, 50.0));

  String _getTargetName() => targetType == 'uav'
      ? 'โดรน'
      : (targetType == 'radar' ? 'เรดาร์' : 'วิทยุ');
  IconData _getJammerIcon() => selectedEquipmentType == 'manpack'
      ? Icons.backpack
      : (selectedEquipmentType == 'station'
            ? Icons.cell_tower
            : Icons.directions_car);
  IconData _getTargetIcon(bool jammed) => isTargetSilent
      ? Icons.do_not_disturb_on
      : (jammed && targetType == 'uav'
            ? Icons.airplanemode_inactive
            : (targetType == 'uav'
                  ? Icons.flight
                  : (targetType == 'radar' ? Icons.radar : Icons.radio)));

  void _deployDecoy() {
    if (decoyAmmo > 0) {
      setState(() {
        decoyAmmo--;
        decoysUsed++;
        activeDecoys.add(Decoy(position: jammerPos));
        _addSafeLog("🔵 ปล่อยเป้าลวง!");
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("เป้าลวงหมด!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetScenario() {
    setState(() {
      targetSignalPowerWatts = 50.0;
      targetPos = const Offset(80, 25);
      targetFreqMHz = 50.0;
      jammerPowerWatts = 50.0;
      jammerPos = const Offset(20, 25);
      jammerFreqMHz = 45.0;
      friendlyPos = const Offset(30, 40);
      friendlyFreqMHz = 60.0;
      obstaclePos = const Offset(45, 25);
      isObstacleActive = false;
      selectedEquipmentType = 'manpack';
      antennaType = 'omni';
      jammingType = 'spot';
      targetType = 'radio';
      jammingTechnique = 'continuous';
      isRaining = false;
      isFogOfWar = false;
      waterfallHistory.clear();
      eventLog.clear();
      _addSafeLog("รีเซ็ตระบบ");
      startTime = DateTime.now().millisecondsSinceEpoch;
      systemTemp = 40.0;
      batteryLevel = 100.0;
      isOverheated = false;
      isTransmitting = false;
      missionProgress = 0.0;
      isMissionComplete = false;
      isMissionFailed = false;
      particles.clear();
      isTargetSilent = false;
      detectionRisk = 0.0;
      missilePos = null;
      isMissileLocked = false;
      activeDecoys.clear();
      decoyAmmo = 3;
      civilians.clear();
      penaltyFriendlyFire = 0;
      penaltyCivilian = 0;
      decoysUsed = 0;
      scorePenalty = 0;
      _toggleHopping(false);
      _toggleMovement(false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("รีเซ็ตภารกิจ"),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void _loadEquipmentPreset(String type) {
    setState(() {
      selectedEquipmentType = type;
      switch (type) {
        case 'manpack':
          jammerPowerWatts = 50.0;
          antennaType = 'omni';
          break;
        case 'vehicle':
          jammerPowerWatts = 200.0;
          antennaType = 'omni';
          break;
        case 'station':
          jammerPowerWatts = 1000.0;
          antennaType = 'directional';
          break;
      }
    });
    Navigator.pop(context);
  }

  void _showSettingsDialog() {
    double tempTargetPower = targetSignalPowerWatts;
    double tempTargetFreq = targetFreqMHz;
    double tempFriendlyFreq = friendlyFreqMHz;
    String tempTargetType = targetType;
    bool tempRain = isRaining;
    bool tempObstacle = isObstacleActive;
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF37474F),
        title: const Text(
          "ตั้งค่า (ครูฝึก)",
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setStateDialog) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "1. กำลังส่งข้าศึก:",
                  style: TextStyle(color: Colors.amber),
                ),
                Slider(
                  value: tempTargetPower,
                  min: 10,
                  max: 200,
                  divisions: 19,
                  label: "${tempTargetPower.toInt()}W",
                  activeColor: Colors.red,
                  onChanged: (v) => setStateDialog(() => tempTargetPower = v),
                ),
                const Text(
                  "2. ความถี่ข้าศึก:",
                  style: TextStyle(color: Colors.amber),
                ),
                Slider(
                  value: tempTargetFreq,
                  min: 30,
                  max: 88,
                  divisions: 58,
                  label: "${tempTargetFreq.toInt()} MHz",
                  activeColor: Colors.redAccent,
                  onChanged: (v) => setStateDialog(() => tempTargetFreq = v),
                ),
                const Text(
                  "3. ความถี่ฝ่ายเรา:",
                  style: TextStyle(color: Colors.amber),
                ),
                Slider(
                  value: tempFriendlyFreq,
                  min: 30,
                  max: 88,
                  divisions: 58,
                  label: "${tempFriendlyFreq.toInt()} MHz",
                  activeColor: Colors.green,
                  onChanged: (v) => setStateDialog(() => tempFriendlyFreq = v),
                ),
                const Text(
                  "4. ชนิดเป้าหมาย:",
                  style: TextStyle(color: Colors.amber),
                ),
                DropdownButton<String>(
                  value: tempTargetType,
                  dropdownColor: Colors.blueGrey,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'radio',
                      child: Text(
                        "วิทยุ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'uav',
                      child: Text(
                        "โดรน",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'radar',
                      child: Text(
                        "เรดาร์",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: (v) => setStateDialog(() => tempTargetType = v!),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: tempRain,
                      activeColor: Colors.blue,
                      onChanged: (v) => setStateDialog(() => tempRain = v!),
                    ),
                    const Text("ฝน", style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 10),
                    Checkbox(
                      value: tempObstacle,
                      activeColor: Colors.brown,
                      onChanged: (v) => setStateDialog(() => tempObstacle = v!),
                    ),
                    const Text("ภูเขา", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                targetSignalPowerWatts = tempTargetPower;
                targetFreqMHz = tempTargetFreq;
                friendlyFreqMHz = tempFriendlyFreq;
                targetType = tempTargetType;
                isRaining = tempRain;
                isObstacleActive = tempObstacle;
                _addSafeLog("🛠️ ปรับค่าโจทย์แล้ว");
              });
              Navigator.pop(c);
            },
            child: const Text("บันทึก"),
          ),
        ],
      ),
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF263238),
        title: const Text("จบภารกิจ?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "ต้องการกลับหน้าเมนูหลักหรือไม่?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text(
              "ยกเลิก",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(c);
              Navigator.pop(context);
            },
            child: const Text("ตกลง", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAnalysisDialog() {
    double js = currentJSRatio;
    bool isJammed = _checkJamSuccess();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF263238),
      builder: (c) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "วิเคราะห์ผลการยิง",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24),
            if (isTransmitting)
              Text(
                "อัตราส่วน J/S: ${isJammed ? js.toStringAsFixed(2) : 'N/A'} dB",
                style: TextStyle(
                  color: isJammed && js > 0 ? Colors.green : Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              const Text(
                "สถานะ: ปิดเครื่องส่ง",
                style: TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 10),
            if (scorePenalty > 0)
              Text(
                "บทลงโทษ: -$scorePenalty คะแนน",
                style: const TextStyle(
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(String l, int s, Color c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: const TextStyle(color: Colors.white70)),
        Text(
          "${s >= 0 ? "+" : ""}$s",
          style: TextStyle(color: c, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  Widget _buildDraggableMarker(
    String id,
    Offset posKm,
    IconData icon,
    Color color,
    String label,
    double mapWidth,
    double mapHeight, {
    bool showBar = false,
    double health = 1.0,
  }) {
    double pxPerKmX = mapWidth / 100.0;
    double pxPerKmY = mapHeight / 50.0;
    double x = posKm.dx * pxPerKmX;
    double y = posKm.dy * pxPerKmY;
    const double markerSize = 80.0;
    return Positioned(
      left: x - (markerSize / 2),
      top: y - 20,
      width: markerSize,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (widget.isChallengeMode && id == 'target') return;
          _handleMapDrag(id, details, mapWidth, mapHeight);
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBar)
                Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: health.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: health > 0 ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                  shadows: const [Shadow(blurRadius: 5, color: Colors.black)],
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Game Loop ---
  void _gameLoop(Timer t) {
    if (!mounted || isMissionComplete || isMissionFailed) return;
    setState(() {
      if (rng.nextInt(100) < 3) {
        civilians.add(
          CivilianSignal(
            freq: 30.0 + rng.nextDouble() * 58.0,
            width: 2.0,
            life: 50 + rng.nextInt(50),
          ),
        );
      }
      civilians.removeWhere((c) {
        c.life--;
        return c.life <= 0;
      });
      bool jammed = _checkJamSuccess();
      waterfallHistory.insert(0, {
        'tFreq': targetFreqMHz,
        'jFreq': jammerFreqMHz,
        'fFreq': friendlyFreqMHz,
        'civs': civilians.map((c) => c.freq).toList(),
        'jBw': jammingType == 'spot' ? 2.0 : 10.0,
        'jammed': jammed,
        'tx': isTransmitting,
        'silent': isTargetSilent,
      });
      if (waterfallHistory.length > 50) waterfallHistory.removeLast();

      if (t.tick % 5 == 0) {
        if (isTransmitting && !isOverheated && batteryLevel > 0) {
          systemTemp += (jammerPowerWatts / 2000.0) * 3.0;
          batteryLevel -= (jammerPowerWatts / 2000.0) * 0.5;
        } else {
          systemTemp -= 1.0;
        }
        systemTemp = systemTemp.clamp(25.0, 120.0);
        batteryLevel = batteryLevel.clamp(0.0, 100.0);
        if (systemTemp >= 100 && !isOverheated) {
          isOverheated = true;
          isTransmitting = false;
          _addSafeLog("⚠️ เครื่องร้อนจัด!");
        }
        if (isOverheated && systemTemp <= 60) {
          isOverheated = false;
          _addSafeLog("✅ เครื่องเย็นลงแล้ว");
        }
        if (batteryLevel <= 0) {
          isTransmitting = false;
          _addSafeLog("🪫 แบตหมด!");
        }
      }

      if (isTransmitting && jammingTechnique == 'sweep') {
        jammerFreqMHz += sweepDirection * 1.5;
        if (jammerFreqMHz >= 88 || jammerFreqMHz <= 30) sweepDirection *= -1;
        jammerFreqMHz = jammerFreqMHz.clamp(30.0, 88.0);
      }
      if (jammingTechnique == 'pulse' && t.tick % 10 == 0) {
        isTransmitting = !isTransmitting;
      }

      if (isTargetSilent) {
        silentDuration++;
        if (silentDuration > 30) {
          isTargetSilent = false;
          silentDuration = 0;
          _addSafeLog("📡 ข้าศึกกลับมาส่งสัญญาณ");
        }
      } else if (jammed) {
        missionProgress += (difficulty == 'hard' ? 0.002 : 0.005);
        if (missionProgress >= 1.0) {
          missionProgress = 1.0;
          isMissionComplete = true;
          _endGame(true);
        }
        if (isTargetHopping && rng.nextInt(100) < 5) {
          targetFreqMHz = 30.0 + rng.nextInt(50);
          _addSafeLog("⚠️ ข้าศึกหนีความถี่!");
        }
        if (rng.nextInt(100) < 2) {
          isTargetSilent = true;
          _addSafeLog("🚫 ข้าศึกเงียบเสียง");
        }
      }

      activeDecoys.removeWhere((d) {
        d.life--;
        return d.life <= 0;
      });
      if (isTransmitting) {
        detectionRisk += 0.005;
      } else {
        detectionRisk -= 0.01;
      }
      detectionRisk = detectionRisk.clamp(0.0, 1.0);

      if (detectionRisk > 0.8 && !isMissileLocked) {
        isMissileLocked = true;
        _addSafeLog("🚨 ถูกล็อกเป้า!");
      }
      if (detectionRisk <= 0.8) isMissileLocked = false;
      if (detectionRisk >= 1.0 && missilePos == null) {
        missilePos = targetPos;
        _addSafeLog("🚀 ตรวจพบ ARM!");
      }

      if (missilePos != null) {
        Offset targetM = jammerPos;
        bool decoyHit = false;
        if (activeDecoys.isNotEmpty) {
          Decoy d = activeDecoys.reduce(
            (a, b) =>
                (a.position - missilePos!).distance <
                    (b.position - missilePos!).distance
                ? a
                : b,
          );
          targetM = d.position;
          decoyHit = true;
        }
        Offset dir = targetM - missilePos!;
        double dist = dir.distance;
        if (dist < 2.0) {
          if (decoyHit) {
            missilePos = null;
            detectionRisk = 0.0;
            _addSafeLog("💥 เป้าลวงถูกทำลาย");
            activeDecoys.removeWhere(
              (x) => (x.position - targetM).distance < 1,
            );
          } else {
            isMissionFailed = true;
            _endGame(false);
          }
        } else {
          if (isTransmitting || decoyHit) {
            missilePos = missilePos! + (dir * (1.5 / dist));
          } else {
            missilePos = missilePos! + (moveDirection * 1.5);
            if (missilePos!.dx < 0 || missilePos!.dy < 0) missilePos = null;
          }
        }
      }
    });
  }

  void _onAnimationTick() {
    if (!mounted) return;
    setState(() {
      bool isJammed = _checkJamSuccess();
      if (isOverheated) {
        particles.add(
          Particle(
            position:
                jammerPos +
                Offset(
                  (rng.nextDouble() - 0.5) * 2,
                  (rng.nextDouble() - 0.5) * 2,
                ),
            velocity: const Offset(0, -1),
            life: 1.0,
            color: Colors.grey,
            size: 5,
          ),
        );
      }
      if (isJammed)
        for (int i = 0; i < 2; i++) {
          particles.add(
            Particle(
              position: targetPos,
              velocity: Offset(
                (rng.nextDouble() - 0.5) * 2,
                (rng.nextDouble() - 0.5) * 2,
              ),
              life: 0.8,
              color: Colors.cyanAccent,
              size: 3,
            ),
          );
        }
      if (missilePos != null) {
        particles.add(
          Particle(
            position: missilePos!,
            velocity: Offset.zero,
            life: 0.5,
            color: Colors.white,
            size: 3,
          ),
        );
      }
      for (var p in particles) {
        p.position += p.velocity * 0.5;
        p.life -= 0.05;
      }
      particles.removeWhere((p) => p.life <= 0);
    });
  }

  // --- UI Widget ---
  @override
  Widget build(BuildContext context) {
    String azimuthText = isFogOfWar
        ? "???"
        : "${(atan2(targetPos.dy - jammerPos.dy, targetPos.dx - jammerPos.dx) * 180 / pi).toStringAsFixed(0)}°";
    String distText = isFogOfWar
        ? "???"
        : "${(jammerPos - targetPos).distance.toStringAsFixed(1)} กม.";
    bool isJammed = _checkJamSuccess();
    double jsRatio = currentJSRatio;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.isChallengeMode
              ? "แข่งขัน: ${widget.playerName}"
              : "ห้องฝึก (Training Room)",
        ),
        backgroundColor: widget.isChallengeMode
            ? Colors.red[900]
            : const Color(0xFFB71C1C),
        actions: [
          if (!widget.isChallengeMode)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showSettingsDialog,
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetScenario,
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _confirmExit,
          ),
        ],
      ),
      drawer: !widget.isChallengeMode
          ? Drawer(
              backgroundColor: const Color(0xFF263238),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Color(0xFFB71C1C)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.military_tech,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'ศูนย์ควบคุมภารกิจ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  RadioListTile<String>(
                    title: const Text(
                      "Easy (ฝึกหัด)",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'easy',
                    groupValue: difficulty,
                    activeColor: Colors.green,
                    onChanged: (v) => setState(() => difficulty = v!),
                  ),
                  RadioListTile<String>(
                    title: const Text(
                      "Normal (มาตรฐาน)",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'normal',
                    groupValue: difficulty,
                    activeColor: Colors.amber,
                    onChanged: (v) => setState(() => difficulty = v!),
                  ),
                  RadioListTile<String>(
                    title: const Text(
                      "Hard (สมจริง)",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'hard',
                    groupValue: difficulty,
                    activeColor: Colors.red,
                    onChanged: (v) => setState(() => difficulty = v!),
                  ),
                  const Divider(color: Colors.white24),
                  ListTile(
                    leading: const Icon(
                      Icons.backpack,
                      color: Colors.lightBlueAccent,
                    ),
                    title: const Text(
                      'ชุดสะพายหลัง (Manpack)',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _loadEquipmentPreset('manpack'),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.directions_car,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'ชุดติดตั้งบนรถ (Vehicle)',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _loadEquipmentPreset('vehicle'),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.cell_tower,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      'สถานีฐาน (Station)',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _loadEquipmentPreset('station'),
                  ),
                  const Divider(color: Colors.white24),
                  SwitchListTile(
                    secondary: const Icon(Icons.volume_up, color: Colors.green),
                    title: const Text(
                      "เสียงจำลอง",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: isSoundEnabled,
                    activeThumbColor: Colors.green,
                    onChanged: (v) => setState(() => isSoundEnabled = v),
                  ),
                  SwitchListTile(
                    secondary: const Icon(
                      Icons.visibility_off,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      "โหมดสมจริง (Fog of War)",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: isFogOfWar,
                    activeThumbColor: Colors.amber,
                    onChanged: (v) => setState(() => isFogOfWar = v),
                  ),
                ],
              ),
            )
          : null,

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            color: Colors.grey[900],
            child: Row(
              children: [
                const Text(
                  "ภารกิจ:",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: missionProgress,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.greenAccent,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "${(missionProgress * 100).toInt()}%",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
          if (detectionRisk > 0)
            Container(
              color: Colors.black,
              height: 4,
              width: double.infinity,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: detectionRisk,
                child: Container(
                  color: detectionRisk > 0.8 ? Colors.red : Colors.orange,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thermostat,
                      color: isOverheated ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${systemTemp.toInt()}°C",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.battery_std,
                      color: batteryLevel < 20 ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${batteryLevel.toInt()}%",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            flex: 5,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double pxPerKmX = constraints.maxWidth / 100.0;
                double pxPerKmY = constraints.maxHeight / 50.0;
                Offset jPx = Offset(
                  jammerPos.dx * pxPerKmX,
                  jammerPos.dy * pxPerKmY,
                );
                Offset tPx = Offset(
                  targetPos.dx * pxPerKmX,
                  targetPos.dy * pxPerKmY,
                );
                double rangePx = burnThroughRangeKm * pxPerKmX;
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF263238),
                    image: DecorationImage(
                      image: const AssetImage("assets/map.png"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                    border: Border.all(
                      color: isJammed
                          ? Colors.green
                          : Colors.red.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size.infinite,
                        painter: BackgroundGridPainter(),
                      ),
                      CustomPaint(
                        size: Size.infinite,
                        painter: LineOfSight2DPainter(
                          start: jPx,
                          end: tPx,
                          blocked: isLineOfSightBlocked(),
                        ),
                      ),
                      CustomPaint(
                        size: Size.infinite,
                        painter: EffectsPainter(particles: particles),
                      ),
                      if (isJammed)
                        CustomPaint(
                          size: Size.infinite,
                          painter: LightningPainter(start: jPx, end: tPx),
                        ),
                      if (!isOverheated && batteryLevel > 0)
                        (antennaType == 'directional'
                            ? Positioned(
                                left: jPx.dx,
                                top: jPx.dy - rangePx,
                                child: Transform.rotate(
                                  angle: atan2(
                                    targetPos.dy - jammerPos.dy,
                                    targetPos.dx - jammerPos.dx,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: AnimatedBuilder(
                                    animation: _animController,
                                    builder: (c, ch) => CustomPaint(
                                      painter: BeamPainter(
                                        radius: rangePx * 2,
                                        isJammed: isJammed,
                                        animValue: _animController.value,
                                      ),
                                      size: Size(rangePx * 2, rangePx * 2),
                                    ),
                                  ),
                                ),
                              )
                            : Positioned(
                                left: jPx.dx - rangePx,
                                top: jPx.dy - rangePx,
                                child: AnimatedBuilder(
                                  animation: _animController,
                                  builder: (c, ch) => CustomPaint(
                                    painter: OmniCirclePainter(
                                      radius: rangePx,
                                      isJammed: isJammed,
                                      animValue: _animController.value,
                                    ),
                                    size: Size(rangePx * 2, rangePx * 2),
                                  ),
                                ),
                              )),
                      _buildDraggableMarker(
                        "hq",
                        hqPos,
                        Icons.cell_tower,
                        Colors.greenAccent,
                        "HQ",
                        constraints.maxWidth,
                        constraints.maxHeight,
                      ),
                      _buildDraggableMarker(
                        "friendly",
                        friendlyPos,
                        Icons.flag,
                        Colors.green,
                        "ฝ่ายเรา",
                        constraints.maxWidth,
                        constraints.maxHeight,
                      ),
                      if (isObstacleActive)
                        _buildDraggableMarker(
                          "obstacle",
                          obstaclePos,
                          Icons.terrain,
                          Colors.brown,
                          "ภูเขา",
                          constraints.maxWidth,
                          constraints.maxHeight,
                        ),
                      if (isRaining)
                        _buildDraggableMarker(
                          "rain",
                          rainPos,
                          Icons.thunderstorm,
                          Colors.blue,
                          "ฝนตก",
                          constraints.maxWidth,
                          constraints.maxHeight,
                        ),
                      for (var d in activeDecoys)
                        Positioned(
                          left: d.position.dx * pxPerKmX - 15,
                          top: d.position.dy * pxPerKmY - 15,
                          child: const Icon(
                            Icons.leak_add,
                            color: Colors.cyanAccent,
                            size: 30,
                          ),
                        ),
                      if (missilePos != null)
                        Positioned(
                          left: missilePos!.dx * pxPerKmX - 15,
                          top: missilePos!.dy * pxPerKmY - 15,
                          child: Transform.rotate(
                            angle:
                                atan2(
                                  jammerPos.dy - missilePos!.dy,
                                  jammerPos.dx - missilePos!.dx,
                                ) +
                                pi / 4,
                            child: const Icon(
                              Icons.rocket_launch,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ),
                      _buildDraggableMarker(
                        "target",
                        targetPos,
                        _getTargetIcon(isJammed),
                        isJammed
                            ? Colors.grey
                            : (isTargetSilent
                                  ? Colors.grey.withOpacity(0.5)
                                  : Colors.red),
                        "${_getTargetName()}\n$distText\n${isTargetSilent ? 'เงียบ' : targetFreqMHz.toInt()}",
                        constraints.maxWidth,
                        constraints.maxHeight,
                        showBar: true,
                        health: isJammed ? 0.0 : 1.0,
                      ),
                      _buildDraggableMarker(
                        "jammer",
                        jammerPos,
                        _getJammerIcon(),
                        isOverheated ? Colors.red : Colors.lightBlueAccent,
                        "เรา (EW)\n$azimuthText",
                        constraints.maxWidth,
                        constraints.maxHeight,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Expanded(
            flex: 4,
            child: Container(
              color: const Color(0xFF1B1B1B),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                children: [
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: WaterfallPainter(
                              history: waterfallHistory,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 30,
                            color: Colors.black54,
                            child: CustomPaint(
                              size: Size.infinite,
                              painter: RealSpectrumPainter(
                                targetFreq: targetFreqMHz,
                                jammerFreq: jammerFreqMHz,
                                friendlyFreq: friendlyFreqMHz,
                                civilians: civilians,
                                jammerBandwidth: jammingType == 'spot'
                                    ? 2.0
                                    : 10.0,
                                isTransmitting: isTransmitting,
                                isTargetSilent: isTargetSilent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => _toggleTx(!isTransmitting),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isTransmitting
                                  ? (isOverheated ? Colors.grey : Colors.red)
                                  : Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isTransmitting
                                    ? Colors.red
                                    : Colors.green,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                isTransmitting
                                    ? "🔴 ส่งสัญญาณ (TX)"
                                    : "🟢 รับสัญญาณ (RX)",
                                style: TextStyle(
                                  color: isTransmitting
                                      ? Colors.white
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(
                            Icons.leak_add,
                            color: Colors.cyanAccent,
                          ),
                          label: Text(
                            "เป้าลวง ($decoyAmmo)",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: _deployDecoy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "ความถี่รบกวน",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      Text(
                        "${jammerFreqMHz.toInt()} MHz",
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: jammerFreqMHz,
                    min: 30,
                    max: 88,
                    divisions: 58,
                    activeColor: Colors.blueAccent,
                    onChanged: (v) => setState(() => jammerFreqMHz = v),
                  ),
                  DropdownButton<String>(
                    value: jammingTechnique,
                    dropdownColor: Colors.grey[800],
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'continuous',
                        child: Text(
                          "ต่อเนื่อง (Continuous)",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'sweep',
                        child: Text(
                          "กวาดคลื่น (Sweep)",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'pulse',
                        child: Text(
                          "เป็นห้วง (Pulse)",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    onChanged: (v) => _setJammingTechnique(v!),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SwitchListTile(
                          title: const Text(
                            "ข้าศึกหนีคลื่น",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                          value: isTargetHopping,
                          activeThumbColor: Colors.red,
                          dense: true,
                          onChanged: _toggleHopping,
                        ),
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          value: targetType,
                          isExpanded: true,
                          dropdownColor: Colors.grey[800],
                          items: const [
                            DropdownMenuItem(
                              value: 'radio',
                              child: Text(
                                "วิทยุ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'uav',
                              child: Text(
                                "โดรน",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'radar',
                              child: Text(
                                "เรดาร์",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          onChanged: (v) => setState(() => targetType = v!),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isObstacleActive,
                        activeColor: Colors.brown,
                        onChanged: (v) => setState(() => isObstacleActive = v!),
                      ),
                      const Text(
                        "ภูเขา",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Checkbox(
                        value: isRaining,
                        activeColor: Colors.blue,
                        onChanged: (v) => setState(() => isRaining = v!),
                      ),
                      const Text("ฝนตก", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: antennaType,
                          isExpanded: true,
                          dropdownColor: Colors.grey[800],
                          items: const [
                            DropdownMenuItem(
                              value: 'omni',
                              child: Text(
                                "สายอากาศ: รอบทิศ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'directional',
                              child: Text(
                                "สายอากาศ: ทิศทาง",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          onChanged: (v) => setState(() => antennaType = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          value: jammingType,
                          isExpanded: true,
                          dropdownColor: Colors.grey[800],
                          items: const [
                            DropdownMenuItem(
                              value: 'spot',
                              child: Text(
                                "ยิงแบบ: เจาะจง",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'barrage',
                              child: Text(
                                "ยิงแบบ: ปูพรม",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          onChanged: (v) => setState(() => jammingType = v!),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "กำลังส่ง (Power)",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "${jammerPowerWatts.toInt()} วัตต์",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  Slider(
                    value: jammerPowerWatts,
                    min: 10,
                    max: 2000,
                    divisions: 199,
                    activeColor: isOverheated ? Colors.grey : Colors.amber,
                    onChanged: isOverheated
                        ? null
                        : (v) => setState(() => jammerPowerWatts = v),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "อัตราส่วน J/S: ${isJammed ? jsRatio.toStringAsFixed(2) : 'N/A'} dB",
                          style: TextStyle(
                            color: isJammed ? Colors.greenAccent : Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _showAnalysisDialog,
                          child: const Text("วิเคราะห์ผล"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Painters ---
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    Paint p = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1;
    for (int i = 1; i < 10; i++) {
      c.drawLine(
        Offset(s.width / 10 * i, 0),
        Offset(s.width / 10 * i, s.height),
        p,
      );
    }
    for (int i = 1; i < 5; i++) {
      c.drawLine(
        Offset(0, s.height / 5 * i),
        Offset(s.width, s.height / 5 * i),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

class EffectsPainter extends CustomPainter {
  final List<Particle> particles;
  EffectsPainter({required this.particles});
  @override
  void paint(Canvas c, Size s) {
    for (var p in particles) {
      c.drawCircle(
        p.position,
        p.size,
        Paint()..color = p.color.withOpacity(p.life),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => true;
}

class LightningPainter extends CustomPainter {
  final Offset start, end;
  LightningPainter({required this.start, required this.end});
  @override
  void paint(Canvas c, Size s) {
    Paint p = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    Path pa = Path()..moveTo(start.dx, start.dy);
    double d = (end - start).distance;
    int seg = (d / 20).toInt();
    for (int i = 1; i < seg; i++) {
      double t = i / seg;
      Offset pt = Offset.lerp(start, end, t)!;
      pa.lineTo(
        pt.dx + (Random().nextDouble() - 0.5) * 20,
        pt.dy + (Random().nextDouble() - 0.5) * 20,
      );
    }
    pa.lineTo(end.dx, end.dy);
    c.drawPath(pa, p);
    c.drawPath(
      pa,
      Paint()
        ..color = Colors.blue.withOpacity(0.3)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => true;
}

class WaterfallPainter extends CustomPainter {
  final List<Map<String, dynamic>> history;
  WaterfallPainter({required this.history});
  @override
  void paint(Canvas c, Size s) {
    double range = 58.0;
    double freqToX(double f) => ((f - 30.0) / range) * s.width;
    double rowH = s.height / 100;
    for (int i = 0; i < history.length; i++) {
      var d = history[i];
      double y = s.height - (i * rowH) - 30;
      if (y < 0) break;
      if (d['civs'] != null)
        for (double f in d['civs']) {
          c.drawRect(
            Rect.fromCenter(
              center: Offset(freqToX(f), y),
              width: 3,
              height: rowH,
            ),
            Paint()..color = Colors.yellowAccent.withOpacity(1.0 - (i / 100)),
          );
        }
      if (d['silent'] != true) {
        c.drawRect(
          Rect.fromCenter(
            center: Offset(freqToX(d['tFreq']), y),
            width: 3,
            height: rowH,
          ),
          Paint()..color = Colors.redAccent.withOpacity(1.0 - (i / 100)),
        );
      }
      if (d['fFreq'] != null) {
        c.drawRect(
          Rect.fromCenter(
            center: Offset(freqToX(d['fFreq']), y),
            width: 3,
            height: rowH,
          ),
          Paint()..color = Colors.greenAccent.withOpacity(1.0 - (i / 100)),
        );
      }
      if (d['tx'] == true) {
        c.drawRect(
          Rect.fromCenter(
            center: Offset(freqToX(d['jFreq']), y),
            width: (d['jBw'] / range) * s.width,
            height: rowH,
          ),
          Paint()..color = Colors.lightBlueAccent.withOpacity(0.3 - (i / 300)),
        );
      }
      if (d['jammed']) {
        c.drawRect(
          Rect.fromCenter(
            center: Offset(freqToX(d['tFreq']), y),
            width: 4,
            height: rowH,
          ),
          Paint()..color = Colors.greenAccent,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => true;
}

class RealSpectrumPainter extends CustomPainter {
  final double targetFreq, jammerFreq, friendlyFreq, jammerBandwidth;
  final bool isTransmitting, isTargetSilent;
  final List<CivilianSignal> civilians;
  RealSpectrumPainter({
    required this.targetFreq,
    required this.jammerFreq,
    required this.friendlyFreq,
    required this.jammerBandwidth,
    required this.isTransmitting,
    required this.isTargetSilent,
    required this.civilians,
  });
  @override
  void paint(Canvas c, Size s) {
    double range = 58.0;
    double freqToX(double f) => ((f - 30.0) / range) * s.width;
    Paint grid = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1;
    for (double f = 30; f <= 80; f += 10) {
      c.drawLine(Offset(freqToX(f), 0), Offset(freqToX(f), s.height), grid);
    }
    c.drawRect(
      Rect.fromCenter(
        center: Offset(freqToX(friendlyFreq), s.height / 2),
        width: (2 / range) * s.width,
        height: s.height * 0.6,
      ),
      Paint()..color = Colors.greenAccent,
    );
    for (var civ in civilians) {
      c.drawRect(
        Rect.fromCenter(
          center: Offset(freqToX(civ.freq), s.height / 2),
          width: (civ.width / range) * s.width,
          height: s.height * 0.5,
        ),
        Paint()..color = Colors.yellowAccent,
      );
    }
    if (!isTargetSilent) {
      c.drawRect(
        Rect.fromCenter(
          center: Offset(freqToX(targetFreq), s.height / 2),
          width: (2 / range) * s.width,
          height: s.height * 0.8,
        ),
        Paint()
          ..color = isTransmitting
              ? Colors.redAccent.withOpacity(0.2)
              : Colors.redAccent,
      );
    }
    c.drawRect(
      Rect.fromCenter(
        center: Offset(freqToX(jammerFreq), s.height / 2),
        width: (jammerBandwidth / range) * s.width,
        height: s.height,
      ),
      Paint()
        ..color = Colors.lightBlueAccent.withOpacity(
          isTransmitting ? 0.8 : 0.3,
        ),
    );
    c.drawRect(
      Rect.fromCenter(
        center: Offset(freqToX(jammerFreq), s.height / 2),
        width: (jammerBandwidth / range) * s.width,
        height: s.height,
      ),
      Paint()
        ..color = Colors.lightBlueAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => true;
}

class BackgroundGridPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    Paint p = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    double w = s.width / 10, h = s.height / 5;
    for (int i = 1; i <= 9; i++) {
      c.drawLine(Offset(i * w, 0), Offset(i * w, s.height), p);
    }
    for (int i = 1; i <= 4; i++) {
      c.drawLine(Offset(0, i * h), Offset(s.width, i * h), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

class LineOfSight2DPainter extends CustomPainter {
  final Offset start, end;
  final bool blocked;
  LineOfSight2DPainter({
    required this.start,
    required this.end,
    required this.blocked,
  });
  @override
  void paint(Canvas c, Size s) {
    c.drawLine(
      start,
      end,
      Paint()
        ..color = blocked
            ? Colors.red.withOpacity(0.5)
            : Colors.green.withOpacity(0.3)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => true;
}

class OmniCirclePainter extends CustomPainter {
  final double radius;
  final bool isJammed;
  final double animValue;
  OmniCirclePainter({
    required this.radius,
    required this.isJammed,
    required this.animValue,
  });
  @override
  void paint(Canvas c, Size s) {
    Offset center = Offset(s.width / 2, s.height / 2);
    c.drawCircle(
      center,
      radius,
      Paint()..color = Colors.redAccent.withOpacity(0.15),
    );
    c.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.redAccent.withOpacity(0.6)
        ..style = PaintingStyle.stroke,
    );
    double r = radius * animValue;
    if (r < radius) {
      c.drawCircle(
        center,
        r,
        Paint()
          ..color = Colors.redAccent.withOpacity(1.0 - animValue)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => true;
}

class BeamPainter extends CustomPainter {
  final double radius;
  final bool isJammed;
  final double animValue;
  BeamPainter({
    required this.radius,
    required this.isJammed,
    required this.animValue,
  });
  @override
  void paint(Canvas c, Size s) {
    Offset center = Offset(0, s.height / 2);
    Rect rect = Rect.fromCircle(center: center, radius: radius);
    c.drawArc(
      rect,
      -pi / 6,
      pi / 3,
      true,
      Paint()..color = Colors.redAccent.withOpacity(0.2),
    );
    c.drawArc(
      rect,
      -pi / 6,
      pi / 3,
      true,
      Paint()
        ..color = Colors.redAccent.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    double r = radius * animValue;
    if (r < radius) {
      c.drawArc(
        Rect.fromCircle(center: center, radius: r),
        -pi / 6,
        pi / 3,
        false,
        Paint()
          ..color = Colors.redAccent.withOpacity(1.0 - animValue)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => true;
}
