import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_context_ext.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;

  const AuthTextField({
    required this.hint,
    this.obscureText = false,
    required this.controller,
    this.validator,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.hintStyle,
    this.suffixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final typography = context.appTypography;
    // 默认圆角 12px
    final radius = borderRadius ?? BorderRadius.circular(12);

    return TextFormField(
      cursorColor: Color(0xFF00C08B),
      controller: controller,
      obscureText: obscureText,
      validator: validator,

      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF333333),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintStyle ??
            typography.body.copyWith(
              color: colors.textSecondary.withOpacity(0.4),
            ),
        filled: true,
        fillColor: fillColor ?? const Color(0xFFE6E6E6),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        // 后缀图标和约束
        suffixIcon: suffixIcon,
        suffixIconConstraints:
        const BoxConstraints(minWidth: 40, minHeight: 40),
        // 默认/可用状态下 1px 浅灰边框
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(
            color: Color(0xFFE6E6E6),
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(
            color: Color(0xFFE6E6E6),
            width: 0.5,
          ),
        ),
        // 焦点状态下 1px 主色 20% 透明
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: Colors.black38,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}