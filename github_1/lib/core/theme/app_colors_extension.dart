import 'package:flutter/material.dart';

/// `ThemeExtension` template for custom colors.
///
/// For example purposes, it has all required fields from the default Material `ColorScheme`.
/// But you can add, rename and delete any fields your need.
///
/// ### Motivation
///
/// At the beginning, you may not know if your colors will fit into the Material `ColorScheme`,
/// but you still decided to start using `ColorScheme`, and only then realize that you need additional fields.
/// You will create `ThemeExtension` for only the additional fields, and as the result, you will have your colors
/// scattered between the `ColorScheme` and `ThemeExtension` with a few extra colors.
///
/// With this template, you can collect all fields in one place,
/// and don't worry about future changes to the Material or your design.
///
/// Or you can just quickly copy-paste this file and rename fields to your needs.
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.error,
    required this.onError,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.customGreen,
    required this.customGreenDark,
    required this.customRed,
    required this.customRedDark,
    required this.customGrey,
    required this.dark,
    required this.light,
    required this.grey25,
    required this.grey100,
    required this.grey200,
    required this.grey300,
    required this.grey400,
    required this.grey500,
    required this.grey600,
    required this.grey800,
    required this.coal, 
  });

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color tertiary;
  final Color onTertiary;
  final Color onSecondary;
  final Color error;
  final Color onError;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color customGreen;
  final Color customGreenDark;
  final Color customRed;
  final Color customRedDark;
  final Color customGrey;
  final Color dark;
  final Color light;
  final Color grey25;
  final Color grey100;
  final Color grey200;
  final Color grey300;
  final Color grey400;
  final Color grey500;
  final Color grey600;
  final Color grey800;
  final Color coal;

  @override
  ThemeExtension<AppColorsExtension> copyWith(
      {Color? primary,
      Color? onPrimary,
      Color? secondary,
      Color? onSecondary,
      Color? tertiary,
      Color? onTertiary,
      Color? error,
      Color? onError,
      Color? background,
      Color? onBackground,
      Color? surface,
      Color? onSurface,
      Color? customGreen,
      Color? customGreenDark,
      Color? customRed,
      Color? customRedDark,
      Color? customGrey,
      Color? dark,
      Color? light,
      Color? grey25,
      Color? grey100,
      Color? grey200,
      Color? grey300,
      Color? grey400,
      Color? grey500,
      Color? grey600,
      Color? grey800,
      Color? coal}) {
    return AppColorsExtension(
        primary: primary ?? this.primary,
        onPrimary: onPrimary ?? this.onPrimary,
        secondary: secondary ?? this.secondary,
        onSecondary: onSecondary ?? this.onSecondary,
        tertiary: tertiary ?? this.tertiary,
        onTertiary: onTertiary ?? this.onTertiary,
        error: error ?? this.error,
        onError: onError ?? this.onError,
        background: background ?? this.background,
        onBackground: onBackground ?? this.onBackground,
        surface: surface ?? this.surface,
        onSurface: onSurface ?? this.onSurface,
        customGreen: customGreen ?? this.customGreen,
        customGreenDark: customGreenDark ?? this.customGreenDark,
        customRed: customRed ?? this.customRed,
        customRedDark: customRedDark ?? this.customRedDark,
        customGrey: customGrey ?? this.customGrey,
        dark: dark ?? this.dark,
        light: light ?? this.light,
        grey25: grey25 ?? this.grey25,
        grey100: grey100 ?? this.grey100,
        grey200: grey200 ?? this.grey200,
        grey300: grey300 ?? this.grey300,
        grey400: grey400 ?? this.grey400,
        grey500: grey500 ?? this.grey500,
        grey600: grey600 ?? this.grey600,
        grey800: grey800 ?? this.grey800,
        coal: coal ?? this.coal);
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      customGreen: Color.lerp(customGreen, other.customGreen, t)!,
      customGreenDark: Color.lerp(customGreenDark, other.customGreenDark, t)!,
      customRed: Color.lerp(customRed, other.customRed, t)!,
      customRedDark: Color.lerp(customRedDark, other.customRedDark, t)!,
      customGrey: Color.lerp(customGrey, other.customGrey, t)!,
      dark: Color.lerp(dark, other.dark, t)!,
      light: Color.lerp(light, other.light, t)!,
      grey25: Color.lerp(grey25, other.grey25, t)!,
      grey100: Color.lerp(grey100, other.grey100, t)!,
      grey200: Color.lerp(grey200, other.grey200, t)!,
      grey300: Color.lerp(grey300, other.grey300, t)!,
      grey400: Color.lerp(grey400, other.grey400, t)!,
      grey500: Color.lerp(grey500, other.grey500, t)!,
      grey600: Color.lerp(grey600, other.grey600, t)!,
      grey800: Color.lerp(grey800, other.grey800, t)!,
      coal: Color.lerp(coal, other.coal, t)!,
    );
  }
}

/// Optional. If you also want to assign colors in the `ColorScheme`.
extension ColorSchemeBuilder on AppColorsExtension {
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface,
    );
  }
}
