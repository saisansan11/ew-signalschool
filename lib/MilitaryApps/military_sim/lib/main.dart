import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import ไฟล์หน้าจอต่างๆ
import 'splash_screen.dart';
import 'prc624_menu.dart';
import 'prc710_menu.dart';
import 'cnr900_menu.dart';
import 'cnr900t_menu.dart';
import 'prc77_menu.dart';

void main() => runApp(const MilitarySimApp());

class MilitarySimApp extends StatelessWidget {
  const MilitarySimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}

class MainSelectorScreen extends StatelessWidget {
  const MainSelectorScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังหลักสีดำ
      extendBodyBehindAppBar: true, // ✅ ให้พื้นหลังยาวทะลุไปถึงหลัง AppBar
      appBar: AppBar(
        title: Text("MAIN MENU",
            style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41))),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.6), // ✅ AppBar โปร่งแสง
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.red),
            onPressed: () => _logout(context),
            tooltip: "ออกจากระบบ",
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_blueprint.jpg"),
            fit: BoxFit.cover,
            opacity: 0.5, // ✅ เพิ่มความชัดของรูปพื้นหลัง (จาก 0.15 -> 0.5)
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0), // Padding ซ้ายขวา
          child: Center(
            // จัดกึ่งกลางแนวตั้ง
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // เว้นระยะเผื่อ AppBar ด้านบน
                  const SizedBox(height: 100),

                  _buildRadioBtn(context, "AN/PRC-624", "Handheld VHF/FM Radio",
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Prc624MenuScreen()));
                  }),
                  const SizedBox(height: 16),

                  _buildRadioBtn(
                      context, "AN/PRC-710", "Tactical Digital Radio", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Prc710MenuScreen()));
                  }),
                  const SizedBox(height: 16),

                  _buildRadioBtn(context, "CNR-900", "Tactical VHF Radio", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Cnr900MenuScreen()));
                  }),
                  const SizedBox(height: 16),

                  _buildRadioBtn(
                      context, "CNR-900T", "Tactical Radio (Full Keypad)", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Cnr900tMenuScreen()));
                  }, isCyan: true),
                  const SizedBox(height: 16),

                  _buildRadioBtn(context, "AN/PRC-77", "Manpack Radio (Analog)",
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Prc77MenuScreen()));
                  }),

                  const SizedBox(height: 40),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24)),
                    child: Text(
                      "SELECT DEVICE TO START TRAINING",
                      style: GoogleFonts.shareTechMono(
                          color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioBtn(
      BuildContext context, String title, String sub, VoidCallback onTap,
      {bool isCyan = false}) {
    Color themeColor = isCyan ? Colors.cyanAccent : const Color(0xFF00FF41);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            // ✅ ปรับสีพื้นหลังปุ่มให้โปร่งแสง (เห็นพื้นหลังทะลุ)
            color: Colors.black.withOpacity(0.5),
            border: Border.all(color: themeColor.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: themeColor.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 0)
            ]),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.radio, color: themeColor, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.blackOpsOne(
                          fontSize: 18, color: Colors.white)),
                  Text(sub,
                      style: GoogleFonts.sarabun(
                          color: Colors.grey[300], fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: themeColor.withOpacity(0.7), size: 16),
          ],
        ),
      ),
    );
  }
}
