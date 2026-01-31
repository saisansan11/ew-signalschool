import 'package:flutter/material.dart';

/// App Colors - Modern Military Theme with Glassmorphism
class AppColors {
  // Base colors - Deep space dark with blue undertones
  static const Color background = Color(0xFF050810);
  static const Color surface = Color(0xFF0D1117);
  static const Color surfaceLight = Color(0xFF161B22);
  static const Color card = Color(0xFF0D1117);
  static const Color cardElevated = Color(0xFF161B22);

  // Glassmorphism colors
  static const Color glassSurface = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassHighlight = Color(0x0DFFFFFF);

  // Primary colors - Modern gradient blues
  static const Color primary = Color(0xFF58A6FF);
  static const Color primaryLight = Color(0xFF79B8FF);
  static const Color primaryDark = Color(0xFF388BFD);

  // Accent - Vibrant cyan
  static const Color accent = Color(0xFF00E5CC);
  static const Color accentLight = Color(0xFF39FFDC);
  static const Color accentDark = Color(0xFF00B5A3);

  // Branch colors (เหล่า) - Enhanced vibrancy
  static const Color signalCorps = Color(0xFFFF9500);    // สื่อสาร - ส้ม
  static const Color signalCorpsLight = Color(0xFFFFAD33);
  static const Color signalCorpsDark = Color(0xFFCC7700);

  static const Color infantry = Color(0xFF30D158);        // ราบ - เขียว
  static const Color armor = Color(0xFF0A84FF);           // ม้า - น้ำเงิน
  static const Color artillery = Color(0xFFFF453A);       // ปืนใหญ่ - แดง
  static const Color engineer = Color(0xFFBF5AF2);        // ช่าง - ม่วง
  static const Color quartermaster = Color(0xFF5E5CE6);   // พลาธิการ - น้ำเงินม่วง

  // Rank colors with gradients
  static const Color officer = Color(0xFFFFD60A);         // นายทหาร - ทอง
  static const Color officerLight = Color(0xFFFFE66D);
  static const Color nco = Color(0xFFC9D1D9);             // นายสิบ - เงิน
  static const Color ncoLight = Color(0xFFE6EDF3);
  static const Color enlisted = Color(0xFFDB8633);        // พลทหาร - ทองแดง
  static const Color enlistedLight = Color(0xFFE5A55D);

  // Status colors - Modern palette
  static const Color success = Color(0xFF3FB950);
  static const Color successLight = Color(0xFF56D364);
  static const Color warning = Color(0xFFD29922);
  static const Color warningLight = Color(0xFFE3B341);
  static const Color error = Color(0xFFF85149);
  static const Color errorLight = Color(0xFFFA7970);
  static const Color info = Color(0xFF58A6FF);
  static const Color infoLight = Color(0xFF79B8FF);

  // Text colors
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);
  static const Color textDisabled = Color(0xFF484F58);

  // Border colors
  static const Color border = Color(0xFF21262D);
  static const Color borderLight = Color(0xFF30363D);
  static const Color borderFocus = Color(0xFF58A6FF);

  // Gradient presets
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentLight, accent],
  );

  static const LinearGradient signalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [signalCorpsLight, signalCorps],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [officerLight, officer],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassSurface, glassHighlight],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surfaceLight, background],
  );

  // Radial glow effects
  static List<BoxShadow> glowShadow(Color color, {double blur = 20, double spread = 0}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.4),
        blurRadius: blur,
        spreadRadius: spread,
      ),
    ];
  }

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}

/// App Sizes - Modern spacing system
class AppSizes {
  // Padding - 4px base scale
  static const double paddingXXS = 2.0;
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border radius - Modern rounded corners
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  static const double radiusFull = 100.0;

  // Icon sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // Font sizes - Type scale
  static const double fontXXS = 10.0;
  static const double fontXS = 11.0;
  static const double fontS = 12.0;
  static const double fontM = 14.0;
  static const double fontL = 16.0;
  static const double fontXL = 18.0;
  static const double fontXXL = 20.0;
  static const double fontHeading = 24.0;
  static const double fontDisplay = 32.0;
  static const double fontHero = 40.0;

  // Component sizes
  static const double buttonHeight = 48.0;
  static const double buttonHeightS = 36.0;
  static const double buttonHeightL = 56.0;
  static const double inputHeight = 48.0;
  static const double cardMinHeight = 120.0;
  static const double bottomSheetMaxHeight = 0.85;
}

/// App Durations - Animation timing
class AppDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slower = Duration(milliseconds: 600);
  static const Duration cardFlip = Duration(milliseconds: 450);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration staggerDelay = Duration(milliseconds: 50);
}

/// App Curves - Animation curves
class AppCurves {
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.easeOutBack;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve sharpCurve = Curves.easeOutExpo;
  static const Curve springCurve = Curves.elasticOut;
}

/// App Text Styles - Modern typography
class AppTextStyles {
  // Display styles - Hero text
  static const TextStyle displayHero = TextStyle(
    fontSize: AppSizes.fontHero,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
    height: 1.1,
  );

  static const TextStyle displayLarge = TextStyle(
    fontSize: AppSizes.fontDisplay,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // Headlines
  static const TextStyle headlineLarge = TextStyle(
    fontSize: AppSizes.fontHeading,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: AppSizes.fontXXL,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: AppSizes.fontXL,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // Titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: AppSizes.fontL,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: AppSizes.fontM,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: AppSizes.fontS,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: AppSizes.fontL,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: AppSizes.fontM,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: AppSizes.fontS,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: AppSizes.fontM,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: AppSizes.fontS,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.4,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: AppSizes.fontXS,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.3,
    height: 1.4,
  );

  // Button text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: AppSizes.fontL,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.2,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: AppSizes.fontM,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: AppSizes.fontS,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.2,
  );

  // Code/Mono text
  static const TextStyle codeLarge = TextStyle(
    fontSize: AppSizes.fontL,
    fontWeight: FontWeight.w400,
    color: AppColors.accent,
    fontFamily: 'monospace',
    height: 1.5,
  );

  static const TextStyle codeMedium = TextStyle(
    fontSize: AppSizes.fontM,
    fontWeight: FontWeight.w400,
    color: AppColors.accent,
    fontFamily: 'monospace',
    height: 1.5,
  );
}

/// Glass Card Decoration
class GlassDecoration {
  static BoxDecoration card({
    Color? borderColor,
    double borderRadius = AppSizes.radiusL,
    bool elevated = false,
  }) {
    return BoxDecoration(
      color: AppColors.glassSurface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? AppColors.glassBorder,
        width: 1,
      ),
      boxShadow: elevated ? AppColors.softShadow : null,
    );
  }

  static BoxDecoration surface({
    Color? backgroundColor,
    double borderRadius = AppSizes.radiusL,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppColors.border,
        width: 1,
      ),
    );
  }

  static BoxDecoration elevated({
    Color? backgroundColor,
    double borderRadius = AppSizes.radiusL,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.cardElevated,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppColors.borderLight,
        width: 1,
      ),
      boxShadow: AppColors.elevatedShadow,
    );
  }

  static BoxDecoration glowCard({
    required Color glowColor,
    double borderRadius = AppSizes.radiusL,
  }) {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: glowColor.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: glowColor.withValues(alpha: 0.2),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ],
    );
  }
}
