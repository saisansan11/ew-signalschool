import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/constants.dart';
import '../../services/progress_service.dart';
import '../tools/signal_library_screen.dart';
import '../tools/flashcard_study_screen.dart';
import 'drone_id_training_screen.dart';
import 'interactive_scenarios_screen.dart';
import 'spectrum_analyzer.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Daily challenges based on day of year for variety
  late List<DailyChallenge> _todayChallenges;
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _todayChallenges = _generateDailyChallenges();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  List<DailyChallenge> _generateDailyChallenges() {
    // Use day of year as seed for consistent daily challenges
    final dayOfYear = _currentDate.difference(DateTime(_currentDate.year, 1, 1)).inDays;
    final random = math.Random(dayOfYear);

    // All possible challenges
    final allChallenges = [
      DailyChallenge(
        id: 'study_flashcards',
        title: 'Flashcard Master',
        titleThai: 'ท่องจำ Flashcard',
        description: 'เรียน Flashcard อย่างน้อย 10 ใบ',
        icon: Icons.style,
        xpReward: 30,
        type: ChallengeType.flashcard,
        targetCount: 10,
        color: Colors.purple,
      ),
      DailyChallenge(
        id: 'identify_drones',
        title: 'Drone Spotter',
        titleThai: 'ระบุโดรน',
        description: 'ระบุโดรนให้ถูกต้อง 5 ชนิด',
        icon: Icons.flight,
        xpReward: 40,
        type: ChallengeType.droneId,
        targetCount: 5,
        color: Colors.orange,
      ),
      DailyChallenge(
        id: 'explore_signals',
        title: 'Signal Explorer',
        titleThai: 'สำรวจสัญญาณ',
        description: 'เรียนรู้สัญญาณใหม่ 3 ชนิด',
        icon: Icons.waves,
        xpReward: 25,
        type: ChallengeType.signalLibrary,
        targetCount: 3,
        color: Colors.blue,
      ),
      DailyChallenge(
        id: 'complete_scenario',
        title: 'Scenario Warrior',
        titleThai: 'ทำ Scenario',
        description: 'ทำ Interactive Scenario 1 ภารกิจ',
        icon: Icons.sports_esports,
        xpReward: 50,
        type: ChallengeType.scenario,
        targetCount: 1,
        color: Colors.green,
      ),
      DailyChallenge(
        id: 'spectrum_analysis',
        title: 'Spectrum Analyst',
        titleThai: 'วิเคราะห์สเปกตรัม',
        description: 'ระบุสัญญาณใน Spectrum Analyzer 3 ตัว',
        icon: Icons.insights,
        xpReward: 45,
        type: ChallengeType.spectrum,
        targetCount: 3,
        color: Colors.cyan,
      ),
      DailyChallenge(
        id: 'learning_streak',
        title: 'Consistent Learner',
        titleThai: 'เรียนต่อเนื่อง',
        description: 'เข้าใช้งานวันนี้ (เสร็จแล้ว!)',
        icon: Icons.local_fire_department,
        xpReward: 10,
        type: ChallengeType.login,
        targetCount: 1,
        isCompleted: true,
        color: Colors.red,
      ),
      DailyChallenge(
        id: 'quick_quiz',
        title: 'Quick Thinker',
        titleThai: 'ตอบเร็ว',
        description: 'ทำ Quiz ระดับใดก็ได้ 1 ครั้ง',
        icon: Icons.quiz,
        xpReward: 35,
        type: ChallengeType.quiz,
        targetCount: 1,
        color: Colors.amber,
      ),
      DailyChallenge(
        id: 'study_time',
        title: 'Dedicated Student',
        titleThai: 'เรียน 15 นาที',
        description: 'ใช้เวลาเรียนรวม 15 นาทีวันนี้',
        icon: Icons.timer,
        xpReward: 20,
        type: ChallengeType.studyTime,
        targetCount: 15,
        color: Colors.teal,
      ),
    ];

    // Shuffle and pick 4 challenges (always include login challenge)
    final loginChallenge = allChallenges.firstWhere((c) => c.type == ChallengeType.login);
    final otherChallenges = allChallenges.where((c) => c.type != ChallengeType.login).toList();
    otherChallenges.shuffle(random);

    return [loginChallenge, ...otherChallenges.take(3)];
  }

  int get _completedCount => _todayChallenges.where((c) => c.isCompleted).length;
  int get _totalXpAvailable => _todayChallenges.fold(0, (sum, c) => sum + c.xpReward);
  int get _earnedXp => _todayChallenges.where((c) => c.isCompleted).fold(0, (sum, c) => sum + c.xpReward);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Daily Challenges'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Show info about refresh
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Challenges รีเซ็ตทุกวันเวลา 00:00'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Today's Progress
            _buildHeaderCard(),
            const SizedBox(height: 24),

            // Bonus Challenge (if all completed)
            if (_completedCount == _todayChallenges.length)
              _buildBonusCard(),

            if (_completedCount == _todayChallenges.length)
              const SizedBox(height: 24),

            // Today's Challenges
            const Text(
              'ภารกิจวันนี้',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Challenge Cards
            ..._todayChallenges.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildChallengeCard(entry.value, entry.key),
              );
            }),

            const SizedBox(height: 24),

            // Tips Section
            _buildTipsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final progress = _completedCount / _todayChallenges.length;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _completedCount == _todayChallenges.length ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: _completedCount == _todayChallenges.length
                  ? const LinearGradient(
                      colors: [Colors.amber, Colors.orange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (_completedCount == _todayChallenges.length ? Colors.amber : AppColors.primary)
                      .withAlpha(60),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Calendar Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_currentDate.day}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getThaiMonth(_currentDate.month),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _completedCount == _todayChallenges.length
                                ? '🎉 ครบทุกภารกิจ!'
                                : 'Daily Challenges',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_completedCount/${_todayChallenges.length} ภารกิจสำเร็จ',
                            style: TextStyle(
                              color: Colors.white.withAlpha(200),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // XP Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.stars, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '$_earnedXp/$_totalXpAvailable',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withAlpha(50),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBonusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent.withAlpha(100)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium, color: Colors.amber, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DAILY BONUS UNLOCKED!',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'คุณทำครบทุกภารกิจวันนี้แล้ว!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+50 Bonus XP',
                  style: TextStyle(
                    color: Colors.amber.shade200,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(DailyChallenge challenge, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: challenge.isCompleted ? null : () => _onChallengePress(challenge),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: challenge.isCompleted
                ? challenge.color.withAlpha(30)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: challenge.isCompleted ? challenge.color : AppColors.border,
              width: challenge.isCompleted ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: challenge.color.withAlpha(challenge.isCompleted ? 50 : 30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  challenge.icon,
                  color: challenge.color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          challenge.titleThai,
                          style: TextStyle(
                            color: challenge.isCompleted
                                ? challenge.color
                                : AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (challenge.isCompleted) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.check_circle, color: challenge.color, size: 18),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.description,
                      style: TextStyle(
                        color: challenge.isCompleted
                            ? challenge.color.withAlpha(180)
                            : AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // XP Reward
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: challenge.isCompleted
                      ? challenge.color.withAlpha(30)
                      : Colors.amber.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.stars,
                      color: challenge.isCompleted ? challenge.color : Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${challenge.xpReward}',
                      style: TextStyle(
                        color: challenge.isCompleted ? challenge.color : Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lightbulb, color: AppColors.info, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'เคล็ดลับ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• ทำ Challenges ทุกวันเพื่อรักษา Streak\n'
            '• ทำครบทุกภารกิจจะได้รับ Bonus XP\n'
            '• Challenges รีเซ็ตใหม่ทุกวันเวลา 00:00\n'
            '• กดที่ Challenge เพื่อไปยังหน้านั้นโดยตรง',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _onChallengePress(DailyChallenge challenge) {
    Widget? targetScreen;

    switch (challenge.type) {
      case ChallengeType.flashcard:
        targetScreen = const FlashcardStudyScreen();
        break;
      case ChallengeType.droneId:
        targetScreen = const DroneIdTrainingScreen();
        break;
      case ChallengeType.signalLibrary:
        targetScreen = const SignalLibraryScreen();
        break;
      case ChallengeType.scenario:
        targetScreen = const InteractiveScenariosScreen();
        break;
      case ChallengeType.spectrum:
        targetScreen = const SpectrumAnalyzer();
        break;
      case ChallengeType.quiz:
        // Show quiz selection
        _showQuizSelection();
        return;
      case ChallengeType.login:
      case ChallengeType.studyTime:
        // These are auto-completed
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => targetScreen!),
    ).then((_) {
      // Simulate completing challenge after returning
      // In real app, this would check actual progress
      setState(() {
        // Mark challenge as completed (simulated)
        final index = _todayChallenges.indexOf(challenge);
        if (index >= 0) {
          _todayChallenges[index] = challenge.copyWith(isCompleted: true);
          // Add XP
          ProgressService.addXp(challenge.xpReward);

          // Check if all completed for bonus
          if (_completedCount == _todayChallenges.length) {
            ProgressService.addXp(50); // Bonus XP
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🎉 ทำครบทุกภารกิจ! +50 Bonus XP'),
                backgroundColor: Colors.amber,
              ),
            );
          }
        }
      });
    });
  }

  void _showQuizSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'เลือก Quiz',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildQuizOption('Quiz Level 1', 'พื้นฐาน', Colors.green, () {
                Navigator.pop(context);
                // Navigate to quiz level 1
              }),
              _buildQuizOption('Quiz Level 2', 'ปานกลาง', Colors.orange, () {
                Navigator.pop(context);
                // Navigate to quiz level 2
              }),
              _buildQuizOption('Quiz Level 3', 'ขั้นสูง', Colors.red, () {
                Navigator.pop(context);
                // Navigate to quiz level 3
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuizOption(String title, String subtitle, Color color, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.quiz, color: color),
      ),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
    );
  }

  String _getThaiMonth(int month) {
    const months = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
    ];
    return months[month - 1];
  }
}

// Challenge Data Classes
enum ChallengeType {
  flashcard,
  droneId,
  signalLibrary,
  scenario,
  spectrum,
  quiz,
  login,
  studyTime,
}

class DailyChallenge {
  final String id;
  final String title;
  final String titleThai;
  final String description;
  final IconData icon;
  final int xpReward;
  final ChallengeType type;
  final int targetCount;
  final bool isCompleted;
  final Color color;

  const DailyChallenge({
    required this.id,
    required this.title,
    required this.titleThai,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.type,
    required this.targetCount,
    this.isCompleted = false,
    required this.color,
  });

  DailyChallenge copyWith({
    String? id,
    String? title,
    String? titleThai,
    String? description,
    IconData? icon,
    int? xpReward,
    ChallengeType? type,
    int? targetCount,
    bool? isCompleted,
    Color? color,
  }) {
    return DailyChallenge(
      id: id ?? this.id,
      title: title ?? this.title,
      titleThai: titleThai ?? this.titleThai,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      xpReward: xpReward ?? this.xpReward,
      type: type ?? this.type,
      targetCount: targetCount ?? this.targetCount,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
    );
  }
}
