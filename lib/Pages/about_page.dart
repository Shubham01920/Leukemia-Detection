import 'package:flutter/material.dart';
import 'dart:ui';
import 'information_box.dart';
import '../theme/app_colors.dart';
import '../widgets/app_text.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const AppText(
          'About',
          bold: true,
          fontSize: 20,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About section with gradient card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: AppGradients.appBarGradient,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'About Leukemia Detection',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1))
                .then()
                .shimmer(delay: 400.ms, duration: 1800.ms),

            const SizedBox(height: 24.0),

            // Mission Section
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.lightPurple.withAlpha(100),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Our Mission',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 300.ms)
                          .slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 8.0),
                      const Text(
                        'To provide accessible and accurate leukemia detection tools using advanced AI technology, helping medical professionals diagnose and treat patients more effectively.',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      )
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 400.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

            const SizedBox(height: 24.0),

            // How It Works Section
            const Text(
              'How It Works',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 700.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 16.0),

            // Information boxes with how it works
            InfoBoxList(
              items: [
                InfoBoxItem(
                  icon: Icons.image,
                  title: "Upload",
                  description:
                      "Upload a blood sample image through our secure platform.",
                ),
                InfoBoxItem(
                  icon: Icons.analytics,
                  title: "Analyze",
                  description:
                      "Our AI algorithms analyze the blood cells for leukemia indicators.",
                ),
                InfoBoxItem(
                  icon: Icons.description,
                  title: "Results",
                  description:
                      "Receive detailed results and potential next steps for diagnosis.",
                ),
              ],
            ).animate().fadeIn(duration: 800.ms, delay: 900.ms).slide(
                begin: const Offset(0, 0.3),
                end: const Offset(0, 0),
                duration: 900.ms),

            const SizedBox(height: 24.0),

            // Contact Section
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.lightPurple.withAlpha(100),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 12.0),
                      ListTile(
                        leading: Icon(Icons.email, color: AppColors.lightBlue),
                        title: const Text('Email',
                            style: TextStyle(color: Colors.white)),
                        subtitle: const Text('support@leukemiadetection.com',
                            style: TextStyle(color: Colors.white70)),
                        onTap: () {
                          // Handle email tap
                        },
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideX(begin: 0.2, end: 0),
                      ListTile(
                        leading: Icon(Icons.phone, color: AppColors.lightBlue),
                        title: const Text('Phone',
                            style: TextStyle(color: Colors.white)),
                        subtitle: const Text('+1 (555) 123-4567',
                            style: TextStyle(color: Colors.white70)),
                        onTap: () {
                          // Handle phone tap
                        },
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 400.ms)
                          .slideX(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 1200.ms).scale(
                begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
          ],
        ),
      ),
    );
  }
}
