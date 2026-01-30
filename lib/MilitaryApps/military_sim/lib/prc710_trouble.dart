import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Prc710TroubleScreen extends StatefulWidget {
  const Prc710TroubleScreen({super.key});

  @override
  State<Prc710TroubleScreen> createState() => _Prc710TroubleScreenState();
}

class _Prc710TroubleScreenState extends State<Prc710TroubleScreen> {
  int totalScore = 0;
  int currentScenarioIndex = 0;
  int? selectedAnswer;
  bool answered = false;
  bool isCorrect = false;

  // ฐานข้อมูลอาการเสียของ PRC-710 (เน้น Digital/ECCM)
  final List<Map<String, dynamic>> scenarios = [
    {
      "symptom":
          "หน้าจอแสดงผลปกติ แต่รับ-ส่งสัญญาณกับลูกข่ายไม่ได้เลย (เสียงซ่าตลอด)",
      "options": [
        "แบตเตอรี่อ่อน",
        "ตั้งโหมดใช้งานไม่ตรงกัน (CLR/SEC/AJ)",
        "เสาอากาศหลวม",
        "ลืมเปิดปุ่ม Squelch",
      ],
      "correctIndex": 1,
      "hint":
          "PRC-710 เป็นวิทยุดิจิตอล ถ้าโหมด (Mode) ไม่ตรงกัน จะคุยกันไม่รู้เรื่องเลย",
    },
    {
      "symptom":
          "ใช้งานโหมดกระโดดความถี่ (Hopping) แล้วเสียงขาดๆ หายๆ หรือเงียบไป",
      "options": [
        "เวลา (TOD) ของเครื่องไม่ตรงกัน (Time Sync หลุด)",
        "ลำโพงเสีย",
        "ความถี่วิทยุต่ำเกินไป",
        "ต้องเปลี่ยนแบตเตอรี่ใหม่",
      ],
      "correctIndex": 0,
      "hint":
          "โหมด Hopping ต้องอาศัย 'เวลา (Time of Day)' ที่แม่นยำระดับวินาทีในการซิงค์",
    },
    {
      "symptom": "หน้าจอขึ้นเตือน 'ALARM: LOW BATT' และเครื่องดับเองเมื่อกดส่ง",
      "options": [
        "เครื่องร้อนเกินไป",
        "เสาอากาศชอร์ต",
        "แบตเตอรี่ Li-Ion เสื่อมสภาพ/หมดประจุ",
        "ปุ่ม PTT ค้าง",
      ],
      "correctIndex": 2,
      "hint":
          "เมื่อกดคีย์ส่ง (PTT) จะกินกระแสสูง ถ้าแบตเสื่อม แรงดันจะตกวูบทันที",
    },
    {
      "symptom": "กดปุ่มตั้งความถี่ไม่ได้ หน้าจอขึ้นรูป 'กุญแจ' (Key Icon)",
      "options": [
        "เครื่องเสีย (Keypad Failure)",
        "ติดล็อคปุ่มกด (Keypad Lock)",
        "ใส่รหัสผ่านผิด",
        "โหมดโปรแกรมขัดข้อง",
      ],
      "correctIndex": 1,
      "hint":
          "ให้กดปุ่มปลดล็อค (มักจะเป็นปุ่ม Light หรือปุ่มเฉพาะ) ค้างไว้เพื่อปลดล็อค",
    },
    {
      "symptom": "ต้องการล้างข้อมูลความถี่และรหัสลับทั้งหมดทันที (Emergency)",
      "options": [
        "ถอดแบตเตอรี่ออกทันที",
        "ทุบทำลายเครื่อง",
        "กดปุ่ม ZEROIZE (Z)",
        "ปิดเครื่องแล้วเปิดใหม่",
      ],
      "correctIndex": 2,
      "hint":
          "ปุ่ม ZEROIZE ออกแบบมาเพื่อลบข้อมูลความลับทางทหารทิ้งทันทีเมื่อจวนตัว",
    },
  ];

  void checkAnswer(int index) {
    if (answered) return;
    setState(() {
      selectedAnswer = index;
      answered = true;
      isCorrect = (index == scenarios[currentScenarioIndex]['correctIndex']);
      if (isCorrect) totalScore += 20; // ข้อละ 20 คะแนน (5 ข้อ = 100)
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
        ? "ผู้เชี่ยวชาญ (EXPERT)"
        : (totalScore >= 60 ? "ผ่านเกณฑ์ (PASSED)" : "ควรฝึกฝนใหม่ (RETRY)");

    Color rankColor =
        totalScore >= 80 ? const Color(0xFF00FF41) : Colors.orange;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: rankColor, width: 2)),
        title: Text(
          "EVALUATION REPORT",
          style: GoogleFonts.blackOpsOne(color: Colors.white, fontSize: 22),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            Text("$totalScore / 100",
                style: GoogleFonts.blackOpsOne(color: rankColor, fontSize: 48)),
            const SizedBox(height: 10),
            Text("ผลการประเมิน:",
                style: GoogleFonts.sarabun(color: Colors.white70)),
            Text(rank,
                style: GoogleFonts.sarabun(
                    color: rankColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // ปิด Dialog
                  Navigator.pop(context); // ออกจากหน้านี้
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
                    backgroundColor: rankColor, foregroundColor: Colors.black),
                child: const Text("RETAKE"),
              ),
            ],
          )
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
        title: Text("TROUBLESHOOTING (710)",
            style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41))),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00FF41)),
                    borderRadius: BorderRadius.circular(5)),
                child: Text("SCORE: $totalScore",
                    style: GoogleFonts.blackOpsOne(
                        fontSize: 14, color: const Color(0xFF00FF41))),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: (currentScenarioIndex + 1) / scenarios.length,
                backgroundColor: Colors.grey[900],
                color: const Color(0xFF00FF41),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 20),

            // Symptom Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF001500),
                border: Border.all(color: const Color(0xFF00FF41), width: 1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF00FF41).withOpacity(0.1),
                      blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 40),
                  const SizedBox(height: 10),
                  Text("SYMPTOM DETECTED:",
                      style: GoogleFonts.blackOpsOne(
                          color: Colors.orange, fontSize: 14)),
                  const SizedBox(height: 5),
                  Text(
                    scenario['symptom'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sarabun(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Options List
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
                                  : 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                scenario['options'][index],
                                style: GoogleFonts.sarabun(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                            if (icon != null) Icon(icon, color: borderColor)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Hint & Next Button
            if (answered) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(5)),
                child: Row(children: [
                  const Icon(Icons.lightbulb, color: Colors.yellow, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(scenario['hint'],
                          style: GoogleFonts.sarabun(
                              color: Colors.yellow, fontSize: 12))),
                ]),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: nextScenario,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(
                      currentScenarioIndex < scenarios.length - 1
                          ? "NEXT PROBLEM"
                          : "VIEW REPORT",
                      style: GoogleFonts.blackOpsOne()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF41),
                      foregroundColor: Colors.black),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
