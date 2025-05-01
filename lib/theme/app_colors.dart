import 'package:flutter/material.dart';

/// App color palette from hex codes
class AppColors {
  static const Color primary = Color(0xFF4D48E2);
  static const Color secondary = Color(0xFF653494);
  static const Color accent = Color(0xFF6851AC);
  static const Color lightPurple = Color(0xFFC6C4F0);
  static const Color lightBlue = Color(0xFF9ABBF3);
  static const Color darkBlue = Color(0xFF293E95);
  static const Color mediumPurple = Color(0xFF886DB1);
  static const Color lilac = Color(0xFF6865B1);
  static const Color navyBlue = Color(0xFF3B4499);
}

/// Predefined gradients for use throughout the app
class AppGradients {
  /// Main background gradient
  static const LinearGradient mainBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary, // #4d48e2
      AppColors.mediumPurple, // #886db1
      AppColors.lightBlue, // #9abbf3
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Card gradient (light variant)
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.lightPurple,
      AppColors.lilac,
    ],
    stops: [0.0, 1.0],
  );

  /// Button gradient
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.secondary,
      AppColors.primary,
    ],
  );

  /// App bar gradient
  static const LinearGradient appBarGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.primary, // #4d48e2
      AppColors.secondary, // #653494
    ],
  );
}
