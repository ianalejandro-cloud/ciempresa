import 'package:ciempresas/core/theme/app_colors_extension.dart';
import 'package:ciempresas/core/theme/app_text_theme_extension.dart';
import 'package:ciempresas/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Simple Flutter app theme with `ChangeNotifier` and `ThemeExtension`.
/// With support for changing between light/dark mode.
///
/// You can also register it in `get_it` or any other package you use.
class AppTheme with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  //
  // Light theme
  //

  static final light = () {
    final defaultTheme = ThemeData.light();

    return defaultTheme.copyWith(
      textTheme: defaultTheme.textTheme.copyWith(
        // Default text style for Text widget.
        bodyMedium: AppTypography.body1.copyWith(color: Colors.black),
      ),
      extensions: [_lightAppColors, _lightTextTheme],
    );
  }();

  static final _lightAppColors = AppColorsExtension(
    primary: const Color(0xFF000001),
    onPrimary: const Color(0xffD0D5DD),
    secondary: const Color(0xFFF8F9FA),
    onSecondary: const Color(0xff8C213F),
    tertiary: const Color(0xffF2F4F7),
    onTertiary: Colors.grey.shade50,
    error: const Color(0xffBA1A1A),
    onError: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    surface: const Color(0xff8C213F),
    onSurface: const Color(0xff191C20),
    customGreen: const Color(0xFF95C60F),
    customGreenDark: const Color(0xFF54B370),
    customRed: const Color(0xFFfbecec),
    customRedDark: const Color(0xffe25048),
    customGrey: const Color(0xFFEDEFF1),
    dark: const Color(0xff8c213f),
    light: const Color(0xffF2F4F7),
    grey25: const Color(0xffFCFCFD),
    grey100: const Color(0xffF2F4F7),
    grey200: const Color(0xffEAECF0),
    grey300: const Color(0xffD0D5DD),
    grey400: const Color(0xff98A2B3),
    grey500: const Color(0xff667085),
    grey600: const Color(0xff475467),
    grey800: const Color(0xff1D2939),
    coal: const Color.fromRGBO(
      16,
      16,
      16,
      1,
    ), // Color Coal según especificación
  );

  static final _lightTextTheme = SimpleAppTextThemeExtension(
    body1: AppTypography.body1.copyWith(color: _lightAppColors.onBackground),
    h1: AppTypography.h1.copyWith(color: Colors.black),
    title: AppTypography.title.copyWith(color: Colors.black),
    title1: AppTypography.title1.copyWith(color: const Color(0xff8C213F)),
    title2: AppTypography.title2.copyWith(color: Colors.black),
    title3: AppTypography.title3.copyWith(color: const Color(0xff234F68)),
    title4: AppTypography.title4.copyWith(color: Colors.black),
    cardTitle: AppTypography.cardTitle.copyWith(color: const Color(0xFF222222)),
    cardSubtitle: AppTypography.cardSubtitle.copyWith(
      color: const Color(0xFF707070),
    ),
    textFieldInput: AppTypography.textFieldInput.copyWith(
      color: const Color.fromRGBO(16, 16, 16, 1),
    ),
    textFieldDisabledInput: AppTypography.textFieldDisabledInput.copyWith(
      color: const Color.fromRGBO(
        159,
        162,
        177,
        1,
      ), // Color gris para campos deshabilitados
    ),
    linkQuestion: AppTypography.linkQuestion,
    pinCodeInput: AppTypography.pinCodeInput.copyWith(
      color: const Color.fromRGBO(16, 16, 16, 1),
    ),
    verificationCodeLabel: AppTypography.verificationCodeLabel.copyWith(
      color: const Color.fromRGBO(58, 62, 73, 1),
    ),
    linkTextLabel: AppTypography.linkTextLabel.copyWith(
      color: const Color.fromRGBO(44, 118, 142, 1),
    ),
    menuoption: AppTypography.menuoption.copyWith(color: Colors.black),
  );

  //
  // Dark theme
  //

  static final dark = () {
    final defaultTheme = ThemeData.dark();

    return defaultTheme.copyWith(
      textTheme: defaultTheme.textTheme.copyWith(
        // Default text style for Text widget.
        bodyMedium: AppTypography.body1.copyWith(color: Colors.white),
      ),
      extensions: [_darkAppColors, _darkTextTheme],
    );
  }();

  static final _darkAppColors = AppColorsExtension(
    primary: const Color(0xFF000001),
    onPrimary: const Color(0xffD0D5DD),
    secondary: const Color(0xFFF8F9FA),
    onSecondary: const Color(0xff8C213F),
    tertiary: const Color(0xffF2F4F7),
    onTertiary: Colors.grey.shade50,
    error: const Color(0xffBA1A1A),
    onError: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    surface: const Color(0xff8C213F),
    onSurface: const Color(0xff191C20),
    customGreen: const Color(0xFF95C60F),
    customGreenDark: const Color(0xFF54B370),
    customRed: const Color(0xFFCC3E34),
    customRedDark: const Color(0xffe25048),
    customGrey: const Color(0xFFEDEFF1),
    dark: const Color(0xff8c213f),
    light: const Color(0xffF2F4F7),
    grey25: const Color(0xffFCFCFD),
    grey100: const Color(0xffF2F4F7),
    grey200: const Color(0xffEAECF0),
    grey300: const Color(0xffD0D5DD),
    grey400: const Color(0xff98A2B3),
    grey500: const Color(0xff667085),
    grey600: const Color(0xff475467),
    grey800: const Color(0xff1D2939),
    coal: const Color.fromRGBO(
      16,
      16,
      16,
      1,
    ), // Color Coal según especificación
  );

  static final _darkTextTheme = SimpleAppTextThemeExtension(
    body1: AppTypography.body1.copyWith(color: _lightAppColors.onBackground),
    h1: AppTypography.h1.copyWith(color: Colors.black),
    title: AppTypography.title.copyWith(color: Colors.black),
    title1: AppTypography.title1.copyWith(color: const Color(0xff8C213F)),
    title2: AppTypography.title2.copyWith(color: Colors.black),
    title3: AppTypography.title3.copyWith(color: const Color(0xff234F68)),
    title4: AppTypography.title4.copyWith(color: Colors.black),
    cardTitle: AppTypography.cardTitle.copyWith(color: const Color(0xFF222222)),
    cardSubtitle: AppTypography.cardSubtitle.copyWith(
      color: const Color(0xFF707070),
    ),
    textFieldInput: AppTypography.textFieldInput.copyWith(
      color: const Color.fromRGBO(16, 16, 16, 1),
    ),
    textFieldDisabledInput: AppTypography.textFieldDisabledInput.copyWith(
      color: const Color.fromRGBO(
        159,
        162,
        177,
        1,
      ), // Color gris para campos deshabilitados
    ),
    linkQuestion: AppTypography.linkQuestion.copyWith(
      color: const Color.fromRGBO(58, 62, 73, 1),
    ),
    pinCodeInput: AppTypography.pinCodeInput.copyWith(
      color: const Color.fromRGBO(16, 16, 16, 1),
    ),
    verificationCodeLabel: AppTypography.verificationCodeLabel.copyWith(
      color: const Color.fromRGBO(58, 62, 73, 1),
    ),
    linkTextLabel: AppTypography.linkTextLabel.copyWith(
      color: const Color.fromRGBO(44, 118, 142, 1),
    ),
    menuoption: AppTypography.menuoption.copyWith(color: Colors.black),
  );
}

/// Here you should define getters for your `ThemeExtension`s.
///
/// Never use `Theme.of(context).extension<MyColors>()!`
/// how they do it in the [official documentation](https://api.flutter.dev/flutter/material/ThemeExtension-class.html),
/// because it's not safe. Always create a getter for your `ThemeExtension` and use it instead.
///
/// Usage example: `Theme.of(context).appColors`.
extension AppThemeExtension on ThemeData {
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? AppTheme._lightAppColors;

  SimpleAppTextThemeExtension get appTextTheme =>
      extension<SimpleAppTextThemeExtension>() ?? AppTheme._lightTextTheme;
}

/// A more convenient way to get `ThemeData` from the `BuildContext`.
///
/// Usage example: `context.theme`.
extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}
