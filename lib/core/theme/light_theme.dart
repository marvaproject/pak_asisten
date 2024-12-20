import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xFFF4F8FF),
    primary: Color(0xFF274688),
    secondary: Color(0xFFF4F8FF),
    outline: Color(0xFFBBBBBB),
    outlineVariant: Color(0xFF274688),
    shadow: Color(0x4C274688),
    inverseSurface: Color(0xFFFFFFFF),
    error: Color(0xFFE74049),
    onSecondaryContainer: Color(0xFF274688),
    tertiary: Color(0xFFFFFFFF),
    onTertiary: Color(0xFF274688),
    tertiaryContainer: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFFD1DBF2),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Colors.white),
      iconSize: WidgetStateProperty.all(16),
      backgroundColor: WidgetStateProperty.all(Color(0xFF274688)),
      textStyle: WidgetStateProperty.all(
        GoogleFonts.lato(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      alignment: Alignment.center,
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(vertical: 20),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
      shadowColor: WidgetStateProperty.all(Color(0x4C274688)),
      elevation: WidgetStateProperty.all(8),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Color(0xFF274688)),
      iconSize: WidgetStateProperty.all(16),
      backgroundColor: WidgetStateProperty.all(Colors.white),
      textStyle: WidgetStateProperty.all(
        GoogleFonts.lato(
          fontSize: 16,
          color: Color(0xFF274688),
          fontWeight: FontWeight.bold,
        ),
      ),
      alignment: Alignment.center,
      padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 20)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          side: BorderSide(
              color: Color(0xFF274688), width: 0.5, style: BorderStyle.solid),
        ),
      ),
      shadowColor: WidgetStateProperty.all(Color(0x4C274688)),
      elevation: WidgetStateProperty.all(8),
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Color(0xFF274688),
  ),
  dialogBackgroundColor: Color(0xFFFFFFFF),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFBBBBBB),
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFF4F8FF),
  ),
  primaryIconTheme: IconThemeData(
    color: Color(0xFF274688),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFF4F8FF),
    selectedItemColor: Color(0xFFD1DBF2),
    selectedIconTheme: IconThemeData(
      color: Color(0xFF274688),
    ),
    unselectedIconTheme: IconThemeData(
      color: Color(0xFF171F22),
    ),
    selectedLabelStyle: GoogleFonts.lato(
      color: Color(0xFF274688),
    ),
  ),
  textTheme: TextTheme(
    bodySmall: GoogleFonts.lato(
      fontSize: 12,
      color: Color(0xFFFFFFFF),
    ),
    bodyMedium: GoogleFonts.lato(
      fontSize: 12,
      color: Color(0xFF171F22),
    ),
    displaySmall: GoogleFonts.lato(
      color: Color(0xFFFFFFFF),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.lato(
      color: Color(0xFFFFFFFF),
    ),
    displayLarge: GoogleFonts.lato(
      color: Color(0xFF274688),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);
