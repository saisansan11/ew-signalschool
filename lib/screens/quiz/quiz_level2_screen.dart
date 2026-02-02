import 'package:flutter/material.dart';
import 'dart:math';
import '../../app/constants.dart';
import '../../services/progress_service.dart';

class QuizLevel2Screen extends StatefulWidget {
  const QuizLevel2Screen({super.key});

  @override
  State<QuizLevel2Screen> createState() => _QuizLevel2ScreenState();
}

class _QuizLevel2ScreenState extends State<QuizLevel2Screen>
    with TickerProviderStateMixin {
  int _currentQuestion = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswer;
  bool _quizCompleted = false;
  late AnimationController _progressController;
  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  // ==========================================
  // คำถามระดับยุทธวิธี (Tactical Level)
  // เนื้อหา: ECM, ESM, Anti-Drone, GPS Warfare
  // ==========================================
  final List<QuizQuestion> _questions = [
    // === ECM / Jamming Techniques ===
    QuizQuestion(
      question: 'Barrage Jamming มีข้อดีอะไรเหนือกว่า Spot Jamming?',
      options: [
        'ใช้พลังงานน้อยกว่า',
        'ครอบคลุมช่วงความถี่กว้างกว่า',
        'มีระยะทำการไกลกว่า',
        'ยากต่อการตรวจจับ',
      ],
      correctIndex: 1,
      explanation:
          'Barrage Jamming กระจายพลังงานครอบคลุมหลายความถี่พร้อมกัน เหมาะกับเป้าหมายที่ใช้ Frequency Hopping แต่ใช้พลังงานมากกว่า Spot Jamming',
      category: 'ECM',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'J/S Ratio (Jamming-to-Signal Ratio) คืออะไร?',
      options: [
        'อัตราส่วนระหว่างความถี่กับแบนด์วิดท์',
        'อัตราส่วนระหว่างกำลังสัญญาณรบกวนกับสัญญาณเป้าหมาย',
        'อัตราส่วนระหว่างระยะทางกับกำลังส่ง',
        'อัตราส่วนระหว่างเวลากับความถี่',
      ],
      correctIndex: 1,
      explanation:
          'J/S Ratio = พลังงานรบกวน / พลังงานสัญญาณ ที่ตำแหน่งเครื่องรับเป้าหมาย ค่า J/S ที่เป็นบวก (dB) หมายถึงการรบกวนสำเร็จ',
      category: 'ECM',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'Sweep Jamming ทำงานอย่างไร?',
      options: [
        'ส่งสัญญาณรบกวนความถี่เดียวต่อเนื่อง',
        'กวาดความถี่ไปมาในช่วงที่กำหนด',
        'ส่งสัญญาณแบบ Pulse',
        'จำลองสัญญาณของเป้าหมาย',
      ],
      correctIndex: 1,
      explanation:
          'Sweep Jamming กวาดความถี่จากต่ำไปสูงและกลับมา ครอบคลุมหลายความถี่ตามลำดับ เหมาะกับเป้าหมายที่ไม่รู้ความถี่แน่นอน',
      category: 'ECM',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'ข้อเสียหลักของการใช้ Directional Antenna ในการ Jamming คืออะไร?',
      options: [
        'ใช้พลังงานมากกว่า Omni',
        'ต้องหันเสาอากาศไปยังเป้าหมาย',
        'ราคาแพงกว่า',
        'มีน้ำหนักมากกว่า',
      ],
      correctIndex: 1,
      explanation:
          'Directional Antenna มี Gain สูงกว่า แต่ต้องชี้ไปยังเป้าหมาย ถ้าเป้าหมายเคลื่อนที่หรือมีหลายเป้าหมาย อาจใช้งานยาก',
      category: 'ECM',
      difficulty: 2,
    ),

    // === ESM / SIGINT ===
    QuizQuestion(
      question: 'ELINT (Electronic Intelligence) แตกต่างจาก COMINT อย่างไร?',
      options: [
        'ELINT เน้นเรดาร์ COMINT เน้นการสื่อสาร',
        'ELINT เน้นการโจมตี COMINT เน้นการป้องกัน',
        'ELINT ใช้คลื่นสั้น COMINT ใช้คลื่นยาว',
        'ELINT ใช้ดาวเทียม COMINT ใช้ภาคพื้น',
      ],
      correctIndex: 0,
      explanation:
          'ELINT = ข่าวกรองจากสัญญาณเรดาร์/เซ็นเซอร์\nCOMINT = ข่าวกรองจากการสื่อสาร (วิทยุ โทรศัพท์ ฯลฯ)\nทั้งสองเป็นส่วนหนึ่งของ SIGINT',
      category: 'ESM',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'Triangulation ในการหาพิกัด (Direction Finding) ต้องการสถานีอย่างน้อยกี่สถานี?',
      options: [
        '1 สถานี',
        '2 สถานี',
        '3 สถานี',
        '4 สถานี',
      ],
      correctIndex: 1,
      explanation:
          'Triangulation ต้องการอย่างน้อย 2 สถานีเพื่อหาจุดตัดของเส้นทิศทาง แต่ 3 สถานีจะให้ความแม่นยำสูงกว่าและลด ambiguity',
      category: 'ESM',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'TOA (Time of Arrival) ใช้หาตำแหน่งเป้าหมายอย่างไร?',
      options: [
        'วัดความแรงสัญญาณ',
        'วัดความต่างเวลาที่สัญญาณมาถึงแต่ละสถานี',
        'วัดความถี่ Doppler',
        'วัดมุม Azimuth',
      ],
      correctIndex: 1,
      explanation:
          'TOA/TDOA วัดความต่างเวลาที่สัญญาณมาถึงสถานีต่างๆ จากความเร็วแสงและเวลาที่ต่างกัน คำนวณตำแหน่งได้',
      category: 'ESM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'ข้อจำกัดของระบบ ESM ในการหาตำแหน่งคืออะไร?',
      options: [
        'ทำงานได้เฉพาะเวลากลางวัน',
        'เป้าหมายต้องส่งสัญญาณ (Active)',
        'ต้องใช้กำลังส่งสูง',
        'ไม่สามารถหาความถี่ได้',
      ],
      correctIndex: 1,
      explanation:
          'ESM เป็น Passive System ได้เปรียบเรื่องซ่อนตัว แต่ต้องรอให้เป้าหมาย "พูด" หรือส่งสัญญาณ ถ้าเป้าหมายเงียบจะไม่เห็น',
      category: 'ESM',
      difficulty: 2,
    ),

    // === Anti-Drone / C-UAS ===
    QuizQuestion(
      question: 'โดรน FPV ทั่วไปใช้ความถี่ใดในการควบคุม?',
      options: [
        'HF (3-30 MHz)',
        'VHF (30-300 MHz)',
        '2.4 GHz และ 5.8 GHz',
        'SHF (10-30 GHz)',
      ],
      correctIndex: 2,
      explanation:
          'โดรนพลเรือน/FPV ส่วนใหญ่ใช้ 2.4 GHz สำหรับ Command & Control และ 5.8 GHz สำหรับ Video Downlink (บางรุ่นกลับกัน)',
      category: 'Anti-Drone',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'เมื่อโดรนถูก Jam สัญญาณควบคุม โดยปกติจะเกิดอะไรขึ้น?',
      options: [
        'ระเบิดทันที',
        'ตกลงมาทันที',
        'เข้า Failsafe Mode (Return to Home หรือ Land)',
        'บินต่อไปตามเส้นทางเดิม',
      ],
      correctIndex: 2,
      explanation:
          'โดรนส่วนใหญ่มี Failsafe Mode: RTH (Return to Home), Hover, หรือ Land เมื่อขาดการเชื่อมต่อ การ Jam GPS ด้วยจะทำให้ RTH ไม่ได้',
      category: 'Anti-Drone',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'ทำไมการ Jam ทั้ง 2.4 GHz และ GPS พร้อมกันจึงมีประสิทธิภาพ?',
      options: [
        'ประหยัดพลังงาน',
        'ตัด Command และป้องกัน Return to Home',
        'ทำให้กล้องใช้งานไม่ได้',
        'ทำลายแบตเตอรี่โดรน',
      ],
      correctIndex: 1,
      explanation:
          'Jam Control (2.4/5.8 GHz) = ตัดการควบคุม\nJam GPS = ป้องกัน RTH และทำให้โดรนไม่รู้ตำแหน่ง\nผลลัพธ์: โดรน Hover หรือ Land ทันที',
      category: 'Anti-Drone',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'ข้อเสียของการใช้ RF Jamming ต่อต้านโดรนในพื้นที่ชุมชนคืออะไร?',
      options: [
        'เสียงดังเกินไป',
        'รบกวน Wi-Fi และสัญญาณพลเรือน',
        'ใช้พลังงานน้อยเกินไป',
        'ทำงานได้เฉพาะกลางคืน',
      ],
      correctIndex: 1,
      explanation:
          '2.4 GHz เป็นความถี่ ISM (Wi-Fi, Bluetooth) การ Jam อาจกระทบการสื่อสารพลเรือน ต้องใช้ Directional Jamming หรือเทคนิคอื่นในพื้นที่ชุมชน',
      category: 'Anti-Drone',
      difficulty: 2,
    ),

    // === GPS Warfare ===
    QuizQuestion(
      question: 'ความถี่ GPS L1 (พลเรือน) คือเท่าไร?',
      options: [
        '1227.60 MHz',
        '1575.42 MHz',
        '2400 MHz',
        '5800 MHz',
      ],
      correctIndex: 1,
      explanation:
          'GPS L1 = 1575.42 MHz (C/A Code พลเรือน)\nGPS L2 = 1227.60 MHz (P(Y) Code ทหาร)\nL5 = 1176.45 MHz (Safety-of-Life)',
      category: 'GPS',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'GPS Spoofing แตกต่างจาก GPS Jamming อย่างไร?',
      options: [
        'Spoofing ใช้กำลังสูงกว่า',
        'Spoofing ส่งสัญญาณ GPS ปลอมเพื่อหลอกตำแหน่ง',
        'Spoofing ทำงานได้เฉพาะในอาคาร',
        'Spoofing ถูกกฎหมาย',
      ],
      correctIndex: 1,
      explanation:
          'Jamming = ส่งเสียงรบกวน ทำให้ GPS ใช้งานไม่ได้\nSpoofing = ส่งสัญญาณ GPS ปลอม ทำให้เป้าหมายเชื่อว่าอยู่ตำแหน่งอื่น อันตรายกว่ามาก',
      category: 'GPS',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'ทำไม GPS จึงง่ายต่อการถูกรบกวน?',
      options: [
        'ใช้ความถี่สูงเกินไป',
        'สัญญาณจากดาวเทียมอ่อนมาก (-130 dBm)',
        'ไม่มีการเข้ารหัส',
        'ใช้โปรโตคอลเก่า',
      ],
      correctIndex: 1,
      explanation:
          'สัญญาณ GPS จากอวกาศ (~20,200 km) มีความแรงต่ำมาก (~-130 dBm) Jammer บนพื้นดินกำลังต่ำก็สามารถกลบสัญญาณได้ง่าย',
      category: 'GPS',
      difficulty: 3,
    ),

    // === ECCM / Protection ===
    QuizQuestion(
      question: 'Frequency Hopping Spread Spectrum (FHSS) ป้องกัน Jamming อย่างไร?',
      options: [
        'เพิ่มกำลังส่ง',
        'เปลี่ยนความถี่หลายร้อยครั้งต่อวินาที',
        'ใช้ Directional Antenna',
        'เข้ารหัสเสียง',
      ],
      correctIndex: 1,
      explanation:
          'FHSS กระโดดความถี่ 50-1000+ ครั้ง/วินาที ตามรหัสลับ Jammer ต้องรู้รหัสหรือ Jam ทุกความถี่ (Barrage) ซึ่งใช้พลังงานมหาศาล',
      category: 'ECCM',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'วิธีใดไม่ใช่ EPM (Electronic Protective Measures)?',
      options: [
        'ลดกำลังส่งให้ต่ำที่สุด',
        'ใช้ Frequency Hopping',
        'เพิ่มกำลังส่ง Jammer',
        'ใช้ Burst Transmission',
      ],
      correctIndex: 2,
      explanation:
          'EPM = มาตรการป้องกันฝ่ายเรา ได้แก่ FHSS, Burst TX, ลดกำลังส่ง, Directional Antenna\nการเพิ่มกำลัง Jammer เป็น ECM (โจมตี) ไม่ใช่ EPM (ป้องกัน)',
      category: 'ECCM',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'Burn-Through Range คืออะไร?',
      options: [
        'ระยะที่เครื่อง Jammer ไหม้',
        'ระยะที่สัญญาณเป้าหมายแรงกว่าสัญญาณรบกวน',
        'ระยะทำการสูงสุดของเรดาร์',
        'ระยะที่ปลอดภัยจากคลื่น RF',
      ],
      correctIndex: 1,
      explanation:
          'Burn-Through Range = ระยะที่ J/S < 0 dB หรือสัญญาณจริงแรงกว่า Jamming ภายในระยะนี้ระบบเป้าหมายจะทำงานได้ตามปกติแม้ถูก Jam',
      category: 'ECM',
      difficulty: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shuffleQuestions();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    );
    _cardController.forward();
  }

  void _shuffleQuestions() {
    _questions.shuffle(Random());
    // Take only 15 questions for the quiz
    if (_questions.length > 15) {
      _questions.removeRange(15, _questions.length);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _cardController.dispose();
    super.dispose();
  }

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
      _cardController.reset();
      setState(() {
        _currentQuestion++;
        _answered = false;
        _selectedAnswer = null;
      });
      _cardController.forward();
    } else {
      ProgressService.saveQuizScore('quiz_level2', _score, _questions.length);
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
      _shuffleQuestions();
    });
    _cardController.forward();
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
        title: const Text('แบบทดสอบ Level 2: ยุทธวิธี'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress bar with category
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(question.category)
                                .withAlpha(50),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getCategoryColor(question.category),
                            ),
                          ),
                          child: Text(
                            question.category,
                            style: TextStyle(
                              color: _getCategoryColor(question.category),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ข้อ ${_currentQuestion + 1}/${_questions.length}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.warning, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '$_score',
                          style: const TextStyle(
                            color: AppColors.warning,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Animated progress bar
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, _) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: AppColors.surfaceLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getCategoryColor(question.category),
                        ),
                        minHeight: 8,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Question content with animation
          Expanded(
            child: ScaleTransition(
              scale: _cardAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getCategoryColor(question.category)
                              .withAlpha(100),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getCategoryColor(question.category)
                                .withAlpha(30),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getCategoryIcon(question.category),
                                color: _getCategoryColor(question.category),
                                size: 32,
                              ),
                              const Spacer(),
                              // Difficulty indicator
                              Row(
                                children: List.generate(3, (i) {
                                  return Icon(
                                    Icons.flash_on,
                                    size: 16,
                                    color: i < question.difficulty
                                        ? AppColors.warning
                                        : AppColors.textMuted,
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            question.question,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
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

                      return _buildOptionCard(
                        index: index,
                        option: option,
                        isSelected: isSelected,
                        isCorrect: isCorrect,
                        answered: _answered,
                        onTap: () => _selectAnswer(index),
                      );
                    }),

                    // Feedback
                    if (_answered)
                      _buildFeedbackCard(
                        isCorrect: _selectedAnswer == question.correctIndex,
                        explanation: question.explanation,
                        correctAnswer: question.options[question.correctIndex],
                        category: question.category,
                      ),
                  ],
                ),
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
                    backgroundColor: _getCategoryColor(
                      _questions[_currentQuestion].category,
                    ),
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

  Widget _buildOptionCard({
    required int index,
    required String option,
    required bool isSelected,
    required bool isCorrect,
    required bool answered,
    required VoidCallback onTap,
  }) {
    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textPrimary;
    IconData? icon;

    if (answered) {
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
        onTap: answered ? null : onTap,
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: borderColor.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: icon != null
                      ? Icon(icon, color: textColor, size: 22)
                      : Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackCard({
    required bool isCorrect,
    required String explanation,
    required String correctAnswer,
    required String category,
  }) {
    final categoryColor = _getCategoryColor(category);

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withAlpha(20)
            : AppColors.danger.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? AppColors.success.withAlpha(60)
              : AppColors.danger.withAlpha(40),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Correct or Incorrect
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.success.withAlpha(30)
                      : AppColors.danger.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? AppColors.success : AppColors.danger,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? 'ถูกต้อง! 🎉' : 'ไม่ถูกต้อง',
                      style: TextStyle(
                        color: isCorrect ? AppColors.success : AppColors.danger,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isCorrect)
                      Text(
                        'คำตอบที่ถูก: $correctAnswer',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Divider
          Container(
            height: 1,
            color: isCorrect
                ? AppColors.success.withAlpha(30)
                : AppColors.danger.withAlpha(20),
          ),

          const SizedBox(height: 12),

          // Explanation
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'อธิบาย:',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      explanation,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Tip for wrong answers
          if (!isCorrect) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: categoryColor.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.school,
                    color: categoryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ทบทวนหัวข้อ $category เพื่อความเข้าใจที่ดีขึ้น',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    IconData gradeIcon;

    if (percentage >= 90) {
      grade = 'S';
      gradeColor = const Color(0xFFFFD700);
      message = 'ยอดเยี่ยม! คุณเชี่ยวชาญระดับยุทธวิธี';
      gradeIcon = Icons.military_tech;
    } else if (percentage >= 80) {
      grade = 'A';
      gradeColor = AppColors.success;
      message = 'ดีมาก! พร้อมสำหรับภารกิจ';
      gradeIcon = Icons.star;
    } else if (percentage >= 70) {
      grade = 'B';
      gradeColor = AppColors.primary;
      message = 'ผ่าน! ควรทบทวนเพิ่มเติม';
      gradeIcon = Icons.thumb_up;
    } else if (percentage >= 60) {
      grade = 'C';
      gradeColor = AppColors.warning;
      message = 'ไม่ผ่าน ต้องศึกษาเพิ่ม';
      gradeIcon = Icons.refresh;
    } else {
      grade = 'F';
      gradeColor = AppColors.danger;
      message = 'ต้องปรับปรุง กรุณาทบทวนบทเรียน';
      gradeIcon = Icons.school;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('ผลการทดสอบ Level 2'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated grade circle
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            gradeColor.withAlpha(50),
                            gradeColor.withAlpha(20),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: gradeColor, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: gradeColor.withAlpha(50),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(gradeIcon, color: gradeColor, size: 40),
                          Text(
                            grade,
                            style: TextStyle(
                              color: gradeColor,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Score
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: _score),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, _) {
                  return Text(
                    '$value / ${_questions.length}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
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
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: passed ? AppColors.success : AppColors.danger,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      passed ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      passed ? 'ผ่าน' : 'ไม่ผ่าน',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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

              // Statistics
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Text(
                      'สถิติตามหมวด',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryStats('ECM'),
                    _buildCategoryStats('ESM'),
                    _buildCategoryStats('Anti-Drone'),
                    _buildCategoryStats('GPS'),
                    _buildCategoryStats('ECCM'),
                  ],
                ),
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

  Widget _buildCategoryStats(String category) {
    // This is a simplified version - in a real app, you'd track per-category scores
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            _getCategoryIcon(category),
            color: _getCategoryColor(category),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getCategoryColor(category),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'ECM':
        return Colors.redAccent;
      case 'ESM':
        return Colors.amber;
      case 'Anti-Drone':
        return Colors.cyan;
      case 'GPS':
        return Colors.green;
      case 'ECCM':
        return Colors.blueAccent;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'ECM':
        return Icons.flash_on;
      case 'ESM':
        return Icons.hearing;
      case 'Anti-Drone':
        return Icons.flight;
      case 'GPS':
        return Icons.gps_fixed;
      case 'ECCM':
        return Icons.shield;
      default:
        return Icons.help_outline;
    }
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String category;
  final int difficulty;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.category,
    this.difficulty = 2,
  });
}
