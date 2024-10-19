import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color(0xFFF4F8FF),
    primary: Color(0xFF274688),
    secondary: Color(0xFFF4F8FF),
    outline: Color(0xFFBBBBBB),
  ),
  dialogTheme: DialogTheme(backgroundColor: Color(0xFF274688),),
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
      fontSize: 12,
      color: Color(0xFFFFFFFF),
    ),
  ),
);
