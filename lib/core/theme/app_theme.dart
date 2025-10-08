import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Colors - Ultra Minimalist
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color neonYellow = Color(0xFFFFFF00);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color mediumGrey = Color(0xFF333333);
  static const Color lightGrey = Color(0xFF666666);
  static const Color errorRed = Color(0xFFFF3B30);
  static const Color successGreen = Color(0xFF30FF30);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryBlack,
      primaryColor: neonYellow,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: neonYellow,
        secondary: primaryWhite,
        surface: darkGrey,
        background: primaryBlack,
        error: errorRed,
        onPrimary: primaryBlack,
        onSecondary: primaryBlack,
        onSurface: primaryWhite,
        onBackground: primaryWhite,
        onError: primaryWhite,
      ),

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlack,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: primaryWhite),
        titleTextStyle: TextStyle(
          color: primaryWhite,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w900,
          color: primaryWhite,
          letterSpacing: -2,
          height: 1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          color: primaryWhite,
          letterSpacing: -1,
        ),
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: primaryWhite,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: primaryWhite,
          letterSpacing: 1,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryWhite,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: primaryWhite,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: primaryWhite,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryWhite,
          letterSpacing: 1.5,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonYellow,
          foregroundColor: primaryBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryWhite,
          side: const BorderSide(color: primaryWhite, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Card
      cardTheme: CardTheme(
        color: darkGrey,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: mediumGrey, width: 1),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: primaryWhite,
        size: 24,
      ),
    );
  }

  // System UI Overlay Style
  static void setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: primaryBlack,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
}

