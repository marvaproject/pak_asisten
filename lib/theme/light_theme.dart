import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xFFF4F8FF),
    primary: Color(0xFF274688),
    secondary: Color(0xFFF4F8FF),
    outline: Color(0xFFBBBBBB),
    shadow: Color(0x4C274688),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Colors.white),
      iconSize: WidgetStateProperty.all(16),
      backgroundColor: WidgetStateProperty.all(Color(0xFF274688)),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          fontSize: 15,
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
          borderRadius: BorderRadius.all(Radius.circular(30)),
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
        TextStyle(
          fontSize: 15,
          color: Color(0xFF274688),
          fontWeight: FontWeight.bold,
        ),
      ),
      alignment: Alignment.center,
      padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 20)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          side: BorderSide(
              color: Color(0xFF274688), width: 1, style: BorderStyle.solid),
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
        width: 1,
        style: BorderStyle.solid,
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
    selectedLabelStyle: TextStyle(
      color: Color(0xFF274688),
    ),
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      fontSize: 12,
      color: Color(0xFFFFFFFF),
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
      color: Color(0xFF171F22),
    ),
    displayMedium: TextStyle(
      color: Color(0xFFFFFFFF),
    ),
  ),
);
