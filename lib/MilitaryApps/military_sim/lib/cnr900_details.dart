import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class Cnr900DetailScreen extends StatelessWidget {
  const Cnr900DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ใช้โมเดลแทน (Placeholder) ไปก่อน
    const String modelUrl =
        "https://saisansan11.github.io/military_sim_2026/assets/assets/models/prc624.glb";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("CNR-900 DETAILS",
            style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41))),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
      ),
      body: Column(
        children: [
          // 3D Model
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xFF001100)],
                ),
              ),
              child: const ModelViewer(
                src: modelUrl,
                alt: "CNR-900 Model",
                ar: true,
                autoRotate: true,
                cameraControls: true,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),

          const Divider(color: Color(0xFF00FF41), height: 1),

          // Specs Info
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF0D0D0D),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("TECHNICAL DATA:",
                        style: GoogleFonts.blackOpsOne(
                            color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 10),
                    _buildSpecItem("Frequency Range", "30.000 - 87.975 MHz"),
                    _buildSpecItem("Channels", "2,320 (25 kHz spacing)"),
                    _buildSpecItem("Power Output", "0.25W / 4W (Manpack)"),
                    _buildSpecItem("Modes", "Clear, Secure, Frequency Hopping"),
                    _buildSpecItem("Data Rate", "Sync up to 16 kbps"),
                    _buildSpecItem(
                        "Features", "Built-in Encryption, GPS Interface"),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF00FF41)),
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFF002200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: Color(0xFF00FF41)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "CNR-900 เป็นวิทยุทางยุทธวิธีรุ่นใหม่ เน้นการป้องกันการดักฟัง (ECCM) และการส่งข้อมูลสนามรบ",
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

  Widget _buildSpecItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.sarabun(color: Colors.grey)),
          Text(value,
              style: GoogleFonts.sarabun(
                  color: const Color(0xFF00FF41), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
