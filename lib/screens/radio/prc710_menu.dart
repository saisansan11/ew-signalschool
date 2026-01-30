import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ Import หน้าจอต่างๆ ของ 710 ให้ครบ
import 'prc710_screen.dart';
import 'prc710_details.dart';
import 'prc710_assembly.dart'; // <-- ไฟล์นี้สำคัญ
import 'prc710_trouble.dart';

class Prc710MenuScreen extends StatelessWidget {
  const Prc710MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("AN/PRC-710 MENU",
            style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41))),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00FF41)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            // ✅ ใช้พื้นหลังพิมพ์เขียวตามที่ต้องการ
            image: AssetImage("assets/images/bg_blueprint.jpg"),
            fit: BoxFit.cover,
            opacity: 0.15, // จางๆ ให้ปุ่มเด่น
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. OPERATION
                _buildNeonButton(context, "1. RADIO OPERATION",
                    "ฝึกการตั้งความถี่และการใช้งาน", Icons.settings_remote, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Prc710Screen()));
                }),
                const SizedBox(height: 20),

                // 2. SPECIFICATION
                _buildNeonButton(context, "2. SPECIFICATION & 3D",
                    "ข้อมูลจำเพาะและโมเดล 3 มิติ", Icons.view_in_ar, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Prc710DetailScreen()));
                }),
                const SizedBox(height: 20),

                // 3. ASSEMBLY (✅ ปลดล็อคแล้ว!)
                _buildNeonButton(context, "3. ASSEMBLY TRAINING",
                    "ฝึกการประกอบชุดอุปกรณ์", Icons.build, () {
                  // 👉 เปลี่ยนจาก _showComingSoon เป็นการเปลี่ยนหน้า
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Prc710AssemblyScreen()));
                }),
                const SizedBox(height: 20),

                // 4. TROUBLESHOOTING
                _buildNeonButton(
                    context,
                    "4. TROUBLESHOOTING",
                    "การวิเคราะห์และแก้ไขข้อขัดข้อง",
                    Icons.build_circle_outlined, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Prc710TroubleScreen()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget ปุ่มสไตล์ Neon Green
  Widget _buildNeonButton(BuildContext context, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Center(
      child: Container(
        width: 350,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF001500)
              .withOpacity(0.9), // พื้นหลังทึบ เพื่อให้อ่านง่ายบนลายเส้น
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: const Color(0xFF00FF41), width: 2), // ขอบเขียว Neon
          boxShadow: const [
            BoxShadow(color: Color(0xFF00FF41), blurRadius: 10)
          ], // แสงฟุ้ง
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            splashColor: const Color(0xFF00FF41).withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // ไอคอนในกรอบสี่เหลี่ยม
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF00FF41)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: const Color(0xFF00FF41), size: 30),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: GoogleFonts.blackOpsOne(
                                fontSize: 18,
                                color: Colors.white,
                                shadows: [
                                  const Shadow(
                                      blurRadius: 5, color: Color(0xFF00FF41))
                                ])),
                        const SizedBox(height: 5),
                        Text(subtitle,
                            style: GoogleFonts.sarabun(
                                fontSize: 12, color: Colors.grey[300])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
