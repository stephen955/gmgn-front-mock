# 主题系统使用指南

## 概述

基于 Provider 的主题管理系统，支持亮色/暗色模式切换，完全符合 Flutter 设计规范。

## 文件结构

```
lib/core/theme/
├── app_theme.dart         # 主题数据定义
├── theme_notifier.dart    # Provider 状态管理
├── theme_example.dart     # 使用示例
└── README.md             # 使用说明
```

## 核心功能

### 1. 主题数据定义 (app_theme.dart)

定义了亮色和暗色两套完整的主题配置：

- **亮色主题**：白色背景，深色文字，蓝色主色调
- **暗色主题**：深色背景，白色文字，蓝色主色调

包含的配置项：
- 基础颜色配置
- AppBar 主题
- 卡片主题
- 按钮主题
- 文字主题
- 颜色方案

### 2. 主题状态管理 (theme_notifier.dart)

使用 Provider 管理主题状态：

```dart
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;
  
  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;
  
  void toggleTheme() { /* 切换主题 */ }
  void setDark(bool value) { /* 设置暗色模式 */ }
  void setLight() { /* 设置为亮色模式 */ }
  void setDarkMode() { /* 设置为暗色模式 */ }
}
```

## 使用方法

### 1. 在 main.dart 中集成

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'GMGN',
          theme: AppTheme.lightTheme,      // 亮色主题
          darkTheme: AppTheme.darkTheme,   // 暗色主题
          themeMode: themeNotifier.themeMode, // 当前主题模式
          home: const HomePage(),
        );
      },
    );
  }
}
```

### 2. 在页面中使用

#### 获取主题状态
```dart
// 方式1：使用 Consumer
Consumer<ThemeNotifier>(
  builder: (context, themeNotifier, child) {
    return Text(
      themeNotifier.isDark ? '暗色模式' : '亮色模式',
    );
  },
)

// 方式2：使用 Provider.of
final themeNotifier = Provider.of<ThemeNotifier>(context);
bool isDark = themeNotifier.isDark;
```

#### 切换主题
```dart
// 切换主题
themeNotifier.toggleTheme();

// 设置为亮色模式
themeNotifier.setLight();

// 设置为暗色模式
themeNotifier.setDarkMode();

// 使用开关控制
SwitchListTile(
  title: const Text('暗色模式'),
  value: themeNotifier.isDark,
  onChanged: (value) => themeNotifier.setDark(value),
)
```

#### 使用主题样式
```dart
// 使用主题文字样式
Text(
  '标题',
  style: Theme.of(context).textTheme.headlineMedium,
)

// 使用主题颜色
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text('使用主题色'),
)

// 使用主题卡片
Card(
  child: ListTile(
    title: Text('卡片标题'),
    subtitle: Text('卡片内容'),
  ),
)
```

### 3. 主题切换按钮示例

```dart
AppBar(
  title: const Text('应用标题'),
  actions: [
    Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return IconButton(
          icon: Icon(
            themeNotifier.isDark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () => themeNotifier.toggleTheme(),
        );
      },
    ),
  ],
)
```

## 自定义主题

### 1. 修改颜色方案

在 `app_theme.dart` 中修改颜色配置：

```dart
static ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.green, // 修改主色调
  // 其他配置...
);
```

### 2. 添加自定义主题

```dart
// 添加自定义主题
static ThemeData customTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.purple,
  // 自定义配置...
);
```

### 3. 扩展主题状态

在 `theme_notifier.dart` 中添加更多主题选项：

```dart
enum ThemeType { light, dark, custom }

class ThemeNotifier extends ChangeNotifier {
  ThemeType _themeType = ThemeType.light;
  
  ThemeMode get themeMode {
    switch (_themeType) {
      case ThemeType.light:
        return ThemeMode.light;
      case ThemeType.dark:
        return ThemeMode.dark;
      case ThemeType.custom:
        return ThemeMode.light; // 或其他处理
    }
  }
}
```

## 最佳实践

### 1. 主题一致性
- 使用 `Theme.of(context)` 获取主题数据
- 避免硬编码颜色值
- 统一使用主题中定义的颜色和样式

### 2. 性能优化
- 使用 `Consumer` 包装需要响应主题变化的组件
- 避免在 `build` 方法中创建大量主题相关的对象

### 3. 用户体验
- 提供明显的主题切换入口
- 保存用户的主题选择（可结合 SharedPreferences）
- 考虑跟随系统主题设置

### 4. 代码组织
- 主题相关的样式统一在 `app_theme.dart` 中定义
- 主题状态管理逻辑集中在 `theme_notifier.dart` 中
- 避免在业务代码中直接操作主题状态

## 扩展功能

### 1. 主题持久化
```dart
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    setDark(isDark);
  }
  
  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDark);
  }
}
```

### 2. 跟随系统主题
```dart
void setSystemTheme(BuildContext context) {
  final brightness = MediaQuery.platformBrightnessOf(context);
  setDark(brightness == Brightness.dark);
}
```

### 3. 自定义主题色
```dart
class AppTheme {
  static Color get primaryColor => Colors.blue;
  static Color get secondaryColor => Colors.blueAccent;
  
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: MaterialColor(primaryColor.value, {
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      // ... 更多色阶
    }),
    // 其他配置...
  );
}
```

## 注意事项

1. **Provider 依赖**：确保已添加 `provider: ^6.0.0` 依赖
2. **初始化顺序**：在 `main.dart` 中正确初始化 Provider
3. **主题切换时机**：避免在 `build` 方法中频繁切换主题
4. **测试覆盖**：在不同主题模式下测试应用表现
5. **无障碍支持**：确保主题切换不影响无障碍功能 