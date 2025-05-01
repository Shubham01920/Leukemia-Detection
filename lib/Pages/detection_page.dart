import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import '../widgets/app_text.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  bool _isAnalyzing = false;

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
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
                    const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.lightBlue,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    AppText.header(
                      'Analysis Complete',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    AppText(
                      'This is a demonstration. In a real app, the AI would analyze the blood sample image and provide detection results.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: AppText.button(
                        'OK',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            // Navigate back to the home page
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.mainBackground,
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                      children: [
                        AppText.subheader(
                          'Upload Blood Sample Image',
                          textAlign: TextAlign.center,
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 300.ms)
                            .slideY(
                                begin: 0.2,
                                end: 0,
                                duration: 600.ms,
                                curve: Curves.easeOutQuad),

                        const SizedBox(height: 24.0),

                        // Image upload area
                        GestureDetector(
                          onTap: () {
                            // Handle image upload
                          },
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.lilac.withAlpha(70),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: AppColors.lightPurple.withAlpha(100),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add_photo_alternate_rounded,
                                          size: 60, color: Colors.white)
                                      .animate(
                                          onPlay: (controller) =>
                                              controller.repeat(reverse: true))
                                      .scaleXY(
                                          begin: 1,
                                          end: 1.1,
                                          duration: 2000.ms,
                                          curve: Curves.easeInOut),
                                  const SizedBox(height: 12),
                                  const AppText(
                                    'Tap to upload an image',
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 800.ms, delay: 500.ms)
                            .slideY(begin: 0.3, end: 0),

                        const SizedBox(height: 24.0),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _isAnalyzing
                                ? null
                                : () {
                                    setState(() {
                                      _isAnalyzing = true;
                                    });
                                    // Simulate analysis process
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      if (!mounted) return;

                                      setState(() {
                                        _isAnalyzing = false;
                                      });
                                      _showResultDialog();
                                    });
                                  },
                            icon: _isAnalyzing
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : const Icon(Icons.biotech_rounded,
                                    color: AppColors.primary),
                            label: AppText.button(
                              _isAnalyzing ? 'Analyzing...' : 'Analyze Sample',
                              color: AppColors.primary,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 800.ms)
                            .slideY(begin: 0.2, end: 0)
                            .then()
                            .shimmer(duration: 1200.ms, delay: 400.ms),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 800.ms).scale(
                  begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
            ],
          ),
        ),
      ),
    );
  }
}
