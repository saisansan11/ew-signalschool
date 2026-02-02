import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/constants.dart';

class DroneFieldScreen extends StatefulWidget {
  const DroneFieldScreen({super.key});

  @override
  State<DroneFieldScreen> createState() => _DroneFieldScreenState();
}

class _DroneFieldScreenState extends State<DroneFieldScreen>
    with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _pulseController;
  late AnimationController _killChainController;

  int _currentKillChainStep = 0;
  bool _isEmergencyMode = false;

  // Drone types data
  final List<DroneType> _droneTypes = [
    DroneType(
      name: 'FPV Kamikaze',
      icon: Icons.flight,
      color: const Color(0xFFFF4444),
      frequencies: ['2.4 GHz', '5.8 GHz'],
      range: '5-10 km',
      threat: 'สูงมาก',
      description: 'โดรนโจมตีแบบพุ่งชน ควบคุมผ่าน FPV',
      characteristics: [
        'ความเร็วสูง 100-150 km/h',
        'บรรทุกวัตถุระเบิด 0.5-3 kg',
        'เวลาบินจำกัด 10-20 นาที',
        'ยากต่อการตรวจจับด้วยเรดาร์',
      ],
    ),
    DroneType(
      name: 'Reconnaissance',
      icon: Icons.visibility,
      color: const Color(0xFF4CAF50),
      frequencies: ['2.4 GHz', '5.8 GHz', '4G LTE'],
      range: '10-50 km',
      threat: 'ปานกลาง',
      description: 'โดรนลาดตระเวน/ISR เก็บข้อมูล',
      characteristics: [
        'กล้องความละเอียดสูง',
        'บินนาน 30-90 นาที',
        'ระดับความสูง 100-500m',
        'ส่งข้อมูลแบบ Real-time',
      ],
    ),
    DroneType(
      name: 'Commercial (DJI)',
      icon: Icons.camera_alt,
      color: const Color(0xFF2196F3),
      frequencies: ['2.4 GHz', '5.8 GHz', 'OcuSync'],
      range: '5-15 km',
      threat: 'ปานกลาง',
      description: 'โดรนพาณิชย์ดัดแปลงใช้ในสงคราม',
      characteristics: [
        'DJI Mavic, Phantom, Matrice',
        'ง่ายต่อการดัดแปลง',
        'หาอะไหล่ได้ง่าย',
        'มีระบบ Return-to-Home',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _killChainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _killChainController.addListener(() {
      final step = (_killChainController.value * 5).floor();
      if (step != _currentKillChainStep && step < 5) {
        setState(() => _currentKillChainStep = step);
      }
    });
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pulseController.dispose();
    _killChainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: _isEmergencyMode ? AppColors.danger : const Color(0xFF1A237E),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Icon(
                  Icons.flight,
                  size: 24,
                  color: _isEmergencyMode
                    ? Colors.white.withValues(alpha: 0.7 + _pulseController.value * 0.3)
                    : Colors.white,
                );
              },
            ),
            const SizedBox(width: 8),
            const Text('ANTI-DRONE OPS', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEmergencyMode ? Icons.warning : Icons.shield),
            onPressed: () => setState(() => _isEmergencyMode = !_isEmergencyMode),
            tooltip: 'Emergency Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEmergencyMode) _buildEmergencyPanel(),
            if (!_isEmergencyMode) ...[
              _buildRadarSection(),
              const SizedBox(height: 24),
              _buildKillChainSection(),
              const SizedBox(height: 24),
              _buildFrequencySpectrum(),
              const SizedBox(height: 24),
              _buildDroneTypesSection(),
              const SizedBox(height: 24),
              _buildDetectionMethods(),
              const SizedBox(height: 24),
              _buildCountermeasures(),
              const SizedBox(height: 24),
              _buildTacticalProcedures(),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _isEmergencyMode = !_isEmergencyMode),
        backgroundColor: _isEmergencyMode ? AppColors.success : AppColors.danger,
        icon: Icon(_isEmergencyMode ? Icons.check : Icons.warning),
        label: Text(_isEmergencyMode ? 'ปลอดภัย' : 'พบโดรน!'),
      ),
    );
  }

  Widget _buildEmergencyPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.danger.withValues(alpha: 0.3),
            AppColors.danger.withValues(alpha: 0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger, width: 2),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + _pulseController.value * 0.1,
                child: const Icon(
                  Icons.warning_amber,
                  color: AppColors.danger,
                  size: 64,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'พบโดรนข้าศึก!',
            style: TextStyle(
              color: AppColors.danger,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildEmergencyStep(1, 'หาที่กำบัง', 'หลบเข้าใต้หลังคา/ต้นไม้ทันที', Icons.home),
          _buildEmergencyStep(2, 'หยุดส่งสัญญาณ', 'ปิดวิทยุ/โทรศัพท์ - ลดการแพร่ RF', Icons.signal_wifi_off),
          _buildEmergencyStep(3, 'สังเกตทิศทาง', 'จดจำทิศทางบินและลักษณะโดรน', Icons.visibility),
          _buildEmergencyStep(4, 'รายงาน', 'แจ้ง ผบ.หน่วย ทันทีที่ปลอดภัย', Icons.campaign),
          _buildEmergencyStep(5, 'อย่ายิง!', 'ห้ามยิงโดรนด้วยอาวุธปืน (เว้นแต่ได้รับคำสั่ง)', Icons.do_not_disturb),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: AppColors.warning),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'โดรน FPV อาจเป็นโดรนโจมตี!\nอย่าออกจากที่กำบังจนกว่าจะแน่ใจว่าปลอดภัย',
                    style: TextStyle(color: AppColors.warning, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyStep(int num, String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.danger,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$num',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: AppColors.danger, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B263B)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.radar, color: Color(0xFF00FF88), size: 24),
              SizedBox(width: 8),
              Text(
                'DRONE DETECTION RADAR',
                style: TextStyle(
                  color: Color(0xFF00FF88),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: AnimatedBuilder(
              animation: _radarController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(200, 200),
                  painter: RadarPainter(
                    sweepAngle: _radarController.value * 2 * math.pi,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRadarStatus('RF Signal', 'Active', const Color(0xFF00FF88)),
              _buildRadarStatus('GPS Jam', 'Ready', const Color(0xFFFFAA00)),
              _buildRadarStatus('Acoustic', 'Active', const Color(0xFF00FF88)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadarStatus(String label, String status, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        Text(
          status,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildKillChainSection() {
    final steps = [
      KillChainStep('DETECT', Icons.sensors, 'ตรวจจับ', 'RF/Radar/Acoustic'),
      KillChainStep('TRACK', Icons.gps_fixed, 'ติดตาม', 'ระบุตำแหน่ง/ทิศทาง'),
      KillChainStep('IDENTIFY', Icons.search, 'ระบุ', 'ชนิด/ภัยคุกคาม'),
      KillChainStep('DECIDE', Icons.psychology, 'ตัดสินใจ', 'เลือกมาตรการ'),
      KillChainStep('NEUTRALIZE', Icons.block, 'ทำลาย', 'Jam/Spoof/Kinetic'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A237E).withValues(alpha: 0.5),
            const Color(0xFF0D47A1).withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3949AB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline, color: Colors.cyan, size: 24),
              SizedBox(width: 8),
              Text(
                'C-UAS KILL CHAIN',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              children: List.generate(steps.length, (index) {
                final isActive = index <= _currentKillChainStep;
                final isCurrent = index == _currentKillChainStep;
                return Expanded(
                  child: _buildKillChainStepWidget(
                    steps[index],
                    isActive,
                    isCurrent,
                    index < steps.length - 1,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKillChainStepWidget(
    KillChainStep step,
    bool isActive,
    bool isCurrent,
    bool showArrow,
  ) {
    final color = isActive ? Colors.cyan : Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isCurrent ? 56 : 48,
          height: isCurrent ? 56 : 48,
          decoration: BoxDecoration(
            color: isActive ? color.withValues(alpha: 0.3) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: isCurrent ? 3 : 2,
            ),
            boxShadow: isCurrent
                ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 12)]
                : null,
          ),
          child: Icon(step.icon, color: color, size: isCurrent ? 28 : 24),
        ),
        const SizedBox(height: 8),
        Text(
          step.name,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          step.thai,
          style: TextStyle(
            color: color.withValues(alpha: 0.7),
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencySpectrum() {
    final frequencies = [
      FrequencyBand('433 MHz', 'Control (LR)', 0.1, const Color(0xFF9C27B0)),
      FrequencyBand('900 MHz', 'Control', 0.15, const Color(0xFF673AB7)),
      FrequencyBand('1.2 GHz', 'Video', 0.2, const Color(0xFF3F51B5)),
      FrequencyBand('1.575 GHz', 'GPS L1', 0.25, const Color(0xFFE91E63)),
      FrequencyBand('2.4 GHz', 'Control/WiFi', 0.5, const Color(0xFF2196F3)),
      FrequencyBand('5.8 GHz', 'Video HD', 0.65, const Color(0xFF00BCD4)),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
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
              Icon(Icons.waves, color: Color(0xFFFF9800), size: 24),
              SizedBox(width: 8),
              Text(
                'DRONE FREQUENCY SPECTRUM',
                style: TextStyle(
                  color: Color(0xFFFF9800),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'ความถี่ที่โดรนใช้งาน - เป้าหมายสำหรับ RF Jamming',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 20),
          ...frequencies.map((freq) => _buildFrequencyBar(freq)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.priority_high, color: AppColors.danger, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'GPS L1 (1575.42 MHz) - จุดอ่อนสำคัญของโดรน\nการ Jam/Spoof GPS ทำให้โดรนหลงทาง หรือ Return-to-Home ผิดพลาด',
                    style: TextStyle(color: AppColors.danger, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyBar(FrequencyBand freq) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              freq.name,
              style: TextStyle(
                color: freq.color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: freq.power + (_pulseController.value * 0.05),
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [freq.color, freq.color.withValues(alpha: 0.5)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: freq.color.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: Text(
              freq.usage,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDroneTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.category, color: Colors.purple, size: 24),
            SizedBox(width: 8),
            Text(
              'DRONE TYPES & THREATS',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._droneTypes.map((drone) => _buildDroneTypeCard(drone)),
      ],
    );
  }

  Widget _buildDroneTypeCard(DroneType drone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: drone.color.withValues(alpha: 0.5)),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: drone.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(drone.icon, color: drone.color, size: 24),
        ),
        title: Text(
          drone.name,
          style: TextStyle(
            color: drone.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getThreatColor(drone.threat).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ภัยคุกคาม: ${drone.threat}',
                style: TextStyle(
                  color: _getThreatColor(drone.threat),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        iconColor: drone.color,
        collapsedIconColor: drone.color,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drone.description,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: drone.frequencies.map((f) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: drone.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(color: drone.color, fontSize: 12),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                const Text(
                  'ลักษณะเฉพาะ:',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                ...drone.characteristics.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_right, color: drone.color, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          c,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.speed, color: AppColors.textMuted, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'ระยะทำการ: ${drone.range}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getThreatColor(String threat) {
    switch (threat) {
      case 'สูงมาก':
        return AppColors.danger;
      case 'สูง':
        return const Color(0xFFFF9800);
      case 'ปานกลาง':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  Widget _buildDetectionMethods() {
    final methods = [
      DetectionMethod(
        name: 'RF Detection',
        thai: 'ตรวจจับคลื่นวิทยุ',
        icon: Icons.wifi_tethering,
        color: const Color(0xFF00BCD4),
        description: 'ตรวจจับสัญญาณ 2.4/5.8 GHz ที่โดรนใช้สื่อสาร',
        pros: ['Passive - ไม่เปิดเผยตำแหน่ง', 'ระยะไกล 5-10 km'],
        cons: ['ไม่ได้ผลกับโดรนอัตโนมัติ'],
        range: '5-10 km',
      ),
      DetectionMethod(
        name: 'Radar',
        thai: 'เรดาร์',
        icon: Icons.radar,
        color: const Color(0xFF4CAF50),
        description: 'ใช้คลื่นเรดาร์ตรวจจับวัตถุบินขนาดเล็ก',
        pros: ['แม่นยำ', 'ระบุตำแหน่ง 3D'],
        cons: ['Active - เปิดเผยตำแหน่ง', 'โดรนเล็กตรวจยาก'],
        range: '3-5 km',
      ),
      DetectionMethod(
        name: 'Acoustic',
        thai: 'เสียง',
        icon: Icons.hearing,
        color: const Color(0xFF9C27B0),
        description: 'ใช้ไมโครโฟนตรวจจับเสียงใบพัดโดรน',
        pros: ['Passive', 'ราคาถูก'],
        cons: ['ระยะสั้น', 'รบกวนจากเสียงรอบข้าง'],
        range: '300-500 m',
      ),
      DetectionMethod(
        name: 'EO/IR',
        thai: 'กล้อง/อินฟราเรด',
        icon: Icons.camera,
        color: const Color(0xFFFF9800),
        description: 'กล้องความละเอียดสูงและอินฟราเรด',
        pros: ['ยืนยันด้วยภาพ', 'ใช้กลางคืนได้'],
        cons: ['ต้องรู้ทิศทางก่อน', 'สภาพอากาศมีผล'],
        range: '1-3 km',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
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
              Icon(Icons.sensors, color: Color(0xFF00BCD4), size: 24),
              SizedBox(width: 8),
              Text(
                'DETECTION METHODS',
                style: TextStyle(
                  color: Color(0xFF00BCD4),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5,
            children: methods.map((m) => _buildDetectionCard(m)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionCard(DetectionMethod method) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: method.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: method.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(method.icon, color: method.color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: TextStyle(
                        color: method.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      method.thai,
                      style: TextStyle(
                        color: method.color.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            method.description,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: method.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'ระยะ: ${method.range}',
              style: TextStyle(color: method.color, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountermeasures() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.danger.withValues(alpha: 0.2),
            AppColors.danger.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.security, color: AppColors.danger, size: 24),
              SizedBox(width: 8),
              Text(
                'COUNTERMEASURES',
                style: TextStyle(
                  color: AppColors.danger,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'มาตรการต่อต้านโดรน (เรียงตามลำดับความปลอดภัย)',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          _buildCountermeasureItem(
            1,
            'RF Jamming',
            'รบกวนสัญญาณควบคุม 2.4/5.8 GHz',
            'โดรนจะเข้าสู่โหมด Failsafe (ลงจอด/บินกลับ)',
            Icons.wifi_off,
            const Color(0xFF2196F3),
          ),
          _buildCountermeasureItem(
            2,
            'GPS Jamming',
            'รบกวนสัญญาณ GPS L1/L2',
            'โดรนไม่สามารถนำทางได้ อาจหลงทาง',
            Icons.gps_off,
            const Color(0xFF9C27B0),
          ),
          _buildCountermeasureItem(
            3,
            'GPS Spoofing',
            'ส่งสัญญาณ GPS ปลอม',
            'หลอกให้โดรนบินไปตำแหน่งที่ต้องการ',
            Icons.gps_not_fixed,
            const Color(0xFFFF9800),
          ),
          _buildCountermeasureItem(
            4,
            'Protocol Takeover',
            'เจาะระบบควบคุมโดรน',
            'ยึดการควบคุมจากผู้บังคับ',
            Icons.phonelink_lock,
            const Color(0xFF00BCD4),
          ),
          _buildCountermeasureItem(
            5,
            'Kinetic',
            'ทำลายด้วยอาวุธ',
            'ใช้เมื่อไม่มีทางเลือกอื่น (มีความเสี่ยง)',
            Icons.gps_fixed,
            AppColors.danger,
          ),
        ],
      ),
    );
  }

  Widget _buildCountermeasureItem(
    int num,
    String title,
    String desc,
    String effect,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$num',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.arrow_forward, color: AppColors.success, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        effect,
                        style: const TextStyle(color: AppColors.success, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTacticalProcedures() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B5E20).withValues(alpha: 0.3),
            const Color(0xFF1B5E20).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.assignment, color: AppColors.success, size: 24),
              SizedBox(width: 8),
              Text(
                'TACTICAL PROCEDURES',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'ขั้นตอนปฏิบัติเมื่อพบโดรนข้าศึกในสนามรบ',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          _buildTacticalStep(
            '5S Protocol',
            [
              'SPOT - มองเห็น/ได้ยินโดรน',
              'SEEK - หาที่กำบังทันที',
              'SILENCE - ปิดอุปกรณ์สื่อสาร',
              'STAND STILL - อย่าเคลื่อนไหว',
              'SIGNAL - รายงานเมื่อปลอดภัย',
            ],
            Icons.list_alt,
            AppColors.primary,
          ),
          const SizedBox(height: 16),
          _buildTacticalStep(
            'ระยะปลอดภัย',
            [
              'FPV Drone: > 100 เมตร (อาจมีวัตถุระเบิด)',
              'Recon Drone: > 50 เมตร (ถ่ายภาพได้)',
              'ห้ามชี้หรือยิงใส่โดรน (ยกเว้นได้รับคำสั่ง)',
              'พรางตัวภายใต้ร่มเงา/หลังคา',
            ],
            Icons.social_distance,
            AppColors.warning,
          ),
          const SizedBox(height: 16),
          _buildTacticalStep(
            'การรายงาน',
            [
              'SALUTE: Size, Activity, Location, Unit, Time, Equipment',
              'จำนวน/ชนิดโดรน',
              'ทิศทางบินและความเร็ว',
              'ความสูงโดยประมาณ',
              'พฤติกรรม (วนเวียน/บินผ่าน/หยุดนิ่ง)',
            ],
            Icons.report,
            const Color(0xFF00BCD4),
          ),
        ],
      ),
    );
  }

  Widget _buildTacticalStep(
    String title,
    List<String> steps,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// Custom Radar Painter
class RadarPainter extends CustomPainter {
  final double sweepAngle;

  RadarPainter({required this.sweepAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw grid circles
    final gridPaint = Paint()
      ..color = const Color(0xFF00FF88).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4, gridPaint);
    }

    // Draw cross lines
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      gridPaint,
    );

    // Draw sweep
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: sweepAngle - 0.5,
        endAngle: sweepAngle,
        colors: [
          Colors.transparent,
          const Color(0xFF00FF88).withValues(alpha: 0.5),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sweepPaint);

    // Draw sweep line
    final linePaint = Paint()
      ..color = const Color(0xFF00FF88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final endX = center.dx + radius * math.cos(sweepAngle - math.pi / 2);
    final endY = center.dy + radius * math.sin(sweepAngle - math.pi / 2);
    canvas.drawLine(center, Offset(endX, endY), linePaint);

    // Draw center dot
    final centerPaint = Paint()
      ..color = const Color(0xFF00FF88)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, centerPaint);

    // Draw some blips (simulated targets)
    final blipPaint = Paint()
      ..color = const Color(0xFF00FF88)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    for (int i = 0; i < 3; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final dist = random.nextDouble() * radius * 0.8 + radius * 0.1;
      final blipX = center.dx + dist * math.cos(angle);
      final blipY = center.dy + dist * math.sin(angle);

      // Only show blip if sweep has passed it recently
      final angleDiff = (sweepAngle - angle) % (2 * math.pi);
      if (angleDiff < 0.5 && angleDiff > 0) {
        canvas.drawCircle(Offset(blipX, blipY), 4, blipPaint);
      }
    }
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) => sweepAngle != oldDelegate.sweepAngle;
}

// Data classes
class DroneType {
  final String name;
  final IconData icon;
  final Color color;
  final List<String> frequencies;
  final String range;
  final String threat;
  final String description;
  final List<String> characteristics;

  DroneType({
    required this.name,
    required this.icon,
    required this.color,
    required this.frequencies,
    required this.range,
    required this.threat,
    required this.description,
    required this.characteristics,
  });
}

class KillChainStep {
  final String name;
  final IconData icon;
  final String thai;
  final String description;

  KillChainStep(this.name, this.icon, this.thai, this.description);
}

class FrequencyBand {
  final String name;
  final String usage;
  final double power;
  final Color color;

  FrequencyBand(this.name, this.usage, this.power, this.color);
}

class DetectionMethod {
  final String name;
  final String thai;
  final IconData icon;
  final Color color;
  final String description;
  final List<String> pros;
  final List<String> cons;
  final String range;

  DetectionMethod({
    required this.name,
    required this.thai,
    required this.icon,
    required this.color,
    required this.description,
    required this.pros,
    required this.cons,
    required this.range,
  });
}
