import 'package:flutter/material.dart';

@immutable
class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;
  final Color color5;
  final Color color6;
  final Color disabled;

  const CustomThemeColors({
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
    required this.color5,
    required this.color6,
    required this.disabled,
  });

  @override
  CustomThemeColors copyWith({
    Color? color1,
    Color? color2,
    Color? color3,
    Color? color4,
    Color? color5,
    Color? color6,
    Color? disabled,
  }) {
    return CustomThemeColors(
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      color3: color3 ?? this.color3,
      color4: color4 ?? this.color4,
      color5: color5 ?? this.color5,
      color6: color6 ?? this.color6,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  ThemeExtension<CustomThemeColors> lerp(
      ThemeExtension<CustomThemeColors>? other, double t) {
    if (other is! CustomThemeColors) return this;
    return CustomThemeColors(
      color1: Color.lerp(color1, other.color1, t)!,
      color2: Color.lerp(color2, other.color2, t)!,
      color3: Color.lerp(color3, other.color3, t)!,
      color4: Color.lerp(color4, other.color4, t)!,
      color5: Color.lerp(color5, other.color5, t)!,
      color6: Color.lerp(color6, other.color6, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
    );
  }
}
