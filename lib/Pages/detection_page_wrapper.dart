import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'detection_page.dart';

/// A wrapper for DetectionPage that ensures it has the proper gradient background
/// when opened directly from the home page
class DetectionPageWrapper extends StatelessWidget {
  const DetectionPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.mainBackground,
        ),
        child: const SafeArea(
          child: DetectionPage(),
        ),
      ),
    );
  }
}
