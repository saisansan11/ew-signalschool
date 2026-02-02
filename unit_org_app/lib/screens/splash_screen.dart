import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../app/constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _waveController;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSequence();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  void _startSequence() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _showContent = true);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),

          // Grid pattern overlay
          _buildGridPattern(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo and title section
                _buildLogoSection(),

                const Spacer(flex: 1),

                // Feature cards
                if (_showContent) _buildFeatureCards(),

                const Spacer(flex: 1),

                // Enter button
                if (_showContent) _buildEnterButton(),

                const SizedBox(height: 40),

                // Footer
                if (_showContent) _buildFooter(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _rotateController]),
      builder: (context, child) {
        return Stack(
          children: [
            // Top-right orb
            Positioned(
              top: -100,
              right: -100,
              child: Transform.rotate(
                angle: _rotateController.value * 2 * math.pi,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.signalCorps.withOpacity(
                            0.15 + _pulseController.value * 0.1),
                        AppColors.signalCorps.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom-left orb
            Positioned(
              bottom: -80,
              left: -80,
              child: Transform.rotate(
                angle: -_rotateController.value * 2 * math.pi,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(
                            0.12 + _pulseController.value * 0.08),
                        AppColors.primary.withOpacity(0.03),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Center glow
            Center(
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.signalCorps.withOpacity(
                          0.05 + _pulseController.value * 0.03),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridPattern() {
    return Opacity(
      opacity: 0.03,
      child: CustomPaint(
        painter: GridPainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Signal tower icon with glow
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.signalCorps.withOpacity(0.3),
                    AppColors.signalCorps.withOpacity(0.15),
                    AppColors.signalCorps.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.signalCorps.withOpacity(
                        0.2 + _pulseController.value * 0.15),
                    blurRadius: 50 + _pulseController.value * 20,
                    spreadRadius: 10 + _pulseController.value * 5,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.signalCorps,
                        AppColors.signalCorps.withOpacity(0.8),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.signalCorps.withOpacity(0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.cell_tower_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scaleXY(begin: 1.0, end: 1.05, duration: 2000.ms)
            .then()
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),

        const SizedBox(height: 32),

        // Title
        Text(
          'หน่วยทหารสื่อสาร',
          style: AppTextStyles.displayLarge.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 8),

        // Subtitle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.signalCorps.withOpacity(0.2),
                AppColors.signalCorps.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            border: Border.all(
              color: AppColors.signalCorps.withOpacity(0.3),
            ),
          ),
          child: Text(
            'ROYAL THAI ARMY SIGNAL CORPS',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.signalCorps,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 500.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 20),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'ระบบเรียนรู้โครงสร้างและการจัดหน่วย\nสำหรับนักเรียนทหารสื่อสาร',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 700.ms),
      ],
    );
  }

  Widget _buildFeatureCards() {
    final features = [
      {
        'icon': Icons.account_tree_rounded,
        'title': 'ผังการจัดหน่วย',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.map_rounded,
        'title': 'แผนที่หน่วย',
        'color': AppColors.signalCorps,
      },
      {
        'icon': Icons.quiz_rounded,
        'title': 'แบบทดสอบ',
        'color': AppColors.success,
      },
      {
        'icon': Icons.style_rounded,
        'title': 'Flashcards',
        'color': AppColors.accent,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: features.asMap().entries.map((entry) {
          final index = entry.key;
          final feature = entry.value;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 6,
                right: index == features.length - 1 ? 0 : 6,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(
                  color: (feature['color'] as Color).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (feature['color'] as Color).withOpacity(0.1),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: (feature['color'] as Color).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      size: 22,
                      color: feature['color'] as Color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    feature['title'] as String,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
                .animate(delay: Duration(milliseconds: 800 + (index * 100)))
                .fadeIn()
                .slideY(begin: 0.3, end: 0),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEnterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GestureDetector(
        onTap: _navigateToHome,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.signalCorps,
                AppColors.signalCorps.withOpacity(0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.signalCorps.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'เข้าสู่บทเรียน',
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .shimmer(
              delay: 2000.ms,
              duration: 1500.ms,
              color: Colors.white.withOpacity(0.2),
            ),
      ),
    ).animate(delay: 1200.ms).fadeIn().slideY(begin: 0.3, end: 0);
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.signalCorps,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.signalCorps.withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'กรมการทหารสื่อสาร กองทัพบก',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.signalCorps,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.signalCorps.withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Signal Corps Learning System',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textMuted.withOpacity(0.5),
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    ).animate(delay: 1400.ms).fadeIn();
  }
}

/// Grid pattern painter for background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.signalCorps
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

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
