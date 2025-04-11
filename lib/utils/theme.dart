import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFA5D6A7);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF9F9F9);
  static const Color textPrimaryColor = Color(0xFF1A1A1A);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color infoColor = Color(0xFF1976D2);

  // Text Styles
  static TextStyle get headingLarge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      );

  static TextStyle get headingMedium => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      );

  static TextStyle get headingSmall => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        color: textPrimaryColor,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        color: textPrimaryColor,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12,
        color: textSecondaryColor,
      );

  // Hindi Text Styles
  static TextStyle get hindiHeadingLarge => GoogleFonts.mukta(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      );

  static TextStyle get hindiHeadingMedium => GoogleFonts.mukta(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      );

  static TextStyle get hindiHeadingSmall => GoogleFonts.mukta(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      );

  static TextStyle get hindiBodyLarge => GoogleFonts.mukta(
        fontSize: 16,
        color: textPrimaryColor,
      );

  static TextStyle get hindiBodyMedium => GoogleFonts.mukta(
        fontSize: 14,
        color: textPrimaryColor,
      );

  static TextStyle get hindiBodySmall => GoogleFonts.mukta(
        fontSize: 12,
        color: textSecondaryColor,
      );

  // Theme Data
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          error: errorColor,
          background: backgroundColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: const BorderSide(color: primaryColor),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: errorColor),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          secondary: secondaryColor,
          error: errorColor,
          background: const Color(0xFF121212),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: const BorderSide(color: primaryColor),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: errorColor),
          ),
        ),
      );
} 