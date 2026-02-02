import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/constants.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const UnitOrgApp());
}

class UnitOrgApp extends StatelessWidget {
  const UnitOrgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'การจัดหน่วยทหาร',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,

        // Color scheme
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
        ),

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.prompt(
            fontSize: AppSizes.fontXL,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),

        // Text theme
        textTheme: GoogleFonts.promptTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.prompt(
            fontSize: AppSizes.fontDisplay,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          headlineLarge: GoogleFonts.prompt(
            fontSize: AppSizes.fontXXL,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          headlineMedium: GoogleFonts.prompt(
            fontSize: AppSizes.fontXL,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleLarge: GoogleFonts.prompt(
            fontSize: AppSizes.fontL,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleMedium: GoogleFonts.prompt(
            fontSize: AppSizes.fontM,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          bodyLarge: GoogleFonts.prompt(
            fontSize: AppSizes.fontL,
            color: AppColors.textSecondary,
          ),
          bodyMedium: GoogleFonts.prompt(
            fontSize: AppSizes.fontM,
            color: AppColors.textSecondary,
          ),
          labelSmall: GoogleFonts.prompt(
            fontSize: AppSizes.fontS,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),

        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL,
              vertical: AppSizes.paddingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            textStyle: GoogleFonts.prompt(
              fontSize: AppSizes.fontM,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: GoogleFonts.prompt(
              fontSize: AppSizes.fontM,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Icon button theme
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
          ),
        ),

        // Bottom sheet theme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
        ),

        // Divider theme
        dividerTheme: const DividerThemeData(
          color: AppColors.border,
          thickness: 1,
        ),

        // Progress indicator theme
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
          linearTrackColor: AppColors.surface,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
