import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ Import ครบทุกไฟล์
import 'prc624_screen.dart';
import 'prc624_details.dart';
import 'prc624_assembly.dart';
import 'prc624_trouble.dart';

class Prc624MenuScreen extends StatelessWidget {
  const Prc624MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("AN/PRC-624 MENU",
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
            image: AssetImage("assets/images/bg_blueprint.jpg"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNeonButton(context, "1. RADIO OPERATION",
                    "ฝึกการตั้งความถี่และการใช้งาน", Icons.settings_remote, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Prc624Screen()));
                }),
                const SizedBox(height: 20),
                _buildNeonButton(context, "2. SPECIFICATION & 3D",
                    "ข้อมูลจำเพาะและโมเดล 3 มิติ", Icons.view_in_ar, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Prc624DetailScreen()));
                }),
                const SizedBox(height: 20),
                _buildNeonButton(context, "3. ASSEMBLY TRAINING",
                    "ฝึกการประกอบชุดอุปกรณ์", Icons.build, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Prc624AssemblyScreen()));
                }),
                const SizedBox(height: 20),
                _buildNeonButton(
                    context,
                    "4. TROUBLESHOOTING",
                    "การวิเคราะห์และแก้ไขข้อขัดข้อง",
                    Icons.build_circle_outlined, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Prc624TroubleScreen()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeonButton(BuildContext context, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Center(
      child: Container(
        width: 350,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF001500),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF00FF41), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xFF00FF41), blurRadius: 10)
          ],
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
                  Icon(icon, color: const Color(0xFF00FF41), size: 40),
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
}
