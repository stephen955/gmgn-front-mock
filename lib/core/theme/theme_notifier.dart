import 'package:flutter/material.dart';

/// 主题状态管理器
/// 使用 Provider 管理应用的主题状态
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;

  /// 是否为暗色模式
  bool get isDark => _isDark;

  /// 获取当前主题模式
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  /// 切换主题模式
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  /// 设置暗色模式
  /// [value] true 为暗色模式，false 为亮色模式
  void setDark(bool value) {
    if (_isDark != value) {
      _isDark = value;
      notifyListeners();
    }
  }

  /// 设置为亮色模式
  void setLight() {
    setDark(false);
  }

  /// 设置为暗色模式
  void setDarkMode() {
    setDark(true);
  }

  /// 根据系统主题设置
  void setSystem() {
    // 这里可以根据系统主题设置
    // 需要结合 MediaQuery.platformBrightnessOf(context)
    // 暂时保持当前状态
  }
} 