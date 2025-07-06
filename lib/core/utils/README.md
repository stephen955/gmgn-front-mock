# 响应式布局工具使用指南

## 概述

基于 MediaQuery + LayoutBuilder 实现的响应式布局工具，支持 Android、iOS 和 Web 平台的多设备适配。

## 文件结构

```
lib/core/utils/
├── responsive_util.dart      # 响应式工具核心类
├── responsive_extensions.dart # 语法糖扩展
├── responsive_example.dart   # 使用示例
└── README.md                # 使用说明
```

## 核心功能

### 1. 语法糖扩展（推荐使用）

#### 数字扩展
```dart
// 导入语法糖扩展
import 'responsive_extensions.dart';

// 基础语法糖
double width = 100.w;    // 响应式宽度
double height = 200.h;   // 响应式高度
double fontSize = 16.sp; // 响应式字体
double radius = 8.r;     // 响应式半径
double padding = 16.p;   // 响应式边距
double paddingH = 16.ph; // 响应式垂直边距
```

#### 边距语法糖
```dart
// 响应式边距
EdgeInsets padding = ResponsiveEdgeInsets.all(16);
EdgeInsets margin = ResponsiveEdgeInsets.symmetric(horizontal: 16, vertical: 20);
EdgeInsets custom = ResponsiveEdgeInsets.only(left: 16, top: 20);

// 扩展方法
EdgeInsets padding = EdgeInsets.all(16).r;      // 响应式全边距
EdgeInsets margin = EdgeInsets.all(16).rv;      // 响应式垂直边距
```

#### 尺寸语法糖
```dart
// 响应式尺寸
double width = ResponsiveSize.width(100);
double height = ResponsiveSize.height(200);
double fontSize = ResponsiveSize.font(16);
double radius = ResponsiveSize.radius(8);

// 响应式 SizedBox
SizedBox widthBox = ResponsiveSizedBox.width(100);
SizedBox heightBox = ResponsiveSizedBox.height(200);
SizedBox sizeBox = ResponsiveSizedBox.size(width: 100, height: 200);
```

#### 样式语法糖
```dart
// 响应式文本样式
TextStyle style = TextStyle(fontSize: 16).r;    // 响应式字体
TextStyle style2 = TextStyle(height: 1.5).rh;   // 响应式行高

// 响应式装饰
BoxDecoration decoration = BoxDecoration(
  borderRadius: ResponsiveBorderRadius.circular(8),
  boxShadow: [ResponsiveShadow.blur(10)],
);
```

#### 动画语法糖
```dart
// 响应式动画
Duration duration = ResponsiveAnimation.duration(300);
Curve curve = ResponsiveAnimation.curve(Curves.easeInOut);

// 扩展方法
Duration duration = Duration(milliseconds: 300).r;
```

### 2. ResponsiveUtil 工具类

#### 初始化
```dart
// 在页面或组件中初始化
ResponsiveUtil.init(context);

// 自定义设计稿尺寸
ResponsiveUtil.init(
  context,
  designWidth: 375.0,  // 设计稿宽度
  designHeight: 812.0, // 设计稿高度
);
```

#### 屏幕信息获取
```dart
// 获取屏幕尺寸
double width = ResponsiveUtil.screenWidth;
double height = ResponsiveUtil.screenHeight;

// 获取像素比
double pixelRatio = ResponsiveUtil.pixelRatio;

// 获取状态栏和底部安全区域高度
double statusBarHeight = ResponsiveUtil.statusBarHeight;
double bottomBarHeight = ResponsiveUtil.bottomBarHeight;
```

#### 平台判断
```dart
// 平台判断
bool isWeb = ResponsiveUtil.isWeb;
bool isAndroid = ResponsiveUtil.isAndroid;
bool isIOS = ResponsiveUtil.isIOS;
bool isMobile = ResponsiveUtil.isMobile;

// 设备类型判断
bool isTablet = ResponsiveUtil.isTablet;
bool isPhone = ResponsiveUtil.isPhone;

// 屏幕方向判断
bool isLandscape = ResponsiveUtil.isLandscape;
bool isPortrait = ResponsiveUtil.isPortrait;
```

#### 尺寸适配
```dart
// 根据设计稿宽度适配
double width = ResponsiveUtil.setWidth(100);  // 设计稿100px
double height = ResponsiveUtil.setHeight(200); // 设计稿200px
double fontSize = ResponsiveUtil.setSp(16);    // 设计稿16px字体
double radius = ResponsiveUtil.setRadius(8);   // 设计稿8px圆角
```

#### 断点系统
```dart
// 获取当前断点
ResponsiveBreakpoint breakpoint = ResponsiveUtil.breakpoint;

// 断点类型
// ResponsiveBreakpoint.small   // < 600px
// ResponsiveBreakpoint.medium  // 600-900px
// ResponsiveBreakpoint.large   // 900-1200px
// ResponsiveBreakpoint.xlarge  // >= 1200px

// 根据断点获取列数
int columns = ResponsiveUtil.getColumnCount(breakpoint);
```

### 2. ResponsiveBuilder 响应式构建器

```dart
ResponsiveBuilder(
  builder: (context, breakpoint) {
    switch (breakpoint) {
      case ResponsiveBreakpoint.small:
        return _buildSmallLayout();
      case ResponsiveBreakpoint.medium:
        return _buildMediumLayout();
      case ResponsiveBreakpoint.large:
        return _buildLargeLayout();
      case ResponsiveBreakpoint.xlarge:
        return _buildXLargeLayout();
    }
  },
)
```

### 3. ResponsiveGrid 响应式网格

```dart
ResponsiveGrid(
  spacing: 16.0,      // 水平间距
  runSpacing: 16.0,   // 垂直间距
  padding: EdgeInsets.all(16),
  children: [
    // 子组件列表
  ],
)
```

### 4. ResponsiveContainer 响应式容器

```dart
ResponsiveContainer(
  width: 300,  // 设计稿宽度
  height: 200, // 设计稿高度
  margin: EdgeInsets.all(16),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text('内容'),
)
```

## 使用示例

### 基础使用（推荐语法糖）
```dart
import 'responsive_extensions.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 初始化响应式工具
    ResponsiveUtil.init(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '标题',
          style: TextStyle(fontSize: 18.sp), // 语法糖：18.sp
        ),
      ),
      body: Padding(
        padding: 16.p, // 语法糖：16.p
        child: Column(
          children: [
            Text(
              '响应式文本',
              style: TextStyle(fontSize: 16.sp), // 语法糖：16.sp
            ),
            ResponsiveSizedBox.height(20), // 语法糖：ResponsiveSizedBox.height(20)
            // 其他组件...
          ],
        ),
      ),
    );
  }
}
```

### 传统使用方式
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 初始化响应式工具
    ResponsiveUtil.init(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '标题',
          style: TextStyle(fontSize: ResponsiveUtil.setSp(18)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveUtil.setWidth(16)),
        child: Column(
          children: [
            Text(
              '响应式文本',
              style: TextStyle(fontSize: ResponsiveUtil.setSp(16)),
            ),
            SizedBox(height: ResponsiveUtil.setHeight(20)),
            // 其他组件...
          ],
        ),
      ),
    );
  }
}
```

### 响应式布局
```dart
ResponsiveBuilder(
  builder: (context, breakpoint) {
    if (ResponsiveUtil.isTablet) {
      return Row(
        children: [
          Expanded(child: _buildLeftPanel()),
          Expanded(child: _buildRightPanel()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildLeftPanel(),
          _buildRightPanel(),
        ],
      );
    }
  },
)
```

### 响应式网格（语法糖版本）
```dart
ResponsiveGrid(
  children: List.generate(6, (index) {
    return Container(
      height: 100.h, // 语法糖：100.h
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: ResponsiveBorderRadius.circular(8), // 语法糖：ResponsiveBorderRadius.circular(8)
      ),
      child: Center(
        child: Text(
          '卡片 ${index + 1}',
          style: TextStyle(fontSize: 16.sp), // 语法糖：16.sp
        ),
      ),
    );
  }),
)
```

### 响应式网格（传统版本）
```dart
ResponsiveGrid(
  children: List.generate(6, (index) {
    return Container(
      height: ResponsiveUtil.setHeight(100),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(ResponsiveUtil.setRadius(8)),
      ),
      child: Center(
        child: Text(
          '卡片 ${index + 1}',
          style: TextStyle(fontSize: ResponsiveUtil.setSp(16)),
        ),
      ),
    );
  }),
)
```

## 最佳实践

### 1. 语法糖使用建议
- **推荐使用语法糖**：`100.w`、`200.h`、`16.sp` 等，代码更简洁
- **导入扩展**：记得导入 `responsive_extensions.dart`
- **混合使用**：可以语法糖和传统方法混合使用

### 2. 初始化时机
- 在页面的 `build` 方法中调用 `ResponsiveUtil.init(context)`
- 确保在每次构建时都能获取最新的屏幕信息

### 3. 设计稿适配
- 统一使用设计稿尺寸作为基准
- 默认设计稿宽度为 375px（iPhone 标准）
- 可根据项目需要调整设计稿尺寸

### 4. 断点使用
- 使用 `ResponsiveBuilder` 处理不同屏幕尺寸的布局差异
- 结合 `ResponsiveGrid` 实现自适应网格布局

### 5. 性能优化
- 避免在 `build` 方法中重复计算尺寸
- 使用 `ResponsiveContainer` 自动处理尺寸适配

### 6. 平台适配
- 使用平台判断方法处理平台特定逻辑
- 注意 Web 平台的特殊处理

## 注意事项

1. **初始化顺序**：确保在使用任何响应式方法前先调用 `ResponsiveUtil.init(context)`
2. **语法糖导入**：使用语法糖时记得导入 `responsive_extensions.dart`
3. **设计稿基准**：统一使用设计稿尺寸，避免硬编码
4. **断点选择**：根据实际需求选择合适的断点
5. **性能考虑**：避免过度使用响应式计算，影响性能
6. **测试覆盖**：在不同设备和平台上测试响应式效果

## 扩展功能

可以根据项目需要扩展以下功能：
- 自定义断点系统
- 主题适配
- 动画适配
- 手势适配
- 无障碍适配 