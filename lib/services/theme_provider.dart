import 'package:flutter/material.dart';
import '../app/constants.dart';
import 'settings_service.dart';

/// Theme provider to manage app theme state
class ThemeProvider extends ChangeNotifier {
  static final ThemeProvider _instance = ThemeProvider._internal();
  factory ThemeProvider() => _instance;
  ThemeProvider._internal();

  bool _isDarkMode = true;
  double _fontScale = 1.0;

  bool get isDarkMode => _isDarkMode;
  double get fontScale => _fontScale;

  ThemeData get theme => _isDarkMode ? appTheme() : appThemeLight();

  /// Initialize theme from saved settings
  Future<void> init() async {
    await SettingsService.init();
    _isDarkMode = SettingsService.getDarkMode();
    _fontScale = SettingsService.getFontScale();

    // Register callbacks for settings changes
    SettingsService.onDarkModeChanged = (isDark) {
      setDarkMode(isDark);
    };
    SettingsService.onFontSizeChanged = (size) {
      setFontScale(SettingsService.getFontScale());
    };
  }

  /// Set dark mode
  void setDarkMode(bool isDark) {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      notifyListeners();
    }
  }

  /// Toggle dark mode
  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await SettingsService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  /// Set font scale
  void setFontScale(double scale) {
    if (_fontScale != scale) {
      _fontScale = scale;
      notifyListeners();
    }
  }

  // ==========================================
  // DYNAMIC COLOR GETTERS
  // ==========================================

  Color get background => _isDarkMode ? AppColors.background : AppColorsLight.background;
  Color get surface => _isDarkMode ? AppColors.surface : AppColorsLight.surface;
  Color get surfaceLight => _isDarkMode ? AppColors.surfaceLight : AppColorsLight.surfaceLight;
  Color get border => _isDarkMode ? AppColors.border : AppColorsLight.border;

  Color get primary => _isDarkMode ? AppColors.primary : AppColorsLight.primary;
  Color get secondary => _isDarkMode ? AppColors.secondary : AppColorsLight.secondary;
  Color get accent => _isDarkMode ? AppColors.accent : AppColorsLight.accent;

  Color get success => _isDarkMode ? AppColors.success : AppColorsLight.success;
  Color get warning => _isDarkMode ? AppColors.warning : AppColorsLight.warning;
  Color get danger => _isDarkMode ? AppColors.danger : AppColorsLight.danger;
  Color get info => _isDarkMode ? AppColors.info : AppColorsLight.info;

  Color get textPrimary => _isDarkMode ? AppColors.textPrimary : AppColorsLight.textPrimary;
  Color get textSecondary => _isDarkMode ? AppColors.textSecondary : AppColorsLight.textSecondary;
  Color get textMuted => _isDarkMode ? AppColors.textMuted : AppColorsLight.textMuted;

  Color get radar => _isDarkMode ? AppColors.radar : AppColorsLight.radar;
  Color get radarGlow => _isDarkMode ? AppColors.radarGlow : AppColorsLight.radarGlow;
  Color get military => _isDarkMode ? AppColors.military : AppColorsLight.military;

  Color get tabHome => _isDarkMode ? AppColors.tabHome : AppColorsLight.tabHome;
  Color get tabLearning => _isDarkMode ? AppColors.tabLearning : AppColorsLight.tabLearning;
  Color get tabTools => _isDarkMode ? AppColors.tabTools : AppColorsLight.tabTools;
  Color get tabField => _isDarkMode ? AppColors.tabField : AppColorsLight.tabField;
  Color get tabProfile => _isDarkMode ? AppColors.tabProfile : AppColorsLight.tabProfile;
}

/// Global theme provider instance
final themeProvider = ThemeProvider();
