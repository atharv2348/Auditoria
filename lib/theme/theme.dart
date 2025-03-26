import 'package:auditoria/theme/theme_extension.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: CustomColors.color3,
    appBarTheme:
        const AppBarTheme(color: CustomColors.color1, centerTitle: true),
    extensions: const [
      CustomThemeColors(
        color1: CustomColors.color1,
        color2: CustomColors.color2,
        color3: CustomColors.color3,
        color4: CustomColors.color4,
        color5: CustomColors.color5,
        color6: CustomColors.color6,
        disabled: CustomColors.disabled,
      ),
    ],
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: CustomColorsDark.color3,
    appBarTheme:
        const AppBarTheme(color: CustomColorsDark.color1, centerTitle: true),
    extensions: const [
      CustomThemeColors(
        color1: CustomColorsDark.color1,
        color2: CustomColorsDark.color2,
        color3: CustomColorsDark.color3,
        color4: CustomColorsDark.color4,
        color5: CustomColorsDark.color5,
        color6: CustomColorsDark.color6,
        disabled: CustomColorsDark.disabled,
      ),
    ],
  );
}
