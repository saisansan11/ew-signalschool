import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class Prc624DetailScreen extends StatefulWidget {
  const Prc624DetailScreen({super.key});

  @override
  State<Prc624DetailScreen> createState() => _Prc624DetailScreenState();
}

class _Prc624DetailScreenState extends State<Prc624DetailScreen> {
  // ✅ 3D Model Path
  final String _gh3DBase =
      "https://saisansan11.github.io/military_sim_2026/assets/assets/models/";

  final List<Map<String, dynamic>> parts = [
    {'id': 'FULL', 'name': 'AN/PRC-624 (FULL SYSTEM)', 'file': 'prc624.glb'},
    {'id': 'RT-624', 'name': 'Receiver-Transmitter', 'file': 'body.glb'},
    {'id': 'BASE', 'name': 'Antenna Base', 'file': 'antenna_base.glb'},
    {'id': 'WHIP', 'name': 'Antenna Whip', 'file': 'antenna_whip.glb'},
    {'id': 'BATTERY', 'name': 'Battery Pack (BA-624)', 'file': 'battery.glb'},
  ];

  int selectedIndex = 0;
  String status = "PENDING"; // สถานะการตรวจเช็ค

  @override
  Widget build(BuildContext context) {
    String currentModelUrl = "$_gh3DBase${parts[selectedIndex]['file']}";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "PART INSPECTION", // เปลี่ยนชื่อกลับเป็น Inspection ตามที่ต้องการ
          style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41)),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
      ),
      body: Column(
        children: [
          // --- ส่วนแสดงผล 3D (55% ของหน้าจอ) ---
          Expanded(
            flex: 55,
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.7),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.cyan.shade50,
                    Colors.blueGrey.shade50,
                  ],
                  stops: const [0.1, 0.5, 0.9],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    ModelViewer(
                      key: ValueKey(currentModelUrl),
                      src: currentModelUrl,
                      alt: "3D Model",
                      ar: true,
                      autoRotate: true,
                      cameraControls: true,
                      backgroundColor: Colors.transparent,
                      loading: Loading.eager,
                    ),

                    // 1. ป้ายชื่อชิ้นส่วน (ขวาบน)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          border: Border.all(color: const Color(0xFF00FF41)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          parts[selectedIndex]['name'],
                          style: GoogleFonts.blackOpsOne(
                            color: const Color(0xFF00FF41),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    // 2. ป้ายสถานะ STATUS (ซ้ายบน) - คืนชีพกลับมาแล้ว!
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: status == "PASS"
                                ? Colors.green
                                : status == "FAIL"
                                ? Colors.red
                                : Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status == "PASS"
                                  ? Icons.check_circle
                                  : status == "FAIL"
                                  ? Icons.cancel
                                  : Icons.help_outline,
                              color: status == "PASS"
                                  ? Colors.green
                                  : status == "FAIL"
                                  ? Colors.red
                                  : Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "STATUS: $status",
                              style: GoogleFonts.blackOpsOne(
                                color: status == "PASS"
                                    ? Colors.green
                                    : status == "FAIL"
                                    ? Colors.red
                                    : Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- ส่วนข้อมูลและปุ่ม (45% ของหน้าจอ) ---
          Expanded(
            flex: 45,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // หัวข้อ
                  Text(
                    "SPECIFICATIONS",
                    style: GoogleFonts.blackOpsOne(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // กล่องข้อความสเปค
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[800]!),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          _getFullSpecText(parts[selectedIndex]['id']),
                          style: GoogleFonts.sarabun(
                            color: const Color(0xFF00FF41),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ปุ่มเลือกชิ้นส่วน (Choice Chips)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: parts.asMap().entries.map((entry) {
                        int idx = entry.key;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              entry.value['id'],
                              style: GoogleFonts.blackOpsOne(fontSize: 12),
                            ),
                            selected: idx == selectedIndex,
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

                  const SizedBox(height: 12),

                  // 3. ปุ่ม FAIL / PASS - คืนชีพกลับมาแล้ว!
                  Row(
                    children: [
                      // ปุ่ม FAIL
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => status = "FAIL");
                          },
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: Text("FAIL", style: GoogleFonts.blackOpsOne()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // ปุ่ม PASS
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => status = "PASS");
                          },
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: Text("PASS", style: GoogleFonts.blackOpsOne()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ข้อมูลสเปค
  String _getFullSpecText(String id) {
    switch (id) {
      case 'FULL':
        return "• ประเภท: วิทยุรับ-ส่ง มือถือ ย่าน VHF/FM\n• ย่านความถี่: 30.000 - 87.975 MHz\n• จำนวนช่อง: 2,320 ช่อง\n• กำลังส่ง: 1-2 วัตต์\n• ระยะหวังผล: 3-5 กม.";
      case 'RT-624':
        return "• รุ่น: RT-624\n• ระบบป้องกัน: กันน้ำลึก 1 เมตร\n• จอแสดงผล: LCD Backlight\n• การควบคุม: ปุ่มกด 4 ปุ่ม";
      case 'BASE':
        return "• ชื่อ: Antenna Base\n• การติดตั้ง: ติดบนเครื่อง RT-624\n• ขั้วต่อ: TNC Type\n• วัสดุ: Reinforced Polymer";
      case 'WHIP':
        return "• ชื่อ: Antenna Whip\n• ความยาว: 1.2 เมตร\n• ย่านความถี่: Broadband 30-88 MHz\n• ข้อควรระวัง: ห้ามพับงอจนหัก";
      case 'BATTERY':
        return "• รุ่น: BA-624\n• ชนิด: Ni-Cd หรือ Li-ion\n• แรงดันไฟ: 7.4 VDC\n• ความจุ: ใช้งานได้ >10 ชม.";
      default:
        return "N/A";
    }
  }
}
