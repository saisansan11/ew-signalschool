import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/platform_model_viewer.dart';

class Cnr900tDetailScreen extends StatelessWidget {
  const Cnr900tDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ใช้โมเดลแทนไปก่อน
    const String modelUrl =
        "https://saisansan11.github.io/military_sim_2026/assets/assets/models/prc624.glb";
    const Color themeColor = Colors.cyanAccent;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("CNR-900T DETAILS",
            style: GoogleFonts.blackOpsOne(color: themeColor)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: themeColor),
      ),
      body: Column(
        children: [
          // 3D Model Area
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xFF001111)],
                ),
              ),
              child: const PlatformModelViewer(
                src: modelUrl,
                alt: "CNR-900T Model",
                autoRotate: true,
                cameraControls: true,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),

          const Divider(color: themeColor, height: 1),

          // Technical Data
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF050510),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("TECHNICAL DATA (TACTICAL):",
                        style: GoogleFonts.blackOpsOne(
                            color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 10),
                    _buildSpecItem(
                        "Frequency Range", "30.000 - 87.975 MHz", themeColor),
                    _buildSpecItem("Channels", "2,320 Channels"),
                    _buildSpecItem(
                        "Keypad", "Full Alphanumeric (ส่งข้อความได้)"),
                    _buildSpecItem(
                        "Modes", "Voice, Data, AJ (Hopping), Secure"),
                    _buildSpecItem(
                        "Encryption", "High Grade Digital Encryption"),
                    _buildSpecItem(
                        "Special Feature", "Built-in SMS / GPS Tracking"),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: themeColor),
                        borderRadius: BorderRadius.circular(5),
                        color: themeColor.withOpacity(0.1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: themeColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "CNR-900T (Tactical) มีแป้นพิมพ์เต็มรูปแบบ สามารถรับ-ส่งข้อความสั้น (Short Message) และพิกัด GPS ได้โดยไม่ต้องใช้อุปกรณ์เสริม",
                              style: GoogleFonts.sarabun(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String value,
      [Color color = Colors.cyanAccent]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.sarabun(color: Colors.grey)),
          Text(value,
              style: GoogleFonts.sarabun(
                  color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
