import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),
  );
}
