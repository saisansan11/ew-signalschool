import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/splash/splash_screen.dart';
import 'services/progress_service.dart';
import 'services/auth_service.dart';
import 'services/theme_provider.dart';
import 'services/bookmark_service.dart';
import 'services/notes_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await ProgressService.init();
  await AuthService.init();
  await themeProvider.init();
  await bookmarkService.init();
  await notesService.init();

  // Update login streak
  await ProgressService.updateLoginStreak();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

// ==========================================
// 2. MAIN APP & MENU
// ==========================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'RTA EW Simulator',
          theme: themeProvider.theme,
          home: const SplashScreen(),
        );
      },
    );
  }
}
