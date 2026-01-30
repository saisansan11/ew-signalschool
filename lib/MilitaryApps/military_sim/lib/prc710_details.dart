import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class Prc710DetailScreen extends StatefulWidget {
  const Prc710DetailScreen({super.key});

  @override
  State<Prc710DetailScreen> createState() => _Prc710DetailScreenState();
}

class _Prc710DetailScreenState extends State<Prc710DetailScreen> {
  // ✅ ใช้โมเดล prc624 ไปก่อน (หรือถ้ามีไฟล์ prc710.glb ให้เปลี่ยนชื่อตรงนี้ครับ)
  final String _gh3DBase =
      "https://saisansan11.github.io/military_sim_2026/assets/assets/models/";

  // รายการชิ้นส่วน (เน้นดูภาพรวม)
  final List<Map<String, dynamic>> parts = [
    {
      'id': 'FULL',
      'name': 'AN/PRC-710 (SYSTEM)',
      'file': 'prc624.glb',
    }, // ใช้โมเดลแทนชั่วคราว
    {'id': 'BODY', 'name': 'Receiver-Transmitter', 'file': 'body.glb'},
    {'id': 'ANT', 'name': 'Broadband Antenna', 'file': 'antenna_whip.glb'},
    {'id': 'BATT', 'name': 'Li-Ion Battery', 'file': 'battery.glb'},
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    String currentModelUrl = "$_gh3DBase${parts[selectedIndex]['file']}";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "PRC-710 DETAILS",
          style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41)),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
      ),
      body: Column(
        children: [
          // --- ส่วนแสดงผล 3D ---
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF00FF41).withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black, Color(0xFF001100), Colors.black],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF41).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 1,
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
                      alt: "PRC-710 3D",
                      ar: true,
                      autoRotate: true,
                      cameraControls: true,
                      backgroundColor: Colors.transparent,
                      loading: Loading.eager,
                    ),
                    // ป้ายชื่อมุมขวาบน
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
                  ],
                ),
              ),
            ),
          ),

          // --- ส่วนข้อมูลสเปค (ข้อมูลจากรูปภาพที่ส่งมา) ---
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF111111),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(
                  top: BorderSide(color: Color(0xFF00FF41), width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "คุณลักษณะทางเทคนิค:",
                    style: GoogleFonts.sarabun(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSpecRow(
                            "• ย่านความถี่:",
                            "30.000 - 87.975 MHz",
                          ),
                          _buildSpecRow(
                            "• ช่องติดต่อ:",
                            "2,320 ช่อง (ห่างกัน 25 KHz)",
                          ),
                          _buildSpecRow(
                            "• กำลังส่ง:",
                            "Low (1W), Mid (2W), Hi (5W)",
                          ),
                          _buildSpecRow(
                            "• โหมดใช้งาน:",
                            "CLR, SEC และ A.J. (Hopping)",
                          ),
                          _buildSpecRow("• น้ำหนักเครื่อง:", "ประมาณ 750 กรัม"),
                          const SizedBox(height: 10),
                          _buildSpecRow(
                            "• คุณสมบัติพิเศษ:",
                            "รองรับการส่งข้อมูล (Data) และ ECCM",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ปุ่มเลือกชิ้นส่วน
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: parts.asMap().entries.map((entry) {
                        int idx = entry.key;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ChoiceChip(
                            label: Text(
                              entry.value['id'],
                              style: GoogleFonts.blackOpsOne(),
                            ),
                            selected: idx == selectedIndex,
                            selectedColor: const Color(0xFF00FF41),
                            backgroundColor: const Color(0xFF222222),
                            labelStyle: TextStyle(
                              color: idx == selectedIndex
                                  ? Colors.black
                                  : Colors.white,
                            ),
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

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.sarabun(fontSize: 14),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(color: Color(0xFF00FF41)),
            ),
          ],
        ),
      ),
    );
  }
}
