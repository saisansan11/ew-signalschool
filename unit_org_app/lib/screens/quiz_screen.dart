import 'package:flutter/material.dart';
import '../app/constants.dart';
import '../models/unit_models.dart';
import '../data/signal_corps_data.dart';

class QuizScreen extends StatefulWidget {
  final String? category;
  final int? difficulty;

  const QuizScreen({super.key, this.category, this.difficulty});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _correctCount = 0;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _animController = AnimationController(
      duration: AppDurations.normal,
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
    // Limit to 10 questions per session
    if (_questions.length > 10) {
      _questions = _questions.sublist(0, 10);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _correctCount++;
      }
    });
    _animController.forward();
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

  void _showResults() {
    final percentage = (_correctCount / _questions.length * 100).round();
    final passed = percentage >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            // Result icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: passed
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.error.withValues(alpha: 0.2),
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
              'คุณตอบถูก $_correctCount จาก ${_questions.length} ข้อ',
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('กลับ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _selectedAnswer = null;
                _answered = false;
                _correctCount = 0;
                _animController.reset();
                _loadQuestions();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('ทำใหม่'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.category ?? 'Quiz',
          style: AppTextStyles.titleLarge,
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle,
                    size: 16, color: AppColors.success),
                const SizedBox(width: 4),
                Text(
                  '$_correctCount/${_currentIndex + (_answered ? 1 : 0)}',
                  style: AppTextStyles.titleMedium,
                ),
              ],
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
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surface,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ข้อ ${_currentIndex + 1} จาก ${_questions.length}',
                style: AppTextStyles.labelSmall,
              ),
              const SizedBox(height: 24),

              // Question card
              Container(
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
                    // Difficulty
                    Row(
                      children: [
                        ...List.generate(
                          3,
                          (i) => Container(
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
              const SizedBox(height: 24),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedAnswer == index;
                    final isCorrect = index == question.correctIndex;
                    final showResult = _answered;

                    Color bgColor = AppColors.surface;
                    Color borderColor = AppColors.border;
                    Color textColor = AppColors.textPrimary;

                    if (showResult) {
                      if (isCorrect) {
                        bgColor = AppColors.success.withValues(alpha: 0.15);
                        borderColor = AppColors.success;
                        textColor = AppColors.success;
                      } else if (isSelected && !isCorrect) {
                        bgColor = AppColors.error.withValues(alpha: 0.15);
                        borderColor = AppColors.error;
                        textColor = AppColors.error;
                      }
                    } else if (isSelected) {
                      bgColor = AppColors.primary.withValues(alpha: 0.15);
                      borderColor = AppColors.primary;
                    }

                    return GestureDetector(
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
                                    ? const Icon(
                                        Icons.check,
                                        size: 18,
                                        color: Colors.white,
                                      )
                                    : showResult && isSelected && !isCorrect
                                        ? const Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.white,
                                          )
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
                    );
                  },
                ),
              ),

              // Explanation (show after answering)
              if (_answered && question.explanation != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
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
              ],
              const SizedBox(height: 16),

              // Next button
              if (_answered)
                SizedBox(
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
            ],
          ),
        ),
      ),
    );
  }
}
