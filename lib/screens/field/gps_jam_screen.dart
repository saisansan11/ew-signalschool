import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/constants.dart';

class GpsJamScreen extends StatefulWidget {
  const GpsJamScreen({super.key});

  @override
  State<GpsJamScreen> createState() => _GpsJamScreenState();
}

class _GpsJamScreenState extends State<GpsJamScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _signalController;
  int _currentStep = 0;
  bool _isEmergencyMode = true;

  final List<EmergencyStep> _immediateSteps = [
    EmergencyStep(
      number: 1,
      title: 'หยุด! อย่าตื่นตระหนก',
      description: 'หยุดการเคลื่อนที่ทันที ประเมินสถานการณ์',
      icon: Icons.pan_tool,
      color: const Color(0xFFFF5252),
      details: [
        'หยุดยานพาหนะในจุดที่ปลอดภัย',
        'ไม่เปลี่ยนเส้นทางทันที',
        'สังเกตสภาพแวดล้อมรอบตัว',
      ],
    ),
    EmergencyStep(
      number: 2,
      title: 'ยืนยันว่าถูก Jam จริง',
      description: 'ตรวจสอบอาการของ GPS Jamming',
      icon: Icons.fact_check,
      color: const Color(0xFFFF9800),
      details: [
        'GPS แสดงตำแหน่งผิด/กระโดด',
        'สัญญาณ GPS หายไปกะทันหัน',
        'Accuracy ต่ำลงมาก (>100m)',
        'Time sync ผิดพลาด',
      ],
    ),
    EmergencyStep(
      number: 3,
      title: 'เปลี่ยนไปใช้การนำทางสำรอง',
      description: 'ใช้วิธีการนำทางแบบดั้งเดิม',
      icon: Icons.explore,
      color: const Color(0xFF4CAF50),
      details: [
        'ใช้แผนที่กระดาษ + เข็มทิศ',
        'จดจำจุดสังเกต (Landmark)',
        'ใช้ Dead Reckoning (คำนวณระยะ/ทิศทาง)',
        'ติดต่อหน่วยข้างเคียงขอพิกัด',
      ],
    ),
    EmergencyStep(
      number: 4,
      title: 'รายงานตามสายการบังคับบัญชา',
      description: 'แจ้งเหตุ GPS Jamming',
      icon: Icons.campaign,
      color: const Color(0xFF2196F3),
      details: [
        'รายงาน: พิกัดโดยประมาณ',
        'เวลาที่เริ่มถูก Jam',
        'ความรุนแรง (สูญเสียทั้งหมด/บางส่วน)',
        'ทิศทางที่คาดว่าเป็นแหล่ง Jam',
      ],
    ),
    EmergencyStep(
      number: 5,
      title: 'ปฏิบัติตามแผนฉุกเฉิน',
      description: 'ดำเนินการตาม SOP หน่วย',
      icon: Icons.assignment_turned_in,
      color: const Color(0xFF9C27B0),
      details: [
        'Rally Point ที่กำหนดไว้ล่วงหน้า',
        'ใช้ PACE Plan (Primary, Alternate, Contingency, Emergency)',
        'รอคำสั่งจาก ผบ.หน่วย',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _signalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _signalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.danger,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.gps_off, size: 24),
            SizedBox(width: 8),
            Text('GPS JAMMING', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEmergencyMode ? Icons.warning : Icons.menu_book),
            onPressed: () =>
                setState(() => _isEmergencyMode = !_isEmergencyMode),
            tooltip: _isEmergencyMode ? 'Study Mode' : 'Emergency Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEmergencyMode) _buildEmergencyHeader(),
            const SizedBox(height: 20),
            _buildGpsStatusVisualization(),
            const SizedBox(height: 24),
            _buildImmediateActions(),
            const SizedBox(height: 24),
            _buildNavigationAlternatives(),
            const SizedBox(height: 24),
            _buildJammingIndicators(),
            const SizedBox(height: 24),
            _buildTechnicalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyHeader() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.danger.withValues(
                  alpha: 0.3 + _pulseController.value * 0.2,
                ),
                AppColors.danger.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.danger, width: 2),
          ),
          child: Row(
            children: [
              Transform.scale(
                scale: 1.0 + _pulseController.value * 0.2,
                child: const Icon(
                  Icons.warning_amber,
                  color: AppColors.danger,
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GPS SIGNAL LOST',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ปฏิบัติตามขั้นตอนด้านล่างทันที',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGpsStatusVisualization() {
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
              Icon(Icons.satellite_alt, color: Color(0xFFFF5252), size: 24),
              SizedBox(width: 8),
              Text(
                'GPS SATELLITE STATUS',
                style: TextStyle(
                  color: Color(0xFFFF5252),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: AnimatedBuilder(
              animation: _signalController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 150),
                  painter: GpsSignalPainter(
                    progress: _signalController.value,
                    isJammed: true,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSatelliteStatus('GPS L1', 'JAMMED', AppColors.danger),
              _buildSatelliteStatus('GPS L2', 'JAMMED', AppColors.danger),
              _buildSatelliteStatus('GLONASS', 'WEAK', AppColors.warning),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSatelliteStatus(String name, String status, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildImmediateActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.flash_on, color: AppColors.warning, size: 24),
            SizedBox(width: 8),
            Text(
              'IMMEDIATE ACTIONS',
              style: TextStyle(
                color: AppColors.warning,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._immediateSteps.asMap().entries.map((entry) {
          final step = entry.value;
          final isActive = entry.key <= _currentStep;
          return _buildStepCard(step, isActive, () {
            setState(() => _currentStep = entry.key);
          });
        }),
      ],
    );
  }

  Widget _buildStepCard(EmergencyStep step, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive
              ? step.color.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? step.color : AppColors.border,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: step.color.withValues(alpha: isActive ? 0.3 : 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${step.number}',
                      style: TextStyle(
                        color: step.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(step.icon, color: step.color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          color: isActive ? step.color : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        step.description,
                        style: TextStyle(
                          color: isActive
                              ? step.color.withValues(alpha: 0.8)
                              : AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isActive ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isActive ? step.color : AppColors.textMuted,
                ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 12),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              ...step.details.map(
                (detail) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_right, color: step.color, size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          detail,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationAlternatives() {
    final alternatives = [
      NavigationMethod(
        name: 'แผนที่ + เข็มทิศ',
        icon: Icons.explore,
        accuracy: 'สูง',
        requirement: 'ต้องฝึกใช้งาน',
        color: const Color(0xFF4CAF50),
      ),
      NavigationMethod(
        name: 'Dead Reckoning',
        icon: Icons.speed,
        accuracy: 'ปานกลาง',
        requirement: 'บันทึกระยะ/เวลา',
        color: const Color(0xFF2196F3),
      ),
      NavigationMethod(
        name: 'จุดสังเกต (Landmarks)',
        icon: Icons.landscape,
        accuracy: 'ต่ำ-ปานกลาง',
        requirement: 'รู้จักพื้นที่',
        color: const Color(0xFFFF9800),
      ),
      NavigationMethod(
        name: 'ติดต่อหน่วยข้างเคียง',
        icon: Icons.groups,
        accuracy: 'สูง',
        requirement: 'มีการสื่อสาร',
        color: const Color(0xFF9C27B0),
      ),
    ];

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
              Icon(Icons.alt_route, color: AppColors.success, size: 24),
              SizedBox(width: 8),
              Text(
                'NAVIGATION ALTERNATIVES',
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
            'วิธีการนำทางเมื่อไม่มี GPS',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5,
            children: alternatives
                .map((alt) => _buildAlternativeCard(alt))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeCard(NavigationMethod method) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: method.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(method.icon, color: method.color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  method.name,
                  style: TextStyle(
                    color: method.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                Text(
                  method.accuracy,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJammingIndicators() {
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
              Icon(Icons.bug_report, color: Color(0xFFFF9800), size: 24),
              SizedBox(width: 8),
              Text(
                'อาการที่บ่งบอกว่าถูก GPS JAM',
                style: TextStyle(
                  color: Color(0xFFFF9800),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildIndicatorItem(
            'ตำแหน่งกระโดดผิดปกติ (>100m)',
            Icons.location_off,
          ),
          _buildIndicatorItem('Accuracy ลดลงกะทันหัน', Icons.gps_not_fixed),
          _buildIndicatorItem('เวลาบนอุปกรณ์ผิดพลาด', Icons.access_time),
          _buildIndicatorItem(
            'สูญเสียสัญญาณทั้งหมดทันที',
            Icons.signal_cellular_off,
          ),
          _buildIndicatorItem(
            'Heading/Direction ผิดพลาด',
            Icons.compass_calibration,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'หากมีอาการหลายอย่างพร้อมกัน มีโอกาสสูงที่ถูก Jam\nหากเกิดกับอุปกรณ์เดียว อาจเป็นปัญหาอุปกรณ์',
                    style: TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: AppColors.danger, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalInfo() {
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
              Icon(Icons.science, color: Color(0xFF00BCD4), size: 24),
              SizedBox(width: 8),
              Text(
                'ข้อมูลทางเทคนิค',
                style: TextStyle(
                  color: Color(0xFF00BCD4),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTechRow('GPS L1 Frequency', '1575.42 MHz'),
          _buildTechRow('GPS L2 Frequency', '1227.60 MHz'),
          _buildTechRow('GPS Signal Power', '-130 dBm (อ่อนมาก)'),
          _buildTechRow('Jamming Range', '10-50 km (ขึ้นกับกำลังส่ง)'),
          _buildTechRow('Typical Jammer Power', '1-100 Watts'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, color: AppColors.warning, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'GPS Signal อ่อนมาก (-130 dBm) จึงถูก Jam ได้ง่าย\nJammer กำลังต่ำสามารถรบกวนได้ระยะไกล',
                    style: TextStyle(color: AppColors.warning, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for GPS Signal Visualization
class GpsSignalPainter extends CustomPainter {
  final double progress;
  final bool isJammed;

  GpsSignalPainter({required this.progress, required this.isJammed});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw satellite constellation
    final satellites = [
      Offset(centerX - 60, centerY - 40),
      Offset(centerX + 60, centerY - 40),
      Offset(centerX - 80, centerY + 20),
      Offset(centerX + 80, centerY + 20),
      Offset(centerX, centerY - 60),
    ];

    final random = math.Random(42);

    for (int i = 0; i < satellites.length; i++) {
      final sat = satellites[i];

      // Satellite icon
      final satPaint = Paint()
        ..color = isJammed
            ? const Color(
                0xFFFF5252,
              ).withValues(alpha: 0.3 + random.nextDouble() * 0.3)
            : const Color(0xFF4CAF50);

      canvas.drawCircle(sat, 8, satPaint);

      // Signal lines (disrupted if jammed)
      final linePaint = Paint()
        ..color = isJammed
            ? const Color(0xFFFF5252).withValues(alpha: 0.3)
            : const Color(0xFF4CAF50).withValues(alpha: 0.5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      if (isJammed) {
        // Disrupted signal - dashed line
        final path = Path();
        final receiver = Offset(centerX, size.height - 20);

        const dashWidth = 5.0;
        const dashSpace = 5.0;
        var distance = 0.0;
        final totalDistance = (receiver - sat).distance;

        while (distance < totalDistance) {
          final start = Offset.lerp(sat, receiver, distance / totalDistance)!;
          final end = Offset.lerp(
            sat,
            receiver,
            (distance + dashWidth) / totalDistance,
          )!;
          path.moveTo(start.dx, start.dy);
          path.lineTo(end.dx, end.dy);
          distance += dashWidth + dashSpace;
        }

        canvas.drawPath(path, linePaint);
      } else {
        canvas.drawLine(sat, Offset(centerX, size.height - 20), linePaint);
      }
    }

    // Draw receiver
    final receiverPaint = Paint()
      ..color = isJammed ? const Color(0xFFFF5252) : const Color(0xFF4CAF50);

    canvas.drawCircle(Offset(centerX, size.height - 20), 12, receiverPaint);

    // Draw jammer symbol if jammed
    if (isJammed) {
      final jammerPaint = Paint()
        ..color = const Color(0xFFFF5252)
        ..style = PaintingStyle.fill;

      // Jammer waves
      for (int i = 1; i <= 3; i++) {
        final wavePaint = Paint()
          ..color = const Color(0xFFFF5252).withValues(alpha: 0.3 - i * 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        final waveProgress = (progress + i * 0.2) % 1.0;
        canvas.drawCircle(
          Offset(size.width - 40, centerY),
          10 + waveProgress * 30,
          wavePaint,
        );
      }

      canvas.drawCircle(Offset(size.width - 40, centerY), 10, jammerPaint);

      // Jammer icon
      final textPainter = TextPainter(
        text: const TextSpan(text: '⚡', style: TextStyle(fontSize: 12)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.width - 46, centerY - 6));
    }
  }

  @override
  bool shouldRepaint(GpsSignalPainter oldDelegate) =>
      progress != oldDelegate.progress || isJammed != oldDelegate.isJammed;
}

// Data classes
class EmergencyStep {
  final int number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> details;

  EmergencyStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.details,
  });
}

class NavigationMethod {
  final String name;
  final IconData icon;
  final String accuracy;
  final String requirement;
  final Color color;

  NavigationMethod({
    required this.name,
    required this.icon,
    required this.accuracy,
    required this.requirement,
    required this.color,
  });
}
