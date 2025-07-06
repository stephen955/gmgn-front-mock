import 'package:flutter/material.dart';
import 'app_theme_extensions.dart';

extension AppThemeContextExt on BuildContext {
  AppColorsExtension get appColors {
    final ext = Theme.of(this).extension<AppColorsExtension>();
    assert(ext != null, 'AppColorsExtension not found in Theme');
    return ext ?? const AppColorsExtension(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      accentDanger: Colors.red,
      textPrimary: Colors.black87,
      textSecondary: Colors.black54,
      background: Colors.white,
    );
  }
  AppSpacingExtension get appSpacing => Theme.of(this).extension<AppSpacingExtension>() ?? AppSpacingExtension();
  AppRadiusExtension get appRadius => Theme.of(this).extension<AppRadiusExtension>() ?? AppRadiusExtension();
  AppShadowsExtension get appShadows => Theme.of(this).extension<AppShadowsExtension>() ?? AppShadowsExtension();
  AppTypographyExtension get appTypography => Theme.of(this).extension<AppTypographyExtension>() ?? AppTypographyExtension(
    h1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    h2: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    body: TextStyle(fontSize: 16),
    caption: TextStyle(fontSize: 12),
  );
  AppButtonStyleExtension get appButtonStyles => Theme.of(this).extension<AppButtonStyleExtension>() ?? AppButtonStyleExtension(
    primary: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
    primaryDisabled: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
    outline: OutlinedButton.styleFrom(),
    icon: ElevatedButton.styleFrom(),
  );
  AppInputDecorationExtension get appInputDecorations => Theme.of(this).extension<AppInputDecorationExtension>() ?? AppInputDecorationExtension(
    normal: InputDecoration(),
    withIcon: (icon, {hintText}) => InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hintText,
    ),
  );
  AppCardStyleExtension get appCardStyle => Theme.of(this).extension<AppCardStyleExtension>() ?? AppCardStyleExtension(
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
  );

  /// 成功色
  Color get success => const Color(0xFF4CAF50);
  
  /// 警告色
  Color get warning => const Color(0xFFFF9800);
  
  /// 错误色
  Color get error => const Color(0xFFF44336);
  
  /// 信息色
  Color get info => const Color(0xFF2196F3);
} 