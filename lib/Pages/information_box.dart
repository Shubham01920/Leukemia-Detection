import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InfoBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int index;

  const InfoBox({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.lightPurple.withAlpha(100),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  spreadRadius: 0.1,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.lilac.withAlpha(70),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 32.0, color: AppColors.lightBlue),
                )
                    .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true))
                    .scaleXY(begin: 1, end: 1.1, duration: 2000.ms)
                    .then(delay: 300.ms),
                const SizedBox(height: 12.0),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.white70,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
            duration: 600.ms, delay: Duration(milliseconds: 100 * (index + 1)))
        .slideY(
            begin: 0.3,
            end: 0,
            curve: Curves.easeOutQuad,
            delay: Duration(milliseconds: 100 * (index + 1)));
  }
}

class InfoBoxList extends StatelessWidget {
  final List<InfoBoxItem> items;

  const InfoBoxList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InfoBox(
          icon: item.icon,
          title: item.title,
          description: item.description,
          index: index,
        );
      },
    );
  }
}

class InfoBoxItem {
  final IconData icon;
  final String title;
  final String description;

  InfoBoxItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
