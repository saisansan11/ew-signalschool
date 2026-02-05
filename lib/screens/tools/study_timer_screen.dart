import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';
import '../../services/progress_service.dart';

class StudyTimerScreen extends StatefulWidget {
  const StudyTimerScreen({super.key});

  @override
  State<StudyTimerScreen> createState() => _StudyTimerScreenState();
}

class _StudyTimerScreenState extends State<StudyTimerScreen>
    with TickerProviderStateMixin {
  // Timer settings
  int _studyDuration = 25; // minutes
  int _shortBreak = 5; // minutes
  int _longBreak = 15; // minutes
  int _sessionsBeforeLongBreak = 4;

  // Timer state
  Timer? _timer;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  _TimerPhase _currentPhase = _TimerPhase.study;
  int _completedSessions = 0;
  int _totalStudyMinutes = 0;

  // Animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _studyDuration * 60;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          if (_currentPhase == _TimerPhase.study) {
            // Track study time
            if (_remainingSeconds % 60 == 0 && _remainingSeconds > 0) {
              _totalStudyMinutes++;
            }
          }
        } else {
          _onPhaseComplete();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _studyDuration * 60;
      _currentPhase = _TimerPhase.study;
    });
  }

  void _onPhaseComplete() {
    _timer?.cancel();
    HapticFeedback.heavyImpact();

    if (_currentPhase == _TimerPhase.study) {
      _completedSessions++;
      _totalStudyMinutes += 1; // Add the final minute

      // Award XP for completing a study session
      ProgressService.addXp(10);

      // Determine next break type
      if (_completedSessions % _sessionsBeforeLongBreak == 0) {
        _currentPhase = _TimerPhase.longBreak;
        _remainingSeconds = _longBreak * 60;
      } else {
        _currentPhase = _TimerPhase.shortBreak;
        _remainingSeconds = _shortBreak * 60;
      }

      _showPhaseCompleteDialog(
        title: 'เรียนครบ $_studyDuration นาที!',
        message: _currentPhase == _TimerPhase.longBreak
            ? 'ยอดเยี่ยม! พักยาว $_longBreak นาที'
            : 'พักสั้น $_shortBreak นาที',
        icon: Icons.celebration,
        color: Colors.amber,
      );
    } else {
      // Break complete
      _currentPhase = _TimerPhase.study;
      _remainingSeconds = _studyDuration * 60;

      _showPhaseCompleteDialog(
        title: 'หมดเวลาพัก!',
        message: 'เริ่มเรียนต่อ $_studyDuration นาที',
        icon: Icons.school,
        color: AppColors.primary,
      );
    }

    setState(() => _isRunning = false);
  }

  void _showPhaseCompleteDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor:
            themeProvider.isDarkMode ? AppColors.surface : AppColorsLight.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: themeProvider.isDarkMode
                    ? AppColors.textPrimary
                    : AppColorsLight.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeProvider.isDarkMode
                    ? AppColors.textSecondary
                    : AppColorsLight.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '+10 XP',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('พักก่อน'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startTimer();
            },
            style: ElevatedButton.styleFrom(backgroundColor: color),
            child: Text(
              _currentPhase == _TimerPhase.study ? 'เริ่มเรียน' : 'เริ่มพัก',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SettingsSheet(
        studyDuration: _studyDuration,
        shortBreak: _shortBreak,
        longBreak: _longBreak,
        sessionsBeforeLongBreak: _sessionsBeforeLongBreak,
        onSave: (study, shortB, longB, sessions) {
          setState(() {
            _studyDuration = study;
            _shortBreak = shortB;
            _longBreak = longB;
            _sessionsBeforeLongBreak = sessions;
            if (!_isRunning) {
              _remainingSeconds = _studyDuration * 60;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Text(
              'STUDY TIMER',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: _showSettingsDialog,
              ),
            ],
          ),
          body: Column(
            children: [
              // Phase indicator
              _buildPhaseIndicator(isDark),

              // Timer display
              Expanded(
                child: Center(
                  child: _buildTimerDisplay(isDark),
                ),
              ),

              // Session stats
              _buildSessionStats(isDark),

              // Controls
              _buildControls(isDark),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhaseIndicator(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPhaseChip(
            'Study',
            Icons.school,
            _currentPhase == _TimerPhase.study,
            AppColors.primary,
            isDark,
          ),
          const SizedBox(width: 12),
          _buildPhaseChip(
            'Short Break',
            Icons.coffee,
            _currentPhase == _TimerPhase.shortBreak,
            Colors.green,
            isDark,
          ),
          const SizedBox(width: 12),
          _buildPhaseChip(
            'Long Break',
            Icons.self_improvement,
            _currentPhase == _TimerPhase.longBreak,
            Colors.purple,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseChip(
    String label,
    IconData icon,
    bool isActive,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withAlpha(30) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? color : (isDark ? AppColors.border : AppColorsLight.border),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive
                ? color
                : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? color
                  : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay(bool isDark) {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final progress = 1 - (_remainingSeconds / (_getPhaseMaxSeconds()));

    final phaseColor = _getPhaseColor();

    return ScaleTransition(
      scale: _isRunning ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: (isDark ? AppColors.surface : AppColorsLight.surface),
              valueColor: AlwaysStoppedAnimation<Color>(phaseColor),
            ),
          ),

          // Timer text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getPhaseLabel(),
                style: TextStyle(
                  color: phaseColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStats(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.check_circle,
            '$_completedSessions',
            'Sessions',
            Colors.green,
            isDark,
          ),
          Container(
            width: 1,
            height: 40,
            color: isDark ? AppColors.border : AppColorsLight.border,
          ),
          _buildStatItem(
            Icons.timer,
            '$_totalStudyMinutes',
            'Minutes',
            AppColors.primary,
            isDark,
          ),
          Container(
            width: 1,
            height: 40,
            color: isDark ? AppColors.border : AppColorsLight.border,
          ),
          _buildStatItem(
            Icons.star,
            '${_completedSessions * 10}',
            'XP',
            Colors.amber,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
    bool isDark,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildControls(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset button
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : AppColorsLight.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.border : AppColorsLight.border,
              ),
            ),
            child: IconButton(
              onPressed: _resetTimer,
              icon: Icon(
                Icons.refresh,
                color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              ),
              iconSize: 28,
            ),
          ),

          const SizedBox(width: 24),

          // Play/Pause button
          GestureDetector(
            onTap: _isRunning ? _pauseTimer : _startTimer,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getPhaseColor(),
                    _getPhaseColor().withAlpha(200),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getPhaseColor().withAlpha(80),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                _isRunning ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),

          const SizedBox(width: 24),

          // Skip button
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : AppColorsLight.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.border : AppColorsLight.border,
              ),
            ),
            child: IconButton(
              onPressed: () {
                _timer?.cancel();
                _onPhaseComplete();
              },
              icon: Icon(
                Icons.skip_next,
                color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              ),
              iconSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  int _getPhaseMaxSeconds() {
    switch (_currentPhase) {
      case _TimerPhase.study:
        return _studyDuration * 60;
      case _TimerPhase.shortBreak:
        return _shortBreak * 60;
      case _TimerPhase.longBreak:
        return _longBreak * 60;
    }
  }

  Color _getPhaseColor() {
    switch (_currentPhase) {
      case _TimerPhase.study:
        return AppColors.primary;
      case _TimerPhase.shortBreak:
        return Colors.green;
      case _TimerPhase.longBreak:
        return Colors.purple;
    }
  }

  String _getPhaseLabel() {
    switch (_currentPhase) {
      case _TimerPhase.study:
        return 'เวลาเรียน';
      case _TimerPhase.shortBreak:
        return 'พักสั้น';
      case _TimerPhase.longBreak:
        return 'พักยาว';
    }
  }
}

enum _TimerPhase {
  study,
  shortBreak,
  longBreak,
}

class _SettingsSheet extends StatefulWidget {
  final int studyDuration;
  final int shortBreak;
  final int longBreak;
  final int sessionsBeforeLongBreak;
  final Function(int, int, int, int) onSave;

  const _SettingsSheet({
    required this.studyDuration,
    required this.shortBreak,
    required this.longBreak,
    required this.sessionsBeforeLongBreak,
    required this.onSave,
  });

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late int _study;
  late int _short;
  late int _long;
  late int _sessions;

  @override
  void initState() {
    super.initState();
    _study = widget.studyDuration;
    _short = widget.shortBreak;
    _long = widget.longBreak;
    _sessions = widget.sessionsBeforeLongBreak;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.border : AppColorsLight.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'ตั้งค่าเวลา',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Study duration
          _buildSliderSetting(
            label: 'เวลาเรียน',
            value: _study,
            min: 15,
            max: 60,
            suffix: 'นาที',
            color: AppColors.primary,
            isDark: isDark,
            onChanged: (v) => setState(() => _study = v.round()),
          ),

          // Short break
          _buildSliderSetting(
            label: 'พักสั้น',
            value: _short,
            min: 3,
            max: 15,
            suffix: 'นาที',
            color: Colors.green,
            isDark: isDark,
            onChanged: (v) => setState(() => _short = v.round()),
          ),

          // Long break
          _buildSliderSetting(
            label: 'พักยาว',
            value: _long,
            min: 10,
            max: 30,
            suffix: 'นาที',
            color: Colors.purple,
            isDark: isDark,
            onChanged: (v) => setState(() => _long = v.round()),
          ),

          // Sessions before long break
          _buildSliderSetting(
            label: 'รอบก่อนพักยาว',
            value: _sessions,
            min: 2,
            max: 6,
            suffix: 'รอบ',
            color: Colors.amber,
            isDark: isDark,
            onChanged: (v) => setState(() => _sessions = v.round()),
          ),

          const SizedBox(height: 24),

          // Presets
          Text(
            'Presets',
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPresetChip('Classic', 25, 5, 15, 4, isDark),
              const SizedBox(width: 8),
              _buildPresetChip('Short', 15, 3, 10, 4, isDark),
              const SizedBox(width: 8),
              _buildPresetChip('Long', 50, 10, 20, 2, isDark),
            ],
          ),

          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(_study, _short, _long, _sessions);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'บันทึก',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSliderSetting({
    required String label,
    required int value,
    required int min,
    required int max,
    required String suffix,
    required Color color,
    required bool isDark,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$value $suffix',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withAlpha(30),
              thumbColor: color,
              overlayColor: color.withAlpha(30),
            ),
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(
    String label,
    int study,
    int shortB,
    int longB,
    int sessions,
    bool isDark,
  ) {
    final isSelected = _study == study &&
        _short == shortB &&
        _long == longB &&
        _sessions == sessions;

    return GestureDetector(
      onTap: () {
        setState(() {
          _study = study;
          _short = shortB;
          _long = longB;
          _sessions = sessions;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(30)
              : (isDark ? AppColors.background : AppColorsLight.background),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.border : AppColorsLight.border),
          ),
        ),
        child: Text(
          '$label ($study/$shortB)',
          style: TextStyle(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
