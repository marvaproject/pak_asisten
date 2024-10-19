import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xFF14274F),
    primary: Color(0xFF274688),
    secondary: Color(0xFFF4F8FF),
    outline: Color(0xFF274688),
  ),
  dialogTheme: DialogTheme(backgroundColor: Color(0xFF274688),),
  dialogBackgroundColor: Color(0xFF3D5891),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFBBBBBB),
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF14274F),
  ),
  primaryIconTheme: IconThemeData(
    color: Color(0xFFF4F8FF),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF274688),
    selectedItemColor: Color(0xFF274688),
    selectedIconTheme: IconThemeData(
      color: Color(0xFFD1DBF2),
    ),
    unselectedIconTheme: IconThemeData(
      color: Color(0xFFF4F8FF),
    ),
    selectedLabelStyle: TextStyle(
      color: Color(0xFFD1DBF2),
    ),
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      fontSize: 14,
      color: Color(0xFFFFFFFF),
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
      color: Color(0xFFFFFFFF),
    ),
    displayMedium: TextStyle(
      fontSize: 14,
      color: Color(0xFFFFFFFF),
    ),
  ),
);
