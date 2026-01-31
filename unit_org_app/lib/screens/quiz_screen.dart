import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../app/constants.dart';
import '../models/unit_models.dart';
import '../data/signal_corps_data.dart';
import '../services/progress_service.dart';

class QuizScreen extends StatefulWidget {
  final String? category;
  final int? difficulty;

  const QuizScreen({super.key, this.category, this.difficulty});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with TickerProviderStateMixin {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _correctCount = 0;
  bool _showExplanation = false;

  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _celebrateController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _initAnimations();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _celebrateController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  void _loadQuestions() {
    if (widget.category != null) {
      _questions = SignalCorpsData.getQuizByCategory(widget.category!);
    } else if (widget.difficulty != null) {
      _questions = SignalCorpsData.getQuizByDifficulty(widget.difficulty!);
    } else {
      _questions = List.from(SignalCorpsData.quizQuestions);
    }
    _questions.shuffle();
    if (_questions.length > 10) {
      _questions = _questions.sublist(0, 10);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _celebrateController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (_answered) return;

    HapticFeedback.mediumImpact();

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _correctCount++;
        _celebrateController.forward(from: 0);
      } else {
        _shakeController.forward(from: 0);
      }
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() => _showExplanation = true);
      }
    });
  }

  void _nextQuestion() {
    HapticFeedback.lightImpact();

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
        _showExplanation = false;
      });
    } else {
      _showResults();
    }
  }

  Future<void> _showResults() async {
    final percentage = (_correctCount / _questions.length * 100).round();
    final passed = percentage >= 70;

    // Record quiz result
    final quizId = '${widget.category ?? 'general'}_${DateTime.now().millisecondsSinceEpoch}';
    await ProgressService.instance.recordQuizResult(
      quizId: quizId,
      score: percentage,
      totalQuestions: _questions.length,
      correctAnswers: _correctCount,
    );

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => _QuizResultSheet(
        correctCount: _correctCount,
        totalQuestions: _questions.length,
        percentage: percentage,
        passed: passed,
        onRetry: () {
          Navigator.pop(context);
          setState(() {
            _currentIndex = 0;
            _selectedAnswer = null;
            _answered = false;
            _showExplanation = false;
            _correctCount = 0;
            _loadQuestions();
          });
        },
        onFinish: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;
    final isCorrect = _answered && _selectedAnswer == question.correctIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background glow effects
          _buildBackgroundEffects(isCorrect),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar
                _buildAppBar(),

                // Progress section
                _buildProgressSection(progress),

                // Question and options
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Question card
                        _buildQuestionCard(question),
                        const SizedBox(height: 24),

                        // Options
                        _buildOptions(question),

                        // Explanation
                        if (_showExplanation && question.explanation != null)
                          _buildExplanation(question.explanation!),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom next button
          if (_answered) _buildNextButton(),

          // Correct celebration overlay
          if (isCorrect)
            Positioned.fill(
              child: IgnorePointer(
                child: _buildCelebrationParticles(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackgroundEffects(bool isCorrect) {
    return Stack(
      children: [
        // Primary glow
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Positioned(
              top: -150 + (_pulseController.value * 30),
              right: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isCorrect ? AppColors.success : AppColors.primary)
                          .withValues(alpha: 0.15 + (_pulseController.value * 0.1)),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Secondary glow
        Positioned(
          bottom: -100,
          left: -50,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => _showExitConfirmation(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Text(
              widget.category ?? 'Quiz',
              style: AppTextStyles.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Score badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.success.withValues(alpha: 0.2),
                  AppColors.success.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppColors.success,
                ),
                const SizedBox(width: 6),
                Text(
                  '$_correctCount',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildProgressSection(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              child: Stack(
                children: [
                  AnimatedFractionallySizedBox(
                    duration: AppDurations.normal,
                    curve: Curves.easeOutCubic,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Question counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ข้อ ${_currentIndex + 1} จาก ${_questions.length}',
                style: AppTextStyles.labelMedium,
              ),
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildQuestionCard(QuizQuestion question) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _answered && _selectedAnswer != question.correctIndex
                ? math.sin(_shakeAnimation.value) * 5
                : 0,
            0,
          ),
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.paddingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          border: Border.all(
            color: _answered
                ? (_selectedAnswer == question.correctIndex
                    ? AppColors.success.withValues(alpha: 0.5)
                    : AppColors.error.withValues(alpha: 0.5))
                : AppColors.border,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _answered
                  ? (_selectedAnswer == question.correctIndex
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.error.withValues(alpha: 0.15))
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with difficulty and category
            Row(
              children: [
                // Difficulty stars
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      return Icon(
                        i < question.difficulty
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 14,
                        color: i < question.difficulty
                            ? AppColors.warning
                            : AppColors.textMuted,
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 8),

                // Category tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    question.category,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Question text
            Text(
              question.question,
              style: AppTextStyles.headlineMedium.copyWith(
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildOptions(QuizQuestion question) {
    return Column(
      children: List.generate(
        question.options.length,
        (index) {
          final isSelected = _selectedAnswer == index;
          final isCorrect = index == question.correctIndex;
          final showResult = _answered;

          Color bgColor = AppColors.surface;
          Color borderColor = AppColors.border;
          Color textColor = AppColors.textPrimary;
          Color letterBgColor = AppColors.surfaceLight;
          Color letterColor = AppColors.textSecondary;

          if (showResult) {
            if (isCorrect) {
              bgColor = AppColors.success.withValues(alpha: 0.15);
              borderColor = AppColors.success;
              textColor = AppColors.textPrimary;
              letterBgColor = AppColors.success;
              letterColor = Colors.white;
            } else if (isSelected && !isCorrect) {
              bgColor = AppColors.error.withValues(alpha: 0.15);
              borderColor = AppColors.error;
              textColor = AppColors.textPrimary;
              letterBgColor = AppColors.error;
              letterColor = Colors.white;
            }
          } else if (isSelected) {
            bgColor = AppColors.primary.withValues(alpha: 0.15);
            borderColor = AppColors.primary;
            letterBgColor = AppColors.primary;
            letterColor = Colors.white;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => _selectAnswer(index),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: isSelected || (showResult && isCorrect)
                      ? [
                          BoxShadow(
                            color: borderColor.withValues(alpha: 0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    // Option letter circle
                    AnimatedContainer(
                      duration: AppDurations.fast,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: letterBgColor,
                        shape: BoxShape.circle,
                        boxShadow: isSelected || (showResult && isCorrect)
                            ? [
                                BoxShadow(
                                  color: letterBgColor.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: showResult && isCorrect
                            ? Icon(
                                Icons.check_rounded,
                                size: 22,
                                color: letterColor,
                              )
                            : showResult && isSelected && !isCorrect
                                ? Icon(
                                    Icons.close_rounded,
                                    size: 22,
                                    color: letterColor,
                                  )
                                : Text(
                                    String.fromCharCode(65 + index),
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: letterColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Option text
                    Expanded(
                      child: Text(
                        question.options[index],
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: textColor,
                          fontWeight: isSelected || (showResult && isCorrect)
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),

                    // Result icon
                    if (showResult && isCorrect)
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      )
                    else if (showResult && isSelected && !isCorrect)
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            )
                .animate(delay: Duration(milliseconds: 150 + (index * 50)))
                .fadeIn()
                .slideX(begin: 0.1, end: 0),
          );
        },
      ),
    );
  }

  Widget _buildExplanation(String explanation) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.info.withValues(alpha: 0.15),
            AppColors.info.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              size: 20,
              color: AppColors.info,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'คำอธิบาย',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  explanation,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildNextButton() {
    final isLastQuestion = _currentIndex >= _questions.length - 1;

    return Positioned(
      left: AppSizes.paddingM,
      right: AppSizes.paddingM,
      bottom: MediaQuery.of(context).padding.bottom + AppSizes.paddingM,
      child: GestureDetector(
        onTap: _nextQuestion,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: isLastQuestion
                ? AppColors.accentGradient
                : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            boxShadow: [
              BoxShadow(
                color: (isLastQuestion ? AppColors.accent : AppColors.primary)
                    .withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLastQuestion ? 'ดูผลคะแนน' : 'ข้อถัดไป',
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isLastQuestion
                    ? Icons.celebration_rounded
                    : Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.5, end: 0),
    );
  }

  Widget _buildCelebrationParticles() {
    return AnimatedBuilder(
      animation: _celebrateController,
      builder: (context, child) {
        if (_celebrateController.value == 0) return const SizedBox.shrink();

        return CustomPaint(
          painter: _CelebrationPainter(
            progress: _celebrateController.value,
            color: AppColors.success,
          ),
        );
      },
    );
  }

  void _showExitConfirmation() {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        ),
        title: Text(
          'ออกจาก Quiz?',
          style: AppTextStyles.headlineSmall,
        ),
        content: Text(
          'ความคืบหน้าของคุณจะไม่ถูกบันทึก',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ทำต่อ',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
            ),
            child: const Text(
              'ออก',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Celebration painter for correct answer particles
class _CelebrationPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_Particle> _particles = [];

  _CelebrationPainter({required this.progress, required this.color}) {
    if (_particles.isEmpty) {
      final random = math.Random(42);
      for (int i = 0; i < 20; i++) {
        _particles.add(_Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 8 + 4,
          speed: random.nextDouble() * 0.5 + 0.3,
          angle: random.nextDouble() * math.pi * 2,
        ));
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in _particles) {
      final opacity = (1 - progress) * 0.8;
      paint.color = color.withValues(alpha: opacity);

      final x = size.width * particle.x +
          math.cos(particle.angle) * progress * 100 * particle.speed;
      final y = size.height * 0.4 +
          math.sin(particle.angle) * progress * 100 * particle.speed -
          progress * 50;

      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1 - progress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CelebrationPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double angle;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

// Quiz Result Bottom Sheet
class _QuizResultSheet extends StatefulWidget {
  final int correctCount;
  final int totalQuestions;
  final int percentage;
  final bool passed;
  final VoidCallback onRetry;
  final VoidCallback onFinish;

  const _QuizResultSheet({
    required this.correctCount,
    required this.totalQuestions,
    required this.percentage,
    required this.passed,
    required this.onRetry,
    required this.onFinish,
  });

  @override
  State<_QuizResultSheet> createState() => _QuizResultSheetState();
}

class _QuizResultSheetState extends State<_QuizResultSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _percentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _percentAnimation = Tween<double>(begin: 0, end: widget.percentage.toDouble()).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultColor = widget.passed ? AppColors.success : AppColors.error;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Column(
              children: [
                // Result icon with animation
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          resultColor.withValues(alpha: 0.3),
                          resultColor.withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: resultColor.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.passed
                          ? Icons.emoji_events_rounded
                          : Icons.refresh_rounded,
                      size: 50,
                      color: resultColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Result text
                Text(
                  widget.passed ? 'ยอดเยี่ยม!' : 'ลองอีกครั้ง',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: resultColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'คุณตอบถูก ${widget.correctCount} จาก ${widget.totalQuestions} ข้อ',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 32),

                // Animated percentage circle
                AnimatedBuilder(
                  animation: _percentAnimation,
                  builder: (context, child) {
                    return SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              value: 1,
                              strokeWidth: 12,
                              backgroundColor: AppColors.surfaceLight,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.surfaceLight,
                              ),
                            ),
                          ),

                          // Progress circle
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              value: _percentAnimation.value / 100,
                              strokeWidth: 12,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(resultColor),
                              strokeCap: StrokeCap.round,
                            ),
                          ),

                          // Percentage text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${_percentAnimation.value.round()}%',
                                style: AppTextStyles.displayLarge.copyWith(
                                  color: resultColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'คะแนน',
                                style: AppTextStyles.labelMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Feedback message
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.passed
                            ? Icons.tips_and_updates_rounded
                            : Icons.school_rounded,
                        color: resultColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.passed
                              ? 'คุณเข้าใจเนื้อหาได้ดี! ลองเรียนรู้หัวข้อถัดไป'
                              : 'ลองทบทวน Flashcard อีกครั้ง แล้วกลับมาทำ Quiz ใหม่',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onFinish,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(AppSizes.radiusL),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Center(
                            child: Text(
                              'กลับ',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: widget.onRetry,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: widget.passed
                                ? AppColors.accentGradient
                                : AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(AppSizes.radiusL),
                            boxShadow: [
                              BoxShadow(
                                color: (widget.passed
                                        ? AppColors.accent
                                        : AppColors.primary)
                                    .withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                widget.passed
                                    ? Icons.play_arrow_rounded
                                    : Icons.replay_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.passed ? 'ทำอีกครั้ง' : 'ลองใหม่',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
