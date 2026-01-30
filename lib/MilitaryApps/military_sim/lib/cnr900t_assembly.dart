import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Cnr900tAssemblyScreen extends StatefulWidget {
  const Cnr900tAssemblyScreen({super.key});

  @override
  State<Cnr900tAssemblyScreen> createState() => _Cnr900tAssemblyScreenState();
}

class _Cnr900tAssemblyScreenState extends State<Cnr900tAssemblyScreen> {
  final String _gh3DBase =
      "https://saisansan11.github.io/military_sim_2026/assets/assets/models/";
  final Color themeColor = Colors.cyanAccent;

  final List<Map<String, dynamic>> assemblySteps = [
    {
      'step': 1,
      'instruction': '1. ติดตั้งแบตเตอรี่ความจุสูง',
      'hint': 'เลือก Battery Pack สำหรับรุ่น T',
      'targetId': 'BATT',
      'model': 'battery.glb'
    },
    {
      'step': 2,
      'instruction': '2. ติดตั้งเสา GPS',
      'hint': 'ต้องใช้เสา GPS แยกสำหรับการระบุพิกัด',
      'targetId': 'GPS',
      'model': 'antenna_base.glb'
    },
    {
      'step': 3,
      'instruction': '3. ติดตั้งเสาอากาศหลัก',
      'hint': 'หมุนเสา Broadband เข้าขั้ว ANT',
      'targetId': 'ANT',
      'model': 'antenna_whip.glb'
    },
    {
      'step': 4,
      'instruction': 'พร้อมปฏิบัติการ',
      'hint': 'CNR-900T พร้อมเชื่อมต่อ Data Link',
      'targetId': 'DONE',
      'model': 'prc624.glb'
    },
  ];

  final List<Map<String, String>> parts = [
    {'id': 'ANT', 'name': 'Broadband Ant.\n(เสาอากาศ)'},
    {'id': 'BATT', 'name': 'High Cap Battery\n(แบตเตอรี่)'},
    {'id': 'GPS', 'name': 'GPS Antenna\n(เสาจีพีเอส)'},
    {'id': 'HSET', 'name': 'Data Cable\n(สายส่งข้อมูล)'},
  ];

  int stepIndex = 0;
  bool isCompleted = false;
  String feedback = "รอคำสั่ง...";
  Color feedbackColor = Colors.grey;

  void _checkPart(String id) {
    if (isCompleted) return;
    if (id == assemblySteps[stepIndex]['targetId']) {
      setState(() {
        feedback = "ถูกต้อง!";
        feedbackColor = themeColor;
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (stepIndex < assemblySteps.length - 1) {
          setState(() {
            stepIndex++;
            feedback = "รอคำสั่งต่อไป...";
            feedbackColor = Colors.white;
            if (assemblySteps[stepIndex]['targetId'] == 'DONE') {
              isCompleted = true;
            }
          });
        }
      });
    } else {
      setState(() {
        feedback = "ผิดพลาด!";
        feedbackColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var step = assemblySteps[stepIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text("ASSEMBLY (900T)",
              style: GoogleFonts.blackOpsOne(color: themeColor)),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: themeColor)),
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: themeColor),
                      color: const Color(0xFF001111)),
                  child: ModelViewer(
                      key: ValueKey(step['model']),
                      src: "$_gh3DBase${step['model']}",
                      alt: "Step",
                      ar: true,
                      autoRotate: true,
                      cameraControls: true,
                      backgroundColor: Colors.transparent))),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: Color(0xFF101520),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                children: [
                  Text(step['instruction'],
                      style: GoogleFonts.sarabun(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Text(step['hint'],
                      style: GoogleFonts.sarabun(
                          color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 5),
                  Text(feedback,
                      style: GoogleFonts.sarabun(
                          color: feedbackColor, fontWeight: FontWeight.bold)),
                  Divider(color: themeColor.withOpacity(0.5)),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Center(
                      child: isCompleted
                          ? ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon:
                                  const Icon(Icons.check, color: Colors.black),
                              label: const Text("FINISH",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: themeColor))
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  childAspectRatio: 3.0,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: parts
                                      .map((p) => ElevatedButton(
                                            onPressed: () =>
                                                _checkPart(p['id']!),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF001111),
                                                side: BorderSide(
                                                    color: themeColor),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                            child: Text(p['name']!,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.sarabun(
                                                    color: Colors.white,
                                                    fontSize: 11)),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
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
