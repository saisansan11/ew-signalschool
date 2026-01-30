import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cnr900TroubleScreen extends StatefulWidget {
  const Cnr900TroubleScreen({super.key});

  @override
  State<Cnr900TroubleScreen> createState() => _Cnr900TroubleScreenState();
}

class _Cnr900TroubleScreenState extends State<Cnr900TroubleScreen> {
  int score = 0;
  int index = 0;
  bool answered = false;
  String? feedback;

  final List<Map<String, dynamic>> questions = [
    {
      "symptom": "หน้าจอขึ้นเตือน 'ALARM: NO KEY' และส่งออกอากาศไม่ได้",
      "options": [
        "แบตเตอรี่หมด",
        "เสาอากาศหลวม",
        "ยังไม่ได้ป้อนรหัสเข้ารหัส (Comsec Key)",
        "เครื่องร้อนเกินไป"
      ],
      "answer": 2,
      "hint":
          "ระบบ Secure ต้องการคีย์รหัส หากไม่มี Key เครื่องจะล็อคการส่งเพื่อความปลอดภัย"
    },
    {
      "symptom": "คุยในโหมด Hopping (AJ) ไม่รู้เรื่อง เสียงขาดหาย",
      "options": [
        "เวลา (Time) ของเครื่องลูกข่ายไม่ตรงกัน",
        "ปรับ Volume เบาไป",
        "ใช้เสาอากาศผิดประเภท",
        "ต้องเปลี่ยนไมค์ใหม่"
      ],
      "answer": 0,
      "hint":
          "โหมดกระโดดความถี่ ต้องอาศัยการซิงค์เวลา (Time Synchronization) ที่แม่นยำ"
    },
    {
      "symptom": "ส่งข้อมูล (Data) ไม่ผ่าน หน้าจอขึ้น 'SYNC FAIL'",
      "options": [
        "สายนำสัญญาณขาด",
        "ตั้งค่า Baud Rate ไม่ตรงกัน",
        "ไฟหน้าจอเสีย",
        "ปุ่ม PTT ค้าง"
      ],
      "answer": 1,
      "hint":
          "การรับส่งข้อมูล ดิจิตอล ความเร็ว (Baud Rate) ทั้งสองฝั่งต้องเท่ากัน"
    },
  ];

  void _checkAnswer(int selected) {
    if (answered) return;
    setState(() {
      answered = true;
      if (selected == questions[index]['answer']) {
        score++;
        feedback = "CORRECT! ถูกต้อง";
      } else {
        feedback = "INCORRECT! ผิดพลาด";
      }
    });
  }

  void _next() {
    if (index < questions.length - 1) {
      setState(() {
        index++;
        answered = false;
        feedback = null;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text("MISSION REPORT",
            style: GoogleFonts.blackOpsOne(color: Colors.white)),
        content: Text("คะแนนของคุณ: $score / ${questions.length}",
            style: GoogleFonts.sarabun(
                color: const Color(0xFF00FF41), fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to menu
            },
            child: const Text("FINISH"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var q = questions[index];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("TROUBLESHOOTING",
            style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41))),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 40),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(q['symptom'],
                        style: GoogleFonts.sarabun(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: q['options'].length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(i),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: answered
                            ? (i == q['answer']
                                ? Colors.green[900]
                                : (feedback == "INCORRECT! ผิดพลาด" &&
                                        i != q['answer']
                                    ? Colors.red[900]
                                    : Colors.grey[900]))
                            : Colors.grey[900],
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        side: BorderSide(
                            color: answered && i == q['answer']
                                ? const Color(0xFF00FF41)
                                : Colors.transparent),
                      ),
                      child: Text(q['options'][i],
                          style: GoogleFonts.sarabun(color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
            if (answered) ...[
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.black,
                child: Row(children: [
                  const Icon(Icons.lightbulb, color: Colors.yellow),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(q['hint'],
                          style: GoogleFonts.sarabun(color: Colors.yellow)))
                ]),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF41)),
                  child: Text(
                      index < questions.length - 1
                          ? "ข้อต่อไป (NEXT)"
                          : "ดูผลลัพธ์ (REPORT)",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
