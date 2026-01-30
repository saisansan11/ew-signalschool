import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cnr900tTroubleScreen extends StatefulWidget {
  const Cnr900tTroubleScreen({super.key});

  @override
  State<Cnr900tTroubleScreen> createState() => _Cnr900tTroubleScreenState();
}

class _Cnr900tTroubleScreenState extends State<Cnr900tTroubleScreen> {
  int score = 0;
  int index = 0;
  bool answered = false;
  String? feedback;
  final Color themeColor = Colors.cyanAccent;

  final List<Map<String, dynamic>> questions = [
    {
      "symptom": "ส่งข้อความ (SMS) ไม่สำเร็จ หน้าจอขึ้น 'TX FAIL'",
      "options": [
        "ไม่ได้ต่อเสาอากาศ",
        "อยู่ในโหมด VOICE (ต้องเปลี่ยนเป็น DATA)",
        "แบตเตอรี่เต็ม",
        "ปุ่มกดสกปรก"
      ],
      "answer": 1,
      "hint":
          "การส่งข้อความ ต้องปรับโหมดการทำงานไปที่ 'DATA' หรือ 'MSG' ก่อนเสมอ"
    },
    {
      "symptom": "หน้าจอไม่แสดงพิกัด GPS (ขึ้นว่า GPS SEARCHING... ตลอดเวลา)",
      "options": [
        "อยู่ในอาคาร/จุดอับสัญญาณดาวเทียม",
        "ลืมเปิดเครื่อง",
        "ตั้งความถี่ผิด",
        "ไม่ได้ใส่หูฟัง"
      ],
      "answer": 0,
      "hint":
          "สัญญาณ GPS รับจากดาวเทียม ไม่สามารถทะลุอาคารหนาๆ ได้ ต้องออกไปที่โล่งแจ้ง"
    },
    {
      "symptom": "กดปุ่มตัวเลขไม่ได้เลย หน้าจอขึ้นรูป 'แม่กุญแจ' (Key Lock)",
      "options": ["ปุ่มเสีย", "เครื่องรวน", "ติด Keypad Lock", "โดนไวรัส"],
      "answer": 2,
      "hint":
          "ระบบล็อคปุ่มป้องกันการกดผิด ให้กดปุ่มปลดล็อค (เช่น ปุ่ม Light ค้างไว้ หรือลำดับปุ่มเฉพาะ)"
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
            style: GoogleFonts.sarabun(color: themeColor, fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
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
        title: Text("TROUBLESHOOTING (900T)",
            style: GoogleFonts.blackOpsOne(color: themeColor)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: themeColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF050510),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
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
                                ? themeColor
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
                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
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
