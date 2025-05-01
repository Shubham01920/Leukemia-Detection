import 'package:flutter/material.dart';
import '../Pages/home_page.dart';
import '../Pages/detection_page.dart';
import '../Pages/about_page.dart';
import '../theme/app_colors.dart';

class NavigatorPage extends StatefulWidget {
  final int initialIndex;

  const NavigatorPage({
    super.key,
    this.initialIndex = 0,
  });

  /// Static method to navigate to a specific page
  static void navigateToPage(BuildContext context, int pageIndex) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => NavigatorPage(initialIndex: pageIndex),
      ),
      (route) => false,
    );
  }

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage>
    with TickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _bounceController;
  late AnimationController _slideController;
  late Animation<double> _bounceAnimation;

  // Navigation items config
  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Home'),
    _NavItem(icon: Icons.medical_services_rounded, label: 'Detect'),
    _NavItem(icon: Icons.info_rounded, label: 'About'),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // Bounce animation for the selected item
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 30),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.2, end: 0.85), weight: 30),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.85, end: 1.1), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // Slide animation for the indicator
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: _currentIndex / (_navItems.length - 1),
    );

    _bounceController.forward();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    const HomePage(),
    const DetectionPage(),
    const AboutPage(),
  ];

  void _onTabSelected(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;

      // Animate the indicator slide
      _slideController.animateTo(
        index / (_navItems.length - 1),
        curve: Curves.elasticOut,
        duration: const Duration(milliseconds: 600),
      );

      // Reset and play bounce animation
      _bounceController.reset();
      _bounceController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.mainBackground,
        ),
        child: SafeArea(
          bottom: false,
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Main curved nav bar
          CustomPaint(
            size: Size(screenSize.width, 80),
            painter: CurvedNavPainter(
              backgroundColor: Colors.white,
              borderColor: AppColors.lightPurple.withAlpha(100),
            ),
          ),

          // Sliding indicator
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: AnimatedBuilder(
              animation: _slideController,
              builder: (context, _) {
                final indicatorPos = Tween<double>(
                  begin: screenSize.width / _navItems.length * 0.5,
                  end: screenSize.width /
                      _navItems.length *
                      (_navItems.length - 0.5),
                ).evaluate(_slideController);

                return CustomPaint(
                  size: Size(screenSize.width, 80),
                  painter: IndicatorPainter(
                    position: indicatorPos,
                    itemWidth: screenSize.width / _navItems.length,
                    color: AppColors.lightPurple.withAlpha(30),
                  ),
                );
              },
            ),
          ),

          // Nav items
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = index == _currentIndex;

                return AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return GestureDetector(
                      onTap: () => _onTabSelected(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: screenSize.width / _navItems.length,
                        height: 60,
                        padding: const EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: isSelected ? _bounceAnimation.value : 1.0,
                              child: Icon(
                                item.icon,
                                color: isSelected
                                    ? AppColors.lightPurple
                                    : Colors.grey.shade400,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.label,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.lightPurple
                                    : Colors.grey.shade500,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for curved nav bar
class CurvedNavPainter extends CustomPainter {
  final Color backgroundColor;
  final Color borderColor;

  CurvedNavPainter({
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define paints
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Define path for the curved shape
    final Path path = Path();

    // Start from bottom left
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.35);

    // Left rounded corner
    path.quadraticBezierTo(5, size.height * 0.2, 20, size.height * 0.2);

    // Left curve to middle - more gentle curve
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.18,
        size.width * 0.35, size.height * 0.18);

    // Middle curve - more consistent with less dip
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.18,
        size.width * 0.5, size.height * 0.18);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.18,
        size.width * 0.65, size.height * 0.18);

    // Right curve to end
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.18,
        size.width - 20, size.height * 0.2);

    // Right rounded corner
    path.quadraticBezierTo(
        size.width - 5, size.height * 0.2, size.width, size.height * 0.35);

    // Bottom right to bottom left
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    // Drop shadow
    canvas.drawShadow(path, Colors.black.withAlpha(40), 6, false);

    // Draw background
    canvas.drawPath(path, backgroundPaint);

    // Draw border
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CurvedNavPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor;
  }
}

// Indicator painter
class IndicatorPainter extends CustomPainter {
  final double position;
  final double itemWidth;
  final Color color;

  IndicatorPainter({
    required this.position,
    required this.itemWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path();

    // Draw a pill shape at the current position
    final double left = position - itemWidth * 0.35;
    final double right = position + itemWidth * 0.35;
    final double top = size.height * 0.25;
    final double bottom = size.height * 0.65;
    final double radius = (bottom - top) / 2;

    // Rounded rectangle
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, top, right, bottom),
        Radius.circular(radius),
      ),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(IndicatorPainter oldDelegate) {
    return oldDelegate.position != position || oldDelegate.color != color;
  }
}

// Simple class to hold navigation item data
class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
