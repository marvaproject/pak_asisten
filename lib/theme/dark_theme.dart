import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xFF14274F),
    primary: Color(0xFF274688),
    secondary: Color(0xFFF4F8FF),
    outline: Color(0xFF274688),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStateProperty.all(Color(0xFFF4F8FF)),
      iconSize: MaterialStateProperty.all(16),
      backgroundColor: MaterialStateProperty.all(Color(0xFF274688)),
      textStyle: MaterialStateProperty.all(
        TextStyle(
          fontSize: 15,
          color: Color(0xFFF4F8FF),
          fontWeight: FontWeight.bold,
        ),
      ),
      alignment: Alignment.center,
      padding: MaterialStateProperty.all(
        EdgeInsets.symmetric(vertical: 15),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      shadowColor: MaterialStateProperty.all(Color(0x4C274688)),
      elevation: MaterialStateProperty.all(8),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStateProperty.all(Color(0xFF274688)),
      iconSize: MaterialStateProperty.all(16),
      backgroundColor: MaterialStateProperty.all(Color(0xFFF4F8FF)),
      textStyle: MaterialStateProperty.all(
        TextStyle(
          fontSize: 15,
          color: Color(0xFF274688),
          fontWeight: FontWeight.bold,
        ),
      ),
      alignment: Alignment.center,
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          side: BorderSide(
              color: Color(0xFF274688), width: 1, style: BorderStyle.solid),
        ),
      ),
      shadowColor: MaterialStateProperty.all(Color(0x4C274688)),
      elevation: MaterialStateProperty.all(8),
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Color(0xFF274688),
  ),
  dialogBackgroundColor: Color(0xFF3D5891),
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
      color: Color(0xFFF4F8FF),
    ),
  ),
);
