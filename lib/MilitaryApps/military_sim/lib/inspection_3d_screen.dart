import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ เปลี่ยนชื่อ Class ให้เป็น Inspection3DScreen (เผื่อแอพเรียกอันนี้)
class Inspection3DScreen extends StatefulWidget {
  const Inspection3DScreen({super.key});

  @override
  State<Inspection3DScreen> createState() => _Inspection3DScreenState();
}

class _Inspection3DScreenState extends State<Inspection3DScreen> {
  // ✅ ใช้ assets 2 ชั้น (ถูกต้อง)
  final String _gh3DBase =
      "https://saisansan11.github.io/military_sim_2026/assets/assets/models/";

  final List<Map<String, dynamic>> parts = [
    {'id': 'FULL', 'name': 'AN/PRC-624 (FULL)', 'file': 'prc624.glb'},
    {'id': 'RT-624', 'name': 'Receiver-Transmitter', 'file': 'body.glb'},
    {'id': 'BASE', 'name': 'Antenna Base', 'file': 'antenna_base.glb'},
    {'id': 'WHIP', 'name': 'Antenna Whip', 'file': 'antenna_whip.glb'},
    {'id': 'BATT', 'name': 'Battery (BA-624)', 'file': 'battery.glb'},
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    String currentModelUrl = "$_gh3DBase${parts[selectedIndex]['file']}";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "PART INSPECTION (V2)",
          style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41)),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[800]!),
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ModelViewer(
                  key: ValueKey(currentModelUrl),
                  src: currentModelUrl, // ✅ ลิ้งก์ถูกแน่นอน
                  alt: "A 3D model",
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                  backgroundColor: Colors.transparent,
                  loading: Loading.eager,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Text(
                    "SELECT PART TO INSPECT",
                    style: GoogleFonts.blackOpsOne(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: parts.asMap().entries.map((entry) {
                        int idx = entry.key;
                        bool isSel = idx == selectedIndex;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              entry.value['id'],
                              style: GoogleFonts.blackOpsOne(),
                            ),
                            selected: isSel,
                            selectedColor: const Color(0xFF00FF41),
                            onSelected: (val) {
                              if (val) setState(() => selectedIndex = idx);
                            },
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
