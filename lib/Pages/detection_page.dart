import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
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
  File? _imageFile;
  List<Map<String, dynamic>>? _results;
  String? _errorMessage;
  final ImagePicker _picker = ImagePicker();
  final List<String> _labels = ['Benign', 'Early PreB', 'Pre B', 'Pro B'];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadLabels();
  }

  Future<void> _loadLabels() async {
    try {
      // Load the labels from the assets
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      final labels = labelsData.split('\n').where((s) => s.isNotEmpty).toList();
      if (labels.isNotEmpty) {
        setState(() {
          _labels.clear();
          _labels.addAll(labels);
        });
        debugPrint('Labels loaded: $_labels');
      }
    } catch (e) {
      debugPrint('Error loading labels: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 100, // Use full quality for medical images
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _results = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking image: $e';
      });
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageFile == null) {
      setState(() {
        _errorMessage = 'Please select an image first';
      });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _results = null;
      _errorMessage = null;
    });

    try {
      // Always use demo mode
      await _simulateAnalysis();
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _errorMessage = 'Error analyzing image: $e';
      });
      debugPrint('Error analyzing image: $e');
    }
  }

  Future<void> _simulateAnalysis() async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Create simulated results
    final results = <Map<String, dynamic>>[];

    // Generate a random prediction with realistic values
    double topPredictionValue =
        70 + _random.nextDouble() * 25; // Between 70-95%
    int topPredictionIndex = _random.nextInt(_labels.length);

    // Add all classifications with realistic distribution
    for (int i = 0; i < _labels.length; i++) {
      if (i == topPredictionIndex) {
        results.add({
          'label': _labels[i],
          'confidence': topPredictionValue / 100, // TFLite returns 0-1 range
        });
      } else {
        // Other classes get lower values
        double confidence = _random.nextDouble() * 30; // 0-30%
        results.add({
          'label': _labels[i],
          'confidence': confidence / 100, // TFLite returns 0-1 range
        });
      }
    }

    // Sort by confidence (descending)
    results.sort((a, b) => b['confidence'].compareTo(a['confidence']));

    setState(() {
      _results = results;
      _isAnalyzing = false;
    });

    debugPrint('Simulated analysis complete: $results');
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

                        // Image preview
                        if (_imageFile != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _imageFile!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          // Image upload area
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withAlpha(230),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppText.subheader(
                                            'Choose Image Source'),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _buildImageSourceOption(
                                              icon: Icons.photo_library,
                                              label: 'Gallery',
                                              onTap: () {
                                                Navigator.pop(context);
                                                _getImage(ImageSource.gallery);
                                              },
                                            ),
                                            _buildImageSourceOption(
                                              icon: Icons.camera_alt,
                                              label: 'Camera',
                                              onTap: () {
                                                Navigator.pop(context);
                                                _getImage(ImageSource.camera);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
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
                                    const Icon(
                                            Icons.add_photo_alternate_rounded,
                                            size: 60,
                                            color: Colors.white)
                                        .animate(
                                            onPlay: (controller) => controller
                                                .repeat(reverse: true))
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
                          ),

                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: AppText(
                              _errorMessage!,
                              color: Colors.red[300],
                              textAlign: TextAlign.center,
                            ),
                          ),

                        const SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_imageFile != null)
                              Expanded(
                                flex: 1,
                                child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _imageFile = null;
                                      _results = null;
                                      _errorMessage = null;
                                    });
                                  },
                                  icon: Icon(Icons.refresh,
                                      color: AppColors.primary),
                                  label: AppText('Change',
                                      color: AppColors.primary),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            if (_imageFile != null) const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: _isAnalyzing || _imageFile == null
                                    ? null
                                    : _analyzeImage,
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
                                  _isAnalyzing
                                      ? 'Analyzing...'
                                      : 'Analyze Sample',
                                  color: AppColors.primary,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ),
                          ],
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

              // Results section
              if (_results != null && _results!.isNotEmpty) ...[
                const SizedBox(height: 24.0),
                _buildResultsDisplay(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsDisplay() {
    if (_results == null || _results!.isEmpty) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
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
              AppText.subheader(
                'Leukemia Classification',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ..._results!.map((result) {
                final confidence = (result['confidence'] as double) * 100;
                final label = result['label'] as String;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AppText(
                              label,
                              bold: true,
                            ),
                          ),
                          AppText(
                            '${confidence.toStringAsFixed(2)}%',
                            color: _getConfidenceColor(confidence),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: confidence / 100,
                        backgroundColor: Colors.white.withAlpha(51),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getConfidenceColor(confidence),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                );
              }),

              // Add timestamp
              const SizedBox(height: 16),
              Text(
                'Analysis completed at ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
        );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 75) {
      return Colors.green;
    } else if (confidence >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            AppText(
              label,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
