import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class Prc624Screen extends StatefulWidget {
  const Prc624Screen({super.key});

  @override
  State<Prc624Screen> createState() => _Prc624ScreenState();
}

class _Prc624ScreenState extends State<Prc624Screen> {
  // --- 0. พิกัดฐานข้อมูล (แก้ไขแล้ว) ---

  // ✅ 1. แก้พิกัดรูปภาพ: ใส่ assets/assets/ ซ้อน 2 ชั้น ตามที่เจอในโฟลเดอร์
  final String imgUrl =
      "https://saisansan11.github.io/military_sim_2026/assets/assets/images/prc624_real.png";

  // 2. พิกัดเสียง (อันนี้ถูกต้องแล้วครับ)
  final String soundBase =
      "https://saisansan11.github.io/military_sim_2026/assets/assets/";

  // --- 1. ระบบเสียง ---
  final AudioPlayer _staticPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  final String soundSwitch = "sounds/switch.mp3";
  final String soundBeep = "sounds/beep.mp3";
  final String soundStatic = "sounds/static.mp3";

  // --- 2. ตัวแปรสถานะเครื่อง ---
  String frequency = "45.500";
  bool isPowerOn = false;
  bool isTransmitting = false;
  bool isBacklightOn = false;

  // --- 3. ตัวแปรโหมดแก้ไข ---
  bool isEditing = false;
  int editIndex = 0;
  List<String> tempFreqList = [];
  bool showCursor = true;
  Timer? _blinkTimer;

  final bool isDebugMode = false;

  @override
  void dispose() {
    _staticPlayer.stop();
    _effectPlayer.dispose();
    _staticPlayer.dispose();
    _blinkTimer?.cancel();
    super.dispose();
  }

  Future<void> _playLocalSound(
    AudioPlayer player,
    String path, {
    bool loop = false,
  }) async {
    try {
      if (loop) {
        await player.setReleaseMode(ReleaseMode.loop);
      } else {
        await player.setReleaseMode(ReleaseMode.stop);
      }
      // ดึงเสียงจาก Base ที่ตั้งไว้
      await player.play(UrlSource("$soundBase$path"));
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  void _showTacticalMessage(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black87,
        content: Row(
          children: [
            Icon(Icons.terminal, color: color),
            const SizedBox(width: 10),
            Text(msg, style: GoogleFonts.vt323(color: color, fontSize: 18)),
          ],
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- Logic ---
  void _togglePower() async {
    setState(() => isPowerOn = !isPowerOn);
    if (isPowerOn) {
      await _playLocalSound(_effectPlayer, soundSwitch);
      setState(() => frequency = "88.888");
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() => frequency = "45.500");
        _playLocalSound(_staticPlayer, soundStatic, loop: true);
      }
    } else {
      _staticPlayer.stop();
      _playLocalSound(_effectPlayer, soundSwitch);
      _blinkTimer?.cancel();
      setState(() {
        isTransmitting = false;
        isBacklightOn = false;
        isEditing = false;
      });
    }
  }

  void _startEditing() {
    if (!isPowerOn) return;
    setState(() {
      isEditing = true;
      tempFreqList = frequency.split('');
      editIndex = 0;
      showCursor = true;
    });
    _blinkTimer?.cancel();
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) setState(() => showCursor = !showCursor);
    });
  }

  void _moveCursor() {
    if (!isEditing) {
      _startEditing();
      return;
    }
    _playLocalSound(_effectPlayer, soundSwitch);
    setState(() {
      editIndex++;
      if (editIndex >= tempFreqList.length) editIndex = 0;
      if (tempFreqList[editIndex] == '.') editIndex++;
      showCursor = true;
    });
  }

  void _changeNumber() {
    if (!isEditing) return;
    _playLocalSound(_effectPlayer, soundSwitch);
    setState(() {
      int currentVal = int.parse(tempFreqList[editIndex]);
      currentVal++;
      if (currentVal > 9) currentVal = 0;
      tempFreqList[editIndex] = currentVal.toString();
      showCursor = true;
    });
  }

  void _saveFrequency() {
    if (!isEditing) return;
    setState(() {
      frequency = tempFreqList.join('');
      isEditing = false;
      _blinkTimer?.cancel();
      showCursor = true;
    });
    _playLocalSound(_effectPlayer, soundBeep);
    _showTacticalMessage("FREQ SAVED: $frequency MHz", Colors.green);
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("AN/PRC-624 OPERATION"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00FF41)),
          onPressed: () {
            _staticPlayer.stop();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ClipRect(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 400,
              height: 750,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      imgUrl,
                      // ✅ แก้ไข: ใช้ BoxFit.fill เพื่อบังคับภาพให้ตรงบล็อก ไม่เลื่อน
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: Text(
                              "Image Not Found\nCheck URL",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 25,
                    child: _buildKnobOverlay(size: 70, onTap: _togglePower),
                  ),
                  Positioned(
                    top: 30,
                    right: 110,
                    child: _buildKnobOverlay(size: 65),
                  ),
                  Positioned(
                    top: 395,
                    left: 105,
                    child: _buildRealScreen(width: 190, height: 50),
                  ),

                  // ปุ่มกด 4 ปุ่ม
                  Positioned(
                    bottom: 140,
                    left: 45,
                    child: _buildButtonOverlay(
                      size: 60,
                      onTap: () {
                        if (!isPowerOn) return;
                        _playLocalSound(_effectPlayer, soundSwitch);
                        if (isEditing) {
                          setState(() {
                            isEditing = false;
                            _blinkTimer?.cancel();
                            showCursor = true;
                          });
                        } else {
                          setState(() => isBacklightOn = !isBacklightOn);
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 140,
                    left: 122,
                    child: _buildButtonOverlay(
                      size: 60,
                      onTap: () {
                        if (!isPowerOn) return;
                        _moveCursor();
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 140,
                    left: 200,
                    child: _buildButtonOverlay(
                      size: 60,
                      onTap: () {
                        if (!isPowerOn) return;
                        if (isEditing) {
                          _changeNumber();
                        } else {
                          _playLocalSound(_effectPlayer, soundSwitch);
                          _showTacticalMessage("BATTERY: GOOD", Colors.green);
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 140,
                    left: 278,
                    child: _buildButtonOverlay(
                      size: 60,
                      onTap: () {
                        if (!isPowerOn) return;
                        _saveFrequency();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTapDown: (_) {
          if (isPowerOn) {
            setState(() => isTransmitting = true);
            _staticPlayer.pause();
          }
        },
        onTapUp: (_) async {
          if (isPowerOn) {
            setState(() => isTransmitting = false);
            await _playLocalSound(_effectPlayer, soundBeep);
            await Future.delayed(const Duration(milliseconds: 300));
            _staticPlayer.resume();
          }
        },
        child: Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: isTransmitting
                ? const Color(0xFFD32F2F)
                : const Color(0xFF37474F),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white38, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 10,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mic, color: Colors.white, size: 30),
              Text(
                "PTT",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRealScreen({required double width, required double height}) {
    Color screenColor = Colors.black.withOpacity(0.85);
    if (isPowerOn) {
      if (isBacklightOn) {
        screenColor = const Color(0xFF9CCC65).withOpacity(0.6);
      } else {
        screenColor = const Color(0xFF558B2F).withOpacity(0.2);
      }
    }
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: screenColor,
        borderRadius: BorderRadius.circular(4),
        border: isDebugMode ? Border.all(color: Colors.yellow, width: 2) : null,
      ),
      child: isPowerOn
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...(isEditing ? tempFreqList : frequency.split(''))
                    .asMap()
                    .entries
                    .map((entry) {
                  int idx = entry.key;
                  String char = entry.value;
                  bool isCursorPos = isEditing && idx == editIndex;
                  Color charColor = Colors.black.withOpacity(0.9);
                  if (isCursorPos && !showCursor) {
                    charColor = Colors.transparent;
                  }
                  Color bgColor = Colors.transparent;
                  if (isCursorPos) bgColor = Colors.black.withOpacity(0.1);
                  return Container(
                    color: bgColor,
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Text(
                      char,
                      style: GoogleFonts.vt323(
                        fontSize: height * 0.9,
                        color: charColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            )
          : const SizedBox(),
    );
  }

  Widget _buildButtonOverlay({
    required double size,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDebugMode ? Colors.red.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isDebugMode ? Border.all(color: Colors.red, width: 2) : null,
        ),
      ),
    );
  }

  Widget _buildKnobOverlay({required double size, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isDebugMode ? Colors.blue.withOpacity(0.3) : Colors.transparent,
          border: isDebugMode ? Border.all(color: Colors.blue, width: 2) : null,
        ),
      ),
    );
  }
}
