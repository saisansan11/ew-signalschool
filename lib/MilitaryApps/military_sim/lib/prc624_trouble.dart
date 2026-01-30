import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Prc624TroubleScreen extends StatefulWidget {
  const Prc624TroubleScreen({super.key});

  @override
  State<Prc624TroubleScreen> createState() => _Prc624TroubleScreenState();
}

class _Prc624TroubleScreenState extends State<Prc624TroubleScreen> {
  int totalScore = 0;
  int currentScenarioIndex = 0;
  int? selectedAnswer;
  bool answered = false;
  bool isCorrect = false;

  // ฐานข้อมูลโจทย์ปัญหา (เหมือนเดิม)
  final List<Map<String, dynamic>> scenarios = [
    {
      "symptom":
          "เครื่องเปิดติด หน้าจอปกติ แต่ไม่มีเสียงสัญญาณใดๆ แม้แต่เสียงซ่า (Noise) เมื่อเปิด SQL Off",
      "options": [
        "แบตเตอรี่เสื่อม",
        "ลำโพงภายในหรือชุดหูฟังชำรุด",
        "เสาอากาศหักภายใน",
        "ตั้งช่องความถี่ผิด",
      ],
      "correctIndex": 1,
      "hint": "ถ้า SQL Off แล้วยังเงียบสนิท ปัญหาอยู่ที่ภาคเสียง (Audio Path)",
    },
    {
      "symptom":
          "ส่งสัญญาณออกไปแล้ว เพื่อนตอบกลับมาว่า 'เสียงเบามากและมีเสียงฮัม' (Humming)",
      "options": [
        "แบตเตอรี่อ่อน",
        "พูดห่างไมโครโฟนเกินไป",
        "ฝาครอบช่องเสียบ Audio (U-229) หลวมหรือสกปรก",
        "เสาอากาศผิดขนาด",
      ],
      "correctIndex": 2,
      "hint": "ขั้วต่อที่สกปรกทำให้เกิดความต้านทานและสัญญาณรบกวนในสายไมค์",
    },
    {
      "symptom": "เครื่องร้อนจัดหลังจากกดส่งสัญญาณ (PTT) เพียงไม่กี่ครั้ง",
      "options": [
        "ใช้งานกลางแดด",
        "ค่า VSWR สูง (เสาอากาศชำรุด/ไม่ตรงย่าน)",
        "เปิดระดับเสียงดังเกินไป",
        "แบตเตอรี่ลัดวงจรภายใน",
      ],
      "correctIndex": 1,
      "hint":
          "แรงสะท้อนกลับจากเสาอากาศที่ชำรุดจะย้อนกลับมาเผาภาคส่ง (Final Amp)",
    },
    {
      "symptom": "หน้าจอแสดงตัวเลขความถี่ไม่ครบ (บางขีดหายไป)",
      "options": [
        "ถอดแบตเตอรี่ออกแล้วใส่ใหม่",
        "ส่งซ่อมระดับหน่วย (เปลี่ยนโมดูลหน้าจอ)",
        "เคาะเครื่องแรงๆ",
        "ปรับปุ่ม Volume",
      ],
      "correctIndex": 1,
      "hint":
          "อาการหน้าจอขาดส่วน (Missing Segments) เป็นปัญหาที่ฮาร์ดแวร์ภายใน",
    },
    {
      "symptom":
          "กดปุ่ม FUNCTION แล้วเครื่องไม่ตอบสนอง แต่ปุ่มหมุน Channel ยังใช้งานได้",
      "options": [
        "ปุ่มยางสกปรก/ค้าง",
        "เปิดระบบ Keypad Lock ไว้",
        "เครื่องแฮงค์ (Hang)",
        "แบตเตอรี่ใกล้หมด",
      ],
      "correctIndex": 1,
      "hint": "PRC-624 มีระบบป้องกันการกดปุ่มโดยไม่ตั้งใจ (Lock Symbol บนจอ)",
    },
    {
      "symptom": "รับสัญญาณได้ แต่มีเสียงวี๊ด (Whining) แทรกตลอดเวลา",
      "options": [
        "สายอากาศอยู่ใกล้สายไฟแรงสูง",
        "เครื่องส่งฝั่งตรงข้ามเสีย",
        "วงจรกรองกระแสภายในเสื่อม",
        "ใช้แบตเตอรี่ผิดประเภท",
      ],
      "correctIndex": 2,
      "hint": "เสียงวี๊ดตามจังหวะไฟมักเกิดจากตัวเก็บประจุภายในภาคจ่ายไฟรั่ว",
    },
    {
      "symptom":
          "หมุนปุ่มความถี่แล้ว ตัวเลขบนหน้าจอกระโดดข้ามไปมา ไม่เรียงลำดับ",
      "options": [
        "ปุ่มเลือกช่อง (Encoder) เสีย/สกปรก",
        "ซอฟต์แวร์เครื่องรวน",
        "แบตเตอรี่แรงดันเกิน",
        "ต้องกด reset",
      ],
      "correctIndex": 0,
      "hint": "หน้าสัมผัสภายในปุ่มหมุน (Selector Switch) สึกหรอหรือมีคราบไขมัน",
    },
    {
      "symptom":
          "เครื่องรีเซ็ตตัวเอง (ดับแล้วติดใหม่) ทันทีที่กดส่งสัญญาณ (PTT)",
      "options": [
        "แบตเตอรี่จ่ายกระแสไม่พอ (Voltage Drop)",
        "เสาอากาศชอร์ตลงดิน",
        "ปุ่ม PTT ลัดวงจร",
        "ความถี่ที่ตั้งไว้ไม่ได้รับอนุญาต",
      ],
      "correctIndex": 0,
      "hint": "ภาคส่งใช้ไฟสูงมาก ถ้าแบตเตอรี่เสื่อมแรงดันจะตกจนเครื่องดับ",
    },
    {
      "symptom": "มีกลิ่นไหม้ออกมาจากบริเวณช่องเสียบแบตเตอรี่",
      "options": [
        "ฝุ่นไหม้",
        "ขั้วแบตเตอรี่ลัดวงจร",
        "เครื่องทำงานหนักเกินไป",
        "แบตเตอรี่กำลังชาร์จ",
      ],
      "correctIndex": 1,
      "hint":
          "กลิ่นไหม้ในอุปกรณ์ไฟฟ้าคือสัญญาณอันตรายร้ายแรง ห้ามเปิดเครื่องเด็ดขาด",
    },
    {
      "symptom": "หน้าจอ LCD แสดงข้อความ 'ERR 01' หรือรหัสผิดพลาด",
      "options": [
        "เครื่องติดไวรัส",
        "ตั้งช่องความถี่ซ้ำกัน",
        "ระบบตรวจสอบตัวเองพบความผิดปกติภายใน (Internal Failure)",
        "ลืมใส่เสาอากาศ",
      ],
      "correctIndex": 2,
      "hint": "รหัส Error code หมายถึงจุดเสียเฉพาะที่ต้องใช้ช่างเทคนิคตรวจสอบ",
    },
  ];

  void checkAnswer(int index) {
    if (answered) return;
    setState(() {
      selectedAnswer = index;
      answered = true;
      isCorrect = (index == scenarios[currentScenarioIndex]['correctIndex']);
      if (isCorrect) totalScore += 10;
    });
  }

  void nextScenario() {
    if (currentScenarioIndex < scenarios.length - 1) {
      setState(() {
        currentScenarioIndex++;
        selectedAnswer = null;
        answered = false;
      });
    } else {
      showFinalScore();
    }
  }

  void showFinalScore() {
    String rank = totalScore >= 80
        ? "จ่าสื่อสารมือฉมัง"
        : (totalScore >= 50 ? "สิบตรีชำนาญการ" : "พลทหารฝึกหัด");

    // เปลี่ยนสีตามยศ
    Color rankColor = totalScore >= 80
        ? const Color(0xFF00FF41)
        : Colors.orange;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: rankColor, width: 2),
        ),
        title: Text(
          "INSPECTION REPORT",
          style: GoogleFonts.blackOpsOne(color: Colors.white, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              "$totalScore / 100",
              style: GoogleFonts.blackOpsOne(color: rankColor, fontSize: 48),
            ),
            const SizedBox(height: 10),
            Text(
              "ระดับความสามารถ:",
              style: GoogleFonts.sarabun(color: Colors.white70),
            ),
            Text(
              rank,
              style: GoogleFonts.sarabun(
                color: rankColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("EXIT", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    currentScenarioIndex = 0;
                    totalScore = 0;
                    selectedAnswer = null;
                    answered = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: rankColor,
                  foregroundColor: Colors.black,
                ),
                child: const Text("RETAKE EXAM"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scenario = scenarios[currentScenarioIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "TROUBLESHOOTING",
          style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41)),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00FF41)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "SCORE: $totalScore",
                  style: GoogleFonts.blackOpsOne(
                    fontSize: 14,
                    color: const Color(0xFF00FF41),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress Bar แบบ Sci-Fi
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: (currentScenarioIndex + 1) / scenarios.length,
                backgroundColor: Colors.grey[900],
                color: const Color(0xFF00FF41),
                minHeight: 10,
              ),
            ),

            const SizedBox(height: 20),

            // กล่องโจทย์ปัญหา (Theme Sci-Fi)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.5),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "SYMPTOM DETECTED:",
                    style: GoogleFonts.blackOpsOne(
                      color: Colors.orange,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    scenario['symptom'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sarabun(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // รายการตัวเลือก
            Expanded(
              child: ListView.builder(
                itemCount: scenario['options'].length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedAnswer == index;
                  bool isCorrectAnswer = scenario['correctIndex'] == index;

                  Color borderColor = Colors.grey[800]!;
                  Color bgColor = const Color(0xFF111111);
                  IconData? icon;

                  if (answered) {
                    if (isCorrectAnswer) {
                      borderColor = const Color(0xFF00FF41);
                      bgColor = const Color(0xFF003300);
                      icon = Icons.check_circle;
                    } else if (isSelected) {
                      borderColor = Colors.red;
                      bgColor = const Color(0xFF330000);
                      icon = Icons.cancel;
                    }
                  } else if (isSelected) {
                    borderColor = Colors.cyanAccent;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => checkAnswer(index),
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          border: Border.all(
                            color: borderColor,
                            width: isSelected || (answered && isCorrectAnswer)
                                ? 2
                                : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: borderColor.withOpacity(0.3),
                                    blurRadius: 8,
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                scenario['options'][index],
                                style: GoogleFonts.sarabun(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (icon != null) ...[
                              const SizedBox(width: 10),
                              Icon(icon, color: borderColor),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ส่วนแสดงผลเมื่อตอบแล้ว (เฉลย/ปุ่มถัดไป)
            if (answered) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.yellow,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        scenario['hint'],
                        style: GoogleFonts.sarabun(
                          color: Colors.yellow[200],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: nextScenario,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(
                    currentScenarioIndex < scenarios.length - 1
                        ? "NEXT SCENARIO"
                        : "VIEW FINAL REPORT",
                    style: GoogleFonts.blackOpsOne(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF41),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
