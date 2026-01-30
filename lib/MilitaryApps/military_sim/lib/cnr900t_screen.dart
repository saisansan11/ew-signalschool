import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cnr900tScreen extends StatefulWidget {
  const Cnr900tScreen({super.key});

  @override
  State<Cnr900tScreen> createState() => _Cnr900tScreenState();
}

class _Cnr900tScreenState extends State<Cnr900tScreen> {
  String frequency = "068.000";
  String tempInput = "";
  bool isEditing = false;
  double volume = 70;
  bool isPttPressed = false;
  bool isLightOn = true;
  String currentMode = "DATA";

  void _onKeyPress(String value) {
    setState(() {
      if (!isEditing) {
        isEditing = true;
        tempInput = value;
      } else {
        if (tempInput.length < 6) tempInput += value;
      }
    });
  }

  void _onEnter() {
    setState(() {
      if (isEditing && tempInput.isNotEmpty) {
        if (tempInput.length > 3) {
          frequency = "${tempInput.substring(0, 3)}.${tempInput.substring(3)}";
        } else {
          frequency = tempInput.padRight(7, '0');
        }
        tempInput = "";
        isEditing = false;
      }
    });
  }

  void _toggleMode() {
    setState(() {
      if (currentMode == "DATA") {
        currentMode = "VOICE";
      } else if (currentMode == "VOICE")
        currentMode = "AJ";
      else
        currentMode = "DATA";
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.cyanAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF050510),
      appBar: AppBar(
        title: Text("CNR-900T (DATA)",
            style: GoogleFonts.blackOpsOne(color: primaryColor)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: Column(
        children: [
          // --- ส่วนบน: หน้าจอ LCD (ปรับ Flex ให้สมดุลขึ้น) ---
          Expanded(
            flex: 4, // 40% ของหน้าจอ
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF101520),
                border: Border(
                    bottom: BorderSide(color: Colors.cyan[900]!, width: 4)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: isLightOn
                            ? const Color(0xFF001111)
                            : const Color(0xFF050505),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey[600]!, width: 3),
                        boxShadow: isLightOn
                            ? [
                                BoxShadow(
                                    color: primaryColor.withOpacity(0.2),
                                    blurRadius: 10)
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("PWR: HI",
                                  style: GoogleFonts.shareTechMono(
                                      color: Colors.white, fontSize: 12)),
                              Text(currentMode,
                                  style: GoogleFonts.blackOpsOne(
                                      color: primaryColor, fontSize: 12)),
                              Icon(Icons.wifi,
                                  color:
                                      isPttPressed ? Colors.red : Colors.white,
                                  size: 16),
                            ],
                          ),
                          Center(
                            child: Text(
                              isEditing
                                  ? tempInput.padRight(6, '_')
                                  : frequency,
                              style: GoogleFonts.shareTechMono(
                                fontSize: 42,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                shadows: isLightOn
                                    ? [
                                        const BoxShadow(
                                            color: primaryColor, blurRadius: 5)
                                      ]
                                    : [],
                              ),
                            ),
                          ),
                          // Data Flow Bar
                          Row(
                            children: [
                              const Text("DAT ",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10)),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: isPttPressed ? null : 0.0,
                                  color: primaryColor,
                                  backgroundColor: Colors.grey[800],
                                  minHeight: 2,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Controls (ลดขนาดลงอีก)
                  SizedBox(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKnob("VOL", volume,
                            (v) => setState(() => volume = v), primaryColor),

                        // PTT Button
                        GestureDetector(
                          onTapDown: (_) => setState(() => isPttPressed = true),
                          onTapUp: (_) => setState(() => isPttPressed = false),
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: isPttPressed
                                  ? Colors.red
                                  : const Color(0xFF333333),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Center(
                                child: Text("PTT",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12))),
                          ),
                        ),

                        IconButton(
                          onPressed: () =>
                              setState(() => isLightOn = !isLightOn),
                          icon: Icon(Icons.lightbulb_outline,
                              color: isLightOn ? Colors.yellow : Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- ส่วนล่าง: Keypad (ไม้ตาย: FittedBox) ---
          Expanded(
            flex: 6, // 60% ของหน้าจอ
            child: Container(
              color: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Center(
                // ✅ FittedBox จะย่อขนาดปุ่มลงอัตโนมัติถ้าจอมันเตี้ยเกินไป!
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 400, maxHeight: 400),
                    child: GridView.count(
                      shrinkWrap: true, // ให้ขนาด Grid พอดีกับปุ่ม
                      crossAxisCount: 3,
                      childAspectRatio: 2.6, // ✅ บีบให้แบนสุดๆ (ประหยัดที่)
                      mainAxisSpacing: 6, // ✅ ลดช่องไฟ
                      crossAxisSpacing: 6,
                      physics:
                          const NeverScrollableScrollPhysics(), // ล็อคเลื่อน
                      children: [
                        _buildKey(
                            "1", "MSG", () => _onKeyPress("1"), primaryColor),
                        _buildKey(
                            "2", "MODE", () => _toggleMode(), primaryColor),
                        _buildKey(
                            "3", "SQL", () => _onKeyPress("3"), primaryColor),
                        _buildKey(
                            "4", "KEY", () => _onKeyPress("4"), primaryColor),
                        _buildKey(
                            "5", "ZERO", () => _onKeyPress("5"), primaryColor),
                        _buildKey(
                            "6", "SYNC", () => _onKeyPress("6"), primaryColor),
                        _buildKey(
                            "7", "OPT", () => _onKeyPress("7"), primaryColor),
                        _buildKey(
                            "8", "PGM", () => _onKeyPress("8"), primaryColor),
                        _buildKey(
                            "9", "TST", () => _onKeyPress("9"), primaryColor),
                        _buildKey(
                            "CLR",
                            "",
                            () => setState(() {
                                  tempInput = "";
                                  isEditing = false;
                                }),
                            primaryColor),
                        _buildKey(
                            "0", "", () => _onKeyPress("0"), primaryColor),
                        _buildKey("ENT", "", () => _onEnter(), primaryColor,
                            isAction: true),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String label, String sub, VoidCallback onTap, Color color,
      {bool isAction = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            color: isAction ? color.withOpacity(0.3) : const Color(0xFF222222),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: isAction ? color : Colors.grey[800]!),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: GoogleFonts.blackOpsOne(
                      fontSize: 16, color: Colors.white)), // ลด Font 18->16
              if (sub.isNotEmpty)
                Text(sub,
                    style: GoogleFonts.sarabun(
                        fontSize: 9, color: color)), // ลด Font 10->9
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKnob(
      String label, double val, Function(double) onChg, Color themeColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        SizedBox(
          height: 35, // ลดความสูง
          child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                  value: val,
                  min: 0,
                  max: 100,
                  activeColor: themeColor,
                  inactiveColor: Colors.grey[800],
                  onChanged: onChg)),
        ),
      ],
    );
  }
}
