import 'package:flutter/material.dart';
import 'dart:math';

// ==========================================
// 1. LESSON 1: ภาพรวมและ 3 เสาหลัก (Overview & Triad)
// ==========================================
class Lesson1_Basics extends StatelessWidget {
  const Lesson1_Basics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header("1. สงครามที่มองไม่เห็น", Colors.blueAccent),
        const SizedBox(height: 15),
        _Text("\"ในสนามรบสมัยใหม่ ใครครองสเปกตรัมได้ คนนั้นชนะ\""),
        const SizedBox(height: 10),
        _Box(
          title: "นิยาม EW (Electronic Warfare)",
          desc:
              "การใช้ 'พลังงานแม่เหล็กไฟฟ้า' (คลื่นวิทยุ/เรดาร์/เลเซอร์) เพื่อ:\n"
              "1. โจมตี (Attack) -> ให้ข้าศึกใช้ไม่ได้\n"
              "2. ป้องกัน (Protect) -> ให้เราใช้ได้ตลอดเวลา\n"
              "3. สนับสนุน (Support) -> หาว่าข้าศึกอยู่ที่ไหน",
          color: Colors.blue,
        ),
        const SizedBox(height: 30),
        _SubHeader("วงจร 3 เสาหลัก (The EW Triad)", Colors.amber),
        const SizedBox(height: 15),
        const EWCycleAnimation(), // [Animation] วงจร EW
        const SizedBox(height: 20),
        _ExpandableCard(
          Icons.hearing,
          Colors.amber,
          "1. ES (Support)",
          "ภารกิจ: ค้นหา (Search), ดักรับ (Intercept), หาพิกัด (Locate)\nเป้าหมาย: เพื่อรู้ว่าข้าศึกคือใคร อยู่ที่ไหน กำลังคุยอะไรกัน",
        ),
        const SizedBox(height: 10),
        _ExpandableCard(
          Icons.flash_on,
          Colors.red,
          "2. EA (Attack)",
          "ภารกิจ: รบกวน (Jamming), ลวง (Deception), ทำลาย (Destroy)\nเป้าหมาย: ทำให้จอเรดาร์ข้าศึกบอด หรือวิทยุข้าศึกมีแต่เสียงซ่า",
        ),
        const SizedBox(height: 10),
        _ExpandableCard(
          Icons.shield,
          Colors.green,
          "3. EP (Protection)",
          "ภารกิจ: ป้องกันฝ่ายเราจากการถูกรบกวน\nเทคนิค: กระโดดความถี่ (Frequency Hopping), ลดกำลังส่ง, ใช้รหัสลับ",
        ),

        // Knowledge Check
        const SizedBox(height: 20),
        const KnowledgeCheck(
          question: 'องค์ประกอบใดของ EW ที่มีหน้าที่ "ค้นหา ดักรับ และหาพิกัด" ของข้าศึก?',
          options: [
            'EA (Electronic Attack)',
            'EP (Electronic Protection)',
            'ES (Electronic Support)',
            'ECM (Electronic Countermeasures)',
          ],
          correctIndex: 2,
          explanation: 'ES (Electronic Support) หรือ ESM มีหน้าที่ค้นหา (Search), ดักรับ (Intercept), และหาพิกัด (Locate) สัญญาณของข้าศึก เพื่อนำข้อมูลไปใช้ในการวางแผนรบ',
          color: Colors.amber,
        ),
      ],
    );
  }
}

// ==========================================
// 2. LESSON 2: สนามรบสเปกตรัม (The Spectrum) [UPGRADED]
// ==========================================
class Lesson2_Spectrum extends StatefulWidget {
  const Lesson2_Spectrum({super.key});
  @override
  State<Lesson2_Spectrum> createState() => _Lesson2_SpectrumState();
}

class _Lesson2_SpectrumState extends State<Lesson2_Spectrum> {
  double _freqValue = 0.0; // 0=HF, 1=VHF, 2=UHF, 3=SHF

  // ข้อมูลแต่ละย่านความถี่ (อิงจากเอกสารทหารสื่อสาร)
  final List<Map<String, dynamic>> _bands = [
    {
      "name": "HF (High Frequency)",
      "range": "3 - 30 MHz",
      "prop": "Sky Wave (สะท้อนบรรยากาศ)",
      "usage": "สื่อสารระยะไกล (ข้ามเขา/ข้ามจังหวัด)",
      "gear": "วิทยุ SSB, AN/GRC-106, วิทยุ AM ไกล",
      "color": Colors.blue,
      "waveSpeed": 1.0, // คลื่นยาว ช้า
    },
    {
      "name": "VHF (Very High Freq)",
      "range": "30 - 300 MHz",
      "prop": "Line of Sight (ทางสายตา) + Ground Wave",
      "usage": "วิทยุทางยุทธวิธีหลัก (Tactical Radio)",
      "gear": "AN/PRC-77, CNR-9000 (SINCGARS), วิทยุ FM",
      "color": Colors.green,
      "waveSpeed": 3.0,
    },
    {
      "name": "UHF (Ultra High Freq)",
      "range": "300 MHz - 3 GHz",
      "prop": "Line of Sight (ทางสายตาแท้จริง)",
      "usage": "Data Link, สื่อสารอากาศยาน, มือถือ",
      "gear": "HAVE QUICK, Link-16, โดรน FPV (2.4GHz)",
      "color": Colors.orange,
      "waveSpeed": 6.0,
    },
    {
      "name": "SHF (Super High Freq)",
      "range": "3 - 30 GHz",
      "prop": "Line of Sight (บีมแคบ)",
      "usage": "เรดาร์, ดาวเทียม, Wi-Fi 5G",
      "gear": "Radar Gripen, Starlink, Microwave Link",
      "color": Colors.red,
      "waveSpeed": 12.0, // คลื่นสั้น เร็ว
    },
  ];

  @override
  Widget build(BuildContext context) {
    int index = _freqValue.round();
    var band = _bands[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header("2. สนามรบสเปกตรัม", Colors.purpleAccent),
        const SizedBox(height: 10),
        _Text(
          "คลื่นแต่ละย่านมีนิสัยไม่เหมือนกัน ทหารสื่อสารต้องเลือกใช้ให้ถูกภารกิจ",
        ),

        const SizedBox(height: 20),
        // --- ส่วนแสดงผล Interactive ---
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: band['color'], width: 2),
          ),
          child: Column(
            children: [
              // กราฟิกคลื่น
              SizedBox(
                height: 80,
                width: double.infinity,
                child: SpectrumWaveVisual(
                  speed: band['waveSpeed'],
                  color: band['color'],
                ),
              ),
              const SizedBox(height: 10),
              // ข้อมูลย่าน
              Text(
                band['name'],
                style: TextStyle(
                  color: band['color'],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                band['range'],
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Divider(color: Colors.white24),
              _PropInfo("การเดินทาง:", band['prop']),
              _PropInfo("ภารกิจ:", band['usage']),
              _PropInfo("ยุทโธปกรณ์:", band['gear']),
            ],
          ),
        ),

        const SizedBox(height: 10),
        // Slider ควบคุม
        Column(
          children: [
            const Text(
              "หมุนเพื่อเปลี่ยนย่านความถี่ (Tuning)",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            Slider(
              value: _freqValue,
              min: 0,
              max: 3,
              divisions: 3,
              activeColor: band['color'],
              inactiveColor: Colors.grey[800],
              onChanged: (v) => setState(() => _freqValue = v),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("HF", style: TextStyle(color: Colors.white30)),
                Text("VHF", style: TextStyle(color: Colors.white30)),
                Text("UHF", style: TextStyle(color: Colors.white30)),
                Text("SHF", style: TextStyle(color: Colors.white30)),
              ],
            ),
          ],
        ),

        const SizedBox(height: 30),
        _SubHeader("ลักษณะการแพร่กระจายคลื่น (Propagation)", Colors.white),
        const SizedBox(height: 15),
        const PropagationVisual(), // [Visual] แสดงภาพการเดินทางของคลื่น

        // Knowledge Check
        const SizedBox(height: 20),
        const KnowledgeCheck(
          question: 'ย่านความถี่ใดเหมาะสำหรับการสื่อสารระยะไกลข้ามภูเขาโดยอาศัยการสะท้อนชั้นบรรยากาศ?',
          options: [
            'UHF (300 MHz - 3 GHz)',
            'SHF (3 - 30 GHz)',
            'HF (3 - 30 MHz)',
            'VHF (30 - 300 MHz)',
          ],
          correctIndex: 2,
          explanation: 'HF (High Frequency) สามารถสะท้อนชั้นบรรยากาศไอโอโนสเฟียร์ (Sky Wave) ทำให้สื่อสารได้ระยะไกลข้ามภูเขาหรือข้ามจังหวัด แต่คุณภาพเสียงต่ำกว่า VHF/UHF',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _PropInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. ANIMATED WIDGETS (กราฟิกจำลอง)
// ==========================================

// --- 3.1 วงจร EW (หมุนวน) ---
class EWCycleAnimation extends StatefulWidget {
  const EWCycleAnimation({super.key});
  @override
  State<EWCycleAnimation> createState() => _EWCycleAnimationState();
}

class _EWCycleAnimationState extends State<EWCycleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
      ),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (c, _) => CustomPaint(painter: EWCyclePainter(_ctrl.value)),
      ),
    );
  }
}

class EWCyclePainter extends CustomPainter {
  final double p;
  EWCyclePainter(this.p);
  @override
  void paint(Canvas c, Size s) {
    final center = Offset(s.width / 2, s.height / 2);
    const r = 50.0;
    final p1 = center + const Offset(0, -r);
    final p2 = center + const Offset(r * 0.866, r * 0.5);
    final p3 = center + const Offset(-r * 0.866, r * 0.5);
    final paintLine = Paint()
      ..color = Colors.white24
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    c.drawLine(p1, p2, paintLine);
    c.drawLine(p2, p3, paintLine);
    c.drawLine(p3, p1, paintLine);
    Offset ballPos = (p < 0.33)
        ? Offset.lerp(p1, p2, p / 0.33)!
        : (p < 0.66)
        ? Offset.lerp(p2, p3, (p - 0.33) / 0.33)!
        : Offset.lerp(p3, p1, (p - 0.66) / 0.34)!;
    c.drawCircle(ballPos, 6, Paint()..color = Colors.cyanAccent);
    _drawNode(c, p1, "ESM\n(ฟัง)", Colors.amber);
    _drawNode(c, p2, "ECM\n(รุก)", Colors.red);
    _drawNode(c, p3, "EPM\n(รับ)", Colors.green);
  }

  void _drawNode(Canvas c, Offset p, String l, Color col) {
    c.drawCircle(p, 28, Paint()..color = col.withOpacity(0.2));
    c.drawCircle(
      p,
      28,
      Paint()
        ..color = col
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    TextPainter(
        text: TextSpan(
          text: l,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )
      ..layout()
      ..paint(c, p - const Offset(12, 12));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

// --- 3.2 Spectrum Wave Visual (คลื่นเปลี่ยนความถี่ได้) ---
class SpectrumWaveVisual extends StatefulWidget {
  final double speed;
  final Color color;
  const SpectrumWaveVisual({
    super.key,
    required this.speed,
    required this.color,
  });
  @override
  State<SpectrumWaveVisual> createState() => _SpectrumWaveVisualState();
}

class _SpectrumWaveVisualState extends State<SpectrumWaveVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (c, _) => CustomPaint(
        painter: WaveSinglePainter(_ctrl.value, widget.speed, widget.color),
      ),
    );
  }
}

class WaveSinglePainter extends CustomPainter {
  final double anim;
  final double freqMult;
  final Color color;
  WaveSinglePainter(this.anim, this.freqMult, this.color);
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final path = Path();
    for (double x = 0; x <= s.width; x++) {
      double y =
          s.height / 2 +
          sin((x / s.width * freqMult * pi * 2) - (anim * 2 * pi)) *
              (s.height * 0.4);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    c.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

// --- 3.3 Propagation Visual (ภาพจำลองการแพร่คลื่น) ---
class PropagationVisual extends StatelessWidget {
  const PropagationVisual({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomPaint(painter: PropagationPainter()),
    );
  }
}

class PropagationPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Earth Surface (Curved)
    final earthPath = Path();
    earthPath.moveTo(0, s.height);
    earthPath.quadraticBezierTo(s.width / 2, s.height - 20, s.width, s.height);
    c.drawPath(earthPath, p..color = Colors.brown);

    // Ionosphere (Sky)
    c.drawLine(
      const Offset(0, 10),
      Offset(s.width, 10),
      p
        ..color = Colors.blue.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // Sender (Left)
    c.drawRect(
      Rect.fromLTWH(20, s.height - 30, 10, 20),
      p
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    // Receiver (Right)
    c.drawRect(
      Rect.fromLTWH(s.width - 30, s.height - 30, 10, 20),
      p
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    // HF Skywave (Bounce)
    p
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final hfPath = Path();
    hfPath.moveTo(25, s.height - 30);
    hfPath.lineTo(s.width / 2, 10); // Bounce off sky
    hfPath.lineTo(s.width - 25, s.height - 30);
    c.drawPath(hfPath, p);
    _drawText(c, "HF (Sky Wave)", Offset(s.width / 2, 25), Colors.blue);

    // VHF Line of Sight (Direct)
    p.color = Colors.green;
    c.drawLine(
      Offset(25, s.height - 30),
      Offset(s.width - 25, s.height - 30),
      p,
    );
    _drawText(
      c,
      "VHF (Line of Sight)",
      Offset(s.width / 2, s.height - 45),
      Colors.green,
    );
  }

  void _drawText(Canvas c, String text, Offset pos, Color color) {
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
        textAlign: TextAlign.center,
      )
      ..layout()
      ..paint(c, pos - const Offset(40, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ==========================================
// 4. UI HELPERS
// ==========================================
Widget _Header(String t, Color c) => Text(
  t,
  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: c),
);
Widget _SubHeader(String t, Color c) => Text(
  t,
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c),
);
Widget _Text(String t) => Text(
  t,
  style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
);
Widget _Box({
  required String title,
  required String desc,
  required Color color,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      border: Border.all(color: color.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Divider(color: Colors.white10),
        Text(desc, style: const TextStyle(color: Colors.white70)),
      ],
    ),
  );
}

Widget _ExpandableCard(
  IconData icon,
  Color color,
  String title,
  String content,
) {
  return Card(
    color: Colors.white10,
    child: ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(content, style: const TextStyle(color: Colors.white70)),
        ),
      ],
    ),
  );
}

// ==========================================
// KNOWLEDGE CHECK WIDGET (ตรวจสอบความเข้าใจ)
// ==========================================
class KnowledgeCheck extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final Color color;

  const KnowledgeCheck({
    super.key,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.color = Colors.cyan,
  });

  @override
  State<KnowledgeCheck> createState() => _KnowledgeCheckState();
}

class _KnowledgeCheckState extends State<KnowledgeCheck> {
  int? _selectedIndex;
  bool _answered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color.withOpacity(0.15),
            widget.color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.color.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Icon(Icons.help_outline, color: widget.color, size: 20),
                const SizedBox(width: 8),
                Text(
                  'ตรวจสอบความเข้าใจ',
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                if (_answered && _selectedIndex == widget.correctIndex)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.green, size: 14),
                        SizedBox(width: 4),
                        Text('+5 XP', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Question
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Options
          ...widget.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedIndex == index;
            final isCorrect = index == widget.correctIndex;

            Color bgColor = Colors.white.withOpacity(0.05);
            Color borderColor = Colors.white.withOpacity(0.1);
            Color textColor = Colors.white70;
            IconData? trailingIcon;

            if (_answered) {
              if (isCorrect) {
                bgColor = Colors.green.withOpacity(0.2);
                borderColor = Colors.green;
                textColor = Colors.green;
                trailingIcon = Icons.check_circle;
              } else if (isSelected && !isCorrect) {
                bgColor = Colors.red.withOpacity(0.2);
                borderColor = Colors.red;
                textColor = Colors.red;
                trailingIcon = Icons.cancel;
              }
            } else if (isSelected) {
              bgColor = widget.color.withOpacity(0.2);
              borderColor = widget.color;
              textColor = widget.color;
            }

            return GestureDetector(
              onTap: _answered ? null : () => setState(() => _selectedIndex = index),
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? borderColor : Colors.transparent,
                        border: Border.all(color: borderColor),
                      ),
                      child: isSelected
                          ? Icon(Icons.check, size: 14, color: _answered ? textColor : Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(color: textColor, fontSize: 13),
                      ),
                    ),
                    if (trailingIcon != null)
                      Icon(trailingIcon, color: textColor, size: 20),
                  ],
                ),
              ),
            );
          }),

          // Submit button or explanation
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: _answered
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (_selectedIndex == widget.correctIndex ? Colors.green : Colors.orange).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: (_selectedIndex == widget.correctIndex ? Colors.green : Colors.orange).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: _selectedIndex == widget.correctIndex ? Colors.green : Colors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.explanation,
                            style: TextStyle(
                              color: _selectedIndex == widget.correctIndex ? Colors.green.shade300 : Colors.orange.shade300,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedIndex != null
                          ? () => setState(() => _answered = true)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.color,
                        disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'ตรวจคำตอบ',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// LESSON 3: ESM (Electronic Support Measures)
// ==========================================
class Lesson3_ESM extends StatefulWidget {
  const Lesson3_ESM({super.key});
  @override
  State<Lesson3_ESM> createState() => _Lesson3_ESMState();
}

class _Lesson3_ESMState extends State<Lesson3_ESM>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header("3. ESM - ดักรับและวิเคราะห์", Colors.amber),
        const SizedBox(height: 15),
        _Text(
          "ESM (Electronic Support Measures) คือการค้นหา ดักรับ ระบุ และหาตำแหน่งแหล่งกำเนิดคลื่นแม่เหล็กไฟฟ้า "
          "เพื่อสนับสนุนข่าวกรองและการเตือนภัย",
        ),

        const SizedBox(height: 20),
        _SubHeader("วงจรการทำงาน ESM", Colors.amber),
        const SizedBox(height: 15),

        // ESM Process Animation
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (c, _) =>
                CustomPaint(painter: ESMProcessPainter(_controller.value)),
          ),
        ),

        const SizedBox(height: 20),
        _Box(
          title: "ขั้นตอน ESM",
          desc:
              "1. Search (ค้นหา) - กวาดความถี่เพื่อหาสัญญาณ\n"
              "2. Intercept (ดักรับ) - บันทึกและวิเคราะห์สัญญาณ\n"
              "3. Identify (ระบุ) - จำแนกชนิดและเจ้าของสัญญาณ\n"
              "4. Locate (หาตำแหน่ง) - ใช้ DF หาพิกัดแหล่งกำเนิด",
          color: Colors.amber,
        ),

        const SizedBox(height: 20),
        _SubHeader("ประเภทข่าวกรอง SIGINT", Colors.white),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.chat_bubble,
          Colors.green,
          "COMINT (Communications Intelligence)",
          "ข่าวกรองจากการดักฟังการสื่อสาร:\n\n"
              "• วิทยุสื่อสารทางยุทธวิธี (VHF/UHF)\n"
              "• โทรศัพท์มือถือ/ดาวเทียม\n"
              "• เครือข่ายข้อมูล\n\n"
              "ข้อมูลที่ได้: เนื้อหาการสนทนา, โครงสร้างหน่วย, แผนปฏิบัติการ",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.radar,
          Colors.cyan,
          "ELINT (Electronic Intelligence)",
          "ข่าวกรองจากสัญญาณเรดาร์และเซ็นเซอร์:\n\n"
              "• เรดาร์ค้นหาและติดตาม\n"
              "• ระบบนำวิถีอาวุธ\n"
              "• เรดาร์เครื่องบิน\n\n"
              "ข้อมูลที่ได้: ชนิดเรดาร์, ความสามารถ, ตำแหน่งที่ตั้ง",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.sensors,
          Colors.orange,
          "FISINT (Foreign Instrumentation Signals)",
          "ข่าวกรองจากสัญญาณ Telemetry:\n\n"
              "• ข้อมูลการทดสอบขีปนาวุธ\n"
              "• ระบบนำร่องอากาศยาน\n"
              "• ดาวเทียม\n\n"
              "ข้อมูลที่ได้: พารามิเตอร์การบิน, สมรรถนะอาวุธ",
        ),

        const SizedBox(height: 20),
        _SubHeader("Direction Finding (DF)", Colors.white),
        const SizedBox(height: 10),
        _Text(
          "การหาทิศทางและตำแหน่งแหล่งกำเนิดสัญญาณ โดยใช้หลักการ Triangulation",
        ),
        const SizedBox(height: 15),

        // DF Animation
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (c, _) =>
                CustomPaint(painter: DFTriangulationPainter(_controller.value)),
          ),
        ),

        const SizedBox(height: 15),
        _Box(
          title: "เทคนิค DF ที่ใช้",
          desc:
              "• Amplitude Comparison - เปรียบเทียบความแรงสัญญาณ\n"
              "• Phase Interferometry - วัดเฟสต่างระหว่างเสาอากาศ\n"
              "• Time Difference of Arrival (TDOA) - วัดเวลาที่สัญญาณมาถึง\n"
              "• Frequency Difference of Arrival (FDOA) - ใช้ Doppler Effect",
          color: Colors.cyan,
        ),
      ],
    );
  }
}

// ==========================================
// LESSON 4: ECM (Electronic Countermeasures)
// ==========================================
class Lesson4_ECM extends StatefulWidget {
  const Lesson4_ECM({super.key});
  @override
  State<Lesson4_ECM> createState() => _Lesson4_ECMState();
}

class _Lesson4_ECMState extends State<Lesson4_ECM>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedJamType = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header("4. ECM - การรบกวนอิเล็กทรอนิกส์", Colors.redAccent),
        const SizedBox(height: 15),
        _Text(
          "ECM (Electronic Countermeasures) คือการใช้พลังงานแม่เหล็กไฟฟ้าเพื่อ "
          "รบกวน หลอกลวง หรือทำลายระบบอิเล็กทรอนิกส์ของข้าศึก",
        ),

        const SizedBox(height: 20),
        _SubHeader("เทคนิค Jamming หลัก", Colors.redAccent),
        const SizedBox(height: 15),

        // Interactive Jamming Type Selector
        Row(
          children: [
            _JamTypeButton(
              label: "Spot",
              isSelected: _selectedJamType == 0,
              onTap: () => setState(() => _selectedJamType = 0),
            ),
            const SizedBox(width: 10),
            _JamTypeButton(
              label: "Barrage",
              isSelected: _selectedJamType == 1,
              onTap: () => setState(() => _selectedJamType = 1),
            ),
            const SizedBox(width: 10),
            _JamTypeButton(
              label: "Sweep",
              isSelected: _selectedJamType == 2,
              onTap: () => setState(() => _selectedJamType = 2),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // Jamming Visualization
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (c, _) => CustomPaint(
              painter: JammingVisualizerPainter(
                _controller.value,
                _selectedJamType,
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Jamming Type Description
        _getJammingDescription(_selectedJamType),

        const SizedBox(height: 20),
        _SubHeader("สูตรคำนวณ J/S Ratio", Colors.white),
        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
          ),
          child: const Column(
            children: [
              Text(
                "J/S = Pj × Gj × Rts² / (Ps × Gs × Rjt²)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              Divider(color: Colors.white24),
              Text(
                "Pj = กำลังส่ง Jammer | Gj = Gain เสาอากาศ Jammer\n"
                "Ps = กำลังส่งเป้าหมาย | Gs = Gain เสาอากาศเป้าหมาย\n"
                "Rts = ระยะ Target-Station | Rjt = ระยะ Jammer-Target",
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        _ExpandableCard(
          Icons.psychology,
          Colors.purple,
          "Deception (การหลอกลวง)",
          "การส่งสัญญาณปลอมเพื่อหลอกระบบข้าศึก:\n\n"
              "• False Target - สร้างเป้าปลอมบนจอเรดาร์\n"
              "• Range Gate Pull-Off - ดึงเกตระยะให้ผิด\n"
              "• Velocity Gate Pull-Off - หลอกความเร็ว Doppler\n"
              "• Angle Deception - หลอกทิศทาง",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.fireplace,
          Colors.orange,
          "Expendables (สิ่งสิ้นเปลือง)",
          "อุปกรณ์ต่อต้านที่ใช้แล้วหมด:\n\n"
              "• Chaff - แถบโลหะสะท้อนเรดาร์\n"
              "• Flare - พลุความร้อนหลอก IR Missile\n"
              "• Decoy - เป้าลวงอิเล็กทรอนิกส์\n"
              "• Smoke - ม่านควันบังเรดาร์",
        ),
      ],
    );
  }

  Widget _JamTypeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.redAccent.withOpacity(0.3)
                : Colors.white10,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.redAccent : Colors.white24,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.redAccent : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getJammingDescription(int type) {
    final descriptions = [
      {
        'title': 'Spot Jamming',
        'desc':
            'รบกวนความถี่เดียวอย่างเข้มข้น\n\n'
            '✓ ใช้พลังงานต่ำ\n'
            '✓ J/S สูง\n'
            '✗ ต้องรู้ความถี่แน่นอน\n'
            '✗ หลบ FHSS ไม่ได้',
        'color': Colors.green,
      },
      {
        'title': 'Barrage Jamming',
        'desc':
            'รบกวนช่วงความถี่กว้าง\n\n'
            '✓ ครอบคลุมหลายความถี่\n'
            '✓ รับมือ FHSS ได้\n'
            '✗ ใช้พลังงานสูง\n'
            '✗ J/S ต่ำกว่า Spot',
        'color': Colors.orange,
      },
      {
        'title': 'Sweep Jamming',
        'desc':
            'กวาดความถี่ไปมาในช่วงที่กำหนด\n\n'
            '✓ ครอบคลุมความถี่มาก\n'
            '✓ ใช้พลังงานปานกลาง\n'
            '✗ มีช่องว่างระหว่าง Sweep\n'
            '✗ ไม่ต่อเนื่อง',
        'color': Colors.cyan,
      },
    ];

    final d = descriptions[type];
    return _Box(
      title: d['title'] as String,
      desc: d['desc'] as String,
      color: d['color'] as Color,
    );
  }
}

// ==========================================
// LESSON 5: ECCM (Electronic Counter-Countermeasures)
// ==========================================
class Lesson5_ECCM extends StatefulWidget {
  const Lesson5_ECCM({super.key});
  @override
  State<Lesson5_ECCM> createState() => _Lesson5_ECCMState();
}

class _Lesson5_ECCMState extends State<Lesson5_ECCM>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header("5. ECCM - การป้องกันการถูกรบกวน", Colors.green),
        const SizedBox(height: 15),
        _Text(
          "ECCM (Electronic Counter-Countermeasures) หรือ EPM (Electronic Protective Measures) "
          "คือมาตรการป้องกันระบบอิเล็กทรอนิกส์ฝ่ายเราจากการถูกรบกวน",
        ),

        const SizedBox(height: 20),
        _SubHeader("Frequency Hopping (FHSS)", Colors.green),
        const SizedBox(height: 15),

        // FHSS Animation
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.green.withOpacity(0.5)),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (c, _) =>
                CustomPaint(painter: FHSSVisualizerPainter(_controller.value)),
          ),
        ),

        const SizedBox(height: 15),
        _Box(
          title: "Frequency Hopping Spread Spectrum",
          desc:
              "กระโดดความถี่ 50-1000+ ครั้ง/วินาที\n\n"
              "• ใช้รหัสลับ (Pseudo-Random Code) กำหนดลำดับ\n"
              "• Jammer ต้อง Barrage ทุกความถี่ (พลังงานมหาศาล)\n"
              "• ตัวอย่าง: SINCGARS กระโดด 111 ครั้ง/วินาที",
          color: Colors.green,
        ),

        const SizedBox(height: 20),
        _SubHeader("เทคนิค ECCM อื่นๆ", Colors.white),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.power_settings_new,
          Colors.amber,
          "Power Management",
          "การจัดการกำลังส่ง:\n\n"
              "• ลดกำลังส่งให้ต่ำที่สุด (Minimum Power)\n"
              "• ใช้ Directional Antenna ลดการแผ่\n"
              "• ส่งเป็นห้วงสั้น (Burst Transmission)\n"
              "• ใช้ Spread Spectrum ลดความหนาแน่นพลังงาน",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.shield,
          Colors.blue,
          "Antenna Techniques",
          "เทคนิคสายอากาศ:\n\n"
              "• Sidelobe Blanking - ตัดสัญญาณจาก Sidelobe\n"
              "• Sidelobe Cancellation - หักล้างสัญญาณรบกวน\n"
              "• Adaptive Nulling - สร้าง Null ไปยัง Jammer\n"
              "• Frequency Diversity - ส่งหลายความถี่พร้อมกัน",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.security,
          Colors.purple,
          "Signal Processing",
          "การประมวลผลสัญญาณ:\n\n"
              "• Pulse Compression - เพิ่ม SNR\n"
              "• Moving Target Indicator (MTI)\n"
              "• Constant False Alarm Rate (CFAR)\n"
              "• Coherent Processing",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.lock,
          Colors.red,
          "COMSEC (Communications Security)",
          "ความปลอดภัยการสื่อสาร:\n\n"
              "• Encryption - เข้ารหัสข้อมูล\n"
              "• Authentication - ยืนยันตัวตน\n"
              "• TRANSEC - ปกป้องการส่งสัญญาณ\n"
              "• OPSEC - รักษาความลับปฏิบัติการ",
        ),
      ],
    );
  }
}

// ==========================================
// LESSON 6: วิทยุสื่อสารทางยุทธวิธี
// ==========================================
class Lesson6_Radio extends StatelessWidget {
  const Lesson6_Radio({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header("6. วิทยุสื่อสารทางยุทธวิธี", Colors.teal),
        const SizedBox(height: 15),
        _Text(
          "วิทยุสื่อสารเป็นระบบหลักในการบัญชาการและควบคุมกำลังพล "
          "การเข้าใจย่านความถี่และคุณลักษณะจำเป็นต่อทั้ง ECM และ ECCM",
        ),

        const SizedBox(height: 20),
        _SubHeader("ประเภทวิทยุทางยุทธวิธี", Colors.teal),
        const SizedBox(height: 15),

        _RadioTypeCard(
          name: "HF Radio (3-30 MHz)",
          model: "AN/PRC-150, CODAN",
          range: "ระยะไกล (Sky Wave)",
          usage: "สื่อสารข้ามภูมิภาค, ชายแดน",
          color: Colors.blue,
        ),
        const SizedBox(height: 10),

        _RadioTypeCard(
          name: "VHF Radio (30-88 MHz)",
          model: "AN/PRC-77, CNR-9000",
          range: "ระยะสายตา ~15 km",
          usage: "ยุทธวิธีหลัก, SINCGARS",
          color: Colors.green,
        ),
        const SizedBox(height: 10),

        _RadioTypeCard(
          name: "UHF Radio (225-400 MHz)",
          model: "AN/PRC-117, HAVE QUICK",
          range: "ระยะสายตา, Data Link",
          usage: "สื่อสารอากาศยาน, SATCOM",
          color: Colors.orange,
        ),
        const SizedBox(height: 10),

        _RadioTypeCard(
          name: "SATCOM",
          model: "AN/PRC-152, Iridium",
          range: "ทั่วโลก",
          usage: "สื่อสารดาวเทียม",
          color: Colors.purple,
        ),

        const SizedBox(height: 20),
        _SubHeader("SINCGARS", Colors.white),
        const SizedBox(height: 10),
        _Box(
          title: "Single Channel Ground and Airborne Radio System",
          desc:
              "ระบบวิทยุยุทธวิธีมาตรฐาน NATO:\n\n"
              "• ย่านความถี่: 30-87.975 MHz (VHF FM)\n"
              "• ช่องสัญญาณ: 2,320 ช่อง (ห่างกัน 25 kHz)\n"
              "• FHSS: 111 hops/second\n"
              "• กำลังส่ง: 0.1W - 50W\n"
              "• รองรับ Data และ Voice",
          color: Colors.teal,
        ),

        const SizedBox(height: 20),
        _SubHeader("ระเบียบวิทยุ", Colors.white),
        const SizedBox(height: 10),
        _ExpandableCard(
          Icons.mic,
          Colors.amber,
          "หลักการสื่อสาร",
          "• ใช้สัญญาณเรียกขาน (Call Sign)\n"
              "• พูดสั้น กระชับ ชัดเจน\n"
              "• ใช้ Phonetic Alphabet (Alpha, Bravo...)\n"
              "• ยืนยันคำสั่งด้วย Read Back\n"
              "• รักษาวินัยวิทยุ (Radio Silence เมื่อสั่ง)",
        ),
      ],
    );
  }
}

Widget _RadioTypeCard({
  required String name,
  required String model,
  required String range,
  required String usage,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.5)),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.radio, color: color, size: 28),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "รุ่น: $model",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "ระยะ: $range",
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
              Text(
                "ใช้งาน: $usage",
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ==========================================
// LESSON 7: Anti-Drone EW
// ==========================================
class Lesson7_AntiDrone extends StatefulWidget {
  const Lesson7_AntiDrone({super.key});
  @override
  State<Lesson7_AntiDrone> createState() => _Lesson7_AntiDroneState();
}

class _Lesson7_AntiDroneState extends State<Lesson7_AntiDrone>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header("7. Anti-Drone EW (C-UAS)", Colors.cyan),
        const SizedBox(height: 15),
        _Text(
          "Counter-UAS (C-UAS) คือการตรวจจับ ติดตาม ระบุ และต่อต้านอากาศยานไร้คนขับ (UAV/Drone) "
          "ที่ไม่ได้รับอนุญาตหรือเป็นภัยคุกคาม",
        ),

        const SizedBox(height: 20),
        _SubHeader("ความถี่โดรนพลเรือน", Colors.cyan),
        const SizedBox(height: 15),

        // Drone Frequency Spectrum
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.cyan.withOpacity(0.5)),
          ),
          child: CustomPaint(painter: DroneFrequencyPainter()),
        ),

        const SizedBox(height: 15),
        _Box(
          title: "ความถี่หลักของโดรน",
          desc:
              "📡 2.4 GHz - Command & Control (RC)\n"
              "📹 5.8 GHz - Video Downlink (FPV)\n"
              "🛰️ 1575.42 MHz - GPS L1\n"
              "📱 4G/5G LTE - โดรนบางรุ่น\n\n"
              "* บางโดรนสลับใช้ 2.4/5.8 GHz ทั้งสองทาง",
          color: Colors.cyan,
        ),

        const SizedBox(height: 20),
        _SubHeader(
          "Kill Chain: Detect → Track → Identify → Neutralize",
          Colors.white,
        ),
        const SizedBox(height: 15),

        // Kill Chain Animation
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (c, _) =>
                CustomPaint(painter: KillChainPainter(_controller.value)),
          ),
        ),

        const SizedBox(height: 20),
        _ExpandableCard(
          Icons.sensors,
          Colors.green,
          "Detect (ตรวจจับ)",
          "เซ็นเซอร์ตรวจจับโดรน:\n\n"
              "• RF Sensor - ตรวจจับสัญญาณควบคุม\n"
              "• Radar - ตรวจจับวัตถุบินขนาดเล็ก\n"
              "• Acoustic - ตรวจจับเสียงใบพัด\n"
              "• EO/IR - กล้องและความร้อน",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.track_changes,
          Colors.amber,
          "Track & Identify (ติดตามและระบุ)",
          "การติดตามและจำแนกประเภท:\n\n"
              "• Sensor Fusion - รวมข้อมูลหลายเซ็นเซอร์\n"
              "• RF Fingerprinting - ระบุรุ่นจากลายเซ็น\n"
              "• Visual AI - จำแนกจากภาพ\n"
              "• Protocol Analysis - วิเคราะห์โปรโตคอล",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.dangerous,
          Colors.red,
          "Neutralize (ทำลาย)",
          "วิธีการต่อต้าน:\n\n"
              "• RF Jamming - รบกวนสัญญาณควบคุม\n"
              "• GPS Jamming/Spoofing - รบกวนนำร่อง\n"
              "• Kinetic - ยิงตก\n"
              "• Protocol Takeover - ยึดควบคุม\n"
              "• Net/Laser - ดักจับ/เผาไหม้",
        ),

        const SizedBox(height: 20),
        _Box(
          title: "⚠️ ข้อพึงระวัง",
          desc:
              "• การ Jam 2.4 GHz อาจกระทบ Wi-Fi พลเรือน\n"
              "• GPS Jamming มีผลต่อระบบอื่นด้วย\n"
              "• ต้องระบุ Friend/Foe ก่อนต่อต้าน\n"
              "• โดรน Failsafe อาจ RTH, Hover, หรือ Land",
          color: Colors.orange,
        ),
      ],
    );
  }
}

// ==========================================
// LESSON 8: GPS Warfare
// ==========================================
class Lesson8_GPS extends StatefulWidget {
  const Lesson8_GPS({super.key});
  @override
  State<Lesson8_GPS> createState() => _Lesson8_GPSState();
}

class _Lesson8_GPSState extends State<Lesson8_GPS>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header("8. GPS Warfare", Colors.green),
        const SizedBox(height: 15),
        _Text(
          "ระบบ GPS เป็นโครงสร้างพื้นฐานสำคัญทั้งพลเรือนและทหาร "
          "การรบกวนและป้องกัน GPS จึงเป็นส่วนสำคัญของ EW สมัยใหม่",
        ),

        const SizedBox(height: 20),
        _SubHeader("ความถี่ GPS", Colors.green),
        const SizedBox(height: 15),

        _Box(
          title: "ความถี่สัญญาณ GPS",
          desc:
              "L1: 1575.42 MHz - C/A Code (พลเรือน)\n"
              "L2: 1227.60 MHz - P(Y) Code (ทหาร)\n"
              "L5: 1176.45 MHz - Safety-of-Life\n\n"
              "⚠️ สัญญาณจากดาวเทียมอ่อนมาก (~-130 dBm)\n"
              "ทำให้ง่ายต่อการถูกรบกวน",
          color: Colors.green,
        ),

        const SizedBox(height: 20),
        _SubHeader("GPS Jamming vs Spoofing", Colors.white),
        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.signal_wifi_off, color: Colors.red, size: 40),
                    SizedBox(height: 8),
                    Text(
                      "Jamming",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "ส่งเสียงรบกวน\nทำให้ GPS ใช้งานไม่ได้\n'ไม่มีสัญญาณ'",
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.purple.withOpacity(0.5)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.gps_not_fixed, color: Colors.purple, size: 40),
                    SizedBox(height: 8),
                    Text(
                      "Spoofing",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "ส่งสัญญาณ GPS ปลอม\nหลอกให้เชื่อตำแหน่งผิด\nอันตรายกว่า Jamming",
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        _SubHeader("การป้องกัน GPS", Colors.white),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.security,
          Colors.blue,
          "Anti-Jam Techniques",
          "เทคนิคต้านการรบกวน:\n\n"
              "• CRPA (Controlled Reception Pattern Antenna)\n"
              "  สร้าง Null ไปยังทิศทาง Jammer\n"
              "• Saasm (Selective Availability Anti-Spoofing Module)\n"
              "  รหัสทหารที่ยากต่อการ Spoof\n"
              "• INS Integration\n"
              "  ใช้ร่วมกับระบบนำร่องเฉื่อย",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.my_location,
          Colors.teal,
          "Alternative Navigation",
          "ระบบนำร่องทดแทน:\n\n"
              "• GLONASS (รัสเซีย)\n"
              "• BeiDou (จีน)\n"
              "• Galileo (ยุโรป)\n"
              "• eLoran - ระบบภาคพื้น\n"
              "• INS - Inertial Navigation",
        ),

        const SizedBox(height: 20),
        _Box(
          title: "กรณีศึกษา: Spoofing",
          desc:
              "• 2011: Iran ยึด RQ-170 Sentinel ด้วย GPS Spoofing\n"
              "• 2017: Black Sea เรือ 20+ ลำรายงานตำแหน่งผิด\n"
              "• 2019: Tel Aviv Airport ถูก Spoof จากซีเรีย\n"
              "• 2022-ปัจจุบัน: Ukraine ใช้ GPS Jamming ป้องกัน",
          color: Colors.amber,
        ),
      ],
    );
  }
}

// ==========================================
// LESSON 9: กรณีศึกษา EW
// ==========================================
class Lesson9_CaseStudies extends StatelessWidget {
  const Lesson9_CaseStudies({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header("9. กรณีศึกษา EW", Colors.deepPurple),
        const SizedBox(height: 15),
        _Text(
          "เรียนรู้จากเหตุการณ์และปฏิบัติการ EW ในประวัติศาสตร์ "
          "เพื่อทำความเข้าใจการประยุกต์ใช้ในสถานการณ์จริง",
        ),

        const SizedBox(height: 20),
        _CaseStudyCard(
          title: "Operation Mole Cricket 19 (1982)",
          subtitle: "Israeli SEAD ในเลบานอน",
          content:
              "อิสราเอลใช้ UAV เป็นเป้าลวงให้ซีเรียเปิดเรดาร์ SAM\n"
              "จากนั้นใช้ F-4 Phantom ยิง AGM-78 และ AGM-45\n"
              "ผลลัพธ์: ทำลาย SAM Site 19 แห่ง ภายใน 2 ชม.\n\n"
              "บทเรียน: การผสมผสาน ESM, ECM, และ Kinetic",
          color: Colors.blue,
          year: "1982",
        ),
        const SizedBox(height: 15),

        _CaseStudyCard(
          title: "Desert Storm - E/A-6B Prowler",
          subtitle: "Airborne EW ในสงครามอ่าว",
          content:
              "E/A-6B Prowler ทำหน้าที่ Stand-Off Jamming\n"
              "ใช้ ALQ-99 Jamming Pod รบกวนเรดาร์อิรัก\n"
              "ผลลัพธ์: Coalition Air Superiority ภายใน 48 ชม.\n\n"
              "บทเรียน: Airborne EW เป็น Force Multiplier",
          color: Colors.amber,
          year: "1991",
        ),
        const SizedBox(height: 15),

        _CaseStudyCard(
          title: "Krasukha-4 ในซีเรีย",
          subtitle: "Russian EW Deployment",
          content:
              "รัสเซียนำ Krasukha-4 มาใช้ในซีเรีย\n"
              "รบกวน AWACS, ดาวเทียม, และ UAV\n"
              "ระยะทำการ: 150-300 km\n\n"
              "บทเรียน: Ground-Based EW ยังมีความสำคัญ",
          color: Colors.red,
          year: "2015+",
        ),
        const SizedBox(height: 15),

        _CaseStudyCard(
          title: "Ukraine-Russia EW War",
          subtitle: "Modern EW in Peer Conflict",
          content:
              "ทั้งสองฝ่ายใช้ EW อย่างเข้มข้น:\n"
              "• R-330Zh Zhitel - Russian COMINT/Jamming\n"
              "• Khibiny - Russian Airborne ECM\n"
              "• Ukraine Drone ปรับใช้ FHSS หนี Jamming\n"
              "• GPS Jamming/Spoofing ทั้งสองฝ่าย\n\n"
              "บทเรียน: EW เป็นส่วนสำคัญของ Modern Warfare",
          color: Colors.orange,
          year: "2022+",
        ),
        const SizedBox(height: 15),

        _CaseStudyCard(
          title: "Commercial Drone Threats",
          subtitle: "C-UAS Challenges",
          content:
              "• 2019: Aramco ถูกโจมตีด้วยโดรน (Saudi Arabia)\n"
              "• 2020: Nagorno-Karabakh - TB2 UAV\n"
              "• 2023: Airports ถูก Shut Down จากโดรน\n\n"
              "บทเรียน: C-UAS EW เป็นสิ่งจำเป็นทุกระดับ",
          color: Colors.cyan,
          year: "2019+",
        ),

        const SizedBox(height: 20),
        _Box(
          title: "สรุปบทเรียน",
          desc:
              "1. EW เป็น Force Multiplier ไม่ใช่ Stand-Alone\n"
              "2. ต้องผสมผสาน ESM-ECM-EPM อย่างเหมาะสม\n"
              "3. ข้าศึกปรับตัวตลอด → ต้องพัฒนาต่อเนื่อง\n"
              "4. Training และ Doctrine สำคัญเท่าอุปกรณ์\n"
              "5. Spectrum Awareness คือกุญแจสู่ชัยชนะ",
          color: Colors.deepPurple,
        ),
      ],
    );
  }
}

Widget _CaseStudyCard({
  required String title,
  required String subtitle,
  required String content,
  required Color color,
  required String year,
}) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                year,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(color: Colors.white10),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}

// ==========================================
// CUSTOM PAINTERS FOR ANIMATIONS
// ==========================================

class ESMProcessPainter extends CustomPainter {
  final double progress;
  ESMProcessPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw radar sweep
    final sweepPaint = Paint()
      ..color = Colors.amber.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 80),
      -pi / 2 + progress * 2 * pi,
      pi / 4,
      true,
      sweepPaint,
    );

    // Draw concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        i * 25.0,
        Paint()
          ..color = Colors.amber.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // Draw detected signals
    final signalPositions = [
      const Offset(0.7, 0.3),
      const Offset(0.2, 0.6),
      const Offset(0.8, 0.7),
    ];

    for (int i = 0; i < signalPositions.length; i++) {
      final pos = Offset(
        size.width * signalPositions[i].dx,
        size.height * signalPositions[i].dy,
      );

      // Pulse effect
      double pulse = sin((progress + i * 0.3) * 2 * pi) * 0.5 + 0.5;

      canvas.drawCircle(
        pos,
        8 + pulse * 4,
        Paint()..color = Colors.red.withOpacity(0.3 + pulse * 0.4),
      );
      canvas.drawCircle(pos, 5, Paint()..color = Colors.red);
    }

    // Center station
    canvas.drawCircle(center, 10, Paint()..color = Colors.amber);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DFTriangulationPainter extends CustomPainter {
  final double progress;
  DFTriangulationPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Three DF stations
    final stations = [
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.2),
    ];

    // Target position
    final target = Offset(size.width * 0.5, size.height * 0.5);

    // Draw lines from stations to target
    final linePaint = Paint()
      ..color = Colors.green.withOpacity(0.5)
      ..strokeWidth = 2;

    for (var station in stations) {
      canvas.drawLine(station, target, linePaint);
    }

    // Draw stations
    for (var station in stations) {
      canvas.drawCircle(station, 8, Paint()..color = Colors.green);
    }

    // Animated target indicator
    double pulse = sin(progress * 2 * pi) * 0.5 + 0.5;
    canvas.drawCircle(
      target,
      10 + pulse * 5,
      Paint()..color = Colors.red.withOpacity(0.3 + pulse * 0.4),
    );
    canvas.drawCircle(target, 6, Paint()..color = Colors.red);

    // Draw labels
    _drawText(
      canvas,
      "DF-1",
      stations[0] + const Offset(-15, 15),
      Colors.green,
    );
    _drawText(
      canvas,
      "DF-2",
      stations[1] + const Offset(-15, 15),
      Colors.green,
    );
    _drawText(
      canvas,
      "DF-3",
      stations[2] + const Offset(-15, -20),
      Colors.green,
    );
    _drawText(canvas, "Target", target + const Offset(-20, 15), Colors.red);
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

class JammingVisualizerPainter extends CustomPainter {
  final double progress;
  final int type; // 0=spot, 1=barrage, 2=sweep

  JammingVisualizerPainter(this.progress, this.type);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw frequency axis
    canvas.drawLine(
      Offset(20, size.height - 20),
      Offset(size.width - 20, size.height - 20),
      Paint()
        ..color = Colors.white24
        ..strokeWidth = 1,
    );

    // Draw target signal
    double targetX = size.width * 0.5;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(targetX, size.height / 2),
        width: 20,
        height: size.height * 0.6,
      ),
      Paint()..color = Colors.red.withOpacity(0.5),
    );

    // Draw jamming based on type
    switch (type) {
      case 0: // Spot
        double jamX = targetX;
        double pulse = sin(progress * 4 * pi) * 0.3 + 0.7;
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(jamX, size.height / 2),
            width: 25,
            height: size.height * 0.8 * pulse,
          ),
          Paint()..color = Colors.blue.withOpacity(0.7),
        );
        break;

      case 1: // Barrage
        for (double x = 50; x < size.width - 50; x += 30) {
          double pulse = sin((progress * 2 * pi) + (x / 50)) * 0.3 + 0.5;
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(x, size.height / 2),
              width: 25,
              height: size.height * 0.5 * pulse,
            ),
            Paint()..color = Colors.blue.withOpacity(0.4),
          );
        }
        break;

      case 2: // Sweep
        double sweepX = 50 + (progress * (size.width - 100));
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(sweepX, size.height / 2),
            width: 30,
            height: size.height * 0.7,
          ),
          Paint()..color = Colors.blue.withOpacity(0.8),
        );
        break;
    }

    // Labels
    _drawText(
      canvas,
      "Freq →",
      Offset(size.width - 50, size.height - 10),
      Colors.white54,
    );
    _drawText(
      canvas,
      "Target",
      Offset(targetX - 20, size.height - 10),
      Colors.red,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(color: color, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FHSSVisualizerPainter extends CustomPainter {
  final double progress;
  FHSSVisualizerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Frequency channels
    final channels = [0.2, 0.4, 0.6, 0.8, 0.3, 0.7, 0.5, 0.9];
    int currentChannel =
        (progress * channels.length * 3).toInt() % channels.length;

    // Draw channel grid
    for (int i = 0; i < 10; i++) {
      double y = size.height * (i + 1) / 11;
      canvas.drawLine(
        Offset(20, y),
        Offset(size.width - 20, y),
        Paint()
          ..color = Colors.green.withOpacity(0.1)
          ..strokeWidth = 1,
      );
    }

    // Draw hopping pattern
    for (int i = 0; i < channels.length; i++) {
      double x = 40 + (i * (size.width - 80) / (channels.length - 1));
      double y = size.height * (1 - channels[i]);

      bool isCurrent = i == currentChannel;

      canvas.drawCircle(
        Offset(x, y),
        isCurrent ? 12 : 6,
        Paint()
          ..color = isCurrent ? Colors.green : Colors.green.withOpacity(0.3),
      );

      if (i > 0) {
        double prevX =
            40 + ((i - 1) * (size.width - 80) / (channels.length - 1));
        double prevY = size.height * (1 - channels[i - 1]);
        canvas.drawLine(
          Offset(prevX, prevY),
          Offset(x, y),
          Paint()
            ..color = Colors.green.withOpacity(0.3)
            ..strokeWidth = 1,
        );
      }
    }

    // Label
    _drawText(
      canvas,
      "FHSS: ${currentChannel + 1}/8",
      const Offset(10, 10),
      Colors.green,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 12,
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

class DroneFrequencyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Frequency bands
    final bands = [
      {
        'label': 'GPS L1',
        'pos': 0.15,
        'color': Colors.green,
        'freq': '1.5 GHz',
      },
      {
        'label': '2.4 GHz',
        'pos': 0.4,
        'color': Colors.cyan,
        'freq': 'RC Control',
      },
      {
        'label': '5.8 GHz',
        'pos': 0.7,
        'color': Colors.orange,
        'freq': 'FPV Video',
      },
    ];

    // Draw axis
    canvas.drawLine(
      Offset(20, size.height - 30),
      Offset(size.width - 20, size.height - 30),
      Paint()
        ..color = Colors.white24
        ..strokeWidth = 2,
    );

    // Draw bands
    for (var band in bands) {
      double x = 20 + (band['pos'] as double) * (size.width - 40);
      Color color = band['color'] as Color;

      // Band rectangle
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, size.height / 2),
          width: 50,
          height: size.height * 0.5,
        ),
        Paint()..color = color.withOpacity(0.3),
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, size.height / 2),
          width: 50,
          height: size.height * 0.5,
        ),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      // Labels
      _drawText(canvas, band['label'] as String, Offset(x - 20, 5), color);
      _drawText(
        canvas,
        band['freq'] as String,
        Offset(x - 25, size.height - 20),
        Colors.white54,
      );
    }
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class KillChainPainter extends CustomPainter {
  final double progress;
  KillChainPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final steps = ['Detect', 'Track', 'Identify', 'Neutralize'];
    final colors = [Colors.green, Colors.amber, Colors.cyan, Colors.red];

    double stepWidth = (size.width - 40) / steps.length;
    int activeStep = (progress * steps.length).toInt() % steps.length;

    for (int i = 0; i < steps.length; i++) {
      double x = 20 + stepWidth * i + stepWidth / 2;
      double y = size.height / 2;

      bool isActive = i == activeStep;

      // Circle
      canvas.drawCircle(
        Offset(x, y),
        isActive ? 25 : 20,
        Paint()..color = colors[i].withOpacity(isActive ? 1.0 : 0.3),
      );

      // Arrow
      if (i < steps.length - 1) {
        canvas.drawLine(
          Offset(x + 25, y),
          Offset(x + stepWidth - 25, y),
          Paint()
            ..color = Colors.white24
            ..strokeWidth = 2,
        );
      }

      // Label
      _drawText(canvas, steps[i], Offset(x - 25, y + 30), colors[i]);
    }
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
// LESSON 10: RADAR SYSTEMS
// ==========================================
class Lesson10_Radar extends StatefulWidget {
  const Lesson10_Radar({super.key});
  @override
  State<Lesson10_Radar> createState() => _Lesson10_RadarState();
}

class _Lesson10_RadarState extends State<Lesson10_Radar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedRadarType = 0;

  final List<Map<String, dynamic>> _radarTypes = [
    {
      'name': 'Pulse Radar',
      'desc': 'ส่ง Pulse สั้น วัดระยะจากเวลาสะท้อนกลับ',
      'icon': Icons.radio_button_checked,
      'color': Colors.cyan,
    },
    {
      'name': 'Doppler Radar',
      'desc': 'ตรวจจับความเร็วจาก Doppler Shift',
      'icon': Icons.speed,
      'color': Colors.orange,
    },
    {
      'name': 'Pulse-Doppler',
      'desc': 'ผสมผสาน Pulse + Doppler ได้ทั้งระยะและความเร็ว',
      'icon': Icons.radar,
      'color': Colors.purple,
    },
    {
      'name': 'SAR',
      'desc': 'Synthetic Aperture - สร้างภาพความละเอียดสูง',
      'icon': Icons.satellite_alt,
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header("10. ระบบเรดาร์ (Radar Systems)", Colors.cyan),
        const SizedBox(height: 15),
        _Text(
          "RADAR = RAdio Detection And Ranging\n"
          "การใช้คลื่นวิทยุตรวจจับตำแหน่งและระยะทางของเป้าหมาย",
        ),

        const SizedBox(height: 20),
        _SubHeader("หลักการพื้นฐาน", Colors.white),
        const SizedBox(height: 15),

        // Radar Basic Animation
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.cyan.withOpacity(0.5)),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (c, _) => CustomPaint(
              painter: RadarBasicPainter(_controller.value),
            ),
          ),
        ),

        const SizedBox(height: 15),
        _Box(
          title: "สมการเรดาร์ (Radar Equation)",
          desc:
              "Pr = (Pt × Gt × Gr × σ × λ²) / ((4π)³ × R⁴)\n\n"
              "Pr = กำลังรับ | Pt = กำลังส่ง\n"
              "Gt, Gr = Gain เสา | σ = RCS เป้าหมาย\n"
              "λ = ความยาวคลื่น | R = ระยะทาง",
          color: Colors.cyan,
        ),

        const SizedBox(height: 25),
        _SubHeader("ประเภทเรดาร์", Colors.cyan),
        const SizedBox(height: 15),

        // Radar Type Selector
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _radarTypes.asMap().entries.map((entry) {
              final index = entry.key;
              final radar = entry.value;
              final isSelected = index == _selectedRadarType;
              final color = radar['color'] as Color;

              return GestureDetector(
                onTap: () => setState(() => _selectedRadarType = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.3) : Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? color : Colors.white24,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        radar['icon'] as IconData,
                        color: isSelected ? color : Colors.white54,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        radar['name'] as String,
                        style: TextStyle(
                          color: isSelected ? color : Colors.white54,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 15),

        // Radar Type Visualization
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: (_radarTypes[_selectedRadarType]['color'] as Color).withOpacity(0.5),
            ),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (c, _) => CustomPaint(
              painter: RadarTypePainter(_controller.value, _selectedRadarType),
            ),
          ),
        ),

        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (_radarTypes[_selectedRadarType]['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (_radarTypes[_selectedRadarType]['color'] as Color).withOpacity(0.5),
            ),
          ),
          child: Text(
            _radarTypes[_selectedRadarType]['desc'] as String,
            style: TextStyle(
              color: _radarTypes[_selectedRadarType]['color'] as Color,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 25),
        _SubHeader("พารามิเตอร์สำคัญ", Colors.white),
        const SizedBox(height: 15),

        _ExpandableCard(
          Icons.timer,
          Colors.blue,
          "PRF (Pulse Repetition Freq)",
          "อัตราการส่ง Pulse ต่อวินาที\n\n"
              "• PRF สูง → อัตรา Update สูง, ระยะสั้น\n"
              "• PRF ต่ำ → ระยะไกล, อัตรา Update ต่ำ\n"
              "• Ru (Unambiguous Range) = c / (2 × PRF)\n\n"
              "ตัวอย่าง: PRF = 1 kHz → Ru = 150 km",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.straighten,
          Colors.green,
          "Pulse Width (τ)",
          "ความกว้าง Pulse\n\n"
              "• Pulse กว้าง → พลังงานมาก, Range Resolution แย่\n"
              "• Pulse แคบ → Range Resolution ดี, พลังงานน้อย\n"
              "• Range Resolution = c × τ / 2\n\n"
              "ตัวอย่าง: τ = 1 μs → Resolution = 150 m",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.aspect_ratio,
          Colors.orange,
          "RCS (Radar Cross Section)",
          "พื้นที่หน้าตัดสะท้อนเรดาร์ของเป้าหมาย (หน่วย: m²)\n\n"
              "• เครื่องบินลำใหญ่: 100 m²\n"
              "• เครื่องบินรบ: 1-10 m²\n"
              "• Stealth Fighter: 0.001-0.01 m²\n"
              "• นก: 0.01 m²\n"
              "• คน: 1 m²",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.waves,
          Colors.purple,
          "Doppler Shift",
          "การเปลี่ยนความถี่เนื่องจากความเร็วสัมพัทธ์\n\n"
              "• fd = 2 × v × f / c\n"
              "• v = ความเร็วเป้าหมาย\n"
              "• f = ความถี่เรดาร์\n\n"
              "ใช้แยก Moving Target จาก Clutter (MTI)",
        ),

        const SizedBox(height: 25),
        _SubHeader("เรดาร์ทางทหาร", Colors.white),
        const SizedBox(height: 15),

        _buildMilitaryRadarTable(),

        const SizedBox(height: 25),
        _SubHeader("Radar Clutter & Countermeasures", Colors.redAccent),
        const SizedBox(height: 15),

        _ExpandableCard(
          Icons.landscape,
          Colors.brown,
          "Clutter (สิ่งรบกวน)",
          "สัญญาณที่ไม่ต้องการสะท้อนกลับ:\n\n"
              "• Ground Clutter: ภูมิประเทศ, อาคาร\n"
              "• Sea Clutter: คลื่นทะเล\n"
              "• Weather Clutter: ฝน, เมฆ\n"
              "• Chaff: แถบโลหะจากข้าศึก",
        ),
        const SizedBox(height: 10),

        _ExpandableCard(
          Icons.security,
          Colors.green,
          "ECCM ของเรดาร์",
          "เทคนิคต้านทาน Jamming:\n\n"
              "• Frequency Agility - เปลี่ยนความถี่ทุก Pulse\n"
              "• Pulse Compression - เพิ่ม SNR\n"
              "• Sidelobe Blanking - ตัด Sidelobe\n"
              "• Adaptive Beamforming - Null ทิศทาง Jammer\n"
              "• Home-on-Jam (HOJ) - ติดตาม Jammer",
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMilitaryRadarTable() {
    final radars = [
      {
        'name': 'AN/APG-77 (F-22)',
        'type': 'AESA Multifunction',
        'range': '400+ km',
        'band': 'X-Band',
      },
      {
        'name': 'AN/SPY-1 (Aegis)',
        'type': 'Phased Array',
        'range': '500+ km',
        'band': 'S-Band',
      },
      {
        'name': 'SA-6 Gainful',
        'type': 'SAM Fire Control',
        'range': '28 km',
        'band': 'H/I-Band',
      },
      {
        'name': 'JY-27',
        'type': 'VHF Early Warning',
        'range': '500 km',
        'band': 'VHF',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9),
                topRight: Radius.circular(9),
              ),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('ระบบ', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('ระยะ', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Band', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          ...radars.map((radar) => Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        radar['name']!,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        radar['type']!,
                        style: const TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    radar['range']!,
                    style: const TextStyle(color: Colors.cyan, fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    radar['band']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
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

// Radar Basic Painter - แสดงหลักการพื้นฐาน
class RadarBasicPainter extends CustomPainter {
  final double progress;
  RadarBasicPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.2, size.height / 2);
    final targetPos = Offset(size.width * 0.75, size.height / 2);

    // Draw radar station
    canvas.drawCircle(center, 15, Paint()..color = Colors.cyan);
    canvas.drawCircle(
      center,
      20,
      Paint()
        ..color = Colors.cyan.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Draw target
    canvas.drawCircle(targetPos, 12, Paint()..color = Colors.red);

    // Animate pulse
    double pulseX = center.dx + (targetPos.dx - center.dx) * (progress % 0.5) * 2;
    double returnX = targetPos.dx - (targetPos.dx - center.dx) * ((progress - 0.5).clamp(0, 0.5) * 2);

    if (progress < 0.5) {
      // Outgoing pulse
      canvas.drawCircle(
        Offset(pulseX, size.height / 2),
        8,
        Paint()..color = Colors.cyan.withOpacity(0.8),
      );

      // Draw beam
      final beamPaint = Paint()
        ..color = Colors.cyan.withOpacity(0.2)
        ..style = PaintingStyle.fill;
      final beamPath = Path()
        ..moveTo(center.dx, center.dy - 20)
        ..lineTo(pulseX, size.height / 2 - 30)
        ..lineTo(pulseX, size.height / 2 + 30)
        ..lineTo(center.dx, center.dy + 20)
        ..close();
      canvas.drawPath(beamPath, beamPaint);
    } else {
      // Returning echo
      canvas.drawCircle(
        Offset(returnX, size.height / 2),
        6,
        Paint()..color = Colors.green.withOpacity(0.8),
      );
    }

    // Labels
    _drawText(canvas, "Tx/Rx", center + const Offset(-12, 25), Colors.cyan);
    _drawText(canvas, "Target", targetPos + const Offset(-15, 20), Colors.red);

    // Distance indicator
    canvas.drawLine(
      Offset(center.dx, size.height - 20),
      Offset(targetPos.dx, size.height - 20),
      Paint()
        ..color = Colors.white24
        ..strokeWidth = 1,
    );
    _drawText(
      canvas,
      "R = c × t / 2",
      Offset(size.width / 2 - 30, size.height - 15),
      Colors.white54,
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Radar Type Painter - แสดงประเภทเรดาร์ต่างๆ
class RadarTypePainter extends CustomPainter {
  final double progress;
  final int type;
  RadarTypePainter(this.progress, this.type);

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case 0:
        _drawPulseRadar(canvas, size);
        break;
      case 1:
        _drawDopplerRadar(canvas, size);
        break;
      case 2:
        _drawPulseDoppler(canvas, size);
        break;
      case 3:
        _drawSAR(canvas, size);
        break;
    }
  }

  void _drawPulseRadar(Canvas canvas, Size size) {
    // Draw time axis
    canvas.drawLine(
      Offset(20, size.height - 20),
      Offset(size.width - 20, size.height - 20),
      Paint()..color = Colors.white24..strokeWidth = 1,
    );

    // Draw pulses
    for (int i = 0; i < 4; i++) {
      double x = 50 + i * 80;
      double pulseHeight = size.height * 0.6;

      // Moving pulse animation
      double offset = ((progress * 4 + i) % 4) * 20 - 40;

      canvas.drawRect(
        Rect.fromLTWH(x + offset, size.height - 20 - pulseHeight, 15, pulseHeight),
        Paint()..color = Colors.cyan.withOpacity(0.7),
      );
    }

    _drawText(canvas, "Pulse Radar - ส่ง Pulse วัดเวลาสะท้อน", Offset(20, 10), Colors.cyan);
    _drawText(canvas, "Time →", Offset(size.width - 60, size.height - 15), Colors.white54);
  }

  void _drawDopplerRadar(Canvas canvas, Size size) {
    final centerY = size.height / 2;

    // Draw continuous wave
    final path = Path();
    for (double x = 20; x < size.width - 20; x++) {
      double freqShift = x > size.width / 2 ? 1.5 : 1.0; // Doppler shift
      double y = centerY + sin((x / 20 + progress * 10) * freqShift) * 30;
      if (x == 20) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Frequency shift indicator
    canvas.drawLine(
      Offset(size.width / 2, 20),
      Offset(size.width / 2, size.height - 20),
      Paint()..color = Colors.white24..strokeWidth = 1,
    );

    _drawText(canvas, "CW Doppler - ตรวจจับความเร็ว", Offset(20, 10), Colors.orange);
    _drawText(canvas, "Tx Freq", Offset(30, size.height - 35), Colors.white54);
    _drawText(canvas, "Shifted", Offset(size.width - 70, size.height - 35), Colors.orange);
  }

  void _drawPulseDoppler(Canvas canvas, Size size) {
    // Draw range-doppler matrix
    int cols = 6;
    int rows = 4;
    double cellW = (size.width - 60) / cols;
    double cellH = (size.height - 50) / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        double x = 30 + c * cellW;
        double y = 25 + r * cellH;

        // Highlight some cells as targets
        bool isTarget = (r == 1 && c == 3) || (r == 2 && c == 4);
        double pulse = sin((progress * 4 + r + c) * pi) * 0.5 + 0.5;

        canvas.drawRect(
          Rect.fromLTWH(x, y, cellW - 2, cellH - 2),
          Paint()
            ..color = isTarget
                ? Colors.purple.withOpacity(0.5 + pulse * 0.5)
                : Colors.purple.withOpacity(0.1),
        );
      }
    }

    _drawText(canvas, "Range-Doppler Matrix", Offset(20, 5), Colors.purple);
    _drawText(canvas, "Range →", Offset(size.width - 70, size.height - 15), Colors.white54);
    _drawText(canvas, "Velocity ↑", Offset(5, size.height / 2), Colors.white54);
  }

  void _drawSAR(Canvas canvas, Size size) {
    // Draw aircraft path
    double aircraftY = 30;
    double aircraftX = 30 + progress * (size.width - 60);

    canvas.drawCircle(
      Offset(aircraftX, aircraftY),
      8,
      Paint()..color = Colors.green,
    );

    // Draw synthetic aperture
    canvas.drawLine(
      Offset(30, aircraftY),
      Offset(aircraftX, aircraftY),
      Paint()
        ..color = Colors.green.withOpacity(0.5)
        ..strokeWidth = 4,
    );

    // Draw imaging beam
    final beamPath = Path()
      ..moveTo(aircraftX, aircraftY + 8)
      ..lineTo(aircraftX - 40, size.height - 20)
      ..lineTo(aircraftX + 40, size.height - 20)
      ..close();
    canvas.drawPath(beamPath, Paint()..color = Colors.green.withOpacity(0.2));

    // Draw ground image pixels
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 4; j++) {
        double x = size.width / 2 - 80 + i * 20;
        double y = size.height - 60 + j * 10;
        double intensity = sin((i + j + progress * 5) * 0.5) * 0.5 + 0.5;

        canvas.drawRect(
          Rect.fromLTWH(x, y, 18, 8),
          Paint()..color = Colors.green.withOpacity(intensity * 0.7),
        );
      }
    }

    _drawText(canvas, "SAR - Synthetic Aperture Radar", Offset(20, 5), Colors.green);
    _drawText(canvas, "Synthetic Aperture", Offset(50, aircraftY + 10), Colors.green);
  }

  void _drawText(Canvas canvas, String text, Offset pos, Color color) {
    TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
