import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/app_text.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // Navigate to login page after animation delay
    Timer(const Duration(seconds: 3), () {
      _navigateToLogin();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Stack(
            children: [
              // Fade out splash screen
              FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppGradients.mainBackground,
                  ),
                  child: _buildSplashContent(),
                ),
              ),

              // Fade in login page
              FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
                  ),
                ),
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    final exit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Exit Application?'),
            content:
                const Text('Are you sure you want to exit the application?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ).animate().scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 300.ms,
                curve: Curves.elasticOut,
              ),
        ) ??
        false;

    if (exit) {
      SystemNavigator.pop();
    }
    return false;
  }

  Widget _buildSplashContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated logo
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(128),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ).animate().scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 800.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 40),

          // App name with staggered text animation
          AppText.header(
            'Leukemia Detection',
            textAlign: TextAlign.center,
            color: Colors.white,
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 400.ms)
              .slideY(begin: 0.5, end: 0, curve: Curves.easeOutQuad)
              .then(delay: 200.ms)
              .shimmer(duration: 1200.ms),

          const SizedBox(height: 12),

          // Tagline with staggered appearance
          AppText(
            'Advanced AI diagnostics for healthcare professionals',
            textAlign: TextAlign.center,
            color: Colors.white.withAlpha(204),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 600.ms)
              .slideY(begin: 0.5, end: 0, curve: Curves.easeOutQuad),

          const SizedBox(height: 60),

          // Loading indicator
          CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
            backgroundColor: AppColors.lightPurple.withAlpha(77),
          ).animate().fadeIn(duration: 600.ms, delay: 800.ms).scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          _onWillPop();
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.mainBackground,
            ),
            child: _buildSplashContent(),
          ),
        ),
      ),
    );
  }
}
