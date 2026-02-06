import 'package:flutter/material.dart';
import '../app/constants.dart';
import '../models/unit_models.dart';
import '../data/signal_corps_data.dart';
import '../services/progress_service.dart';

class QuizScreen extends StatefulWidget {
  final String? category;
  final int? difficulty;
  final bool adaptive; // Enable adaptive difficulty

  const QuizScreen({
    super.key,
    this.category,
    this.difficulty,
    this.adaptive = true,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late List<QuizQuestion> _questions;
  late List<QuizQuestion> _allQuestions;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _correctCount = 0;
  late AnimationController _animController;

  // Adaptive quiz
  int _currentDifficulty = 2;
  int _consecutiveCorrect = 0;
  int _consecutiveWrong = 0;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
    _animController = AnimationController(
      duration: AppDurations.normal,
      vsync: this,
    );
  }

  void _initializeQuiz() {
    // Load all questions for the category
    if (widget.category != null) {
      _allQuestions = List.from(SignalCorpsData.getQuizByCategory(widget.category!));
    } else {
      _allQuestions = List.from(SignalCorpsData.quizQuestions);
    }

    // Get recommended difficulty from progress service
    if (widget.adaptive && widget.category != null) {
      _currentDifficulty = ProgressService.instance.getRecommendedDifficulty(widget.category!);
    } else if (widget.difficulty != null) {
      _currentDifficulty = widget.difficulty!;
    }

    _loadQuestions();
  }

  void _loadQuestions() {
    if (widget.adaptive) {
      // Load questions matching current difficulty (with fallback)
      _questions = _getQuestionsForDifficulty(_currentDifficulty);
    } else if (widget.difficulty != null) {
      _questions = _allQuestions.where((q) => q.difficulty == widget.difficulty).toList();
    } else {
      _questions = List.from(_allQuestions);
    }

    _questions.shuffle();

    // Limit to 10 questions per session
    if (_questions.length > 10) {
      _questions = _questions.sublist(0, 10);
    }
  }

  List<QuizQuestion> _getQuestionsForDifficulty(int difficulty) {
    // Get questions at target difficulty
    var questions = _allQuestions.where((q) => q.difficulty == difficulty).toList();

    // If not enough questions, include adjacent difficulties
    if (questions.length < 5) {
      if (difficulty > 1) {
        questions.addAll(_allQuestions.where((q) => q.difficulty == difficulty - 1));
      }
      if (difficulty < 3) {
        questions.addAll(_allQuestions.where((q) => q.difficulty == difficulty + 1));
      }
    }

    // Fallback to all questions if still not enough
    if (questions.isEmpty) {
      questions = List.from(_allQuestions);
    }

    return questions;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (_answered) return;

    final isCorrect = index == _questions[_currentIndex].correctIndex;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (isCorrect) {
        _correctCount++;
        _consecutiveCorrect++;
        _consecutiveWrong = 0;
      } else {
        _consecutiveWrong++;
        _consecutiveCorrect = 0;
      }
    });

    // Update adaptive quiz state
    if (widget.adaptive && widget.category != null) {
      ProgressService.instance.recordAdaptiveAnswer(widget.category!, isCorrect);

      // Adjust difficulty for next questions
      _adjustDifficulty();
    }

    _animController.forward();
  }

  void _adjustDifficulty() {
    if (_consecutiveCorrect >= 3 && _currentDifficulty < 3) {
      _currentDifficulty++;
      _consecutiveCorrect = 0;
    } else if (_consecutiveWrong >= 2 && _currentDifficulty > 1) {
      _currentDifficulty--;
      _consecutiveWrong = 0;
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
      _animController.reset();
    } else {
      _showResults();
    }
  }

  Future<void> _showResults() async {
    final percentage = (_correctCount / _questions.length * 100).round();
    final passed = percentage >= 70;

    // Record quiz result
    final quizId = '${widget.category ?? "general"}_${DateTime.now().millisecondsSinceEpoch}';
    await ProgressService.instance.recordQuizResult(
      quizId: quizId,
      score: percentage,
      totalQuestions: _questions.length,
      correctAnswers: _correctCount,
    );

    // Check for new achievements
    final newAchievements = ProgressService.instance.popRecentAchievements();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _QuizResultDialog(
        correctCount: _correctCount,
        totalQuestions: _questions.length,
        percentage: percentage,
        passed: passed,
        newAchievements: newAchievements,
        onRestart: () {
          Navigator.pop(context);
          setState(() {
            _currentIndex = 0;
            _selectedAnswer = null;
            _answered = false;
            _correctCount = 0;
            _consecutiveCorrect = 0;
            _consecutiveWrong = 0;
            _animController.reset();
            _loadQuestions();
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
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Quiz'),
        ),
        body: const Center(
          child: Text('ไม่มีคำถามในหมวดนี้'),
        ),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Semantics(
          header: true,
          child: Text(
            widget.category ?? 'Quiz',
            style: AppTextStyles.titleLarge,
          ),
        ),
        actions: [
          // Adaptive difficulty indicator
          if (widget.adaptive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: _getDifficultyColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 14,
                    color: _getDifficultyColor(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getDifficultyText(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _getDifficultyColor(),
                    ),
                  ),
                ],
              ),
            ),
          // Score counter
          Semantics(
            label: 'คะแนน $_correctCount จาก ${_currentIndex + (_answered ? 1 : 0)} ข้อ',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    '$_correctCount/${_currentIndex + (_answered ? 1 : 0)}',
                    style: AppTextStyles.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
              Semantics(
                label: 'ความคืบหน้า ข้อที่ ${_currentIndex + 1} จาก ${_questions.length}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surface,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ข้อ ${_currentIndex + 1} จาก ${_questions.length}',
                style: AppTextStyles.labelSmall,
              ),
              const SizedBox(height: 24),

              // Question card
              Semantics(
                label: 'คำถาม: ${question.question}',
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Difficulty indicator
                      Row(
                        children: [
                          ...List.generate(
                            3,
                            (i) => Semantics(
                              excludeSemantics: true,
                              child: Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i < question.difficulty
                                      ? AppColors.warning
                                      : AppColors.border,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            question.category,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        question.question,
                        style: AppTextStyles.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildOptionButton(question, index);
                  },
                ),
              ),

              // Explanation (show after answering)
              if (_answered && question.explanation != null) ...[
                const SizedBox(height: 16),
                Semantics(
                  label: 'คำอธิบาย: ${question.explanation}',
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 20,
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            question.explanation!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.info,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Next button
              if (_answered)
                Semantics(
                  button: true,
                  label: _currentIndex < _questions.length - 1 ? 'ไปข้อถัดไป' : 'ดูผลคะแนน',
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        ),
                      ),
                      child: Text(
                        _currentIndex < _questions.length - 1
                            ? 'ข้อถัดไป'
                            : 'ดูผลคะแนน',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(QuizQuestion question, int index) {
    final isSelected = _selectedAnswer == index;
    final isCorrect = index == question.correctIndex;
    final showResult = _answered;

    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textPrimary;

    String semanticStatus = '';

    if (showResult) {
      if (isCorrect) {
        bgColor = AppColors.success.withOpacity(0.15);
        borderColor = AppColors.success;
        textColor = AppColors.success;
        semanticStatus = 'คำตอบที่ถูกต้อง';
      } else if (isSelected && !isCorrect) {
        bgColor = AppColors.error.withOpacity(0.15);
        borderColor = AppColors.error;
        textColor = AppColors.error;
        semanticStatus = 'คำตอบผิด';
      }
    } else if (isSelected) {
      bgColor = AppColors.primary.withOpacity(0.15);
      borderColor = AppColors.primary;
      semanticStatus = 'เลือกแล้ว';
    }

    return Semantics(
      button: !_answered,
      selected: isSelected,
      label: 'ตัวเลือก ${String.fromCharCode(65 + index)}: ${question.options[index]}. $semanticStatus',
      child: GestureDetector(
        onTap: () => _selectAnswer(index),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              // Option letter
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: showResult && isCorrect
                      ? AppColors.success
                      : showResult && isSelected && !isCorrect
                          ? AppColors.error
                          : isSelected
                              ? AppColors.primary
                              : AppColors.surfaceLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: showResult && isCorrect
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : showResult && isSelected && !isCorrect
                          ? const Icon(Icons.close, size: 18, color: Colors.white)
                          : Text(
                              String.fromCharCode(65 + index),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.options[index],
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (_currentDifficulty) {
      case 1:
        return AppColors.success;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  String _getDifficultyText() {
    switch (_currentDifficulty) {
      case 1:
        return 'ง่าย';
      case 2:
        return 'กลาง';
      case 3:
        return 'ยาก';
      default:
        return 'กลาง';
    }
  }
}

class _QuizResultDialog extends StatelessWidget {
  final int correctCount;
  final int totalQuestions;
  final int percentage;
  final bool passed;
  final List newAchievements;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const _QuizResultDialog({
    required this.correctCount,
    required this.totalQuestions,
    required this.percentage,
    required this.passed,
    required this.newAchievements,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      content: Semantics(
        liveRegion: true,
        label: passed
            ? 'ยอดเยี่ยม! คุณตอบถูก $correctCount จาก $totalQuestions ข้อ คิดเป็น $percentage เปอร์เซ็นต์'
            : 'ลองอีกครั้ง คุณตอบถูก $correctCount จาก $totalQuestions ข้อ คิดเป็น $percentage เปอร์เซ็นต์',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            // Result icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: passed
                    ? AppColors.success.withOpacity(0.2)
                    : AppColors.error.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                passed ? Icons.emoji_events : Icons.refresh,
                size: 40,
                color: passed ? AppColors.success : AppColors.error,
              ),
            ),
            const SizedBox(height: 24),

            // Result text
            Text(
              passed ? 'ยอดเยี่ยม!' : 'ลองอีกครั้ง',
              style: AppTextStyles.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'คุณตอบถูก $correctCount จาก $totalQuestions ข้อ',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 16),

            // Score circle
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: passed ? AppColors.success : AppColors.error,
                  width: 4,
                ),
              ),
              child: Center(
                child: Text(
                  '$percentage%',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: passed ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // New achievements
            if (newAchievements.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emoji_events, color: AppColors.warning, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'รางวัลใหม่!',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...newAchievements.map((a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(a.icon, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(a.title, style: AppTextStyles.titleMedium),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Feedback
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
              child: Text(
                passed
                    ? 'คุณเข้าใจเนื้อหาได้ดี! ลองเรียนรู้หัวข้อถัดไป'
                    : 'ลองทบทวน Flashcard อีกครั้งแล้วกลับมาทำ Quiz ใหม่',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onExit,
          child: const Text('กลับ'),
        ),
        ElevatedButton(
          onPressed: onRestart,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text('ทำใหม่'),
        ),
      ],
    );
  }
}
