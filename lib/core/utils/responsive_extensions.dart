import 'package:flutter/material.dart';
import 'responsive_util.dart';

/// 响应式工具语法糖扩展
/// 提供简洁的响应式尺寸设置方法

/// 数字扩展 - 提供响应式尺寸设置
extension ResponsiveExtension on num {
  /// 根据设计稿宽度适配
  /// 使用方式: 100.w
  double get w => ResponsiveUtil.setWidth(this.toDouble());
  
  /// 根据设计稿高度适配
  /// 使用方式: 200.h
  double get h => ResponsiveUtil.setHeight(this.toDouble());
  
  /// 根据设计稿宽度适配字体大小
  /// 使用方式: 16.sp
  double get sp => ResponsiveUtil.setSp(this.toDouble());
  
  /// 根据设计稿宽度适配半径
  /// 使用方式: 8.r
  double get r => ResponsiveUtil.setRadius(this.toDouble());
  
  /// 根据设计稿宽度适配边距
  /// 使用方式: 16.p
  double get p => ResponsiveUtil.setWidth(this.toDouble());
  
  /// 根据设计稿高度适配边距
  /// 使用方式: 16.ph
  double get ph => ResponsiveUtil.setHeight(this.toDouble());
}

/// EdgeInsets 扩展 - 提供响应式边距设置
extension ResponsiveEdgeInsetsExtension on EdgeInsets {
  /// 创建响应式边距
  /// 使用方式: EdgeInsets.all(16).r
  EdgeInsets get r => EdgeInsets.only(
    top: top > 0 ? top.w : 0,
    bottom: bottom > 0 ? bottom.w : 0,
    left: left > 0 ? left.w : 0,
    right: right > 0 ? right.w : 0,
  );
  
  /// 创建响应式垂直边距
  /// 使用方式: EdgeInsets.symmetric(vertical: 16).rv
  EdgeInsets get rv => EdgeInsets.only(
    top: top > 0 ? top.h : 0,
    bottom: bottom > 0 ? bottom.h : 0,
    left: left > 0 ? left.w : 0,
    right: right > 0 ? right.w : 0,
  );
}

/// 响应式 EdgeInsets 工厂方法
class ResponsiveEdgeInsets {
  /// 响应式全边距
  /// 使用方式: ResponsiveEdgeInsets.all(16)
  static EdgeInsets all(double value) => EdgeInsets.all(value.w);
  
  /// 响应式对称边距
  /// 使用方式: ResponsiveEdgeInsets.symmetric(horizontal: 16, vertical: 20)
  static EdgeInsets symmetric({
    double horizontal = 0,
    double vertical = 0,
  }) => EdgeInsets.symmetric(
    horizontal: horizontal.w,
    vertical: vertical.h,
  );
  
  /// 响应式指定边距
  /// 使用方式: ResponsiveEdgeInsets.only(left: 16, top: 20)
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: left.w,
    top: top.h,
    right: right.w,
    bottom: bottom.h,
  );
  
  /// 响应式水平边距
  /// 使用方式: ResponsiveEdgeInsets.horizontal(16)
  static EdgeInsets horizontal(double value) => EdgeInsets.symmetric(horizontal: value.w);
  
  /// 响应式垂直边距
  /// 使用方式: ResponsiveEdgeInsets.vertical(20)
  static EdgeInsets vertical(double value) => EdgeInsets.symmetric(vertical: value.h);
}

/// 响应式尺寸工厂方法
class ResponsiveSize {
  /// 响应式宽度
  /// 使用方式: ResponsiveSize.width(100)
  static double width(double value) => ResponsiveUtil.setWidth(value);
  
  /// 响应式高度
  /// 使用方式: ResponsiveSize.height(200)
  static double height(double value) => ResponsiveUtil.setHeight(value);
  
  /// 响应式字体大小
  /// 使用方式: ResponsiveSize.font(16)
  static double font(double value) => ResponsiveUtil.setSp(value);
  
  /// 响应式半径
  /// 使用方式: ResponsiveSize.radius(8)
  static double radius(double value) => ResponsiveUtil.setRadius(value);
}

/// 响应式 SizedBox 工厂方法
class ResponsiveSizedBox {
  /// 响应式宽度 SizedBox
  /// 使用方式: ResponsiveSizedBox.width(100)
  static SizedBox width(double width) => SizedBox(width: width.w);
  
  /// 响应式高度 SizedBox
  /// 使用方式: ResponsiveSizedBox.height(200)
  static SizedBox height(double height) => SizedBox(height: height.h);
  
  /// 响应式尺寸 SizedBox
  /// 使用方式: ResponsiveSizedBox.size(width: 100, height: 200)
  static SizedBox size({double? width, double? height}) => SizedBox(
    width: width?.w,
    height: height?.h,
  );
}

/// 响应式文本样式扩展
extension ResponsiveTextStyleExtension on TextStyle {
  /// 应用响应式字体大小
  /// 使用方式: TextStyle(fontSize: 16).r
  TextStyle get r => copyWith(fontSize: fontSize?.sp);
  
  /// 应用响应式行高
  /// 使用方式: TextStyle(height: 1.5).rh
  TextStyle get rh => copyWith(height: height?.h);
}

/// 响应式 BoxDecoration 扩展
extension ResponsiveBoxDecorationExtension on BoxDecoration {
  /// 应用响应式圆角
  /// 使用方式: BoxDecoration(borderRadius: BorderRadius.circular(8)).r
  BoxDecoration get r {
    if (borderRadius is BorderRadius) {
      final radius = borderRadius as BorderRadius;
      return copyWith(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.topLeft.x.r),
          topRight: Radius.circular(radius.topRight.x.r),
          bottomLeft: Radius.circular(radius.bottomLeft.x.r),
          bottomRight: Radius.circular(radius.bottomRight.x.r),
        ),
      );
    }
    return this;
  }
}

/// 响应式 BorderRadius 工厂方法
class ResponsiveBorderRadius {
  /// 响应式圆形圆角
  /// 使用方式: ResponsiveBorderRadius.circular(8)
  static BorderRadius circular(double radius) => BorderRadius.circular(radius.r);
  
  /// 响应式指定圆角
  /// 使用方式: ResponsiveBorderRadius.only(topLeft: 8, topRight: 12)
  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(topLeft.r),
    topRight: Radius.circular(topRight.r),
    bottomLeft: Radius.circular(bottomLeft.r),
    bottomRight: Radius.circular(bottomRight.r),
  );
  
  /// 响应式水平圆角
  /// 使用方式: ResponsiveBorderRadius.horizontal(left: 8, right: 8)
  static BorderRadius horizontal({
    double left = 0,
    double right = 0,
  }) => BorderRadius.horizontal(
    left: Radius.circular(left.r),
    right: Radius.circular(right.r),
  );
  
  /// 响应式垂直圆角
  /// 使用方式: ResponsiveBorderRadius.vertical(top: 8, bottom: 8)
  static BorderRadius vertical({
    double top = 0,
    double bottom = 0,
  }) => BorderRadius.vertical(
    top: Radius.circular(top.r),
    bottom: Radius.circular(bottom.r),
  );
}

/// 响应式 Shadow 工厂方法
class ResponsiveShadow {
  /// 响应式阴影
  /// 使用方式: ResponsiveShadow.offset(blurRadius: 10, offset: Offset(0, 4))
  static BoxShadow offset({
    Color color = const Color(0x29000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    double spreadRadius = 0.0,
  }) => BoxShadow(
    color: color,
    offset: Offset(offset.dx.w, offset.dy.h),
    blurRadius: blurRadius.r,
    spreadRadius: spreadRadius.r,
  );
  
  /// 响应式模糊阴影
  /// 使用方式: ResponsiveShadow.blur(10)
  static BoxShadow blur(double blurRadius) => BoxShadow(
    color: const Color(0x29000000),
    blurRadius: blurRadius.r,
  );
}

/// 响应式动画持续时间扩展
extension ResponsiveDurationExtension on Duration {
  /// 响应式动画持续时间
  /// 使用方式: Duration(milliseconds: 300).r
  Duration get r {
    // 根据屏幕尺寸调整动画时长，大屏幕动画稍慢
    final factor = ResponsiveUtil.screenWidth > 600 ? 1.2 : 1.0;
    return Duration(milliseconds: (inMilliseconds * factor).round());
  }
}

/// 响应式动画曲线扩展
extension ResponsiveCurveExtension on Curve {
  /// 响应式动画曲线
  /// 使用方式: Curves.easeInOut.r
  Curve get r => this; // 可以根据需要调整曲线
}

/// 响应式动画工厂方法
class ResponsiveAnimation {
  /// 响应式动画持续时间
  /// 使用方式: ResponsiveAnimation.duration(300)
  static Duration duration(int milliseconds) => Duration(milliseconds: milliseconds).r;
  
  /// 响应式动画曲线
  /// 使用方式: ResponsiveAnimation.curve(Curves.easeInOut)
  static Curve curve(Curve curve) => curve.r;
} 