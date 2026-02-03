import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/progress_service.dart';
import '../../services/theme_provider.dart';

// ==========================================
// FLASHCARD STUDY MODE
// โหมดท่องจำด้วย Flashcard
// ==========================================

enum FlashcardCategory {
  signals,
  drones,
  ewTerms,
  frequencies,
}

extension FlashcardCategoryExtension on FlashcardCategory {
  String get displayName {
    switch (this) {
      case FlashcardCategory.signals:
        return 'RF Signals';
      case FlashcardCategory.drones:
        return 'Drone ID';
      case FlashcardCategory.ewTerms:
        return 'EW Terms';
      case FlashcardCategory.frequencies:
        return 'Frequencies';
    }
  }

  IconData get icon {
    switch (this) {
      case FlashcardCategory.signals:
        return Icons.waves;
      case FlashcardCategory.drones:
        return Icons.flight;
      case FlashcardCategory.ewTerms:
        return Icons.book;
      case FlashcardCategory.frequencies:
        return Icons.radio;
    }
  }

  Color get color {
    switch (this) {
      case FlashcardCategory.signals:
        return AppColors.primary;
      case FlashcardCategory.drones:
        return Colors.orange;
      case FlashcardCategory.ewTerms:
        return AppColors.success;
      case FlashcardCategory.frequencies:
        return AppColors.warning;
    }
  }
}

class FlashcardData {
  final String id;
  final String question;
  final String answer;
  final String? hint;
  final FlashcardCategory category;
  final List<String> tags;

  const FlashcardData({
    required this.id,
    required this.question,
    required this.answer,
    this.hint,
    required this.category,
    this.tags = const [],
  });
}

class FlashcardStudyScreen extends StatefulWidget {
  const FlashcardStudyScreen({super.key});

  @override
  State<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen>
    with SingleTickerProviderStateMixin {
  FlashcardCategory? _selectedCategory;
  bool _studyMode = false;
  List<FlashcardData> _studyDeck = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  int _correctCount = 0;
  int _incorrectCount = 0;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  final List<FlashcardData> _allCards = [
    // RF Signals
    const FlashcardData(
      id: 'sig_wifi24',
      question: 'WiFi 2.4 GHz ใช้ความถี่ช่วงใด?',
      answer: '2400 - 2483.5 MHz\n(Channels 1-14)\nModulation: OFDM',
      hint: 'ย่าน ISM Band',
      category: FlashcardCategory.signals,
      tags: ['WiFi', 'ISM'],
    ),
    const FlashcardData(
      id: 'sig_gps_l1',
      question: 'GPS L1 ใช้ความถี่เท่าไร?',
      answer: '1575.42 MHz\nModulation: BPSK/CDMA\nBandwidth: 2 MHz',
      hint: 'L-Band',
      category: FlashcardCategory.signals,
      tags: ['GPS', 'Navigation'],
    ),
    const FlashcardData(
      id: 'sig_dji',
      question: 'DJI OcuSync ใช้ความถี่ช่วงใด?',
      answer: '2.4 GHz และ 5.8 GHz\nFHSS + OFDM\nRange: 10-15 km',
      hint: 'Dual-band',
      category: FlashcardCategory.signals,
      tags: ['Drone', 'DJI'],
    ),
    const FlashcardData(
      id: 'sig_bt',
      question: 'Bluetooth Classic ใช้ความถี่ช่วงใด?',
      answer: '2402 - 2480 MHz\n79 channels, 1 MHz spacing\nFHSS 1600 hops/sec',
      hint: 'ย่านเดียวกับ WiFi',
      category: FlashcardCategory.signals,
      tags: ['Bluetooth', 'ISM'],
    ),
    const FlashcardData(
      id: 'sig_lte',
      question: 'LTE Band 3 (1800 MHz) ใช้ความถี่ช่วงใด?',
      answer: 'Uplink: 1710-1785 MHz\nDownlink: 1805-1880 MHz\nOFDM/SC-FDMA',
      category: FlashcardCategory.signals,
      tags: ['4G', 'Cellular'],
    ),
    const FlashcardData(
      id: 'sig_link16',
      question: 'Link-16 (TADIL-J) ใช้ความถี่ช่วงใด?',
      answer: '960 - 1215 MHz (L-Band)\nTDMA + FHSS\nMIL-STD-6016',
      hint: 'NATO Tactical Data Link',
      category: FlashcardCategory.signals,
      tags: ['Military', 'NATO'],
    ),
    const FlashcardData(
      id: 'sig_uhf_mil',
      question: 'UHF Military SATCOM ใช้ความถี่ช่วงใด?',
      answer: 'Uplink: 290-320 MHz\nDownlink: 240-270 MHz\nNarrowband FDMA',
      category: FlashcardCategory.signals,
      tags: ['Military', 'SATCOM'],
    ),
    const FlashcardData(
      id: 'sig_adsb',
      question: 'ADS-B Out ใช้ความถี่เท่าไร?',
      answer: '1090 MHz (Mode S Extended Squitter)\nPPM Modulation\n112-bit message',
      hint: 'เดียวกับ Mode S transponder',
      category: FlashcardCategory.signals,
      tags: ['Aviation', 'Surveillance'],
    ),

    // Drones
    const FlashcardData(
      id: 'drone_mavic3',
      question: 'DJI Mavic 3 มีคุณสมบัติอะไรบ้าง?',
      answer: 'Weight: 895g\nMax Speed: 75 km/h\nMax Range: 30 km\nOcuSync 3.0 (2.4/5.8 GHz)',
      category: FlashcardCategory.drones,
      tags: ['DJI', 'Consumer'],
    ),
    const FlashcardData(
      id: 'drone_tb2',
      question: 'Bayraktar TB2 มีคุณสมบัติอะไรบ้าง?',
      answer: 'MTOW: 700 kg\nEndurance: 27 hours\nCeiling: 8,200 m\nC-band + Satellite',
      hint: 'Turkish UCAV',
      category: FlashcardCategory.drones,
      tags: ['Military', 'Turkey'],
    ),
    const FlashcardData(
      id: 'drone_sw300',
      question: 'Switchblade 300 มีคุณสมบัติอะไรบ้าง?',
      answer: 'Weight: 2.5 kg\nRange: 10 km\nSpeed: 160 km/h\nLoitering Munition',
      hint: 'AeroVironment',
      category: FlashcardCategory.drones,
      tags: ['Military', 'US'],
    ),
    const FlashcardData(
      id: 'drone_orlan10',
      question: 'Orlan-10 มีคุณสมบัติอะไรบ้าง?',
      answer: 'Weight: 18 kg\nEndurance: 16 hours\nRange: 120 km\nRF: 868/900 MHz',
      hint: 'Russian ISR UAV',
      category: FlashcardCategory.drones,
      tags: ['Military', 'Russia'],
    ),
    const FlashcardData(
      id: 'drone_fpv',
      question: 'FPV Racing Drone มีคุณสมบัติทั่วไปอะไรบ้าง?',
      answer: 'Weight: 250-650g\nSpeed: up to 180 km/h\nControl: 2.4 GHz (ELRS/Crossfire)\nVideo: 5.8 GHz',
      category: FlashcardCategory.drones,
      tags: ['FPV', 'Racing'],
    ),
    const FlashcardData(
      id: 'drone_shahed',
      question: 'Shahed-136 มีคุณสมบัติอะไรบ้าง?',
      answer: 'Weight: 200 kg\nRange: 2,500 km\nSpeed: 185 km/h\nGPS + INS guidance',
      hint: 'Iranian loitering munition',
      category: FlashcardCategory.drones,
      tags: ['Military', 'Iran'],
    ),

    // EW Terms
    const FlashcardData(
      id: 'term_esm',
      question: 'ESM ย่อมาจากอะไร? มีหน้าที่อย่างไร?',
      answer: 'Electronic Support Measures\nการรับและวิเคราะห์สัญญาณแม่เหล็กไฟฟ้า\nPassive detection & identification',
      category: FlashcardCategory.ewTerms,
      tags: ['ESM', 'Basic'],
    ),
    const FlashcardData(
      id: 'term_ecm',
      question: 'ECM ย่อมาจากอะไร? มีหน้าที่อย่างไร?',
      answer: 'Electronic Counter Measures\nการรบกวนหรือหลอกลวงระบบอิเล็กทรอนิกส์\nJamming, Deception, Decoys',
      category: FlashcardCategory.ewTerms,
      tags: ['ECM', 'Basic'],
    ),
    const FlashcardData(
      id: 'term_eccm',
      question: 'ECCM/EP ย่อมาจากอะไร? มีหน้าที่อย่างไร?',
      answer: 'Electronic Counter-Counter Measures\nหรือ Electronic Protection\nมาตรการป้องกันการถูกรบกวน',
      category: FlashcardCategory.ewTerms,
      tags: ['ECCM', 'Basic'],
    ),
    const FlashcardData(
      id: 'term_elint',
      question: 'ELINT ย่อมาจากอะไร?',
      answer: 'Electronic Intelligence\nการรวบรวมข่าวกรองจากสัญญาณที่ไม่ใช่การสื่อสาร\nเช่น Radar, Navigation systems',
      category: FlashcardCategory.ewTerms,
      tags: ['ELINT', 'Intel'],
    ),
    const FlashcardData(
      id: 'term_comint',
      question: 'COMINT ย่อมาจากอะไร?',
      answer: 'Communications Intelligence\nการรวบรวมข่าวกรองจากสัญญาณสื่อสาร\nVoice, Data, Messaging',
      category: FlashcardCategory.ewTerms,
      tags: ['COMINT', 'Intel'],
    ),
    const FlashcardData(
      id: 'term_sigint',
      question: 'SIGINT ย่อมาจากอะไร?',
      answer: 'Signals Intelligence\nการรวบรวมข่าวกรองจากสัญญาณทุกประเภท\nรวม COMINT + ELINT',
      category: FlashcardCategory.ewTerms,
      tags: ['SIGINT', 'Intel'],
    ),
    const FlashcardData(
      id: 'term_jsr',
      question: 'J/S Ratio คืออะไร?',
      answer: 'Jamming-to-Signal Ratio\nอัตราส่วนกำลังสัญญาณรบกวนต่อสัญญาณเป้าหมาย\nยิ่งสูงยิ่งรบกวนได้ผล',
      hint: 'หน่วยเป็น dB',
      category: FlashcardCategory.ewTerms,
      tags: ['Jamming', 'Calculation'],
    ),
    const FlashcardData(
      id: 'term_prf',
      question: 'PRF คืออะไร?',
      answer: 'Pulse Repetition Frequency\nความถี่การส่งพัลส์ของเรดาร์\nหน่วยเป็น Hz หรือ pulses/sec',
      category: FlashcardCategory.ewTerms,
      tags: ['Radar', 'Parameter'],
    ),
    const FlashcardData(
      id: 'term_eirp',
      question: 'EIRP คืออะไร?',
      answer: 'Effective Isotropic Radiated Power\nกำลังส่งที่แท้จริงเมื่อรวม Antenna Gain\nEIRP = P_tx × G_antenna',
      category: FlashcardCategory.ewTerms,
      tags: ['RF', 'Calculation'],
    ),

    // Frequencies
    const FlashcardData(
      id: 'freq_vhf',
      question: 'VHF Band ครอบคลุมความถี่ช่วงใด?',
      answer: '30 - 300 MHz\nใช้งาน: FM Radio, TV, Aviation, Marine\nVery High Frequency',
      category: FlashcardCategory.frequencies,
      tags: ['VHF', 'Band'],
    ),
    const FlashcardData(
      id: 'freq_uhf',
      question: 'UHF Band ครอบคลุมความถี่ช่วงใด?',
      answer: '300 MHz - 3 GHz\nใช้งาน: TV, Cellular, WiFi, GPS\nUltra High Frequency',
      category: FlashcardCategory.frequencies,
      tags: ['UHF', 'Band'],
    ),
    const FlashcardData(
      id: 'freq_shf',
      question: 'SHF Band ครอบคลุมความถี่ช่วงใด?',
      answer: '3 - 30 GHz\nใช้งาน: Radar, Satellite, 5G\nSuper High Frequency',
      category: FlashcardCategory.frequencies,
      tags: ['SHF', 'Band'],
    ),
    const FlashcardData(
      id: 'freq_lband',
      question: 'L-Band ครอบคลุมความถี่ช่วงใด?',
      answer: '1 - 2 GHz\nใช้งาน: GPS, GNSS, Link-16, SATCOM\nIEEE Radar Band',
      category: FlashcardCategory.frequencies,
      tags: ['L-Band', 'Radar'],
    ),
    const FlashcardData(
      id: 'freq_sband',
      question: 'S-Band ครอบคลุมความถี่ช่วงใด?',
      answer: '2 - 4 GHz\nใช้งาน: Weather Radar, WiFi, Bluetooth\nIEEE Radar Band',
      category: FlashcardCategory.frequencies,
      tags: ['S-Band', 'Radar'],
    ),
    const FlashcardData(
      id: 'freq_cband',
      question: 'C-Band ครอบคลุมความถี่ช่วงใด?',
      answer: '4 - 8 GHz\nใช้งาน: Satellite, Some Radars, 5G\nIEEE Radar Band',
      category: FlashcardCategory.frequencies,
      tags: ['C-Band', 'Radar'],
    ),
    const FlashcardData(
      id: 'freq_xband',
      question: 'X-Band ครอบคลุมความถี่ช่วงใด?',
      answer: '8 - 12 GHz\nใช้งาน: Military Radar, Marine Radar\nIEEE Radar Band',
      category: FlashcardCategory.frequencies,
      tags: ['X-Band', 'Radar'],
    ),
    const FlashcardData(
      id: 'freq_ism',
      question: 'ISM Bands ที่นิยมใช้มีอะไรบ้าง?',
      answer: '433 MHz (EU)\n915 MHz (US)\n2.4 GHz (Global)\n5.8 GHz (Global)\nIndustrial, Scientific, Medical',
      category: FlashcardCategory.frequencies,
      tags: ['ISM', 'Unlicensed'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  List<FlashcardData> get _filteredCards {
    if (_selectedCategory == null) return _allCards;
    return _allCards.where((c) => c.category == _selectedCategory).toList();
  }

  void _startStudy() {
    _studyDeck = List.from(_filteredCards)..shuffle(Random());
    setState(() {
      _studyMode = true;
      _currentIndex = 0;
      _showAnswer = false;
      _correctCount = 0;
      _incorrectCount = 0;
    });
  }

  void _flipCard() {
    if (_showAnswer) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _showAnswer = !_showAnswer);
  }

  void _markCard(bool correct) {
    setState(() {
      if (correct) {
        _correctCount++;
      } else {
        _incorrectCount++;
      }
    });
    _nextCard();
  }

  void _nextCard() {
    if (_currentIndex < _studyDeck.length - 1) {
      _flipController.reset();
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final total = _correctCount + _incorrectCount;
    final percent = total > 0 ? (_correctCount / total * 100).round() : 0;

    // Award XP based on performance
    if (percent >= 70) {
      ProgressService.addXp(total * 5);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              percent >= 70 ? Icons.check_circle : Icons.info,
              color: percent >= 70 ? AppColors.success : AppColors.warning,
            ),
            const SizedBox(width: 10),
            const Text('Study Complete!', style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResultStat('Correct', _correctCount, AppColors.success),
                _buildResultStat('Incorrect', _incorrectCount, AppColors.danger),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '$percent%',
              style: TextStyle(
                color: percent >= 70 ? AppColors.success : AppColors.warning,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (percent >= 70) ...[
              const SizedBox(height: 8),
              Text(
                '+${total * 5} XP',
                style: const TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startStudy();
            },
            child: const Text('Study Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _studyMode = false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            title: const Text('Flashcard Study'),
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            actions: [
              if (_studyMode)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      '${_currentIndex + 1}/${_studyDeck.length}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: _studyMode ? _buildStudyMode(isDark) : _buildCategorySelection(isDark),
        );
      },
    );
  }

  Widget _buildCategorySelection(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats
        _buildStatsCard(isDark),
        const SizedBox(height: 24),
        // Category Selection
        const Text(
          'Select Category',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // All categories option
        _buildCategoryCard(null, 'All Categories', Icons.apps, AppColors.primary, isDark),
        const SizedBox(height: 12),
        // Individual categories
        ...FlashcardCategory.values.map((cat) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCategoryCard(cat, cat.displayName, cat.icon, cat.color, isDark),
        )),
        const SizedBox(height: 24),
        // Start Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _startStudy,
            icon: const Icon(Icons.play_arrow),
            label: Text('Start Study (${_filteredCards.length} cards)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.style, '${_allCards.length}', 'Total Cards'),
          _buildStatItem(Icons.category, '${FlashcardCategory.values.length}', 'Categories'),
          _buildStatItem(Icons.star, '${ProgressService.getLevel()}', 'Level'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(200),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    FlashcardCategory? category,
    String title,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    final isSelected = _selectedCategory == category;
    final count = category == null
        ? _allCards.length
        : _allCards.where((c) => c.category == category).length;

    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColorsLight.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '$count cards',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyMode(bool isDark) {
    if (_studyDeck.isEmpty) return const SizedBox();

    final card = _studyDeck[_currentIndex];

    return Column(
      children: [
        // Progress
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _studyDeck.length,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation<Color>(card.category.color),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check, color: AppColors.success, size: 16),
                      const SizedBox(width: 4),
                      Text('$_correctCount', style: const TextStyle(color: AppColors.success)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: card.category.color.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      card.category.displayName,
                      style: TextStyle(
                        color: card.category.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.close, color: AppColors.danger, size: 16),
                      const SizedBox(width: 4),
                      Text('$_incorrectCount', style: const TextStyle(color: AppColors.danger)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Card
        Expanded(
          child: GestureDetector(
            onTap: _flipCard,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final angle = _flipAnimation.value * 3.14159;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: angle < 1.5708
                        ? _buildCardFront(card, isDark)
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(3.14159),
                            child: _buildCardBack(card, isDark),
                          ),
                  );
                },
              ),
            ),
          ),
        ),
        // Actions
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (_showAnswer) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _markCard(false),
                    icon: const Icon(Icons.close),
                    label: const Text('Incorrect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _markCard(true),
                    icon: const Icon(Icons.check),
                    label: const Text('Correct'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ] else
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _flipCard,
                    icon: const Icon(Icons.flip),
                    label: const Text('Show Answer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardFront(FlashcardData card, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: card.category.color, width: 2),
        boxShadow: [
          BoxShadow(
            color: card.category.color.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            card.category.icon,
            color: card.category.color,
            size: 48,
          ),
          const SizedBox(height: 24),
          Text(
            card.question,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (card.hint != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lightbulb, color: AppColors.warning, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Hint: ${card.hint}',
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
          const Text(
            'Tap to flip',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(FlashcardData card, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: card.category.color.withAlpha(isDark ? 40 : 20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: card.category.color, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 40),
          const SizedBox(height: 16),
          const Text(
            'ANSWER',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            card.answer,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (card.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: card.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }
}
