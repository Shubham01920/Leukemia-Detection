import 'package:flutter/material.dart';
import 'information_box.dart';
import '../theme/app_colors.dart';
import '../widgets/app_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'detection_page_wrapper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const AppText(
          'Leukemia Detection',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card with gradient
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: AppGradients.appBarGradient,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Leukemia Detection',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Revolutionizing medical diagnostics with advanced AI',
                      style: TextStyle(
                        fontSize: 14.0,
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

            // Title for information section
            const Padding(
              padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
              child: Text(
                'Important Information',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 500.ms)
                .slideX(begin: -0.2, end: 0),

            // Information boxes
            InfoBoxList(
              items: [
                InfoBoxItem(
                  icon: Icons.medical_services,
                  title: "What is Leukemia",
                  description:
                      "Leukemia is a cancer of blood-forming tissues, including bone marrow.",
                ),
                InfoBoxItem(
                  icon: Icons.help_outline,
                  title: "Symptoms",
                  description:
                      "Common symptoms include fatigue, frequent infections, and easy bruising.",
                ),
                InfoBoxItem(
                  icon: Icons.healing,
                  title: "Treatment",
                  description:
                      "Treatment may include chemotherapy, radiation therapy, and stem cell transplant.",
                ),
              ],
            ).animate().fadeIn(duration: 800.ms, delay: 700.ms).slide(
                begin: const Offset(0, 0.3),
                end: const Offset(0, 0),
                delay: 700.ms),

            const SizedBox(height: 24.0),

            // Action button
            ElevatedButton.icon(
              onPressed: () {
                // Open detection page with proper gradient background
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DetectionPageWrapper(),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded,
                  color: AppColors.primary),
              label: const Text(
                'Start Detection',
                style: TextStyle(fontSize: 16, color: AppColors.primary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 1200.ms)
                .scale(delay: 1200.ms)
                .then(delay: 200.ms)
                .shimmer(duration: 1200.ms),
          ],
        ),
      ),
    );
  }
}
