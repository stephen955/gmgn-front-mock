import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color secondary;
  final Color accentDanger;
  final Color textPrimary;
  final Color textSecondary;
  final Color background;

  const AppColorsExtension({
    required this.primary,
    required this.secondary,
    required this.accentDanger,
    required this.textPrimary,
    required this.textSecondary,
    required this.background,
  });

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? secondary,
    Color? accentDanger,
    Color? textPrimary,
    Color? textSecondary,
    Color? background,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accentDanger: accentDanger ?? this.accentDanger,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      background: background ?? this.background,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accentDanger: Color.lerp(accentDanger, other.accentDanger, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      background: Color.lerp(background, other.background, t)!,
    );
  }
}

@immutable
class AppSpacingExtension extends ThemeExtension<AppSpacingExtension> {
  final double small;
  final double medium;
  final double normal;
  final double large;
  final double xl;

  const AppSpacingExtension({
    this.small = 4.0,
    this.medium = 8.0,
    this.normal = 12.0,
    this.large = 16.0,
    this.xl = 24.0,
  });

  @override
  AppSpacingExtension copyWith({
    double? small,
    double? medium,
    double? normal,
    double? large,
    double? xl,
  }) {
    return AppSpacingExtension(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      normal: normal ?? this.normal,
      large: large ?? this.large,
      xl: xl ?? this.xl,
    );
  }

  @override
  AppSpacingExtension lerp(ThemeExtension<AppSpacingExtension>? other, double t) {
    if (other is! AppSpacingExtension) return this;
    return AppSpacingExtension(
      small: lerpDouble(small, other.small, t),
      medium: lerpDouble(medium, other.medium, t),
      normal: lerpDouble(normal, other.normal, t),
      large: lerpDouble(large, other.large, t),
      xl: lerpDouble(xl, other.xl, t),
    );
  }
}

double lerpDouble(double a, double b, double t) => a + (b - a) * t;

@immutable
class AppRadiusExtension extends ThemeExtension<AppRadiusExtension> {
  final double small;
  final double medium;
  final double normal;
  final double large;
  final double card;

  const AppRadiusExtension({
    this.small = 4.0,
    this.medium = 8.0,
    this.normal = 8.0,
    this.large = 12.0,
    this.card = 10.0,
  });

  @override
  AppRadiusExtension copyWith({double? small, double? medium, double? normal, double? large, double? card}) {
    return AppRadiusExtension(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      normal: normal ?? this.normal,
      large: large ?? this.large,
      card: card ?? this.card,
    );
  }

  @override
  AppRadiusExtension lerp(ThemeExtension<AppRadiusExtension>? other, double t) {
    if (other is! AppRadiusExtension) return this;
    return AppRadiusExtension(
      small: lerpDouble(small, other.small, t),
      medium: lerpDouble(medium, other.medium, t),
      normal: lerpDouble(normal, other.normal, t),
      large: lerpDouble(large, other.large, t),
      card: lerpDouble(card, other.card, t),
    );
  }
}

@immutable
class AppShadowsExtension extends ThemeExtension<AppShadowsExtension> {
  final List<BoxShadow> card;

  const AppShadowsExtension({
    this.card = const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.05),
        offset: Offset(0, 4),
        blurRadius: 16,
      ),
    ],
  });

  @override
  AppShadowsExtension copyWith({List<BoxShadow>? card}) {
    return AppShadowsExtension(
      card: card ?? this.card,
    );
  }

  @override
  AppShadowsExtension lerp(ThemeExtension<AppShadowsExtension>? other, double t) {
    if (other is! AppShadowsExtension) return this;
    // 只做简单插值，实际可根据需求扩展
    return AppShadowsExtension(card: card);
  }
}

@immutable
class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle body;
  final TextStyle caption;

  const AppTypographyExtension({
    required this.h1,
    required this.h2,
    required this.body,
    required this.caption,
  });

  @override
  AppTypographyExtension copyWith({
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? body,
    TextStyle? caption,
  }) {
    return AppTypographyExtension(
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      body: body ?? this.body,
      caption: caption ?? this.caption,
    );
  }

  @override
  AppTypographyExtension lerp(ThemeExtension<AppTypographyExtension>? other, double t) {
    if (other is! AppTypographyExtension) return this;
    return AppTypographyExtension(
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }
}

@immutable
class AppButtonStyleExtension extends ThemeExtension<AppButtonStyleExtension> {
  final ButtonStyle primary;
  final ButtonStyle primaryDisabled;
  final ButtonStyle outline;
  final ButtonStyle icon;

  const AppButtonStyleExtension({
    required this.primary,
    required this.primaryDisabled,
    required this.outline,
    required this.icon,
  });

  @override
  AppButtonStyleExtension copyWith({
    ButtonStyle? primary,
    ButtonStyle? primaryDisabled,
    ButtonStyle? outline,
    ButtonStyle? icon,
  }) {
    return AppButtonStyleExtension(
      primary: primary ?? this.primary,
      primaryDisabled: primaryDisabled ?? this.primaryDisabled,
      outline: outline ?? this.outline,
      icon: icon ?? this.icon,
    );
  }

  @override
  AppButtonStyleExtension lerp(ThemeExtension<AppButtonStyleExtension>? other, double t) {
    if (other is! AppButtonStyleExtension) return this;
    // ButtonStyle 不支持 lerp，直接返回当前实例
    return this;
  }
}

@immutable
class AppInputDecorationExtension extends ThemeExtension<AppInputDecorationExtension> {
  final InputDecoration normal;
  final InputDecoration Function(IconData, {String? hintText}) withIcon;

  const AppInputDecorationExtension({
    required this.normal,
    required this.withIcon,
  });

  @override
  AppInputDecorationExtension copyWith({
    InputDecoration? normal,
    InputDecoration Function(IconData, {String? hintText})? withIcon,
  }) {
    return AppInputDecorationExtension(
      normal: normal ?? this.normal,
      withIcon: withIcon ?? this.withIcon,
    );
  }

  @override
  AppInputDecorationExtension lerp(ThemeExtension<AppInputDecorationExtension>? other, double t) {
    if (other is! AppInputDecorationExtension) return this;
    return this;
  }
}

@immutable
class AppCardStyleExtension extends ThemeExtension<AppCardStyleExtension> {
  final BoxDecoration card;
  final EdgeInsets padding;

  const AppCardStyleExtension({
    required this.card,
    required this.padding,
  });

  @override
  AppCardStyleExtension copyWith({BoxDecoration? card, EdgeInsets? padding}) {
    return AppCardStyleExtension(
      card: card ?? this.card,
      padding: padding ?? this.padding,
    );
  }

  @override
  AppCardStyleExtension lerp(ThemeExtension<AppCardStyleExtension>? other, double t) {
    if (other is! AppCardStyleExtension) return this;
    return this;
  }
} 