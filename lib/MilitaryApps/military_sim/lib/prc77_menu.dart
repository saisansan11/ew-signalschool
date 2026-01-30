import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Prc77MenuScreen extends StatelessWidget {
  const Prc77MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: Text("AN/PRC-77 MENU",
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
            // ✅ แก้ชื่อรูปตรงนี้ให้เป็น bg_blueprint.jpg
            image: AssetImage("assets/images/bg_blueprint.jpg"),
            fit: BoxFit.cover, opacity: 0.15,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRetroButton(
                    context,
                    "1. RADIO OPERATION",
                    "ฝึกการหมุนปรับความถี่ (Analog)",
                    Icons.settings_remote, () {
                  _showComingSoon(context, "กำลังจำลองระบบ Analog Knob...");
                }),
                const SizedBox(height: 20),
                _buildRetroButton(context, "2. SPECIFICATION & 3D",
                    "ดูส่วนประกอบภายใน", Icons.view_in_ar, () {
                  _showComingSoon(context, "กำลังสร้างโมเดล PRC-77...");
                }),
                const SizedBox(height: 20),
                _buildRetroButton(context, "3. ASSEMBLY TRAINING",
                    "ฝึกการประกอบเครื่อง", Icons.build, () {
                  _showComingSoon(context, "กำลังเตรียมบทเรียน...");
                }),
                const SizedBox(height: 20),
                _buildRetroButton(
                    context,
                    "4. TROUBLESHOOTING",
                    "แก้ปัญหาเสียงซ่า/ไม่ออกอากาศ",
                    Icons.build_circle_outlined, () {
                  _showComingSoon(context, "กำลังรวบรวมอาการเสีย...");
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetroButton(BuildContext context, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Center(
      child: Container(
        width: 350,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF2b2b2b),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey[600]!, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(0, 5), blurRadius: 5)
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(icon, color: Colors.grey[400], size: 40),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: GoogleFonts.blackOpsOne(
                                fontSize: 18, color: Colors.white)),
                        const SizedBox(height: 5),
                        Text(subtitle,
                            style: GoogleFonts.sarabun(
                                fontSize: 12, color: Colors.grey[400])),
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

  void _showComingSoon(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.black,
              title: Text("SYSTEM STATUS",
                  style: GoogleFonts.blackOpsOne(color: Colors.white)),
              content:
                  Text(message, style: GoogleFonts.sarabun(color: Colors.grey)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("ACKNOWLEDGE"))
              ],
            ));
  }
}
