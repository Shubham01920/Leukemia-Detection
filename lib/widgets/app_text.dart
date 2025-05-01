import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Styles for different text variants
enum AppTextStyle {
  /// Large header text
  header,

  /// Smaller sub-header text
  subheader,

  /// Standard body text
  body,

  /// Small caption text
  caption,

  /// Button text
  button,
}

/// A custom styled text widget that uses Google Fonts
class AppText extends StatelessWidget {
  /// The text to display
  final String text;

  /// Optional style variant
  final AppTextStyle style;

  /// Whether to make the text bold
  final bool bold;

  /// Optional custom font size
  final double? fontSize;

  /// Optional custom text color
  final Color? color;

  /// Optional text alignment
  final TextAlign? textAlign;

  /// Optional max lines
  final int? maxLines;

  /// Optional text overflow behavior
  final TextOverflow? overflow;

  /// Creates a custom text widget with Montserrat font
  const AppText(
    this.text, {
    super.key,
    this.style = AppTextStyle.body,
    this.bold = false,
    this.fontSize,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  /// Creates a header text
  factory AppText.header(
    String text, {
    Key? key,
    bool bold = true,
    Color? color,
    TextAlign? textAlign,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.header,
      bold: bold,
      color: color,
      textAlign: textAlign,
    );
  }

  /// Creates a subheader text
  factory AppText.subheader(
    String text, {
    Key? key,
    bool bold = true,
    Color? color,
    TextAlign? textAlign,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.subheader,
      bold: bold,
      color: color,
      textAlign: textAlign,
    );
  }

  /// Creates a button text
  factory AppText.button(
    String text, {
    Key? key,
    Color? color,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.button,
      bold: true,
      color: color,
    );
  }

  /// Creates a caption text
  factory AppText.caption(
    String text, {
    Key? key,
    bool bold = false,
    Color? color,
    TextAlign? textAlign,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.caption,
      bold: bold,
      color: color,
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define font size based on style
    double determinedFontSize = fontSize ?? _getFontSize();

    // Define font weight based on bold flag
    FontWeight weight = bold ? FontWeight.bold : FontWeight.normal;

    // Define color with fallback
    Color textColor = color ?? Colors.white;

    TextStyle textStyle;
    try {
      // Try to use Google Fonts
      textStyle = GoogleFonts.montserrat(
        fontSize: determinedFontSize,
        fontWeight: weight,
        color: textColor,
        letterSpacing: _getLetterSpacing(),
      );
    } catch (e) {
      // Fallback to system font if Google Fonts fails
      textStyle = TextStyle(
        fontSize: determinedFontSize,
        fontWeight: weight,
        color: textColor,
        letterSpacing: _getLetterSpacing(),
        fontFamily: 'Roboto',
      );
    }

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Get font size based on style
  double _getFontSize() {
    switch (style) {
      case AppTextStyle.header:
        return 24.0;
      case AppTextStyle.subheader:
        return 18.0;
      case AppTextStyle.body:
        return 16.0;
      case AppTextStyle.caption:
        return 12.0;
      case AppTextStyle.button:
        return 16.0;
    }
  }

  /// Get letter spacing based on style
  double _getLetterSpacing() {
    switch (style) {
      case AppTextStyle.header:
        return 0.5;
      case AppTextStyle.subheader:
        return 0.3;
      case AppTextStyle.button:
        return 0.5;
      default:
        return 0.2;
    }
  }
}
