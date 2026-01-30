import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Prc710Screen extends StatefulWidget {
  const Prc710Screen({super.key});

  @override
  State<Prc710Screen> createState() => _Prc710ScreenState();
}

class _Prc710ScreenState extends State<Prc710Screen> {
  // สถานะเครื่อง
  String frequency = "045.000";
  String tempInput = "";
  bool isEditing = false;
  double volume = 50;
  bool isPttPressed = false;
  bool isLightOn = true;

  // ฟังก์ชั่นกดปุ่มตัวเลข
  void _onKeyPress(String value) {
    setState(() {
      if (!isEditing) {
        isEditing = true;
        tempInput = value;
      } else {
        if (tempInput.length < 6) {
          tempInput += value;
        }
      }
    });
  }

  // ฟังก์ชั่นตกลง (ENT)
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

  // ฟังก์ชั่นลบ (CLR)
  void _onClear() {
    setState(() {
      tempInput = "";
      isEditing = false;
    });
  }

  // ฟังก์ชั่น PTT
  void _togglePtt(bool pressed) {
    setState(() {
      isPttPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: Text("PRC-710 OPERATION",
            style: GoogleFonts.blackOpsOne(color: const Color(0xFF00FF41))),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF00FF41)),
      ),
      body: Column(
        children: [
          // --- ส่วนบน: หน้าจอ LCD และ ปุ่มหมุน (ย่อให้กระชับขึ้น) ---
          Expanded(
            flex: 4, // ให้พื้นที่ส่วนบน 40%
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF2d2d2d),
                border: Border(
                    bottom: BorderSide(color: Colors.grey[800]!, width: 5)),
              ),
              child: Column(
                children: [
                  // 1. หน้าจอ LCD
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      // เอาความสูง fix ออก ให้ยืดตามพื้นที่
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isLightOn
                            ? const Color(0xFF003300)
                            : const Color(0xFF111111),
                        border: Border.all(color: Colors.grey[700]!, width: 4),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isLightOn
                            ? [
                                const BoxShadow(
                                    color: Color(0xFF00FF41),
                                    blurRadius: 5,
                                    spreadRadius: -5)
                              ]
                            : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.battery_full,
                                  color: Colors.black, size: 16),
                              Text("CH: 01",
                                  style: GoogleFonts.shareTechMono(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Icon(
                                  isPttPressed
                                      ? Icons.wifi_tethering
                                      : Icons.wifi_off,
                                  color:
                                      isPttPressed ? Colors.red : Colors.black,
                                  size: 16),
                            ],
                          ),
                          const Spacer(),
                          Center(
                            child: Text(
                              isEditing
                                  ? tempInput.padRight(6, '_')
                                  : frequency,
                              style: GoogleFonts.shareTechMono(
                                fontSize: 40,
                                color: const Color(0xFF00FF41).withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  const Shadow(
                                      blurRadius: 10, color: Color(0xFF00FF41))
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Text("VOL: ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10)),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: volume / 100,
                                  backgroundColor: Colors.black26,
                                  color: Colors.black,
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 2. ปุ่มควบคุม (เรียงแนวนอน)
                  SizedBox(
                    height: 80, // กำหนดความสูงให้ปุ่มควบคุมไม่กินที่เยอะเกินไป
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildKnobControl("VOL", volume,
                            (val) => setState(() => volume = val)),

                        // PTT Button
                        GestureDetector(
                          onTapDown: (_) => _togglePtt(true),
                          onTapUp: (_) => _togglePtt(false),
                          onTapCancel: () => _togglePtt(false),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: isPttPressed
                                  ? Colors.red[900]
                                  : const Color(0xFF333333),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 3),
                              boxShadow: [
                                BoxShadow(
                                    color: isPttPressed
                                        ? Colors.red
                                        : Colors.black,
                                    blurRadius: 10)
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "PTT",
                                style: GoogleFonts.blackOpsOne(
                                    color: isPttPressed
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),

                        // Light Button
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  setState(() => isLightOn = !isLightOn),
                              icon: Icon(Icons.light_mode,
                                  color:
                                      isLightOn ? Colors.yellow : Colors.grey),
                              iconSize: 28,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(height: 4),
                            const Text("LIGHT",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- ส่วนล่าง: แป้นตัวเลข (Keypad) แก้ไขแล้ว! ---
          Expanded(
            flex: 6, // ให้พื้นที่ส่วนล่าง 60%
            child: Container(
              color: const Color(0xFF111111),
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Center(
                // ✅ ใช้ Center + ConstrainedBox บีบไม่ให้ปุ่มกว้างเกินไปบนจอคอม
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      Text("KEYPAD ENTRY",
                          style: GoogleFonts.blackOpsOne(
                              color: Colors.grey[800], fontSize: 18)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 3,
                          // ✅ ปรับ childAspectRatio เป็น 2.0 (ปุ่มจะเตี้ยลง กว้างขึ้น)
                          childAspectRatio: 2.0,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: [
                            _buildKey("1", "FREQ"),
                            _buildKey("2", "MODE"),
                            _buildKey("3", "SQL"),
                            _buildKey("4", "LITE"),
                            _buildKey("5", "ZERO"),
                            _buildKey("6", "CMS"),
                            _buildKey("7", "OPT"),
                            _buildKey("8", "PGM"),
                            _buildKey("9", "TST"),
                            _buildKey("CLR", "", isAction: true),
                            _buildKey("0", ""),
                            _buildKey("ENT", "", isAction: true),
                          ],
                        ),
                      ),
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

  // Widget สร้างปุ่มตัวเลข
  Widget _buildKey(String label, String subLabel, {bool isAction = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (label == "CLR") {
            _onClear();
          } else if (label == "ENT")
            _onEnter();
          else
            _onKeyPress(label);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: isAction ? Colors.grey[850] : const Color(0xFF222222),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 2), blurRadius: 2)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.blackOpsOne(
                  color: isAction ? Colors.orange : Colors.white,
                  fontSize: 20, // ลดขนาดตัวอักษรลงนิดหน่อย
                ),
              ),
              if (subLabel.isNotEmpty)
                Text(
                  subLabel,
                  style: GoogleFonts.sarabun(
                      color: const Color(0xFF00FF41),
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget สร้างปุ่มหมุน
  Widget _buildKnobControl(
      String label, double currentVal, Function(double) onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: GoogleFonts.blackOpsOne(color: Colors.grey, fontSize: 10)),
        SizedBox(
          height: 50, // ลดความสูง Slider
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: currentVal,
              min: 0,
              max: 100,
              activeColor: const Color(0xFF00FF41),
              inactiveColor: Colors.grey[800],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
