import 'package:flutter/material.dart';
import 'dart:math';
import '../../app/constants.dart';
import '../../services/auth_service.dart';
import '../main_shell.dart';
import '../auth/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  double _loadingProgress = 0.0;
  String _loadingText = 'กำลังเริ่มต้นระบบ...';

  final List<String> _loadingSteps = [
    'กำลังเริ่มต้นระบบ...',
    'โหลดฐานข้อมูล EW...',
    'เตรียมโมดูลการเรียนรู้...',
    'โหลดเครื่องมือคำนวณ...',
    'พร้อมใช้งาน!',
  ];

  @override
  void initState() {
    super.initState();

    // Radar sweep animation
    _radarController = AnimationController(
      vsync: this,
      duration: AppDurations.radarSweep,
    )..repeat();

    // Pulse animation for outer rings
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Fade in animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _simulateLoading();
  }

  void _simulateLoading() async {
    for (int i = 0; i < _loadingSteps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _loadingProgress = (i + 1) / _loadingSteps.length;
          _loadingText = _loadingSteps[i];
        });
      }
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      // Check authentication status
      final isLoggedIn = AuthService.isLoggedIn();

      if (isLoggedIn) {
        // Already logged in - go to main app
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainShell(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      } else {
        // Not logged in - show auth screen
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AuthScreen(
                  onAuthSuccess: () {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const MainShell(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Stack(
                children: [
                  // Background grid pattern
                  CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: GridPainter(),
                  ),

                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Radar animation
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: AnimatedBuilder(
                            animation: Listenable.merge([
                              _radarController,
                              _pulseController,
                            ]),
                            builder: (context, child) {
                              return CustomPaint(
                                painter: RadarPainter(
                                  sweepProgress: _radarController.value,
                                  pulseProgress: _pulseController.value,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 40),

                        // App name
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.radarGradient.createShader(bounds),
                          child: const Text(
                            'RTA EW SIM',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Electronic Warfare Training System',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Loading bar
                        SizedBox(
                          width: 250,
                          child: Column(
                            children: [
                              // Progress bar
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: 250 * _loadingProgress,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.radarGradient,
                                        borderRadius: BorderRadius.circular(2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.radar.withOpacity(
                                              0.5,
                                            ),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Loading text
                              Text(
                                _loadingText,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Percentage
                              Text(
                                '${(_loadingProgress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.radar,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Version at bottom
                  const Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Text(
                      AppStrings.version,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Radar Painter
class RadarPainter extends CustomPainter {
  final double sweepProgress;
  final double pulseProgress;

  RadarPainter({required this.sweepProgress, required this.pulseProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw concentric circles
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      final radius = maxRadius * (i / 4);
      final opacity = 0.1 + (pulseProgress * 0.1 * (5 - i) / 4);
      ringPaint.color = AppColors.radar.withOpacity(opacity);
      canvas.drawCircle(center, radius, ringPaint);
    }

    // Draw cross lines
    final linePaint = Paint()
      ..color = AppColors.radar.withOpacity(0.15)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      linePaint,
    );
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      linePaint,
    );

    // Draw sweep
    final sweepAngle = sweepProgress * 2 * pi;
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: sweepAngle - pi / 3,
        endAngle: sweepAngle,
        colors: [
          Colors.transparent,
          AppColors.radar.withOpacity(0.0),
          AppColors.radar.withOpacity(0.3),
          AppColors.radar.withOpacity(0.6),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
        transform: GradientRotation(sweepAngle - pi / 3),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    canvas.drawCircle(center, maxRadius, sweepPaint);

    // Draw sweep line
    final sweepLinePaint = Paint()
      ..color = AppColors.radar
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final sweepEnd = Offset(
      center.dx + maxRadius * cos(sweepAngle - pi / 2),
      center.dy + maxRadius * sin(sweepAngle - pi / 2),
    );
    canvas.drawLine(center, sweepEnd, sweepLinePaint);

    // Draw center dot
    final centerDotPaint = Paint()..color = AppColors.radar;
    canvas.drawCircle(center, 4, centerDotPaint);

    // Draw blips (random targets)
    final blipPaint = Paint()..color = AppColors.radar;
    final random = Random(42); // Fixed seed for consistent blips
    for (int i = 0; i < 5; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final distance = random.nextDouble() * maxRadius * 0.8 + maxRadius * 0.1;
      final blipPos = Offset(
        center.dx + distance * cos(angle),
        center.dy + distance * sin(angle),
      );

      // Fade blip based on sweep position
      final angleDiff = ((sweepAngle - pi / 2) - angle) % (2 * pi);
      final fadeProgress = angleDiff / (2 * pi);
      final blipOpacity = (1 - fadeProgress).clamp(0.0, 1.0);

      if (blipOpacity > 0.1) {
        blipPaint.color = AppColors.radar.withOpacity(blipOpacity);
        canvas.drawCircle(blipPos, 3, blipPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) =>
      sweepProgress != oldDelegate.sweepProgress ||
      pulseProgress != oldDelegate.pulseProgress;
}

// Grid background painter
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..strokeWidth = 0.5;

    const spacing = 30.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
