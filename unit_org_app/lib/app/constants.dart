import 'package:flutter/material.dart';

/// App Colors - Bento Grid Apple Style (Light Mode)
class AppColors {
  // Base colors - Clean whites and soft grays
  static const Color background = Color(0xFFF5F5F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFAFAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardElevated = Color(0xFFFFFFFF);

  // Bento card background colors - Soft pastels
  static const Color bentoPeach = Color(0xFFFFF0E8);
  static const Color bentoMint = Color(0xFFE8F5F0);
  static const Color bentoLavender = Color(0xFFF0E8FF);
  static const Color bentoSky = Color(0xFFE8F4FF);
  static const Color bentoCream = Color(0xFFFFF8E8);
  static const Color bentoRose = Color(0xFFFFE8F0);

  // Primary colors - Vibrant accents
  static const Color primary = Color(0xFF007AFF);
  static const Color primaryLight = Color(0xFF5AC8FA);
  static const Color primaryDark = Color(0xFF0051D4);

  // Accent colors
  static const Color accent = Color(0xFF34C759);
  static const Color accentOrange = Color(0xFFFF9500);
  static const Color accentPink = Color(0xFFFF2D55);
  static const Color accentPurple = Color(0xFFAF52DE);
  static const Color accentTeal = Color(0xFF5AC8FA);
  static const Color accentIndigo = Color(0xFF5856D6);

  // Branch colors (เหล่า)
  static const Color signalCorps = Color(0xFFFF9500);
  static const Color signalCorpsLight = Color(0xFFFFAD33);
  static const Color signalCorpsDark = Color(0xFFE68600);

  static const Color infantry = Color(0xFF34C759);
  static const Color armor = Color(0xFF007AFF);
  static const Color artillery = Color(0xFFFF3B30);
  static const Color engineer = Color(0xFFAF52DE);
  static const Color quartermaster = Color(0xFF5856D6);

  // Rank colors
  static const Color officer = Color(0xFFFFD60A);
  static const Color officerLight = Color(0xFFFFE66D);
  static const Color nco = Color(0xFF8E8E93);
  static const Color ncoLight = Color(0xFFC7C7CC);
  static const Color enlisted = Color(0xFFDB8633);
  static const Color enlistedLight = Color(0xFFE5A55D);

  // Status colors
  static const Color success = Color(0xFF34C759);
  static const Color successLight = Color(0xFFE8F8ED);
  static const Color warning = Color(0xFFFF9500);
  static const Color warningLight = Color(0xFFFFF4E5);
  static const Color error = Color(0xFFFF3B30);
  static const Color errorLight = Color(0xFFFFE5E5);
  static const Color info = Color(0xFF007AFF);
  static const Color infoLight = Color(0xFFE5F1FF);

  // Text colors
  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF6E6E73);
  static const Color textMuted = Color(0xFF8E8E93);
  static const Color textDisabled = Color(0xFFC7C7CC);

  // Border colors
  static const Color border = Color(0xFFE5E5EA);
  static const Color borderLight = Color(0xFFF2F2F7);
  static const Color borderFocus = Color(0xFF007AFF);

  // Gradient presets - Apple style
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34C759), Color(0xFF30D158)],
  );

  static const LinearGradient signalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFAD33), Color(0xFFFF9500)],
  );

  static const LinearGradient sunriseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
  );

  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667EEA), Color(0xFF64B5F6)],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF512F), Color(0xFFFFAB40)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFAF52DE), Color(0xFF5856D6)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFE66D), Color(0xFFFFD60A)],
  );

  // Shadow presets - Soft Apple-style shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> coloredShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}

/// App Sizes
class AppSizes {
  // Padding
  static const double paddingXXS = 2.0;
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border radius - More rounded for Bento style
  static const double radiusXS = 8.0;
  static const double radiusS = 12.0;
  static const double radiusM = 16.0;
  static const double radiusL = 20.0;
  static const double radiusXL = 28.0;
  static const double radiusXXL = 36.0;
  static const double radiusFull = 100.0;

  // Icon sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // Font sizes
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

  // Bento grid sizes
  static const double bentoGap = 12.0;
  static const double bentoSmall = 140.0;
  static const double bentoMedium = 180.0;
  static const double bentoLarge = 220.0;

  // Component sizes
  static const double buttonHeight = 50.0;
  static const double buttonHeightS = 40.0;
  static const double buttonHeightL = 56.0;
  static const double inputHeight = 50.0;
  static const double cardMinHeight = 120.0;
  static const double bottomSheetMaxHeight = 0.85;
}

/// App Durations
class AppDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slower = Duration(milliseconds: 600);
  static const Duration cardFlip = Duration(milliseconds: 450);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration staggerDelay = Duration(milliseconds: 60);
}

/// App Curves
class AppCurves {
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.easeOutBack;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve sharpCurve = Curves.easeOutExpo;
  static const Curve springCurve = Curves.elasticOut;
}

/// App Text Styles - Apple SF Pro inspired
class AppTextStyles {
  // Display styles
  static const TextStyle displayHero = TextStyle(
    fontSize: AppSizes.fontHero,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.5,
    height: 1.1,
  );

  static const TextStyle displayLarge = TextStyle(
    fontSize: AppSizes.fontDisplay,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
    height: 1.15,
  );

  // Headlines
  static const TextStyle headlineLarge = TextStyle(
    fontSize: AppSizes.fontHeading,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: AppSizes.fontXXL,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: AppSizes.fontXL,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );

  // Titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: AppSizes.fontL,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
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
    letterSpacing: 0.3,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: AppSizes.fontS,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: AppSizes.fontXS,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.1,
    height: 1.4,
  );

  // Button text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: AppSizes.fontL,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.2,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: AppSizes.fontM,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: AppSizes.fontS,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.2,
  );

  // Code/Mono text
  static const TextStyle codeLarge = TextStyle(
    fontSize: AppSizes.fontL,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    fontFamily: 'monospace',
    height: 1.5,
  );

  static const TextStyle codeMedium = TextStyle(
    fontSize: AppSizes.fontM,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    fontFamily: 'monospace',
    height: 1.5,
  );
}

/// Bento Card Decoration
class BentoDecoration {
  static BoxDecoration card({
    Color? backgroundColor,
    double borderRadius = AppSizes.radiusL,
    bool hasShadow = true,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: hasShadow ? AppColors.softShadow : null,
    );
  }

  static BoxDecoration coloredCard({
    required Color backgroundColor,
    double borderRadius = AppSizes.radiusL,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: AppColors.softShadow,
    );
  }

  static BoxDecoration gradientCard({
    required Gradient gradient,
    double borderRadius = AppSizes.radiusL,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: AppColors.cardShadow,
    );
  }

  static BoxDecoration outlineCard({
    Color? borderColor,
    double borderRadius = AppSizes.radiusL,
  }) {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? AppColors.border,
        width: 1.5,
      ),
    );
  }
}

/// Glass Card Decoration (kept for compatibility)
class GlassDecoration {
  static BoxDecoration card({
    Color? borderColor,
    double borderRadius = AppSizes.radiusL,
    bool elevated = false,
  }) {
    return BentoDecoration.card(
      borderRadius: borderRadius,
      hasShadow: elevated,
    );
  }

  static BoxDecoration surface({
    Color? backgroundColor,
    double borderRadius = AppSizes.radiusL,
  }) {
    return BentoDecoration.card(
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    );
  }

  static BoxDecoration elevated({
    Color? backgroundColor,
    double borderRadius = AppSizes.radiusL,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
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
      boxShadow: AppColors.coloredShadow(glowColor),
    );
  }
}
