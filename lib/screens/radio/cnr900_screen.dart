import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cnr900Screen extends StatefulWidget {
  const Cnr900Screen({super.key});

  @override
  State<Cnr900Screen> createState() => _Cnr900ScreenState();
}

class _Cnr900ScreenState extends State<Cnr900Screen> {
  String frequency = "052.550";
  String tempInput = "";
  bool isEditing = false;
  double volume = 60;
  bool isPttPressed = false;
  bool isLightOn = true;
  String currentMode = "CLR";

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
      if (currentMode == "CLR") {
        currentMode = "SEC";
      } else if (currentMode == "SEC")
        currentMode = "AJ";
      else
        currentMode = "CLR";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Text("CNR-900 OPERATION",
            style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41))),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
      ),
      body: Column(
        children: [
          // --- ส่วนบน: หน้าจอ LCD ---
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                border: Border(
                    bottom: BorderSide(color: Colors.green[900]!, width: 4)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: isLightOn
                            ? const Color(0xFF002200)
                            : const Color(0xFF050505),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey[600]!, width: 3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("BAT: OK",
                                  style: GoogleFonts.shareTechMono(
                                      color: Colors.white, fontSize: 12)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                color: currentMode == "CLR"
                                    ? Colors.grey
                                    : (currentMode == "SEC"
                                        ? Colors.orange
                                        : Colors.green),
                                child: Text(currentMode,
                                    style: GoogleFonts.blackOpsOne(
                                        color: Colors.black, fontSize: 10)),
                              ),
                              Icon(Icons.signal_cellular_alt,
                                  color:
                                      isPttPressed ? Colors.red : Colors.white,
                                  size: 16),
                            ],
                          ),
                          Center(
                            child: Text(
                              isEditing
                                  ? tempInput.padRight(6, '-')
                                  : frequency,
                              style: GoogleFonts.shareTechMono(
                                  fontSize: 42,
                                  color: const Color(0xFF00FF41),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Vol Indicator
                          Row(
                            children: [
                              const Text("VOL ",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10)),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: volume / 100,
                                  color: const Color(0xFF00FF41),
                                  backgroundColor: Colors.grey[800],
                                  minHeight: 4,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ปุ่มหมุนและ PTT (ลดขนาดลงเพื่อให้ประหยัดที่)
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKnob(
                            "VOL", volume, (v) => setState(() => volume = v)),

                        // PTT Button
                        GestureDetector(
                          onTapDown: (_) => setState(() => isPttPressed = true),
                          onTapUp: (_) => setState(() => isPttPressed = false),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color:
                                  isPttPressed ? Colors.red : Colors.grey[800],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                    color: isPttPressed
                                        ? Colors.red
                                        : Colors.black,
                                    blurRadius: 10)
                              ],
                            ),
                            child: const Center(
                                child: Text("PTT",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12))),
                          ),
                        ),

                        // Light Button
                        IconButton(
                          onPressed: () =>
                              setState(() => isLightOn = !isLightOn),
                          icon: Icon(Icons.lightbulb,
                              color: isLightOn ? Colors.yellow : Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- ส่วนล่าง: Keypad (แก้ไขให้ไม่ล้นจอ) ---
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Center(
                // ✅ จัดกึ่งกลาง
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth:
                          400), // ✅ ล็อคความกว้างไม่ให้เกิน 400px (ปุ่มจะไม่สูงเกินไป)
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio:
                        2.2, // ✅ ปรับให้ปุ่มแบนลง (เตี้ยลง) จะได้ไม่กินที่แนวตั้ง
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    physics:
                        const NeverScrollableScrollPhysics(), // ✅ ล็อคไม่ให้ Scroll
                    children: [
                      _buildKey("1", "FREQ", () => _onKeyPress("1")),
                      _buildKey("2", "MODE", () => _toggleMode()),
                      _buildKey("3", "SQL", () => _onKeyPress("3")),
                      _buildKey("4", "ERF", () => _onKeyPress("4")),
                      _buildKey("5", "ZERO", () => _onKeyPress("5")),
                      _buildKey("6", "DATA", () => _onKeyPress("6")),
                      _buildKey("7", "OPT", () => _onKeyPress("7")),
                      _buildKey("8", "PGM", () => _onKeyPress("8")),
                      _buildKey("9", "TST", () => _onKeyPress("9")),
                      _buildKey(
                          "CLR",
                          "",
                          () => setState(() {
                                tempInput = "";
                                isEditing = false;
                              })),
                      _buildKey("0", "", () => _onKeyPress("0")),
                      _buildKey("ENT", "", () => _onEnter(), isAction: true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String label, String sub, VoidCallback onTap,
      {bool isAction = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            color: isAction ? const Color(0xFF003300) : const Color(0xFF222222),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: GoogleFonts.blackOpsOne(
                      fontSize: 18,
                      color: Colors.white)), // ลดขนาด Font ลงนิดหน่อย
              if (sub.isNotEmpty)
                Text(sub,
                    style: GoogleFonts.sarabun(
                        fontSize: 10, color: const Color(0xFF00FF41))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKnob(String label, double val, Function(double) onChg) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        SizedBox(
          height: 40, // ลดความสูง Knob
          child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                  value: val,
                  min: 0,
                  max: 100,
                  activeColor: const Color(0xFF00FF41),
                  inactiveColor: Colors.grey[800],
                  onChanged: onChg)),
        ),
      ],
    );
  }
}
