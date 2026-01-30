import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class AssemblyScreen extends StatefulWidget {
  const AssemblyScreen({super.key});

  @override
  State<AssemblyScreen> createState() => _AssemblyScreenState();
}

class _AssemblyScreenState extends State<AssemblyScreen> {
  // ✅ Path 3D
  final String _gh3DBase =
      "https://saisansan11.github.io/military_sim_2026/assets/assets/models/";

  // ขั้นตอนการประกอบ
  final List<Map<String, dynamic>> assemblySteps = [
    {
      'step': 1,
      'instruction': 'ขั้นตอนที่ 1: ติดตั้งแหล่งพลังงาน',
      'hint': 'เลือกชิ้นส่วนที่ให้พลังงาน (Battery)',
      'targetId': 'BATT',
      'model': 'battery.glb',
    },
    {
      'step': 2,
      'instruction': 'ขั้นตอนที่ 2: ติดตั้งฐานเชื่อมต่อ',
      'hint': 'เลือกฐานแมทชิ่ง (Base) ติดกับตัวเครื่อง',
      'targetId': 'BASE',
      'model': 'antenna_base.glb',
    },
    {
      'step': 3,
      'instruction': 'ขั้นตอนที่ 3: ติดตั้งตัวแพร่คลื่น',
      'hint': 'เลือกก้านเสาอากาศ (Whip) ส่งสัญญาณ',
      'targetId': 'WHIP',
      'model': 'antenna_whip.glb',
    },
    {
      'step': 4,
      'instruction': 'การประกอบเสร็จสมบูรณ์',
      'hint': 'วิทยุพร้อมใช้งาน',
      'targetId': 'DONE',
      'model': 'prc624.glb',
    },
  ];

  // ปุ่มตัวเลือก
  final List<Map<String, String>> availableParts = [
    {'id': 'WHIP', 'name': 'ANTENNA WHIP\n(ก้านเสา)'},
    {'id': 'BATT', 'name': 'BATTERY\n(แบตเตอรี่)'},
    {'id': 'BASE', 'name': 'ANTENNA BASE\n(ฐานเสา)'},
    {'id': 'RT', 'name': 'RT-624 BODY\n(ตัวเครื่อง)'},
  ];

  int currentStepIndex = 0;
  bool isCompleted = false;
  String feedbackMessage = "รอคำสั่ง...";
  Color feedbackColor = Colors.grey;

  void _checkPart(String partId) {
    if (isCompleted) return;

    var currentStep = assemblySteps[currentStepIndex];

    if (partId == currentStep['targetId']) {
      setState(() {
        feedbackMessage = "ถูกต้อง! กำลังติดตั้ง...";
        feedbackColor = const Color(0xFF00FF41);
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (currentStepIndex < assemblySteps.length - 1) {
          setState(() {
            currentStepIndex++;
            feedbackMessage = "รอคำสั่งต่อไป...";
            feedbackColor = Colors.white;

            if (assemblySteps[currentStepIndex]['targetId'] == 'DONE') {
              isCompleted = true;
              feedbackMessage = "ภารกิจเสร็จสิ้น";
              feedbackColor = const Color(0xFF00FF41);
            }
          });
        }
      });
    } else {
      String specificHint = "เลือกผิดชิ้นส่วน!";
      if (currentStep['targetId'] == 'WHIP' && partId == 'BASE') {
        specificHint = "ผิดครับ! นั่นคือฐาน (Base)\nต้องเลือกก้านเสา (Whip)";
      } else if (currentStep['targetId'] == 'BASE' && partId == 'WHIP') {
        specificHint = "ผิดครับ! ต้องใส่ฐาน (Base) ก่อน";
      }

      setState(() {
        feedbackMessage = specificHint;
        feedbackColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var stepData = assemblySteps[currentStepIndex];
    String currentModelUrl = "$_gh3DBase${stepData['model']}";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "ASSEMBLY TRAINING",
          style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41)),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
      ),
      body: Column(
        children: [
          // --- 1. ส่วนแสดงผล 3D ---
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: feedbackColor == Colors.red
                      ? Colors.red
                      : Colors.cyanAccent.withOpacity(0.7),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black, Color(0xFF001100), Colors.black],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    ModelViewer(
                      key: ValueKey(currentModelUrl),
                      src: currentModelUrl,
                      alt: "Assembly Step",
                      ar: true,
                      autoRotate: true,
                      cameraControls: true,
                      backgroundColor: Colors.transparent,
                      loading: Loading.eager,
                    ),

                    // ป้ายบอกขั้นตอน
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00FF41),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isCompleted
                              ? "COMPLETE"
                              : "STEP ${stepData['step']}/3",
                          style: GoogleFonts.blackOpsOne(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    // ✅ คืนชีพ: ป้ายแจ้งเตือนเมื่อเสร็จภารกิจ
                    if (isCompleted)
                      Container(
                        color: Colors.black.withOpacity(0.6), // พื้นหลังจางๆ
                        child: Center(
                          child: Text(
                            "ASSEMBLY\nCOMPLETE",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.blackOpsOne(
                              color: const Color(0xFF00FF41),
                              fontSize: 32, // ปรับขนาดให้พอดี
                              shadows: [
                                const Shadow(
                                  blurRadius: 20,
                                  color: Color(0xFF00FF41),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // --- 2. ส่วนควบคุม (ปุ่มใหญ่ กดง่าย) ---
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.grey[800]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stepData['instruction'],
                          style: GoogleFonts.sarabun(
                            color: const Color(0xFF00FF41),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isCompleted ? "ภารกิจเสร็จสิ้น" : stepData['hint'],
                          style: GoogleFonts.sarabun(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const Divider(color: Colors.grey, height: 16),
                        Row(
                          children: [
                            Icon(
                              feedbackColor == Colors.red
                                  ? Icons.cancel
                                  : feedbackColor == const Color(0xFF00FF41)
                                      ? Icons.check_circle
                                      : Icons.info_outline,
                              color: feedbackColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feedbackMessage,
                                style: GoogleFonts.sarabun(
                                  color: feedbackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: isCompleted
                        ? Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  currentStepIndex = 0;
                                  isCompleted = false;
                                  feedbackMessage = "เริ่มใหม่...";
                                  feedbackColor = Colors.white;
                                });
                              },
                              icon: const Icon(Icons.refresh, size: 30),
                              label: const Text("ฝึกใหม่อีกครั้ง"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00FF41),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                textStyle: GoogleFonts.blackOpsOne(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        : GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 1.8,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: availableParts.map((part) {
                              return ElevatedButton(
                                onPressed: () => _checkPart(part['id']!),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF333333),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: Color(0xFF00FF41),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    part['name']!,
                                    style: GoogleFonts.sarabun(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList(),
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
