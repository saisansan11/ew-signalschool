import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/progress_service.dart';

class QuizLevel1Screen extends StatefulWidget {
  const QuizLevel1Screen({super.key});

  @override
  State<QuizLevel1Screen> createState() => _QuizLevel1ScreenState();
}

class _QuizLevel1ScreenState extends State<QuizLevel1Screen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswer;
  bool _quizCompleted = false;

  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: 'EW ย่อมาจากอะไร?',
      options: [
        'Electric Warfare',
        'Electronic Warfare',
        'Energy Weapon',
        'Electromagnetic Wave',
      ],
      correctIndex: 1,
      explanation: 'EW = Electronic Warfare หรือ สงครามอิเล็กทรอนิกส์',
    ),
    QuizQuestion(
      question: '3 องค์ประกอบหลักของ EW คืออะไร?',
      options: [
        'EA, EP, ES',
        'ESM, ECM, ECCM',
        'HF, VHF, UHF',
        'SIGINT, ELINT, COMINT',
      ],
      correctIndex: 1,
      explanation: 'ESM (ดักรับ), ECM (รบกวน), ECCM (ป้องกัน)',
    ),
    QuizQuestion(
      question: 'ESM มีหน้าที่หลักคืออะไร?',
      options: [
        'รบกวนสัญญาณข้าศึก',
        'ป้องกันการถูกรบกวน',
        'ดักรับและวิเคราะห์สัญญาณ',
        'ทำลายอุปกรณ์อิเล็กทรอนิกส์',
      ],
      correctIndex: 2,
      explanation:
          'ESM = Electronic Support Measures ค้นหา ดักรับ และระบุแหล่งสัญญาณ',
    ),
    QuizQuestion(
      question: 'ย่านความถี่ VHF มีช่วงประมาณเท่าไร?',
      options: ['3-30 MHz', '30-300 MHz', '300 MHz-3 GHz', '3-30 GHz'],
      correctIndex: 1,
      explanation: 'VHF = Very High Frequency อยู่ในช่วง 30-300 MHz',
    ),
    QuizQuestion(
      question: 'Spot Jamming คืออะไร?',
      options: [
        'การรบกวนแบบกวาดความถี่กว้าง',
        'การรบกวนความถี่เดียวเฉพาะจุด',
        'การรบกวนแบบสุ่ม',
        'การรบกวนด้วยเสียงรบกวน',
      ],
      correctIndex: 1,
      explanation: 'Spot Jamming = รบกวนความถี่เดียวอย่างเข้มข้น',
    ),
    QuizQuestion(
      question: 'FHSS ใช้เพื่อวัตถุประสงค์ใด?',
      options: [
        'เพิ่มกำลังส่ง',
        'ป้องกันการถูกรบกวน',
        'เพิ่มระยะการสื่อสาร',
        'ลดการใช้พลังงาน',
      ],
      correctIndex: 1,
      explanation:
          'FHSS = Frequency Hopping Spread Spectrum กระโดดความถี่เพื่อหลบการรบกวน',
    ),
    QuizQuestion(
      question: 'COMSEC หมายถึงอะไร?',
      options: [
        'Computer Security',
        'Communication Security',
        'Combat Security',
        'Command Security',
      ],
      correctIndex: 1,
      explanation: 'COMSEC = Communication Security ความปลอดภัยในการสื่อสาร',
    ),
    QuizQuestion(
      question: 'DF ในงาน ESM หมายถึงอะไร?',
      options: [
        'Data Filtering',
        'Direction Finding',
        'Digital Format',
        'Defense Function',
      ],
      correctIndex: 1,
      explanation: 'DF = Direction Finding การหาทิศทางแหล่งกำเนิดสัญญาณ',
    ),
    QuizQuestion(
      question: 'ความถี่ GPS L1 (พลเรือน) คือเท่าไร?',
      options: ['1227.60 MHz', '1575.42 MHz', '2400 MHz', '5800 MHz'],
      correctIndex: 1,
      explanation: 'GPS L1 = 1575.42 MHz สำหรับการใช้งานพลเรือน',
    ),
    QuizQuestion(
      question: 'Anti-Drone EW มักรบกวนความถี่ใด?',
      options: [
        'HF (3-30 MHz)',
        'VHF (30-300 MHz)',
        '2.4 GHz และ 5.8 GHz',
        'SHF (30-300 GHz)',
      ],
      correctIndex: 2,
      explanation: 'โดรนส่วนใหญ่ใช้ 2.4 GHz (command) และ 5.8 GHz (video)',
    ),
  ];

  void _selectAnswer(int index) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentQuestion].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _answered = false;
        _selectedAnswer = null;
      });
    } else {
      // Save quiz score
      ProgressService.saveQuizScore('quiz_level1', _score, _questions.length);
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _answered = false;
      _selectedAnswer = null;
      _quizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildResultScreen();
    }

    final question = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('แบบทดสอบ Level 1'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ข้อ ${_currentQuestion + 1}/${_questions.length}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'คะแนน: $_score',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          // Question content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withAlpha(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.help_outline,
                          color: AppColors.primary,
                          size: 40,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          question.question,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Options
                  ...question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = _selectedAnswer == index;
                    final isCorrect = index == question.correctIndex;

                    Color bgColor = AppColors.surface;
                    Color borderColor = AppColors.border;
                    Color textColor = AppColors.textPrimary;
                    IconData? icon;

                    if (_answered) {
                      if (isCorrect) {
                        bgColor = AppColors.success.withAlpha(30);
                        borderColor = AppColors.success;
                        textColor = AppColors.success;
                        icon = Icons.check_circle;
                      } else if (isSelected && !isCorrect) {
                        bgColor = AppColors.danger.withAlpha(30);
                        borderColor = AppColors.danger;
                        textColor = AppColors.danger;
                        icon = Icons.cancel;
                      }
                    } else if (isSelected) {
                      bgColor = AppColors.primary.withAlpha(30);
                      borderColor = AppColors.primary;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => _selectAnswer(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: borderColor.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: icon != null
                                      ? Icon(icon, color: textColor, size: 20)
                                      : Text(
                                          String.fromCharCode(65 + index),
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // Explanation (shown after answering)
                  if (_answered)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              question.explanation,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Next button
          if (_answered)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.surface,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentQuestion < _questions.length - 1
                        ? 'ข้อถัดไป'
                        : 'ดูผลคะแนน',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_score / _questions.length * 100).round();
    final passed = percentage >= 70;

    String grade;
    Color gradeColor;
    String message;

    if (percentage >= 90) {
      grade = 'A';
      gradeColor = AppColors.success;
      message = 'ยอดเยี่ยม! คุณมีความรู้ EW ดีมาก';
    } else if (percentage >= 80) {
      grade = 'B';
      gradeColor = AppColors.primary;
      message = 'ดีมาก! พร้อมสำหรับ Level ถัดไป';
    } else if (percentage >= 70) {
      grade = 'C';
      gradeColor = AppColors.warning;
      message = 'ผ่าน! แต่ควรทบทวนเพิ่มเติม';
    } else if (percentage >= 60) {
      grade = 'D';
      gradeColor = Colors.orange;
      message = 'ไม่ผ่าน ควรกลับไปศึกษาเพิ่ม';
    } else {
      grade = 'F';
      gradeColor = AppColors.danger;
      message = 'ต้องปรับปรุง กรุณาทบทวนบทเรียน';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('ผลการทดสอบ'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Grade circle
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gradeColor.withAlpha(30),
                  border: Border.all(color: gradeColor, width: 4),
                ),
                child: Center(
                  child: Text(
                    grade,
                    style: TextStyle(
                      color: gradeColor,
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Score
              Text(
                '$_score / ${_questions.length}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: gradeColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // Pass/Fail badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: passed ? AppColors.success : AppColors.danger,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  passed ? 'ผ่าน' : 'ไม่ผ่าน',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Message
              Text(
                message,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _restartQuiz,
                      icon: const Icon(Icons.refresh),
                      label: const Text('ทำใหม่'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.home),
                      label: const Text('กลับหน้าหลัก'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}
