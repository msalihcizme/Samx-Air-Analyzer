import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      primaryColor: Colors.deepPurple.shade300,
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple.shade300,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple.shade700,
        ),
        iconTheme: IconThemeData(color: Colors.deepPurple.shade300),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.deepPurple.shade400,
        unselectedLabelColor: Colors.deepPurple.shade200,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.deepPurple.shade400, width: 3),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.deepPurple.shade100,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
      ),
      iconTheme: IconThemeData(color: Colors.deepPurple.shade300, size: 26),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.deepPurple.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
