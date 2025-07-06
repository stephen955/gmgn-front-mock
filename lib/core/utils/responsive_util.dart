import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 响应式布局工具类
/// 基于 MediaQuery + LayoutBuilder 实现多平台适配
class ResponsiveUtil {
  static MediaQueryData? _mediaQueryData;
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _pixelRatio = 0;
  static double _statusBarHeight = 0;
  static double _bottomBarHeight = 0;
  static double _textScaleFactor = 0;
  static double _designWidth = 375.0; // 设计稿宽度
  static double _designHeight = 812.0; // 设计稿高度

  /// 初始化响应式工具
  /// [context] 上下文
  /// [designWidth] 设计稿宽度，默认375
  /// [designHeight] 设计稿高度，默认812
  static void init(BuildContext context, {
    double designWidth = 375.0,
    double designHeight = 812.0,
  }) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData!.size.width;
    _screenHeight = _mediaQueryData!.size.height;
    _pixelRatio = _mediaQueryData!.devicePixelRatio;
    _statusBarHeight = _mediaQueryData!.padding.top;
    _bottomBarHeight = _mediaQueryData!.padding.bottom;
    _textScaleFactor = _mediaQueryData!.textScaleFactor;
    _designWidth = designWidth;
    _designHeight = designHeight;
  }

  /// 获取屏幕宽度
  static double get screenWidth => _screenWidth;

  /// 获取屏幕高度
  static double get screenHeight => _screenHeight;

  /// 获取像素比
  static double get pixelRatio => _pixelRatio;

  /// 获取状态栏高度
  static double get statusBarHeight => _statusBarHeight;

  /// 获取底部安全区域高度
  static double get bottomBarHeight => _bottomBarHeight;

  /// 获取文字缩放因子
  static double get textScaleFactor => _textScaleFactor;

  /// 获取设计稿宽度
  static double get designWidth => _designWidth;

  /// 获取设计稿高度
  static double get designHeight => _designHeight;

  /// 判断是否为Web平台
  static bool get isWeb => kIsWeb;

  /// 判断是否为Android平台
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// 判断是否为iOS平台
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// 判断是否为移动端
  static bool get isMobile => isAndroid || isIOS;

  /// 判断是否为平板
  static bool get isTablet {
    if (isWeb) {
      return _screenWidth >= 768;
    }
    return _screenWidth >= 600;
  }

  /// 判断是否为手机
  static bool get isPhone => !isTablet;

  /// 根据设计稿宽度适配尺寸
  /// [width] 设计稿中的宽度
  static double setWidth(double width) {
    return width * _screenWidth / _designWidth;
  }

  /// 根据设计稿高度适配尺寸
  /// [height] 设计稿中的高度
  static double setHeight(double height) {
    return height * _screenHeight / _designHeight;
  }

  /// 根据设计稿宽度适配字体大小
  /// [fontSize] 设计稿中的字体大小
  static double setSp(double fontSize) {
    return fontSize * _screenWidth / _designWidth;
  }

  /// 根据设计稿宽度适配半径
  /// [radius] 设计稿中的半径
  static double setRadius(double radius) {
    return radius * _screenWidth / _designWidth;
  }

  /// 获取屏幕方向
  static Orientation get orientation {
    return _screenWidth > _screenHeight 
        ? Orientation.landscape 
        : Orientation.portrait;
  }

  /// 判断是否为横屏
  static bool get isLandscape => orientation == Orientation.landscape;

  /// 判断是否为竖屏
  static bool get isPortrait => orientation == Orientation.portrait;

  /// 获取屏幕密度
  static double get devicePixelRatio => _pixelRatio;

  /// 获取屏幕尺寸信息
  static String get screenInfo {
    return 'Width: ${_screenWidth.toStringAsFixed(2)}, '
           'Height: ${_screenHeight.toStringAsFixed(2)}, '
           'PixelRatio: ${_pixelRatio.toStringAsFixed(2)}, '
           'Platform: ${_getPlatformName()}';
  }

  /// 获取平台名称
  static String _getPlatformName() {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    return 'Unknown';
  }

  /// 根据屏幕宽度获取断点
  static ResponsiveBreakpoint get breakpoint {
    if (_screenWidth < 600) return ResponsiveBreakpoint.small;
    if (_screenWidth < 900) return ResponsiveBreakpoint.medium;
    if (_screenWidth < 1200) return ResponsiveBreakpoint.large;
    return ResponsiveBreakpoint.xlarge;
  }

  /// 根据断点获取列数
  static int getColumnCount(ResponsiveBreakpoint breakpoint) {
    switch (breakpoint) {
      case ResponsiveBreakpoint.small:
        return 1;
      case ResponsiveBreakpoint.medium:
        return 2;
      case ResponsiveBreakpoint.large:
        return 3;
      case ResponsiveBreakpoint.xlarge:
        return 4;
    }
  }
}

/// 响应式断点枚举
enum ResponsiveBreakpoint {
  small,   // < 600px
  medium,  // 600-900px
  large,   // 900-1200px
  xlarge,  // >= 1200px
}

/// 响应式布局构建器
/// 提供不同断点下的布局构建
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveBreakpoint breakpoint) builder;
  final ResponsiveBreakpoint? breakpoint;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
    this.breakpoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ResponsiveUtil.init(context);
        final currentBreakpoint = breakpoint ?? ResponsiveUtil.breakpoint;
        return builder(context, currentBreakpoint);
      },
    );
  }
}

/// 响应式网格布局
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsets padding;
  final ResponsiveBreakpoint? breakpoint;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.padding = EdgeInsets.zero,
    this.breakpoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoint: breakpoint,
      builder: (context, breakpoint) {
        final columnCount = ResponsiveUtil.getColumnCount(breakpoint);
        return Padding(
          padding: padding,
          child: Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: children.map((child) {
              return SizedBox(
                width: (ResponsiveUtil.screenWidth - 
                       padding.left - 
                       padding.right - 
                       spacing * (columnCount - 1)) / columnCount,
                child: child,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

/// 响应式容器
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final ResponsiveBreakpoint? breakpoint;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.decoration,
    this.breakpoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoint: breakpoint,
      builder: (context, breakpoint) {
        double? responsiveWidth;
        double? responsiveHeight;

        if (width != null) {
          responsiveWidth = ResponsiveUtil.setWidth(width!);
        }
        if (height != null) {
          responsiveHeight = ResponsiveUtil.setHeight(height!);
        }

        return Container(
          width: responsiveWidth,
          height: responsiveHeight,
          margin: margin,
          padding: padding,
          decoration: decoration,
          child: child,
        );
      },
    );
  }
} 