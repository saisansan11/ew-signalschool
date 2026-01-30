import 'package:flutter/material.dart';
import 'dart:math';
import '../../app/constants.dart';
import '../../services/progress_service.dart';

class QuizLevel3Screen extends StatefulWidget {
  const QuizLevel3Screen({super.key});

  @override
  State<QuizLevel3Screen> createState() => _QuizLevel3ScreenState();
}

class _QuizLevel3ScreenState extends State<QuizLevel3Screen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _showResult = false;
  late List<QuizQuestion> _shuffledQuestions;

  late AnimationController _progressController;
  late AnimationController _cardController;
  late AnimationController _pulseController;
  late Animation<double> _cardAnimation;
  late Animation<double> _pulseAnimation;

  final List<QuizQuestion> _questions = [
    // ECCM/EPM Advanced
    QuizQuestion(
      question: 'Adaptive Nulling ในระบบ ECCM ทำงานอย่างไร?',
      options: [
        'ลดกำลังส่งของ Jammer',
        'สร้าง Null ในทิศทางของ Jammer โดยอัตโนมัติ',
        'เปลี่ยนความถี่หนี Jammer',
        'เพิ่มกำลังส่งของตนเอง',
      ],
      correctIndex: 1,
      explanation: 'Adaptive Nulling ใช้ Digital Signal Processing ปรับ Antenna Pattern '
          'เพื่อสร้าง Null (จุดรับสัญญาณต่ำสุด) ไปยังทิศทางของ Jammer โดยอัตโนมัติ',
      category: 'ECCM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'DRFM (Digital Radio Frequency Memory) ใช้ทำอะไร?',
      options: [
        'บันทึกและเล่นซ้ำสัญญาณเรดาร์เพื่อสร้างเป้าปลอม',
        'จดจำความถี่ที่เคยถูก Jam',
        'บันทึกการสื่อสารของข้าศึก',
        'เพิ่มหน่วยความจำให้ระบบ EW',
      ],
      correctIndex: 0,
      explanation: 'DRFM จับสัญญาณเรดาร์ข้าศึก บันทึกเป็น Digital แล้วส่งกลับ '
          'พร้อมปรับแต่ง (Delay, Doppler, Amplitude) เพื่อสร้าง False Target ที่สมจริง',
      category: 'ECM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'Pulse Compression ช่วยป้องกัน Jamming อย่างไร?',
      options: [
        'ลดขนาดของ Pulse',
        'เพิ่ม Processing Gain ทำให้ SNR สูงขึ้น',
        'ทำให้ Pulse มองไม่เห็น',
        'เปลี่ยน Pulse เป็น CW',
      ],
      correctIndex: 1,
      explanation: 'Pulse Compression ใช้ Long Pulse + Bandwidth (LFM/Phase Coding) '
          'แล้ว Compress ที่ Receiver ทำให้ได้ Processing Gain = Time-Bandwidth Product '
          'เพิ่ม SNR และต้านทาน Jamming ได้ดีขึ้น',
      category: 'ECCM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'TDOA (Time Difference of Arrival) ต้องใช้สถานี DF อย่างน้อยกี่สถานีเพื่อหาตำแหน่ง 2D?',
      options: [
        '2 สถานี',
        '3 สถานี',
        '4 สถานี',
        '5 สถานี',
      ],
      correctIndex: 1,
      explanation: 'TDOA 2D ต้องใช้ 3 สถานี: คู่แรกให้ Hyperbola แรก, '
          'คู่ที่สองให้ Hyperbola ที่สอง, จุดตัดคือตำแหน่งเป้าหมาย '
          'สำหรับ 3D ต้องใช้ 4 สถานี',
      category: 'ESM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'FDOA (Frequency Difference of Arrival) ใช้หลักการใดในการหาตำแหน่ง?',
      options: [
        'Phase Difference',
        'Amplitude Comparison',
        'Doppler Shift จากการเคลื่อนที่ของ Sensor',
        'Time Delay',
      ],
      correctIndex: 2,
      explanation: 'FDOA ใช้ความแตกต่างของ Doppler Shift ที่วัดได้จาก '
          'Sensor ที่เคลื่อนที่ (เช่น ดาวเทียม, เครื่องบิน) '
          'เพื่อสร้าง Isodoppler Lines และหาตำแหน่ง',
      category: 'ESM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'LPI Radar (Low Probability of Intercept) ใช้เทคนิคใดบ้าง?',
      options: [
        'High Power, Narrow Pulse',
        'Low Power, Wide Bandwidth, Frequency Agility',
        'Single Frequency, High PRF',
        'Maximum Power Output',
      ],
      correctIndex: 1,
      explanation: 'LPI Radar ใช้: กำลังส่งต่ำ, Spread Spectrum (กระจายพลังงาน), '
          'Frequency Agility, Pulse Compression, และ Sidelobe Control '
          'เพื่อให้ ESM ตรวจจับได้ยาก',
      category: 'ECCM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'Cognitive EW คืออะไร?',
      options: [
        'EW ที่ควบคุมด้วยมนุษย์เท่านั้น',
        'EW ที่ใช้ AI/ML เรียนรู้และปรับตัวอัตโนมัติ',
        'EW ที่ใช้ความถี่เดียว',
        'EW รุ่นเก่าที่ใช้ Analog',
      ],
      correctIndex: 1,
      explanation: 'Cognitive EW ใช้ AI/ML วิเคราะห์สภาพแวดล้อม EM, เรียนรู้พฤติกรรมข้าศึก, '
          'และปรับ Parameters (ความถี่, กำลัง, Waveform) แบบ Real-Time '
          'เพื่อตอบโต้อย่างเหมาะสมที่สุด',
      category: 'Modern EW',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'ในการคำนวณ Burn-Through Range, ปัจจัยใดทำให้ระยะ Burn-Through สั้นลง?',
      options: [
        'Jammer Power สูงขึ้น',
        'Radar Power สูงขึ้น',
        'ระยะ Jammer-Target ไกลขึ้น',
        'Radar Antenna Gain ต่ำลง',
      ],
      correctIndex: 1,
      explanation: 'Burn-Through Range คือระยะที่ Radar เห็นเป้าหมายแม้ถูก Jam '
          'ถ้า Radar Power สูงขึ้น จะ Burn-Through ได้ที่ระยะไกลกว่า '
          '(Jammer ต้องมาใกล้กว่าจึงจะ Jam ได้)',
      category: 'ECM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'Space-Based EW มีข้อได้เปรียบอะไรเหนือ Ground-Based?',
      options: [
        'ราคาถูกกว่า',
        'ครอบคลุมพื้นที่กว้าง ไม่ถูกจำกัดโดยภูมิประเทศ',
        'กำลังส่งสูงกว่า',
        'ซ่อมบำรุงง่ายกว่า',
      ],
      correctIndex: 1,
      explanation: 'ดาวเทียม EW มองเห็นพื้นที่กว้าง (Footprint ใหญ่), '
          'ไม่ถูกบังโดยภูเขาหรือความโค้งของโลก, '
          'และเข้าถึงได้ทุกที่ แต่มีข้อจำกัดเรื่อง Power และ Payload',
      category: 'Modern EW',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'Cross-Eye Jamming ใช้หลอกระบบใด?',
      options: [
        'Communication System',
        'Monopulse Tracking Radar',
        'GPS Receiver',
        'IFF System',
      ],
      correctIndex: 1,
      explanation: 'Cross-Eye ใช้ 2 Antenna ส่งสัญญาณที่มี Phase ต่างกัน '
          'เพื่อหลอก Monopulse Radar ให้คำนวณ Angle ผิด '
          'ทำให้ Track เป้าหมายไม่ได้',
      category: 'ECM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'AESA Radar มีข้อได้เปรียบด้าน ECCM อย่างไร?',
      options: [
        'ราคาถูกกว่า',
        'เปลี่ยนความถี่และ Beam ได้เร็วมาก, Graceful Degradation',
        'ใช้พลังงานน้อยกว่า',
        'ซ่อมบำรุงง่ายกว่า',
      ],
      correctIndex: 1,
      explanation: 'AESA (Active Electronically Scanned Array) สามารถ: '
          'เปลี่ยนความถี่ทุก Pulse, สร้างหลาย Beam พร้อมกัน, '
          'Null Steering หลบ Jammer, และเสีย Element บางตัวยังทำงานได้',
      category: 'ECCM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'ELINT Parameter ใดบ่งบอกประเภทของ Radar ได้ดีที่สุด?',
      options: [
        'ความถี่กลาง (Center Frequency)',
        'PRF, PW, และ Scan Pattern ร่วมกัน',
        'ความแรงสัญญาณ',
        'ทิศทางมาของสัญญาณ',
      ],
      correctIndex: 1,
      explanation: 'Radar Fingerprinting ใช้ PRF (Pulse Repetition Frequency), '
          'PW (Pulse Width), Scan Pattern, และ Modulation ร่วมกัน '
          'เพื่อระบุชนิดและแม้แต่ Serial Number ของ Radar',
      category: 'ESM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'Reactive Jamming ต่างจาก Proactive Jamming อย่างไร?',
      options: [
        'Reactive ใช้ AI, Proactive ไม่ใช้',
        'Reactive ตอบสนองต่อสัญญาณจริงๆ, Proactive ส่งต่อเนื่อง',
        'Reactive ถูกกว่า',
        'ไม่ต่างกัน',
      ],
      correctIndex: 1,
      explanation: 'Reactive Jamming: ตรวจจับสัญญาณก่อน แล้วตอบโต้ทันที (ประหยัด Power, ซ่อนตัวดี) '
          'Proactive Jamming: ส่ง Jamming ต่อเนื่องโดยไม่รอ (ครอบคลุม, ใช้ Power มาก)',
      category: 'ECM',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'ระบบ SINCGARS มี Anti-Jam Margin ประมาณเท่าไร?',
      options: [
        '5 dB',
        '10-15 dB',
        '17-25 dB',
        '50+ dB',
      ],
      correctIndex: 2,
      explanation: 'SINCGARS ใช้ FHSS ที่ 111 hops/sec ให้ Anti-Jam Margin '
          'ประมาณ 17-25 dB ขึ้นกับ Hopping Rate และ Bandwidth '
          'หมายความว่า Jammer ต้องแรงกว่าสัญญาณ 17-25 dB จึงจะ Jam ได้',
      category: 'ECCM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'Cyber-EW Convergence หมายถึงอะไร?',
      options: [
        'การรวม Cyber Attack กับ EW Attack เข้าด้วยกัน',
        'การใช้ Internet ควบคุม EW',
        'การป้องกัน Cyber ด้วย EW',
        'การใช้ Firewall ในระบบ EW',
      ],
      correctIndex: 0,
      explanation: 'Cyber-EW Convergence คือการใช้ Cyber (Network Attack, Malware) '
          'ร่วมกับ EW (Jamming, Spoofing) โจมตีพร้อมกัน '
          'เช่น Cyber เจาะระบบ C2, EW รบกวนการสื่อสารสำรอง',
      category: 'Modern EW',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'MTI (Moving Target Indicator) ช่วยต้าน Chaff อย่างไร?',
      options: [
        'ทำให้ Chaff มองไม่เห็น',
        'กรอง Clutter ที่นิ่ง/เคลื่อนที่ช้า (เช่น Chaff ที่ลอย) ออก',
        'ทำลาย Chaff',
        'ดูดซับ Chaff',
      ],
      correctIndex: 1,
      explanation: 'MTI ใช้ Doppler Processing กรองสัญญาณสะท้อนจากวัตถุที่นิ่งหรือ '
          'เคลื่อนที่ช้า (Chaff Cloud ลอยช้าๆ) ออกไป '
          'เหลือแต่เป้าหมายที่เคลื่อนที่เร็ว (เครื่องบิน)',
      category: 'ECCM',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'HARM (High-speed Anti-Radiation Missile) ล็อคเป้าหมายอย่างไร?',
      options: [
        'ใช้ IR Seeker',
        'ใช้ Passive RF Seeker ตาม Radar Emission',
        'ใช้ GPS',
        'ใช้ Command Guidance',
      ],
      correctIndex: 1,
      explanation: 'HARM ใช้ Broadband Passive RF Seeker ตรวจจับและติดตาม '
          'การแผ่คลื่นจาก Radar ข้าศึก (Emission) แม้ Radar จะปิดตัว, '
          'HARM รุ่นใหม่มี GPS/INS สำหรับ Home-On-Jam (HOJ)',
      category: 'SEAD',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'ในระบบ IFF (Identification Friend or Foe), Mode S ต่างจาก Mode 3/A อย่างไร?',
      options: [
        'Mode S ใช้ความถี่ต่างกัน',
        'Mode S มี Selective Addressing และ Data Link',
        'Mode S เป็นระบบเก่ากว่า',
        'ไม่ต่างกัน',
      ],
      correctIndex: 1,
      explanation: 'Mode S (Selective) ใช้ 24-bit Address เฉพาะเครื่อง, '
          'รองรับ Data Link (ADS-B), ลด Garbling (การชนกันของสัญญาณ) '
          'ขณะที่ Mode 3/A ใช้ Squawk Code 4 หลักเหมือนกันได้หลายเครื่อง',
      category: 'IFF',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'Bistatic Radar มีข้อดีด้าน ECCM อย่างไร?',
      options: [
        'ใช้พลังงานน้อยกว่า',
        'Jammer ต้อง Jam ทั้ง Tx และ Rx แยกกัน, และ DF หา Jammer ง่ายขึ้น',
        'ราคาถูกกว่า',
        'ติดตั้งง่ายกว่า',
      ],
      correctIndex: 1,
      explanation: 'Bistatic Radar แยก Transmitter และ Receiver '
          'Jammer จะต้องรู้ตำแหน่งทั้งคู่และ Jam ทั้งสอง '
          'นอกจากนี้ Receiver เป็น Passive ทำให้หายากและ DF Jammer ได้',
      category: 'ECCM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'COMINT ระดับ Technical Intelligence (TECHINT) วิเคราะห์อะไร?',
      options: [
        'เนื้อหาการสนทนา',
        'ลักษณะทางเทคนิคของอุปกรณ์สื่อสาร',
        'ตำแหน่งของผู้ส่ง',
        'จำนวนผู้ใช้',
      ],
      correctIndex: 1,
      explanation: 'TECHINT วิเคราะห์: Modulation, Bandwidth, Power, Protocol, Encryption Method '
          'เพื่อระบุชนิดอุปกรณ์, ความสามารถ, และหาจุดอ่อนทางเทคนิค '
          'ต่างจาก COMINT Content ที่วิเคราะห์เนื้อหา',
      category: 'SIGINT',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'Network Centric Warfare (NCW) ทำให้ EW ต้องปรับตัวอย่างไร?',
      options: [
        'ไม่ต้องปรับตัว',
        'ต้องโจมตี Network และ Data Link ไม่ใช่แค่ Sensor เดี่ยว',
        'ใช้ EW แบบเก่าได้',
        'ไม่เกี่ยวข้องกับ EW',
      ],
      correctIndex: 1,
      explanation: 'NCW ใช้ Network เชื่อม Sensor หลายตัว แม้ Jam Radar หนึ่งตัว '
          'ระบบอื่นก็แชร์ข้อมูลได้ ดังนั้น EW ต้องโจมตี: '
          'Data Link, Network Node, และ C2 System ด้วย',
      category: 'Modern EW',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'SIGINT Tasking Cycle เริ่มต้นจากขั้นตอนใด?',
      options: [
        'Collection',
        'Processing',
        'Planning and Direction (Requirements)',
        'Dissemination',
      ],
      correctIndex: 2,
      explanation: 'Intelligence Cycle: 1) Planning & Direction (กำหนดความต้องการ) '
          '→ 2) Collection → 3) Processing → 4) Analysis '
          '→ 5) Dissemination → 6) Feedback กลับมา Planning',
      category: 'SIGINT',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'Spread Spectrum ให้ Anti-Jam Gain เท่ากับอะไร?',
      options: [
        'Carrier Frequency / Bandwidth',
        'Bandwidth / Data Rate (Processing Gain)',
        'Power / Noise',
        'ไม่สามารถคำนวณได้',
      ],
      correctIndex: 1,
      explanation: 'Processing Gain (Gp) = Bandwidth / Data Rate '
          'เช่น DSSS มี BW = 10 MHz, Data = 10 kbps '
          'Gp = 10M/10k = 1000 = 30 dB Anti-Jam Margin',
      category: 'ECCM',
      difficulty: 3,
    ),
    QuizQuestion(
      question: 'MALD (Miniature Air-Launched Decoy) ทำหน้าที่อะไร?',
      options: [
        'รบกวนสัญญาณ GPS',
        'เป็นเป้าลวงเลียนแบบ Signature ของเครื่องบินรบ',
        'ดักฟังการสื่อสาร',
        'โจมตีเรดาร์โดยตรง',
      ],
      correctIndex: 1,
      explanation: 'MALD เป็น Small UAV ที่ปล่อยจากเครื่องบิน '
          'มี Radar Augmenter ทำให้ RCS เหมือนเครื่องบินรบ '
          'MALD-J เพิ่ม Jammer ด้วย ใช้ล่อให้ SAM ยิงหรือ Radar เปิดเผยตัว',
      category: 'SEAD',
      difficulty: 2,
    ),
    QuizQuestion(
      question: 'EW Reprogramming คืออะไร?',
      options: [
        'การเขียนโปรแกรมใหม่ให้คอมพิวเตอร์',
        'การอัปเดต Threat Library และ ECM Techniques เมื่อภัยคุกคามเปลี่ยน',
        'การซ่อมอุปกรณ์ EW',
        'การฝึกพนักงาน EW',
      ],
      correctIndex: 1,
      explanation: 'EW Reprogramming อัปเดต: Threat Parameters (ความถี่, PRF ใหม่), '
          'ECM Techniques ที่เหมาะสม, และ ESM Library '
          'เมื่อข้าศึกเปลี่ยนระบบหรือใช้ ECCM ใหม่',
      category: 'EW Ops',
      difficulty: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shuffledQuestions = List.from(_questions)..shuffle();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _cardController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _cardController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _shuffledQuestions[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _shuffledQuestions.length - 1) {
      _cardController.reset();
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
      _cardController.forward();
    } else {
      _saveScore();
      setState(() {
        _showResult = true;
      });
    }
  }

  void _saveScore() {
    final percent = (_score / _shuffledQuestions.length * 100).round();
    ProgressService.saveQuizScore('quiz_level3', _score, _shuffledQuestions.length);
  }

  void _restartQuiz() {
    _cardController.reset();
    setState(() {
      _shuffledQuestions = List.from(_questions)..shuffle();
      _currentIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _answered = false;
      _showResult = false;
    });
    _cardController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Level 3: ขั้นสูง'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _showResult ? _buildResultScreen() : _buildQuizScreen(),
    );
  }

  Widget _buildQuizScreen() {
    final question = _shuffledQuestions[_currentIndex];
    final progress = (_currentIndex + 1) / _shuffledQuestions.length;

    return Column(
      children: [
        // Advanced Progress Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatChip(
                    icon: Icons.military_tech,
                    label: 'คะแนน',
                    value: '$_score',
                    color: AppColors.success,
                  ),
                  _buildCategoryBadge(question.category),
                  _buildStatChip(
                    icon: Icons.help_outline,
                    label: 'ข้อที่',
                    value: '${_currentIndex + 1}/${_shuffledQuestions.length}',
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Animated Progress Bar
              Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    height: 8,
                    width: MediaQuery.of(context).size.width * progress - 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.danger, AppColors.warning, AppColors.success],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(100),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Difficulty Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ความยาก: ',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  ...List.generate(3, (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      Icons.whatshot,
                      size: 16,
                      color: i < question.difficulty
                          ? AppColors.danger
                          : AppColors.surfaceLight,
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),

        // Question Card
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ScaleTransition(
              scale: _cardAnimation,
              child: Column(
                children: [
                  // Question
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surface,
                          AppColors.surface.withAlpha(200),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getCategoryColor(question.category).withAlpha(100),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getCategoryColor(question.category).withAlpha(30),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getCategoryIcon(question.category),
                          color: _getCategoryColor(question.category),
                          size: 40,
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

                  const SizedBox(height: 20),

                  // Options
                  ...question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = _selectedAnswer == index;
                    final isCorrect = index == question.correctIndex;

                    Color borderColor = AppColors.border;
                    Color bgColor = AppColors.surface;
                    IconData? trailingIcon;

                    if (_answered) {
                      if (isCorrect) {
                        borderColor = AppColors.success;
                        bgColor = AppColors.success.withAlpha(20);
                        trailingIcon = Icons.check_circle;
                      } else if (isSelected && !isCorrect) {
                        borderColor = AppColors.danger;
                        bgColor = AppColors.danger.withAlpha(20);
                        trailingIcon = Icons.cancel;
                      }
                    } else if (isSelected) {
                      borderColor = AppColors.primary;
                      bgColor = AppColors.primary.withAlpha(20);
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _answered ? null : () => _selectAnswer(index),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
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
                                      child: Text(
                                        String.fromCharCode(65 + index),
                                        style: TextStyle(
                                          color: borderColor,
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
                                        color: _answered && isCorrect
                                            ? AppColors.success
                                            : AppColors.textPrimary,
                                        fontSize: 15,
                                        fontWeight: isSelected || (_answered && isCorrect)
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (trailingIcon != null)
                                    Icon(
                                      trailingIcon,
                                      color: isCorrect ? AppColors.success : AppColors.danger,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // Explanation
                  if (_answered)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withAlpha(50)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.school,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'คำอธิบาย',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            question.explanation,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Next Button
                  if (_answered)
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                            shadowColor: AppColors.danger.withAlpha(100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentIndex < _shuffledQuestions.length - 1
                                    ? 'ข้อถัดไป'
                                    : 'ดูผลลัพธ์',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _currentIndex < _shuffledQuestions.length - 1
                                    ? Icons.arrow_forward
                                    : Icons.assessment,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    final percent = (_score / _shuffledQuestions.length * 100).round();
    final passed = percent >= 70;

    String grade;
    Color gradeColor;
    String title;
    IconData icon;

    if (percent >= 90) {
      grade = 'S';
      gradeColor = const Color(0xFFFFD700);
      title = 'EW Master!';
      icon = Icons.workspace_premium;
    } else if (percent >= 80) {
      grade = 'A';
      gradeColor = AppColors.success;
      title = 'EW Specialist';
      icon = Icons.military_tech;
    } else if (percent >= 70) {
      grade = 'B';
      gradeColor = AppColors.primary;
      title = 'Advanced Operator';
      icon = Icons.verified;
    } else if (percent >= 60) {
      grade = 'C';
      gradeColor = AppColors.warning;
      title = 'ต้องทบทวนเพิ่ม';
      icon = Icons.trending_up;
    } else {
      grade = 'F';
      gradeColor = AppColors.danger;
      title = 'ต้องเรียนรู้เพิ่มเติม';
      icon = Icons.refresh;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Animated Grade Badge
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        gradeColor,
                        gradeColor.withAlpha(150),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradeColor.withAlpha(100),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          grade,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'RANK',
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          Icon(icon, color: gradeColor, size: 40),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: gradeColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 32),

          // Stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildResultRow('คะแนน', '$_score / ${_shuffledQuestions.length}'),
                const Divider(color: AppColors.border, height: 24),
                _buildResultRow('เปอร์เซ็นต์', '$percent%'),
                const Divider(color: AppColors.border, height: 24),
                _buildResultRow(
                  'ผลการทดสอบ',
                  passed ? 'ผ่าน' : 'ไม่ผ่าน',
                  valueColor: passed ? AppColors.success : AppColors.danger,
                ),
                const Divider(color: AppColors.border, height: 24),
                _buildResultRow('ระดับ', 'ขั้นสูง (Advanced)'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Performance by Category
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ผลตามหมวดหมู่',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCategoryPerformance(),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('กลับ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
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
                  onPressed: _restartQuiz,
                  icon: const Icon(Icons.refresh),
                  label: const Text('ทำใหม่'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
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
    );
  }

  Widget _buildCategoryPerformance() {
    // Calculate performance by category
    Map<String, List<bool>> categoryResults = {};

    for (int i = 0; i < _shuffledQuestions.length; i++) {
      final q = _shuffledQuestions[i];
      categoryResults.putIfAbsent(q.category, () => []);
      // We'd need to track answers, for now just show categories
    }

    final categories = _questions.map((q) => q.category).toSet().toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((cat) {
        final count = _questions.where((q) => q.category == cat).length;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getCategoryColor(cat).withAlpha(20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _getCategoryColor(cat).withAlpha(100)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getCategoryIcon(cat),
                size: 14,
                color: _getCategoryColor(cat),
              ),
              const SizedBox(width: 6),
              Text(
                '$cat ($count)',
                style: TextStyle(
                  color: _getCategoryColor(cat),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: color.withAlpha(180), fontSize: 10),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getCategoryColor(category)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 16,
            color: _getCategoryColor(category),
          ),
          const SizedBox(width: 6),
          Text(
            category,
            style: TextStyle(
              color: _getCategoryColor(category),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'ECCM':
        return AppColors.success;
      case 'ECM':
        return AppColors.danger;
      case 'ESM':
        return Colors.amber;
      case 'Modern EW':
        return Colors.purple;
      case 'SIGINT':
        return Colors.cyan;
      case 'SEAD':
        return Colors.orange;
      case 'IFF':
        return Colors.teal;
      case 'EW Ops':
        return AppColors.primary;
      default:
        return AppColors.textMuted;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'ECCM':
        return Icons.shield;
      case 'ECM':
        return Icons.wifi_tethering_off;
      case 'ESM':
        return Icons.radar;
      case 'Modern EW':
        return Icons.auto_awesome;
      case 'SIGINT':
        return Icons.hearing;
      case 'SEAD':
        return Icons.rocket_launch;
      case 'IFF':
        return Icons.verified_user;
      case 'EW Ops':
        return Icons.military_tech;
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
  final int difficulty; // 1-3

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.category,
    this.difficulty = 2,
  });
}
