import 'package:flutter/material.dart';
import 'app_theme_extensions.dart';

/// 应用主题数据定义
class AppTheme {
  // 亮色主题
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.white,
      background: Colors.grey,
      error: Colors.red,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF72F5E5),
      selectedLabelStyle: TextStyle(color: Colors.black),
      selectedIconTheme: IconThemeData(color: Color(0xFF72F5E5)),
      unselectedItemColor: Colors.black54,
      unselectedLabelStyle: TextStyle(color: Colors.black54),
      unselectedIconTheme: IconThemeData(color: Colors.black54),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
    extensions: <ThemeExtension<dynamic>>[
      const AppColorsExtension(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
        accentDanger: Colors.red,
        textPrimary: Colors.black87,
        textSecondary: Colors.black54,
        background: Colors.white,
      ),
      AppSpacingExtension(),
      AppRadiusExtension(),
      AppShadowsExtension(),
      AppTypographyExtension(
        h1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        h2: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        body: TextStyle(fontSize: 16),
        caption: TextStyle(fontSize: 12),
      ),
      AppButtonStyleExtension(
        primary: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        primaryDisabled: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
        outline: OutlinedButton.styleFrom(),
        icon: ElevatedButton.styleFrom(),
      ),
      AppInputDecorationExtension(
        normal: InputDecoration(),
        withIcon: (icon, {hintText}) => InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
        ),
      ),
      AppCardStyleExtension(
        card: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
      ),
    ],
  );

  // 暗色主题
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.grey,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.grey[850],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.grey,
      background: Colors.black,
      error: Colors.red,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF72F5E5),
      selectedLabelStyle: TextStyle(color: Colors.black),
      selectedIconTheme: IconThemeData(color: Color(0xFF72F5E5)),
      unselectedItemColor: Colors.white70,
      unselectedLabelStyle: TextStyle(color: Colors.white70),
      unselectedIconTheme: IconThemeData(color: Colors.white70),
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
    ),
    extensions: <ThemeExtension<dynamic>>[
      const AppColorsExtension(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
        accentDanger: Colors.red,
        textPrimary: Colors.white,
        textSecondary: Colors.white70,
        background: Colors.black,
      ),
      AppSpacingExtension(),
      AppRadiusExtension(),
      AppShadowsExtension(),
      AppTypographyExtension(
        h1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        h2: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
        body: TextStyle(fontSize: 16, color: Colors.white),
        caption: TextStyle(fontSize: 12, color: Colors.white70),
      ),
      AppButtonStyleExtension(
        primary: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        primaryDisabled: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
        outline: OutlinedButton.styleFrom(),
        icon: ElevatedButton.styleFrom(),
      ),
      AppInputDecorationExtension(
        normal: InputDecoration(),
        withIcon: (icon, {hintText}) => InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
        ),
      ),
      AppCardStyleExtension(
        card: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
      ),
    ],
  );
} 