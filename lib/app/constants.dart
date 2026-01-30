import 'package:flutter/material.dart';

// ==========================================
// APP CONSTANTS - RTA EW SIMULATOR
// ==========================================

// ==========================================
// DARK THEME COLORS (Default)
// ==========================================
class AppColors {
  // Primary Colors (Military Dark Theme)
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceLight = Color(0xFF21262D);
  static const Color border = Color(0xFF30363D);

  // Accent Colors
  static const Color primary = Color(0xFF58A6FF);      // Blue highlight
  static const Color secondary = Color(0xFF1F6FEB);    // Darker blue
  static const Color accent = Color(0xFF00FFD1);       // Cyan/Teal

  // Status Colors
  static const Color success = Color(0xFF3FB950);      // Green
  static const Color warning = Color(0xFFD29922);      // Orange
  static const Color danger = Color(0xFFF85149);       // Red
  static const Color info = Color(0xFF58A6FF);         // Blue

  // Text Colors
  static const Color textPrimary = Color(0xFFC9D1D9);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);

  // Special Colors
  static const Color radar = Color(0xFF00FF88);        // Radar green
  static const Color radarGlow = Color(0x4000FF88);    // Radar glow (semi-transparent)
  static const Color military = Color(0xFF4A5D23);     // Military green

  // Tab Colors
  static const Color tabHome = Color(0xFF58A6FF);
  static const Color tabLearning = Color(0xFFA371F7);
  static const Color tabTools = Color(0xFF3FB950);
  static const Color tabField = Color(0xFFF85149);
  static const Color tabProfile = Color(0xFFD29922);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1F6FEB), Color(0xFF58A6FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient radarGradient = LinearGradient(
    colors: [Color(0xFF00FF88), Color(0xFF00FFD1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFF85149), Color(0xFFFF7B72)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ==========================================
// LIGHT THEME COLORS
// ==========================================
class AppColorsLight {
  // Primary Colors (Military Light Theme)
  static const Color background = Color(0xFFF6F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF0F3F6);
  static const Color border = Color(0xFFD0D7DE);

  // Accent Colors (Same but adjusted for light)
  static const Color primary = Color(0xFF0969DA);      // Blue highlight
  static const Color secondary = Color(0xFF1F6FEB);    // Darker blue
  static const Color accent = Color(0xFF00A896);       // Cyan/Teal

  // Status Colors
  static const Color success = Color(0xFF1A7F37);      // Green
  static const Color warning = Color(0xFF9A6700);      // Orange
  static const Color danger = Color(0xFFCF222E);       // Red
  static const Color info = Color(0xFF0969DA);         // Blue

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2328);
  static const Color textSecondary = Color(0xFF57606A);
  static const Color textMuted = Color(0xFF8C959F);

  // Special Colors
  static const Color radar = Color(0xFF00875A);        // Radar green
  static const Color radarGlow = Color(0x4000875A);    // Radar glow
  static const Color military = Color(0xFF4A5D23);     // Military green

  // Tab Colors
  static const Color tabHome = Color(0xFF0969DA);
  static const Color tabLearning = Color(0xFF8250DF);
  static const Color tabTools = Color(0xFF1A7F37);
  static const Color tabField = Color(0xFFCF222E);
  static const Color tabProfile = Color(0xFF9A6700);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0969DA), Color(0xFF54AEFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient radarGradient = LinearGradient(
    colors: [Color(0xFF00875A), Color(0xFF00A896)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFCF222E), Color(0xFFFF8182)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppStrings {
  static const String appName = 'RTA EW SIM';
  static const String appFullName = 'RTA EW Simulator';
  static const String appTagline = 'Electronic Warfare Training System';
  static const String version = 'v2.0.0';

  // Tab Names
  static const String tabHome = 'หน้าหลัก';
  static const String tabLearning = 'คลังความรู้';
  static const String tabTools = 'เครื่องมือ';
  static const String tabField = 'ภาคสนาม';
  static const String tabProfile = 'โปรไฟล์';

  // Splash Screen
  static const String splashLoading = 'กำลังโหลด...';
  static const String splashInitializing = 'กำลังเตรียมระบบ...';
}

class AppDurations {
  static const Duration splashDuration = Duration(milliseconds: 3000);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration radarSweep = Duration(milliseconds: 2000);
}

class AppSizes {
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  static const double bottomNavHeight = 70.0;
}

// App Theme - Dark (Default)
ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: AppColors.textMuted,
        fontSize: 12,
      ),
    ),
  );
}

// App Theme - Light
ThemeData appThemeLight() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorsLight.background,
    primaryColor: AppColorsLight.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColorsLight.primary,
      secondary: AppColorsLight.secondary,
      surface: AppColorsLight.surface,
      error: AppColorsLight.danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsLight.surface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColorsLight.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColorsLight.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColorsLight.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        side: const BorderSide(color: AppColorsLight.border),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColorsLight.surface,
      selectedItemColor: AppColorsLight.primary,
      unselectedItemColor: AppColorsLight.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColorsLight.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColorsLight.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColorsLight.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: AppColorsLight.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppColorsLight.textPrimary,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColorsLight.textSecondary,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: AppColorsLight.textMuted,
        fontSize: 12,
      ),
    ),
  );
}
