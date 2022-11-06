import 'package:flutter/material.dart';

ThemeData createLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 22,
      ),


    ),
  );
}

ThemeData createDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 22,
      ),


    ),
  );
}

abstract class AppColors {
}