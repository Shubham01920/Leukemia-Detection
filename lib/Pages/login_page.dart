import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../widgets/app_text.dart';
import '../Navigator/navigator_page.dart';

// Custom painter for circular reveal animation
class CircleRevealPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final Color color;

  CircleRevealPainter({
    required this.center,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CircleRevealPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.center != center ||
        oldDelegate.color != color;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Simulate login process
    setState(() {
      _isLoading = true;
    });

    // Simulate API call with delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Create spectacular transition animation with hero effect
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 2000),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const NavigatorPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Multiple animation effects combined for maximum visual impact
            return Stack(
              children: [
                // Expanding circle from login button position
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: CircleRevealPainter(
                          center: Offset(
                            MediaQuery.of(context).size.width / 2,
                            MediaQuery.of(context).size.height * 0.6,
                          ),
                          radius: animation.value *
                              MediaQuery.of(context).size.height *
                              1.5,
                          color: AppColors.primary.withAlpha(150),
                        ),
                      );
                    },
                  ),
                ),

                // Staggered transitions for content
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                  ),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0.4, 1.0,
                            curve: Curves.easeOutQuint),
                      ),
                    ),
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: const Interval(0.4, 1.0,
                              curve: Curves.easeOutBack),
                        ),
                      ),
                      child: child,
                    ),
                  ),
                ),

                // Particle effects
                ...List.generate(40, (index) {
                  final random = index / 40;
                  final size = 4.0 + (random * 8.0);
                  final delay = random * 0.5;

                  return Positioned(
                    left: random * MediaQuery.of(context).size.width,
                    top: MediaQuery.of(context).size.height *
                        (0.4 + random * 0.6),
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (context, _) {
                        final animationValue = animation.value;
                        if (animationValue < delay) {
                          return const SizedBox();
                        }

                        final particleAnimation =
                            (animationValue - delay) / (1 - delay);
                        final translateY = -300.0 * particleAnimation;
                        final opacity = (1 - particleAnimation);

                        return Transform.translate(
                          offset: Offset(0, translateY),
                          child: Opacity(
                            opacity: opacity > 0 ? opacity : 0,
                            child: Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                color: random > 0.5
                                    ? AppColors.lightBlue.withAlpha(204)
                                    : AppColors.lightPurple.withAlpha(204),
                                shape: random > 0.7
                                    ? BoxShape.rectangle
                                    : BoxShape.circle,
                                borderRadius: random > 0.7
                                    ? BorderRadius.circular(2)
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.mainBackground,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App logo/icon
                  const Icon(
                    Icons.medical_services_rounded,
                    size: 80,
                    color: Colors.white,
                  )
                      .animate(
                          onPlay: (controller) => controller.repeat(
                              reverse: true,
                              period: const Duration(seconds: 10)))
                      .fadeIn(duration: 800.ms)
                      .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          duration: 1200.ms)
                      .then(delay: 400.ms)
                      .shimmer(duration: 2000.ms)
                      .then(delay: 2000.ms)
                      .animate(
                          onPlay: (controller) => controller.repeat(
                              period: const Duration(seconds: 5)))
                      .scaleXY(
                          begin: 1,
                          end: 1.1,
                          duration: 2500.ms,
                          curve: Curves.easeInOutSine)
                      .tint(
                          color: AppColors.lightBlue.withAlpha(100),
                          duration: 2500.ms,
                          curve: Curves.easeInOutSine),

                  const SizedBox(height: 16),

                  // App name
                  AppText.header(
                    'Leukemia Detection',
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 300.ms)
                      .slideY(
                          begin: -0.2,
                          end: 0,
                          curve: Curves.easeOutQuad,
                          duration: 800.ms)
                      .then(delay: 200.ms)
                      .shimmer(duration: 1200.ms),

                  const SizedBox(height: 8),

                  // Tagline
                  AppText(
                    'Advanced AI diagnostics for healthcare professionals',
                    textAlign: TextAlign.center,
                    color: Colors.white70,
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 500.ms)
                      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

                  const SizedBox(height: 50),

                  // Login form container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.lightPurple.withAlpha(100),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Login header
                            AppText.subheader(
                              'Login',
                              color: Colors.white,
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 800.ms)
                                .slideX(begin: -0.2, end: 0),

                            const SizedBox(height: 24),

                            // Email field
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                                prefixIcon: const Icon(Icons.email_outlined,
                                    color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.white.withAlpha(100)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.lightBlue),
                                ),
                                filled: true,
                                fillColor: Colors.white.withAlpha(20),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 1000.ms)
                                .slideX(begin: 0.2, end: 0),
                            const SizedBox(height: 16),

                            // Password field
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: Colors.white70),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.white.withAlpha(100)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.lightBlue),
                                ),
                                filled: true,
                                fillColor: Colors.white.withAlpha(20),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 1200.ms)
                                .slideX(begin: 0.2, end: 0),

                            const SizedBox(height: 8),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Handle forgot password
                                },
                                child: AppText(
                                  'Forgot Password?',
                                  color: AppColors.lightBlue,
                                  fontSize: 14,
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 1400.ms),

                            const SizedBox(height: 24),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        // Create a more interactive bounce effect on click
                                        setState(() {
                                          _isLoading = true;
                                        });

                                        // Add a small delay for better visual feedback
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          _handleLogin();
                                        });
                                      },
                                icon: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.login_rounded,
                                        color: AppColors.primary,
                                      ),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText.button(
                                      'Login',
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 1600.ms)
                                .slideY(begin: 0.2, end: 0)
                                .then(delay: 200.ms)
                                .shimmer(duration: 1200.ms)
                                // Add enhanced bounce effect on hover/focus
                                .animate(
                                  onPlay: (controller) => controller.repeat(
                                      reverse: true,
                                      period:
                                          const Duration(milliseconds: 2000)),
                                  target: _isLoading ? 0.0 : 1.0,
                                )
                                .scaleXY(
                                  begin: 1.0,
                                  end: 1.05,
                                  curve: Curves.elasticInOut,
                                ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms, delay: 600.ms).scale(
                      begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),

                  const SizedBox(height: 20),

                  // Registration option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        "Don't have an account? ",
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      TextButton(
                        onPressed: () {
                          // Show registration dialog with bounce animation
                          showDialog(
                            context: context,
                            builder: (context) => _buildRegisterDialog(context),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.lightBlue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const AppText(
                          'Register',
                          color: AppColors.lightBlue,
                          bold: true,
                          fontSize: 14,
                        ),
                      )
                          .animate(
                            onPlay: (controller) => controller.repeat(
                                reverse: true,
                                period: const Duration(milliseconds: 2500)),
                          )
                          .shimmer(
                            duration: 1800.ms,
                            color: Colors.white.withAlpha(100),
                          ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 1800.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Registration dialog with animation
  Widget _buildRegisterDialog(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.lightPurple.withAlpha(100),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Registration header
                  AppText.header(
                    'Create Account',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  AppText(
                    'Registration will be available in the full version of the app.',
                    textAlign: TextAlign.center,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 30),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.primary,
                      ),
                      label: AppText.button(
                        'Back to Login',
                        color: AppColors.primary,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: 600.ms,
          curve: Curves.elasticOut,
        );
  }
}
