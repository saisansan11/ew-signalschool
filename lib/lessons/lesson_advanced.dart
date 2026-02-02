import 'package:flutter/material.dart';
import 'dart:math';

// ==========================================
// ADVANCED LESSON: ECCM Deep Dive
// ==========================================
class LessonAdvanced_ECCM extends StatefulWidget {
  const LessonAdvanced_ECCM({super.key});
  @override
  State<LessonAdvanced_ECCM> createState() => _LessonAdvanced_ECCMState();
}

class _LessonAdvanced_ECCMState extends State<LessonAdvanced_ECCM>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  int _selectedTechnique = 0;

  final List<ECCMTechnique> _techniques = [
    ECCMTechnique(
      name: 'Adaptive Nulling',
      description: 'สร้าง Null ในทิศทาง Jammer อัตโนมัติ',
      details:
          'ใช้ Digital Beamforming ปรับ Antenna Pattern แบบ Real-time '
          'เพื่อลด Gain ไปยังทิศทางของ Jammer โดยไม่กระทบ Main Beam',
      color: Colors.cyan,
      icon: Icons.adjust,
    ),
    ECCMTechnique(
      name: 'Sidelobe Blanking',
      description: 'ตัดสัญญาณที่เข้าทาง Sidelobe',
      details:
          'ใช้ Auxiliary Antenna ตรวจจับสัญญาณที่เข้ามาทาง Sidelobe '
          'แล้ว Blank (ตัด) สัญญาณนั้นออกจาก Main Channel',
      color: Colors.orange,
      icon: Icons.block,
    ),
    ECCMTechnique(
      name: 'Frequency Agility',
      description: 'เปลี่ยนความถี่แบบสุ่มทุก Pulse',
      details:
          'Radar เปลี่ยนความถี่ทุก Pulse หรือทุก Burst '
          'ทำให้ Jammer ไม่ทันตอบสนอง (DRFM ต้องใช้เวลา)',
      color: Colors.purple,
      icon: Icons.shuffle,
    ),
    ECCMTechnique(
      name: 'Pulse Compression',
      description: 'เพิ่ม SNR ด้วย Time-Bandwidth Product',
      details:
          'ส่ง Long Pulse ที่มี Bandwidth สูง (LFM/Phase Code) '
          'แล้ว Compress ที่ Receiver ให้ได้ Range Resolution สูงและ SNR เพิ่ม',
      color: Colors.green,
      icon: Icons.compress,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Advanced ECCM Techniques", Colors.green),
          const SizedBox(height: 16),

          _buildIntroText(
            "ECCM (Electronic Counter-Countermeasures) ขั้นสูง "
            "ใช้เทคนิคหลายชั้นผสมกันเพื่อต้านทาน Jamming ที่ซับซ้อน",
          ),

          const SizedBox(height: 24),

          // Interactive Technique Selector
          _buildTechniqueSelector(),

          const SizedBox(height: 20),

          // Animated Visualization
          _buildAnimatedVisualization(),

          const SizedBox(height: 20),

          // Technique Details
          _buildTechniqueDetails(),

          const SizedBox(height: 24),

          // Processing Gain Calculator
          _buildProcessingGainSection(),

          const SizedBox(height: 24),

          // AESA Advantages
          _buildAESASection(),

          const SizedBox(height: 24),

          // Summary Box
          _buildSummaryBox(),
        ],
      ),
    );
  }

  Widget _buildHeader(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.shield, color: color, size: 28),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
    );
  }

  Widget _buildTechniqueSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _techniques.asMap().entries.map((entry) {
          final index = entry.key;
          final tech = entry.value;
          final isSelected = index == _selectedTechnique;

          return GestureDetector(
            onTap: () => setState(() => _selectedTechnique = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? tech.color.withOpacity(0.3)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? tech.color : Colors.white24,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: tech.color.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(
                    tech.icon,
                    color: isSelected ? tech.color : Colors.white54,
                    size: 24,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tech.name,
                    style: TextStyle(
                      color: isSelected ? tech.color : Colors.white54,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnimatedVisualization() {
    final tech = _techniques[_selectedTechnique];

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tech.color.withOpacity(0.5)),
      ),
      child: AnimatedBuilder(
        animation: _mainController,
        builder: (context, _) {
          return CustomPaint(
            painter: _getVisualizationPainter(_selectedTechnique),
          );
        },
      ),
    );
  }

  CustomPainter _getVisualizationPainter(int technique) {
    switch (technique) {
      case 0:
        return AdaptiveNullingPainter(_mainController.value);
      case 1:
        return SidelobeBlankinPainter(_mainController.value);
      case 2:
        return FrequencyAgilityPainter(_mainController.value);
      case 3:
        return PulseCompressionPainter(_mainController.value);
      default:
        return AdaptiveNullingPainter(_mainController.value);
    }
  }

  Widget _buildTechniqueDetails() {
    final tech = _techniques[_selectedTechnique];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tech.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tech.color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(tech.icon, color: tech.color, size: 24),
              const SizedBox(width: 10),
              Text(
                tech.name,
                style: TextStyle(
                  color: tech.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            tech.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(color: Colors.white24, height: 20),
          Text(
            tech.details,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingGainSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calculate, color: Colors.green, size: 24),
              SizedBox(width: 10),
              Text(
                'Processing Gain (Gp)',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Formula
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              children: [
                Text(
                  'Gp = B × T = Bandwidth × Pulse Width',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'หรือ Gp = Bandwidth / Data Rate (สำหรับ Spread Spectrum)',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Example calculation
          const Text(
            'ตัวอย่าง: LFM Pulse Compression',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Bandwidth (B) = 10 MHz\n'
            '• Pulse Width (T) = 10 µs\n'
            '• Processing Gain = 10 × 10⁶ × 10 × 10⁻⁶ = 100\n'
            '• Gp in dB = 10 log₁₀(100) = 20 dB\n\n'
            'หมายความว่า SNR เพิ่มขึ้น 20 dB จากการ Pulse Compression',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildAESASection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.grid_on, color: Colors.purple, size: 24),
              SizedBox(width: 10),
              Text(
                'AESA ECCM Advantages',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // AESA Animation
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, _) {
                return CustomPaint(painter: AESAPainter(_mainController.value));
              },
            ),
          ),

          const SizedBox(height: 16),

          _buildAESAAdvantage(
            Icons.speed,
            'Rapid Frequency Change',
            'เปลี่ยนความถี่ทุก Pulse ได้ในไมโครวินาที',
            Colors.cyan,
          ),
          const SizedBox(height: 8),
          _buildAESAAdvantage(
            Icons.call_split,
            'Multiple Beams',
            'สร้างหลาย Beam พร้อมกันเพื่อ Track และ Search',
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildAESAAdvantage(
            Icons.adjust,
            'Adaptive Nulling',
            'สร้าง Null หลายจุดไปยัง Jammer หลายตัว',
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildAESAAdvantage(
            Icons.healing,
            'Graceful Degradation',
            'เสีย T/R Module บางตัวยังทำงานได้',
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildAESAAdvantage(
    IconData icon,
    String title,
    String desc,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
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
                  fontSize: 13,
                ),
              ),
              Text(
                desc,
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.2),
            Colors.purple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.5)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber, size: 24),
              SizedBox(width: 10),
              Text(
                'สรุป ECCM Strategy',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '1. Layered Defense: ใช้หลายเทคนิคซ้อนกัน\n'
            '2. Adaptive Response: ปรับตัวตามภัยคุกคาม\n'
            '3. Redundancy: มี Backup หลายทาง\n'
            '4. Intelligence: รู้จัก Threat Library\n'
            '5. Training: ฝึกจนเป็นอัตโนมัติ',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// Data Model for ECCM Techniques
class ECCMTechnique {
  final String name;
  final String description;
  final String details;
  final Color color;
  final IconData icon;

  ECCMTechnique({
    required this.name,
    required this.description,
    required this.details,
    required this.color,
    required this.icon,
  });
}

// ==========================================
// CUSTOM PAINTERS FOR ADVANCED VISUALIZATIONS
// ==========================================

class AdaptiveNullingPainter extends CustomPainter {
  final double progress;
  AdaptiveNullingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.7);

    // Draw antenna array
    for (int i = -4; i <= 4; i++) {
      final x = center.dx + i * 20;
      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, center.dy), width: 12, height: 30),
        Paint()..color = Colors.green.withOpacity(0.7),
      );
    }

    // Draw main beam
    final beamPath = Path();
    beamPath.moveTo(center.dx - 50, center.dy);
    beamPath.lineTo(center.dx, 30);
    beamPath.lineTo(center.dx + 50, center.dy);
    beamPath.close();

    canvas.drawPath(
      beamPath,
      Paint()
        ..color = Colors.green.withOpacity(0.3)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      beamPath,
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Draw jammer position
    final jammerX = size.width * 0.8;
    final jammerY = size.height * 0.3;

    // Animated null steering
    final nullAngle = sin(progress * 2 * pi) * 0.3 + 0.5;

    // Draw null zone
    canvas.drawPath(
      Path()
        ..moveTo(center.dx + 60, center.dy)
        ..lineTo(jammerX, jammerY + 30)
        ..lineTo(jammerX, jammerY - 30)
        ..close(),
      Paint()
        ..color = Colors.red.withOpacity(0.1 + nullAngle * 0.2)
        ..style = PaintingStyle.fill,
    );

    // Jammer
    canvas.drawCircle(
      Offset(jammerX, jammerY),
      15,
      Paint()..color = Colors.red,
    );

    // Jammer waves (being nulled)
    for (int i = 0; i < 3; i++) {
      final waveProgress = (progress + i * 0.3) % 1.0;
      canvas.drawCircle(
        Offset(jammerX, jammerY),
        20 + waveProgress * 40,
        Paint()
          ..color = Colors.red.withOpacity(
            0.3 * (1 - waveProgress) * (1 - nullAngle),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // Labels
    _drawText(canvas, 'MAIN BEAM', Offset(center.dx - 35, 40), Colors.green);
    _drawText(canvas, 'JAMMER', Offset(jammerX - 25, jammerY + 25), Colors.red);
    _drawText(
      canvas,
      'NULL',
      Offset(size.width * 0.65, size.height * 0.4),
      Colors.orange,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SidelobeBlankinPainter extends CustomPainter {
  final double progress;
  SidelobeBlankinPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.8);

    // Draw antenna pattern with sidelobes
    final patternPath = Path();
    patternPath.moveTo(0, size.height * 0.7);

    for (double x = 0; x <= size.width; x += 2) {
      final normalized = (x - size.width / 2) / (size.width / 2);
      double amplitude;

      if (normalized.abs() < 0.15) {
        // Main lobe
        amplitude = cos(normalized * pi / 0.3) * 0.7;
      } else {
        // Sidelobes
        amplitude =
            sin(normalized * pi * 4).abs() * 0.15 * (1 - normalized.abs());
      }

      patternPath.lineTo(x, size.height * 0.7 - amplitude * size.height * 0.5);
    }

    canvas.drawPath(
      patternPath,
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Jammer coming through sidelobe
    final jammerX = size.width * 0.2;
    final jammerY = size.height * 0.3;

    canvas.drawCircle(
      Offset(jammerX, jammerY),
      12,
      Paint()..color = Colors.red,
    );

    // Jamming signal
    final signalProgress = (progress * 2) % 1.0;
    final signalY = jammerY + signalProgress * (size.height * 0.4);

    if (signalY < size.height * 0.55) {
      canvas.drawLine(
        Offset(jammerX, jammerY + 15),
        Offset(jammerX, signalY),
        Paint()
          ..color = Colors.red.withOpacity(0.7)
          ..strokeWidth = 3,
      );
    }

    // Blanking indicator
    if (signalProgress > 0.5) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(jammerX, size.height * 0.6),
          width: 60,
          height: 30,
        ),
        Paint()..color = Colors.orange.withOpacity(0.5),
      );
      _drawText(
        canvas,
        'BLANKED',
        Offset(jammerX - 25, size.height * 0.55),
        Colors.orange,
      );
    }

    // Auxiliary antenna indicator
    canvas.drawCircle(
      Offset(center.dx, center.dy + 20),
      8,
      Paint()..color = Colors.cyan,
    );
    _drawText(
      canvas,
      'AUX ANT',
      Offset(center.dx - 20, center.dy + 35),
      Colors.cyan,
    );

    _drawText(canvas, 'JAMMER', Offset(jammerX - 25, jammerY - 25), Colors.red);
    _drawText(canvas, 'MAIN BEAM', Offset(center.dx - 35, 20), Colors.green);
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FrequencyAgilityPainter extends CustomPainter {
  final double progress;
  FrequencyAgilityPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw frequency axis
    canvas.drawLine(
      Offset(40, size.height - 30),
      Offset(size.width - 20, size.height - 30),
      Paint()
        ..color = Colors.white24
        ..strokeWidth = 2,
    );

    // Time axis
    canvas.drawLine(
      const Offset(40, 20),
      Offset(40, size.height - 30),
      Paint()
        ..color = Colors.white24
        ..strokeWidth = 2,
    );

    // Frequency channels
    final channels = [0.2, 0.5, 0.8, 0.3, 0.7, 0.4, 0.6, 0.9];
    final currentPulse =
        (progress * channels.length * 2).toInt() % channels.length;

    for (int i = 0; i < channels.length; i++) {
      final x = 60 + (i * (size.width - 100) / (channels.length - 1));
      final y = 40 + (1 - channels[i]) * (size.height - 90);

      final isCurrent = i == currentPulse;
      final isPast = i < currentPulse;

      // Draw pulse
      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y), width: 15, height: 25),
        Paint()
          ..color = isCurrent
              ? Colors.green
              : isPast
              ? Colors.green.withOpacity(0.3)
              : Colors.green.withOpacity(0.1),
      );

      // Connect pulses
      if (i > 0) {
        final prevX =
            60 + ((i - 1) * (size.width - 100) / (channels.length - 1));
        final prevY = 40 + (1 - channels[i - 1]) * (size.height - 90);
        canvas.drawLine(
          Offset(prevX, prevY),
          Offset(x, y),
          Paint()
            ..color = Colors.green.withOpacity(isPast ? 0.5 : 0.1)
            ..strokeWidth = 1,
        );
      }
    }

    // Jammer trying to follow
    final jammerPulse = currentPulse > 0
        ? currentPulse - 1
        : channels.length - 1;
    final jammerX =
        60 + (jammerPulse * (size.width - 100) / (channels.length - 1));
    final jammerY = 40 + (1 - channels[jammerPulse]) * (size.height - 90);

    canvas.drawRect(
      Rect.fromCenter(center: Offset(jammerX, jammerY), width: 20, height: 30),
      Paint()
        ..color = Colors.red.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    _drawText(
      canvas,
      'FREQ',
      Offset(size.width - 40, size.height - 25),
      Colors.white54,
    );
    _drawText(canvas, 'TIME', const Offset(5, 10), Colors.white54);
    _drawText(
      canvas,
      'Radar Pulse',
      Offset(size.width / 2 - 30, 10),
      Colors.green,
    );
    _drawText(
      canvas,
      'Jammer (Late)',
      Offset(jammerX - 30, jammerY + 25),
      Colors.red,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PulseCompressionPainter extends CustomPainter {
  final double progress;
  PulseCompressionPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Transmitted Long Pulse (top)
    final txY = size.height * 0.25;
    final txWidth = size.width * 0.6;

    _drawText(
      canvas,
      'Transmitted (Long Pulse + LFM)',
      const Offset(20, 10),
      Colors.cyan,
    );

    // LFM chirp visualization
    final chirpPath = Path();
    chirpPath.moveTo(40, txY);

    for (double x = 40; x < 40 + txWidth; x += 2) {
      final t = (x - 40) / txWidth;
      final freq = sin(t * pi * 8 + t * t * 20);
      chirpPath.lineTo(x, txY + freq * 20);
    }

    canvas.drawPath(
      chirpPath,
      Paint()
        ..color = Colors.cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Envelope
    canvas.drawRect(
      Rect.fromLTWH(40, txY - 25, txWidth, 50),
      Paint()
        ..color = Colors.cyan.withOpacity(0.2)
        ..style = PaintingStyle.fill,
    );

    // Arrow to compressed
    final arrowY = size.height * 0.5;
    canvas.drawLine(
      Offset(size.width / 2, txY + 30),
      Offset(size.width / 2, arrowY - 10),
      Paint()
        ..color = Colors.white54
        ..strokeWidth = 2,
    );

    _drawText(
      canvas,
      'Matched Filter',
      Offset(size.width / 2 + 10, arrowY - 30),
      Colors.white54,
    );

    // Compressed Pulse (bottom)
    final rxY = size.height * 0.75;
    _drawText(
      canvas,
      'Compressed (High Resolution)',
      const Offset(20, 100),
      Colors.green,
    );

    // Compressed pulse shape (sinc-like)
    final compressedPath = Path();
    final centerX = size.width / 2;

    for (double x = 40; x < size.width - 40; x += 2) {
      final t = (x - centerX) / 30;
      double amplitude;
      if (t.abs() < 0.01) {
        amplitude = 1.0;
      } else {
        amplitude = sin(t * pi) / (t * pi);
      }
      amplitude = amplitude.abs() * (progress > 0.5 ? 1.0 : progress * 2);
      compressedPath.lineTo(x, rxY - amplitude * 60);
    }

    canvas.drawPath(
      compressedPath,
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Processing Gain indicator
    final gainBox = Rect.fromLTWH(size.width - 100, size.height - 60, 80, 40);
    canvas.drawRect(
      gainBox,
      Paint()
        ..color = Colors.amber.withOpacity(0.2)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      gainBox,
      Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.stroke,
    );
    _drawText(
      canvas,
      'Gp = B×T',
      Offset(gainBox.left + 10, gainBox.top + 5),
      Colors.amber,
    );
    _drawText(
      canvas,
      '= 20 dB',
      Offset(gainBox.left + 15, gainBox.top + 20),
      Colors.amber,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AESAPainter extends CustomPainter {
  final double progress;
  AESAPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw AESA array grid
    const cols = 8;
    const rows = 6;
    final cellWidth = (size.width - 80) / cols;
    final cellHeight = (size.height - 40) / rows;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = 40 + col * cellWidth + cellWidth / 2;
        final y = 20 + row * cellHeight + cellHeight / 2;

        // Phase animation for beam steering
        final phase = sin(progress * 2 * pi + col * 0.3 - row * 0.2);
        final brightness = (0.3 + phase * 0.3 + 0.4).clamp(0.0, 1.0);

        // T/R Module
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: cellWidth * 0.8,
            height: cellHeight * 0.8,
          ),
          Paint()..color = Colors.green.withOpacity(brightness),
        );
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: cellWidth * 0.8,
            height: cellHeight * 0.8,
          ),
          Paint()
            ..color = Colors.green
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    }

    // Show beam direction
    final beamAngle = sin(progress * 2 * pi) * 0.3;
    final beamEndX = size.width / 2 + sin(beamAngle) * 60;

    canvas.drawLine(
      Offset(size.width / 2, size.height / 2),
      Offset(beamEndX, 0),
      Paint()
        ..color = Colors.cyan.withOpacity(0.5)
        ..strokeWidth = 20,
    );

    _drawText(
      canvas,
      'AESA Array',
      Offset(size.width / 2 - 30, size.height - 15),
      Colors.white54,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ==========================================
// ADVANCED LESSON: TDOA/FDOA Geolocation
// ==========================================
class LessonAdvanced_DF extends StatefulWidget {
  const LessonAdvanced_DF({super.key});
  @override
  State<LessonAdvanced_DF> createState() => _LessonAdvanced_DFState();
}

class _LessonAdvanced_DFState extends State<LessonAdvanced_DF>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedMethod = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Advanced Direction Finding", Colors.amber),
          const SizedBox(height: 16),

          _buildIntroText(
            "เทคนิค DF ขั้นสูงใช้หลักการทางคณิตศาสตร์และฟิสิกส์ "
            "เพื่อหาตำแหน่งแหล่งกำเนิดสัญญาณด้วยความแม่นยำสูง",
          ),

          const SizedBox(height: 24),

          // Method Selector
          _buildMethodSelector(),

          const SizedBox(height: 20),

          // Visualization
          _buildVisualization(),

          const SizedBox(height: 20),

          // Method Details
          _buildMethodDetails(),

          const SizedBox(height: 24),

          // CEP Explanation
          _buildCEPSection(),

          const SizedBox(height: 24),

          // Comparison Table
          _buildComparisonTable(),
        ],
      ),
    );
  }

  Widget _buildHeader(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.my_location, color: color, size: 28),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
    );
  }

  Widget _buildMethodSelector() {
    final methods = ['TDOA', 'FDOA', 'AOA', 'Hybrid'];
    final colors = [Colors.cyan, Colors.purple, Colors.orange, Colors.green];

    return Row(
      children: methods.asMap().entries.map((entry) {
        final index = entry.key;
        final method = entry.value;
        final isSelected = index == _selectedMethod;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedMethod = index),
            child: Container(
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors[index].withOpacity(0.3)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? colors[index] : Colors.white24,
                ),
              ),
              child: Center(
                child: Text(
                  method,
                  style: TextStyle(
                    color: isSelected ? colors[index] : Colors.white54,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVisualization() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          switch (_selectedMethod) {
            case 0:
              return CustomPaint(painter: TDOAPainter(_controller.value));
            case 1:
              return CustomPaint(painter: FDOAPainter(_controller.value));
            case 2:
              return CustomPaint(painter: AOAPainter(_controller.value));
            case 3:
              return CustomPaint(painter: HybridDFPainter(_controller.value));
            default:
              return CustomPaint(painter: TDOAPainter(_controller.value));
          }
        },
      ),
    );
  }

  Widget _buildMethodDetails() {
    final details = [
      {
        'title': 'TDOA (Time Difference of Arrival)',
        'formula': 'Δt = (d₁ - d₂) / c',
        'description':
            'วัดความต่างเวลาที่สัญญาณมาถึง Sensor แต่ละตัว\n'
            'สร้าง Hyperbola จากคู่ Sensor, จุดตัด = ตำแหน่งเป้าหมาย',
        'pros': '• แม่นยำสูง (CEP < 50m)\n• ไม่ต้องรู้ความถี่แน่นอน',
        'cons': '• ต้อง Sync เวลาแม่นยำมาก\n• ต้องใช้ 3+ สถานี',
        'color': Colors.cyan,
      },
      {
        'title': 'FDOA (Frequency Difference of Arrival)',
        'formula': 'Δf = f₀ × (v₁ - v₂) / c',
        'description':
            'วัดความต่าง Doppler Shift จาก Sensor ที่เคลื่อนที่\n'
            'ใช้กับดาวเทียมหรือเครื่องบินลาดตระเวน',
        'pros': '• ใช้ได้กับ Sensor เคลื่อนที่\n• ไม่ต้อง Sync เวลา',
        'cons': '• ต้องรู้ความเร็ว Sensor แม่นยำ\n• ต้องการ SNR สูง',
        'color': Colors.purple,
      },
      {
        'title': 'AOA (Angle of Arrival)',
        'formula': 'θ = arctan(Δφ × λ / 2πd)',
        'description':
            'วัดมุมที่สัญญาณมาถึงด้วย Phase Interferometry\n'
            'ใช้ Baseline ระหว่าง Antenna หลายตัว',
        'pros': '• ใช้ได้กับสถานีเดียว\n• Real-time',
        'cons': '• Accuracy ขึ้นกับ Baseline\n• Ambiguity ที่มุมกว้าง',
        'color': Colors.orange,
      },
      {
        'title': 'Hybrid (TDOA + FDOA + AOA)',
        'formula': 'Combined Estimation',
        'description':
            'รวมหลายเทคนิคเพื่อเพิ่มความแม่นยำ\n'
            'ใช้ Kalman Filter หรือ Maximum Likelihood',
        'pros': '• แม่นยำสูงสุด\n• Robust ต่อ Error',
        'cons': '• ซับซ้อน\n• ต้องการ Processing สูง',
        'color': Colors.green,
      },
    ];

    final detail = details[_selectedMethod];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (detail['color'] as Color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (detail['color'] as Color).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail['title'] as String,
            style: TextStyle(
              color: detail['color'] as Color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Formula
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                detail['formula'] as String,
                style: TextStyle(
                  color: detail['color'] as Color,
                  fontSize: 16,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          Text(
            detail['description'] as String,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ข้อดี',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail['pros'] as String,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ข้อจำกัด',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail['cons'] as String,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCEPSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.5)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gps_fixed, color: Colors.blue, size: 24),
              SizedBox(width: 10),
              Text(
                'CEP (Circular Error Probable)',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'CEP คือรัศมีวงกลมที่มีโอกาส 50% ที่ตำแหน่งจริงอยู่ภายใน\n\n'
            '• CEP 50m = ตำแหน่งจริงอยู่ใน 50m มีโอกาส 50%\n'
            '• CEP ดี: < 100m (ยุทธวิธี), < 10km (Strategic)\n'
            '• ปัจจัยที่มีผล: SNR, Geometry, Timing Accuracy',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'เปรียบเทียบเทคนิค DF',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Table(
            border: TableBorder.all(color: Colors.white24),
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Method',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Accuracy',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Sensors',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Real-time',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              _buildTableRow('TDOA', 'High', '3+', 'Yes'),
              _buildTableRow('FDOA', 'Medium', '2+', 'Delay'),
              _buildTableRow('AOA', 'Medium', '1+', 'Yes'),
              _buildTableRow('Hybrid', 'Highest', '3+', 'Yes'),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(
    String method,
    String accuracy,
    String sensors,
    String realtime,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            method,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            accuracy,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            sensors,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            realtime,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// DF TECHNIQUE PAINTERS
// ==========================================

class TDOAPainter extends CustomPainter {
  final double progress;
  TDOAPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Three stations
    final stations = [
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.3),
    ];

    // Target
    final target = Offset(size.width * 0.55, size.height * 0.55);

    // Draw hyperbolas
    _drawHyperbola(
      canvas,
      size,
      stations[0],
      stations[1],
      target,
      Colors.cyan,
      progress,
    );
    _drawHyperbola(
      canvas,
      size,
      stations[1],
      stations[2],
      target,
      Colors.purple,
      progress,
    );

    // Draw stations
    for (int i = 0; i < stations.length; i++) {
      canvas.drawCircle(stations[i], 10, Paint()..color = Colors.green);
      _drawText(
        canvas,
        'S${i + 1}',
        stations[i] + const Offset(-8, 15),
        Colors.green,
      );
    }

    // Draw signal waves from target
    for (int i = 0; i < 3; i++) {
      final waveProgress = (progress + i * 0.3) % 1.0;
      canvas.drawCircle(
        target,
        20 + waveProgress * 50,
        Paint()
          ..color = Colors.red.withOpacity(0.3 * (1 - waveProgress))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // Target indicator
    canvas.drawCircle(target, 8, Paint()..color = Colors.red);
    _drawText(canvas, 'TARGET', target + const Offset(-25, -20), Colors.red);

    _drawText(
      canvas,
      'TDOA: Hyperbola Intersection',
      const Offset(10, 10),
      Colors.white54,
    );
  }

  void _drawHyperbola(
    Canvas canvas,
    Size size,
    Offset s1,
    Offset s2,
    Offset target,
    Color color,
    double progress,
  ) {
    // Simplified hyperbola visualization
    final midpoint = Offset((s1.dx + s2.dx) / 2, (s1.dy + s2.dy) / 2);
    final angle = atan2(s2.dy - s1.dy, s2.dx - s1.dx);

    final path = Path();
    for (double t = -1; t <= 1; t += 0.05) {
      final x = midpoint.dx + t * 100 * cos(angle + pi / 2);
      final y = midpoint.dy + t * 100 * sin(angle + pi / 2) + t * t * 50;
      if (t == -1) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FDOAPainter extends CustomPainter {
  final double progress;
  FDOAPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Moving satellite/aircraft
    final sensorY = size.height * 0.25;
    final sensorX = 50 + progress * (size.width - 100);

    // Draw sensor path
    canvas.drawLine(
      Offset(50, sensorY),
      Offset(size.width - 50, sensorY),
      Paint()
        ..color = Colors.purple.withOpacity(0.3)
        ..strokeWidth = 2,
    );

    // Draw sensor
    canvas.drawCircle(
      Offset(sensorX, sensorY),
      12,
      Paint()..color = Colors.purple,
    );

    // Target on ground
    final target = Offset(size.width * 0.6, size.height * 0.7);
    canvas.drawCircle(target, 8, Paint()..color = Colors.red);

    // Doppler effect visualization
    final lineToTarget = Paint()
      ..color = Colors.cyan.withOpacity(0.5)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(sensorX, sensorY), target, lineToTarget);

    // Doppler shift indicator
    final approaching = sensorX < target.dx;
    final shiftColor = approaching ? Colors.blue : Colors.red;
    final shiftText = approaching ? '+Δf (Blue Shift)' : '-Δf (Red Shift)';

    _drawText(
      canvas,
      shiftText,
      Offset(sensorX - 30, sensorY + 20),
      shiftColor,
    );

    // Isodoppler lines
    for (int i = 0; i < 3; i++) {
      final lineX = target.dx + (i - 1) * 40;
      canvas.drawLine(
        Offset(lineX, size.height * 0.4),
        Offset(lineX, size.height * 0.9),
        Paint()
          ..color = Colors.purple.withOpacity(0.2)
          ..strokeWidth = 1,
      );
    }

    _drawText(
      canvas,
      'Moving Sensor',
      Offset(sensorX - 35, sensorY - 25),
      Colors.purple,
    );
    _drawText(canvas, 'TARGET', target + const Offset(-25, 15), Colors.red);
    _drawText(
      canvas,
      'FDOA: Doppler Difference',
      const Offset(10, 10),
      Colors.white54,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AOAPainter extends CustomPainter {
  final double progress;
  AOAPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Station with antenna array
    final station = Offset(size.width * 0.5, size.height * 0.85);

    // Draw antenna array
    for (int i = -2; i <= 2; i++) {
      final x = station.dx + i * 15;
      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, station.dy), width: 8, height: 20),
        Paint()..color = Colors.orange,
      );
    }

    // Target
    final targetAngle = sin(progress * 2 * pi) * 0.5;
    final targetDist = size.height * 0.5;
    final target = Offset(
      station.dx + sin(targetAngle) * targetDist,
      station.dy - cos(targetAngle) * targetDist,
    );

    // Draw bearing line
    canvas.drawLine(
      station,
      target,
      Paint()
        ..color = Colors.orange.withOpacity(0.5)
        ..strokeWidth = 3,
    );

    // Draw angle arc
    final arcRect = Rect.fromCircle(center: station, radius: 50);
    canvas.drawArc(
      arcRect,
      -pi / 2,
      targetAngle,
      false,
      Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Angle text
    final angleDeg = (targetAngle * 180 / pi).toStringAsFixed(1);
    _drawText(
      canvas,
      '$angleDeg°',
      station + const Offset(55, -30),
      Colors.orange,
    );

    // Target
    canvas.drawCircle(target, 8, Paint()..color = Colors.red);

    // Signal waves
    for (int i = 0; i < 2; i++) {
      final waveProgress = (progress * 2 + i * 0.5) % 1.0;
      canvas.drawCircle(
        target,
        15 + waveProgress * 30,
        Paint()
          ..color = Colors.red.withOpacity(0.3 * (1 - waveProgress))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    _drawText(
      canvas,
      'Antenna Array',
      station + const Offset(-35, 10),
      Colors.orange,
    );
    _drawText(canvas, 'TARGET', target + const Offset(-25, -20), Colors.red);
    _drawText(
      canvas,
      'AOA: Phase Interferometry',
      const Offset(10, 10),
      Colors.white54,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HybridDFPainter extends CustomPainter {
  final double progress;
  HybridDFPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Multiple stations with combined techniques
    final stations = [
      Offset(size.width * 0.15, size.height * 0.7),
      Offset(size.width * 0.85, size.height * 0.7),
      Offset(size.width * 0.5, size.height * 0.2),
    ];

    // Target with uncertainty ellipse shrinking
    final target = Offset(size.width * 0.55, size.height * 0.5);

    // Draw uncertainty ellipse (shrinking as methods combine)
    final ellipseSize = 80 - progress * 50;

    canvas.drawOval(
      Rect.fromCenter(
        center: target,
        width: ellipseSize * 1.5,
        height: ellipseSize,
      ),
      Paint()
        ..color = Colors.green.withOpacity(0.3)
        ..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: target,
        width: ellipseSize * 1.5,
        height: ellipseSize,
      ),
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Draw stations and their contributions
    final colors = [Colors.cyan, Colors.purple, Colors.orange];
    final labels = ['TDOA', 'FDOA', 'AOA'];

    for (int i = 0; i < stations.length; i++) {
      // Station
      canvas.drawCircle(stations[i], 10, Paint()..color = colors[i]);
      _drawText(
        canvas,
        labels[i],
        stations[i] + const Offset(-15, 15),
        colors[i],
      );

      // Line to target
      canvas.drawLine(
        stations[i],
        target,
        Paint()
          ..color = colors[i].withOpacity(0.3)
          ..strokeWidth = 2,
      );
    }

    // Target point
    canvas.drawCircle(target, 6, Paint()..color = Colors.red);

    // CEP indicator
    _drawText(
      canvas,
      'CEP: ${(ellipseSize / 2).toStringAsFixed(0)}m',
      target + const Offset(-25, 40),
      Colors.green,
    );

    _drawText(
      canvas,
      'Hybrid: Combined Estimation',
      const Offset(10, 10),
      Colors.white54,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
