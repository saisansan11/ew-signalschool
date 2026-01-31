import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../app/constants.dart';
import '../models/unit_models.dart';
import '../data/signal_corps_data.dart';
import '../services/progress_service.dart';

class FlashcardScreen extends StatefulWidget {
  final String? category;

  const FlashcardScreen({super.key, this.category});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with TickerProviderStateMixin {
  late List<UnitFlashcard> _cards;
  int _currentIndex = 0;
  bool _showAnswer = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;
  late Animation<double> _fadeAnimation;

  // Swipe tracking
  double _dragPosition = 0;
  bool _isDragging = false;
  SwipeDirection? _swipeDirection;

  // Stats
  int _knownCount = 0;
  int _learningCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCards();
    _initAnimations();
  }

  void _initAnimations() {
    _flipController = AnimationController(
      duration: AppDurations.cardFlip,
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );

    _swipeController = AnimationController(
      duration: AppDurations.normal,
      vsync: this,
    );
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _swipeController, curve: Curves.easeOut),
    );
  }

  void _loadCards() {
    if (widget.category != null) {
      _cards = List.from(SignalCorpsData.getFlashcardsByCategory(widget.category!));
    } else {
      _cards = List.from(SignalCorpsData.flashcards);
    }
    _cards.shuffle();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_showAnswer) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _onDragStart(DragStartDetails details) {
    if (!_showAnswer) return;
    setState(() {
      _isDragging = true;
      _dragPosition = 0;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_showAnswer || !_isDragging) return;
    setState(() {
      _dragPosition += details.delta.dx;
      if (_dragPosition.abs() > 50) {
        _swipeDirection = _dragPosition > 0
            ? SwipeDirection.right
            : SwipeDirection.left;
      } else {
        _swipeDirection = null;
      }
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_showAnswer || !_isDragging) return;

    final velocity = details.velocity.pixelsPerSecond.dx;
    final threshold = MediaQuery.of(context).size.width * 0.3;

    if (_dragPosition.abs() > threshold || velocity.abs() > 500) {
      if (_dragPosition > 0 || velocity > 500) {
        _animateSwipe(SwipeDirection.right);
      } else {
        _animateSwipe(SwipeDirection.left);
      }
    } else {
      setState(() {
        _dragPosition = 0;
        _swipeDirection = null;
        _isDragging = false;
      });
    }
  }

  void _animateSwipe(SwipeDirection direction) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = direction == SwipeDirection.right
        ? Offset(screenWidth * 1.5, 0)
        : Offset(-screenWidth * 1.5, 0);

    _swipeAnimation = Tween<Offset>(
      begin: Offset(_dragPosition, 0),
      end: targetOffset,
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOutCubic,
    ));

    await _swipeController.forward();

    if (direction == SwipeDirection.right) {
      _markAsKnown();
    } else {
      _markAsLearning();
    }

    _swipeController.reset();
    setState(() {
      _dragPosition = 0;
      _swipeDirection = null;
      _isDragging = false;
    });
  }

  void _markAsKnown() async {
    final card = _cards[_currentIndex];
    await ProgressService.instance.markFlashcard(card.id, true);

    setState(() {
      _knownCount++;
      _nextCard();
    });
  }

  void _markAsLearning() async {
    final card = _cards[_currentIndex];
    await ProgressService.instance.markFlashcard(card.id, false);

    setState(() {
      _learningCount++;
      if (_currentIndex < _cards.length - 1) {
        _cards.add(_cards[_currentIndex]);
      }
      _nextCard();
    });
  }

  void _nextCard() {
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
        _flipController.reset();
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CompletionDialog(
        knownCount: _knownCount,
        learningCount: _learningCount,
        onRestart: () {
          Navigator.pop(context);
          setState(() {
            _currentIndex = 0;
            _knownCount = 0;
            _learningCount = 0;
            _showAnswer = false;
            _flipController.reset();
            _loadCards();
          });
        },
        onExit: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Flashcards')),
        body: const Center(
          child: Text('ไม่มี Flashcards ในหมวดนี้'),
        ),
      );
    }

    final card = _cards[_currentIndex];
    final progress = (_currentIndex + 1) / _cards.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background glow
          _buildBackgroundGlow(),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(progress),

                // Stats row
                _buildStatsRow()
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 300.ms),

                const SizedBox(height: 24),

                // Flashcard area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const Spacer(flex: 1),
                        _buildCard(card),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),

                // Bottom controls
                _buildBottomControls(),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Swipe indicators overlay
          if (_swipeDirection != null) _buildSwipeIndicator(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlow() {
    return Positioned.fill(
      child: Stack(
        children: [
          if (_swipeDirection == SwipeDirection.right)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      AppColors.success.withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
            ),
          if (_swipeDirection == SwipeDirection.left)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.transparent,
                      AppColors.warning.withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(double progress) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.category ?? 'Flashcards',
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_currentIndex + 1} จาก ${_cards.length}',
                      style: AppTextStyles.labelMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _loadCards();
                    _currentIndex = 0;
                    _showAnswer = false;
                    _flipController.reset();
                  });
                },
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.shuffle,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: AppDurations.normal,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StatChip(
            icon: Icons.check_circle,
            color: AppColors.success,
            value: _knownCount,
            label: 'จำได้',
          ),
          const SizedBox(width: 24),
          _StatChip(
            icon: Icons.refresh,
            color: AppColors.warning,
            value: _learningCount,
            label: 'กำลังเรียน',
          ),
        ],
      ),
    );
  }

  Widget _buildCard(UnitFlashcard card) {
    return GestureDetector(
      onTap: _flipCard,
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipAnimation, _swipeController]),
        builder: (context, child) {
          final angle = _flipAnimation.value * pi;
          final isBack = angle > pi / 2;

          Offset offset = Offset(_dragPosition, 0);
          double opacity = 1.0;

          if (_swipeController.isAnimating) {
            offset = _swipeAnimation.value;
            opacity = _fadeAnimation.value;
          }

          final rotationAngle = _dragPosition * 0.0005;

          return Transform.translate(
            offset: offset,
            child: Transform.rotate(
              angle: rotationAngle,
              child: Opacity(
                opacity: opacity,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  child: isBack
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(pi),
                          child: _buildCardBack(card),
                        )
                      : _buildCardFront(card),
                ),
              ),
            ),
          );
        },
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOut);
  }

  Widget _buildCardFront(UnitFlashcard card) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 320, maxHeight: 400),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceLight,
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Category chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              card.category,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Difficulty indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < card.difficulty
                      ? AppColors.warning
                      : AppColors.border,
                  boxShadow: i < card.difficulty
                      ? [
                          BoxShadow(
                            color: AppColors.warning.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Question
          Text(
            card.question,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          if (card.hint != null) ...[
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 18,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      card.hint!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),

          // Tap hint
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.touch_app,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                'แตะเพื่อดูคำตอบ',
                style: AppTextStyles.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(UnitFlashcard card) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 320, maxHeight: 400),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withValues(alpha: 0.15),
            AppColors.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(
              Icons.check,
              size: 32,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'คำตอบ',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            card.answer,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.accent,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.swipe,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                'ปัดซ้ายหรือขวา',
                style: AppTextStyles.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeIndicator() {
    final isRight = _swipeDirection == SwipeDirection.right;
    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (isRight ? AppColors.success : AppColors.warning)
                    .withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isRight ? AppColors.success : AppColors.warning,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isRight ? AppColors.success : AppColors.warning)
                        .withValues(alpha: 0.4),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Icon(
                isRight ? Icons.check : Icons.refresh,
                size: 40,
                color: isRight ? AppColors.success : AppColors.warning,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    if (!_showAnswer) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          'แตะการ์ดเพื่อดูคำตอบ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.refresh,
              label: 'กำลังเรียน',
              color: AppColors.warning,
              onTap: () => _animateSwipe(SwipeDirection.left),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _ActionButton(
              icon: Icons.check_circle,
              label: 'จำได้แล้ว',
              color: AppColors.success,
              onTap: () => _animateSwipe(SwipeDirection.right),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2);
  }
}

enum SwipeDirection { left, right }

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            '$value',
            style: AppTextStyles.titleMedium.copyWith(color: color),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(
                  color: widget.color.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: widget.color, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: widget.color,
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

class _CompletionDialog extends StatelessWidget {
  final int knownCount;
  final int learningCount;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const _CompletionDialog({
    required this.knownCount,
    required this.learningCount,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final total = knownCount + learningCount;
    final successRate = total > 0 ? (knownCount / total * 100).round() : 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.elevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success animation
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const Icon(
                Icons.celebration,
                size: 40,
                color: Colors.white,
              ),
            )
                .animate()
                .scale(begin: const Offset(0, 0), curve: Curves.elasticOut)
                .then()
                .shake(hz: 2, rotation: 0.05),

            const SizedBox(height: 24),

            Text(
              'เสร็จสิ้น!',
              style: AppTextStyles.headlineLarge,
            ),

            const SizedBox(height: 8),

            Text(
              'อัตราความจำ $successRate%',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.accent,
              ),
            ),

            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle,
                    color: AppColors.success,
                    value: knownCount.toString(),
                    label: 'จำได้',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.refresh,
                    color: AppColors.warning,
                    value: learningCount.toString(),
                    label: 'กำลังเรียน',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onExit,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                    ),
                    child: const Text('กลับ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRestart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                    ),
                    child: const Text('เริ่มใหม่'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(color: color),
          ),
          Text(label, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
