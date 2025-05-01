import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'Pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize fonts with timeout
    await AppTheme.init().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint('Font initialization timed out');
      },
    );
  } catch (e) {
    debugPrint('Error during initialization: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leukemia Detection',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.mainTheme,
      home: BackButtonHandler(child: const SplashScreen()),
    );
  }
}

// Custom back button handler to avoid deprecated API issues
class BackButtonHandler extends StatelessWidget {
  final Widget child;

  const BackButtonHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      // Handle back button press with a simpler approach
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }
}
