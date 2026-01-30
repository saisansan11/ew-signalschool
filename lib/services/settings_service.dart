import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'progress_service.dart';
import 'auth_service.dart';

/// Service for managing app settings
class SettingsService {
  static const String _notificationsKey = 'settings_notifications';
  static const String _soundKey = 'settings_sound';
  static const String _vibrationKey = 'settings_vibration';
  static const String _darkModeKey = 'settings_dark_mode';
  static const String _fontSizeKey = 'settings_font_size';

  static SharedPreferences? _prefs;

  // Callbacks for notifying changes
  static Function(bool)? onDarkModeChanged;
  static Function(String)? onFontSizeChanged;

  /// Initialize the service
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==========================================
  // NOTIFICATIONS
  // ==========================================

  static Future<void> setNotificationsEnabled(bool enabled) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_notificationsKey, enabled);
  }

  static bool getNotificationsEnabled() {
    return _prefs?.getBool(_notificationsKey) ?? true;
  }

  // ==========================================
  // SOUND
  // ==========================================

  static Future<void> setSoundEnabled(bool enabled) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_soundKey, enabled);
  }

  static bool getSoundEnabled() {
    return _prefs?.getBool(_soundKey) ?? true;
  }

  // ==========================================
  // VIBRATION
  // ==========================================

  static Future<void> setVibrationEnabled(bool enabled) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_vibrationKey, enabled);
  }

  static bool getVibrationEnabled() {
    return _prefs?.getBool(_vibrationKey) ?? true;
  }

  // ==========================================
  // DARK MODE
  // ==========================================

  static Future<void> setDarkMode(bool enabled) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_darkModeKey, enabled);
    onDarkModeChanged?.call(enabled);
  }

  static bool getDarkMode() {
    return _prefs?.getBool(_darkModeKey) ?? true; // Default to dark mode
  }

  // ==========================================
  // FONT SIZE
  // ==========================================

  /// Font size options: 'small', 'normal', 'large', 'xlarge'
  static Future<void> setFontSize(String size) async {
    if (_prefs == null) await init();
    await _prefs!.setString(_fontSizeKey, size);
    onFontSizeChanged?.call(size);
  }

  static String getFontSize() {
    return _prefs?.getString(_fontSizeKey) ?? 'normal';
  }

  /// Get font scale factor
  static double getFontScale() {
    switch (getFontSize()) {
      case 'small':
        return 0.85;
      case 'normal':
        return 1.0;
      case 'large':
        return 1.15;
      case 'xlarge':
        return 1.3;
      default:
        return 1.0;
    }
  }

  /// Get Thai label for font size
  static String getFontSizeLabel(String size) {
    switch (size) {
      case 'small':
        return 'เล็ก';
      case 'normal':
        return 'ปกติ';
      case 'large':
        return 'ใหญ่';
      case 'xlarge':
        return 'ใหญ่มาก';
      default:
        return 'ปกติ';
    }
  }

  // ==========================================
  // EXPORT DATA
  // ==========================================

  /// Export all user data as JSON string
  static Future<String> exportUserData() async {
    if (_prefs == null) await init();

    final user = AuthService.getCurrentUser();
    final progressStats = ProgressService.getLearningStats();
    final quizScores = ProgressService.getQuizScores();
    final completedLessons = ProgressService.getCompletedLessons();
    final loginHistory = AuthService.getLoginHistory();

    final exportData = {
      'exportDate': DateTime.now().toIso8601String(),
      'appVersion': '2.0.0',
      'user': user?.toJson(),
      'settings': {
        'notifications': getNotificationsEnabled(),
        'sound': getSoundEnabled(),
        'vibration': getVibrationEnabled(),
        'darkMode': getDarkMode(),
        'fontSize': getFontSize(),
        'biometric': AuthService.useBiometric(),
      },
      'progress': {
        'stats': progressStats,
        'completedLessons': completedLessons,
        'quizScores': quizScores.map((key, value) => MapEntry(key, {
          'score': value['score'],
          'total': value['total'],
          'percent': value['percent'],
        })),
      },
      'loginHistory': loginHistory,
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  /// Get data summary for display
  static Map<String, dynamic> getDataSummary() {
    final stats = ProgressService.getLearningStats();
    final user = AuthService.getCurrentUser();

    return {
      'userName': user?.fullName ?? 'ไม่ระบุ',
      'lessonsCompleted': stats['lessonsCompleted'] ?? 0,
      'quizzesCompleted': stats['quizzesCompleted'] ?? 0,
      'totalXp': stats['totalXp'] ?? 0,
      'level': stats['level'] ?? 1,
      'studyTimeMinutes': stats['totalStudyTime'] ?? 0,
      'loginDays': stats['totalLoginDays'] ?? 1,
    };
  }

  // ==========================================
  // RESET SETTINGS
  // ==========================================

  static Future<void> resetSettings() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_notificationsKey);
    await _prefs!.remove(_soundKey);
    await _prefs!.remove(_vibrationKey);
    await _prefs!.remove(_darkModeKey);
    await _prefs!.remove(_fontSizeKey);
  }
}
