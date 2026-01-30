import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _progressValue = 0.0;
  String _loadingText = "INITIALIZING SYSTEM...";
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_progressValue < 1.0) {
          _progressValue += 0.02;
          if (_progressValue > 0.3 && _progressValue < 0.6) {
            _loadingText = "LOADING ASSETS...";
          } else if (_progressValue > 0.6 && _progressValue < 0.9) {
            _loadingText = "CONNECTING TO SERVER...";
          } else if (_progressValue >= 0.9) {
            _loadingText = "SYSTEM READY";
          }
        } else {
          timer.cancel();
        }
      });
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enterApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainSelectorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Background Image (ปรับให้ชัดขึ้น)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_blueprint.jpg"),
                fit: BoxFit.cover,
                // ✅ เพิ่มความชัดตรงนี้ (จาก 0.15 -> 0.5)
                opacity: 0.5,
              ),
            ),
          ),

          // 2. Scanline Effect (ปรับให้จางลงหน่อย เพื่อไม่ให้กวนตา)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF00FF41)
                      .withOpacity(0.03), // ลดความเข้มลงนิดหนึ่ง
                  Colors.transparent
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // 3. เนื้อหาหลัก
          Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: _opacity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Radar (พื้นหลังโปร่ง)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFF00FF41), width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF00FF41).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2)
                      ],
                      // ✅ ปรับพื้นหลังโลโก้ให้โปร่งแสง (มองทะลุได้)
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: const Icon(Icons.radar,
                        size: 80, color: Color(0xFF00FF41)),
                  ),
                  const SizedBox(height: 30),

                  // Title
                  Text(
                    "TACTICAL RADIO SIMULATOR",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.blackOpsOne(
                      fontSize: 28,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        const Shadow(color: Color(0xFF00FF41), blurRadius: 10),
                      ],
                    ),
                  ),
                  Text(
                    "ROYAL THAI ARMY SIGNAL SCHOOL",
                    style: GoogleFonts.shareTechMono(
                      fontSize: 14,
                      color: const Color(0xFF00FF41),
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Developer Info (กรอบโปร่งแสง)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xFF00FF41).withOpacity(0.5)),
                      borderRadius:
                          BorderRadius.circular(10), // เพิ่มความโค้งมนเล็กน้อย
                      // ✅ ปรับพื้นหลังกรอบข้อความให้โปร่งแสง (มองทะลุได้)
                      color: Colors.black.withOpacity(0.6),
                    ),
                    child: Column(
                      children: [
                        Text("DEVELOPED BY",
                            style: GoogleFonts.sarabun(
                                color: Colors.grey, fontSize: 10)),
                        const SizedBox(height: 4),
                        Text(
                          "ร.ต. วสันต์ ทัศนามล",
                          style: GoogleFonts.sarabun(
                              color: const Color(0xFF00FF41),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "โรงเรียนทหารสื่อสาร กรมการทหารสื่อสาร",
                          style: GoogleFonts.sarabun(
                              color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading / Start Button
                  SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        if (_progressValue < 1.0) ...[
                          LinearProgressIndicator(
                            value: _progressValue,
                            color: const Color(0xFF00FF41),
                            backgroundColor: Colors.black.withOpacity(0.5),
                            minHeight: 2,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "$_loadingText [${(_progressValue * 100).toInt()}%]",
                            style: GoogleFonts.shareTechMono(
                                color: const Color(0xFF00FF41), fontSize: 12),
                          ),
                        ] else ...[
                          FadeTransition(
                            opacity: _animation,
                            child: ElevatedButton(
                              onPressed: _enterApp,
                              style: ElevatedButton.styleFrom(
                                // ✅ ปรับปุ่มให้โปร่งแสง
                                backgroundColor:
                                    const Color(0xFF00FF41).withOpacity(0.2),
                                foregroundColor: const Color(0xFF00FF41),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                side: const BorderSide(
                                    color: Color(0xFF00FF41), width: 2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                elevation: 0, // ลดเงาทึบ
                              ),
                              child: Text(
                                "START SIMULATION",
                                style: GoogleFonts.blackOpsOne(
                                    fontSize: 20, letterSpacing: 2),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Copyright
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "COPYRIGHT © 2026 ROYAL THAI ARMY SIGNAL SCHOOL",
                style: GoogleFonts.sarabun(color: Colors.white38, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
