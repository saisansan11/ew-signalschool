import 'package:flutter/material.dart';
import '../app/constants.dart';
import '../services/progress_service.dart';

/// A widget that shows streak-related notifications and reminders
/// to encourage consistent daily learning.
class StreakNotificationWidget extends StatefulWidget {
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;

  const StreakNotificationWidget({
    super.key,
    this.onDismiss,
    this.onAction,
  });

  @override
  State<StreakNotificationWidget> createState() => _StreakNotificationWidgetState();
}

class _StreakNotificationWidgetState extends State<StreakNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      setState(() => _isVisible = false);
      widget.onDismiss?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    final stats = ProgressService.getLearningStats();
    final streak = stats['currentStreak'] ?? 0;
    final notification = _getNotification(streak);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: notification.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: notification.colors.first.withAlpha(60),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onAction,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icon/Emoji
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              notification.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                notification.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notification.message,
                                style: TextStyle(
                                  color: Colors.white.withAlpha(220),
                                  fontSize: 13,
                                ),
                              ),
                              if (streak > 0) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$streak วัน streak',
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Dismiss button
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: _dismiss,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _StreakNotification _getNotification(int streak) {
    final hour = DateTime.now().hour;

    // Check if streak is about to be lost (late in the day and no activity)
    if (hour >= 20 && streak > 0) {
      return _StreakNotification(
        emoji: '⚠️',
        title: 'อย่าให้ Streak หาย!',
        message: 'ทำกิจกรรมอย่างน้อย 1 อย่างก่อนเที่ยงคืน',
        colors: [Colors.orange, Colors.deepOrange],
      );
    }

    // Celebrate streak milestones
    if (streak >= 30) {
      return _StreakNotification(
        emoji: '🏆',
        title: 'EW Master!',
        message: 'เยี่ยมมาก! Streak $streak วัน คุณคือผู้เชี่ยวชาญ',
        colors: [Colors.amber, Colors.orange],
      );
    } else if (streak >= 14) {
      return _StreakNotification(
        emoji: '🌟',
        title: 'Dedicated Learner!',
        message: 'ยอดเยี่ยม! เรียนต่อเนื่อง $streak วันแล้ว',
        colors: [Colors.purple, Colors.deepPurple],
      );
    } else if (streak >= 7) {
      return _StreakNotification(
        emoji: '🔥',
        title: 'Week Warrior!',
        message: 'สุดยอด! เรียนครบ 1 สัปดาห์แล้ว',
        colors: [Colors.red, Colors.deepOrange],
      );
    } else if (streak >= 3) {
      return _StreakNotification(
        emoji: '💪',
        title: 'ดีมาก!',
        message: 'เรียนต่อเนื่อง $streak วัน เก่งมาก!',
        colors: [Colors.green, Colors.teal],
      );
    } else if (streak > 0) {
      return _StreakNotification(
        emoji: '👍',
        title: 'เริ่มต้นดี!',
        message: 'เรียนต่อทุกวันเพื่อสะสม Streak',
        colors: [Colors.blue, Colors.indigo],
      );
    } else {
      // Greeting based on time of day
      if (hour < 12) {
        return _StreakNotification(
          emoji: '☀️',
          title: 'สวัสดีตอนเช้า!',
          message: 'เริ่มต้นวันใหม่ด้วยการเรียน EW',
          colors: [AppColors.primary, Colors.blue],
        );
      } else if (hour < 18) {
        return _StreakNotification(
          emoji: '📚',
          title: 'สวัสดีตอนบ่าย!',
          message: 'มาเรียนรู้สิ่งใหม่กันเถอะ',
          colors: [Colors.teal, Colors.cyan],
        );
      } else {
        return _StreakNotification(
          emoji: '🌙',
          title: 'สวัสดีตอนเย็น!',
          message: 'ทบทวนความรู้ก่อนนอนกันเถอะ',
          colors: [Colors.indigo, Colors.purple],
        );
      }
    }
  }
}

class _StreakNotification {
  final String emoji;
  final String title;
  final String message;
  final List<Color> colors;

  _StreakNotification({
    required this.emoji,
    required this.title,
    required this.message,
    required this.colors,
  });
}

/// A compact streak indicator that can be shown in app bars or headers
class StreakIndicator extends StatelessWidget {
  final bool showLabel;

  const StreakIndicator({super.key, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    final stats = ProgressService.getLearningStats();
    final streak = stats['currentStreak'] ?? 0;

    if (streak == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.red.shade400],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            showLabel ? '$streak วัน' : '$streak',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// A daily reminder card widget
class DailyReminderCard extends StatelessWidget {
  final VoidCallback? onStartLearning;

  const DailyReminderCard({super.key, this.onStartLearning});

  @override
  Widget build(BuildContext context) {
    final stats = ProgressService.getLearningStats();
    final streak = stats['currentStreak'] ?? 0;
    final todayMinutes = stats['todayStudyTime'] ?? 0;
    final hasStudiedToday = todayMinutes > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasStudiedToday ? AppColors.success : AppColors.warning,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (hasStudiedToday ? AppColors.success : AppColors.warning)
                      .withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  hasStudiedToday ? Icons.check_circle : Icons.schedule,
                  color: hasStudiedToday ? AppColors.success : AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasStudiedToday ? 'เรียนวันนี้แล้ว!' : 'ยังไม่ได้เรียนวันนี้',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      hasStudiedToday
                          ? 'เรียนไปแล้ว $todayMinutes นาที'
                          : 'เรียนเพื่อรักษา Streak $streak วัน',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (streak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$streak',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (!hasStudiedToday) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStartLearning,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('เริ่มเรียนเลย'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
