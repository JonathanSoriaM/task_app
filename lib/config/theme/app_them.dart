import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true, color: Colors.yellow));
}
