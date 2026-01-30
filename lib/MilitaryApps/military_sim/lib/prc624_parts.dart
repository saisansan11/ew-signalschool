import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class Prc624PartsScreen extends StatefulWidget {
  const Prc624PartsScreen({super.key});

  @override
  State<Prc624PartsScreen> createState() => _Prc624PartsScreenState();
}

class _Prc624PartsScreenState extends State<Prc624PartsScreen> {
  // --- 0. ฐานข้อมูลโมเดล (Verified: ใช้ assets/assets/ ถูกต้องแล้วครับ) ---
  final String _gh3DBase =
      "https://saisansan11.github.io/military_sim_2026/assets/assets/models/";

  // รายการชิ้นส่วน
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
    // สร้าง URL เต็มรูปแบบ
    String currentModelUrl = "$_gh3DBase${parts[selectedIndex]['file']}";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "PART INSPECTION",
          style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41)),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
      ),
      body: Column(
        children: [
          // ส่วนแสดงผล 3D
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
                  // ✅ ใส่ Key สำคัญมาก เพื่อให้มันรู้ว่าต้องโหลดใหม่เมื่อเปลี่ยนชิ้นส่วน
                  key: ValueKey(currentModelUrl),
                  src: currentModelUrl, // ✅ ลิ้งก์ถูกต้อง 100%
                  alt: "A 3D model of ${parts[selectedIndex]['name']}",
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                  backgroundColor: Colors.transparent,
                  loading: Loading.eager,
                ),
              ),
            ),
          ),

          // ส่วนควบคุมด้านล่าง
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SPECIFICATIONS",
                    style: GoogleFonts.blackOpsOne(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getSpecText(parts[selectedIndex]['id']),
                      style: GoogleFonts.sarabun(
                        color: const Color(0xFF00FF41),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // ปุ่มเลือกชิ้นส่วน
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: parts.asMap().entries.map((entry) {
                        int idx = entry.key;
                        var part = entry.value;
                        bool isSel = idx == selectedIndex;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              part['id'],
                              style: GoogleFonts.blackOpsOne(),
                            ),
                            selected: isSel,
                            selectedColor: const Color(0xFF00FF41),
                            backgroundColor: const Color(0xFF333333),
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

  String _getSpecText(String id) {
    switch (id) {
      case 'FULL':
        return "• System: AN/PRC-624\n• Freq: 30-88 MHz\n• Weight: 960g";
      case 'RT-624':
        return "• Power: 1-2 Watts\n• Channels: 2,320\n• Protection: Waterproof";
      case 'BASE':
        return "• Connector: TNC Type\n• Material: Reinforced Polymer";
      case 'WHIP':
        return "• Length: 1.2m (Flexible)\n• Range: 3-5 km";
      case 'BATT':
        return "• Type: Li-ion 7.4V\n• Capacity: 24 Hours (Low Power)";
      default:
        return "N/A";
    }
  }
}
