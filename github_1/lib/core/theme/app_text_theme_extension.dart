import 'package:flutter/material.dart';

/// `ThemeExtension` template for custom text styles.
///
/// If your goal is to only change the text color for light/dark mode, I don't see a big benefit from this extension.
/// For the default text style in the Text widget, you can set `textTheme.bodyMedium` in `ThemeData` (example: lib/app_theme.dart).
/// And to set text color for specific widgets, you can use `style: TextStyle(color: Theme.of(context).appColors.error)` or
/// `style: AppTypography.h1.copyWith(color: context.theme.appColors.error)`.
class AppTextThemeExtension extends ThemeExtension<AppTextThemeExtension> {
  const AppTextThemeExtension({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
  });

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;

  @override
  ThemeExtension<AppTextThemeExtension> copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
  }) {
    return AppTextThemeExtension(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
    );
  }

  @override
  ThemeExtension<AppTextThemeExtension> lerp(
    covariant ThemeExtension<AppTextThemeExtension>? other,
    double t,
  ) {
    if (other is! AppTextThemeExtension) {
      return this;
    }

    return AppTextThemeExtension(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
    );
  }
}

/// Small version. Used as an example in lib/app_theme.dart.
class SimpleAppTextThemeExtension
    extends ThemeExtension<SimpleAppTextThemeExtension> {
  const SimpleAppTextThemeExtension({
    required this.body1,
    required this.h1,
    required this.title,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.title4,
    required this.cardTitle,
    required this.cardSubtitle,
    required this.textFieldInput,
    required this.textFieldDisabledInput,
    required this.linkQuestion,
    required this.pinCodeInput,
    required this.verificationCodeLabel,
    required this.linkTextLabel,
    required this.menuoption,
  });

  final TextStyle body1;
  final TextStyle h1;
  final TextStyle title;
  final TextStyle title1;
  final TextStyle title2;
  final TextStyle title3;
  final TextStyle title4;
  final TextStyle cardTitle;
  final TextStyle cardSubtitle;
  final TextStyle textFieldInput;
  final TextStyle textFieldDisabledInput;
  final TextStyle linkQuestion;
  final TextStyle pinCodeInput;
  final TextStyle verificationCodeLabel;
  final TextStyle linkTextLabel;
  final TextStyle menuoption;

  @override
  ThemeExtension<SimpleAppTextThemeExtension> copyWith({
    TextStyle? body1,
    TextStyle? h1,
    TextStyle? title,
    TextStyle? title1,
    TextStyle? title2,
    TextStyle? title3,
    TextStyle? title4,
    TextStyle? cardTitle,
    TextStyle? cardSubtitle,
    TextStyle? textFieldInput,
    TextStyle? textFieldDisabledInput,
    TextStyle? affiliationText,
    TextStyle? pinCodeInput,
    TextStyle? verificationCodeLabel,
    TextStyle? linkTextLabel,
    TextStyle? menuoption,
  }) {
    return SimpleAppTextThemeExtension(
      body1: body1 ?? this.body1,
      h1: h1 ?? this.h1,
      title: title ?? this.title,
      title1: title1 ?? this.title1,
      title2: title2 ?? this.title2,
      title3: title2 ?? this.title3,
      title4: title4 ?? this.title4,
      cardTitle: cardTitle ?? this.cardTitle,
      cardSubtitle: cardSubtitle ?? this.cardSubtitle,
      textFieldInput: textFieldInput ?? this.textFieldInput,
      textFieldDisabledInput:
          textFieldDisabledInput ?? this.textFieldDisabledInput,
      linkQuestion: affiliationText ?? linkQuestion,
      pinCodeInput: pinCodeInput ?? this.pinCodeInput,
      verificationCodeLabel:
          verificationCodeLabel ?? this.verificationCodeLabel,
      linkTextLabel: linkTextLabel ?? this.linkTextLabel,
      menuoption: menuoption ?? this.menuoption,
    );
  }

  @override
  ThemeExtension<SimpleAppTextThemeExtension> lerp(
    covariant ThemeExtension<SimpleAppTextThemeExtension>? other,
    double t,
  ) {
    if (other is! SimpleAppTextThemeExtension) {
      return this;
    }

    return SimpleAppTextThemeExtension(
      body1: TextStyle.lerp(body1, other.body1, t)!,
      h1: TextStyle.lerp(h1, other.h1, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      title1: TextStyle.lerp(title1, other.title1, t)!,
      title2: TextStyle.lerp(title2, other.title2, t)!,
      title3: TextStyle.lerp(title3, other.title3, t)!,
      title4: TextStyle.lerp(title4, other.title4, t)!,
      cardTitle: TextStyle.lerp(cardTitle, other.cardTitle, t)!,
      cardSubtitle: TextStyle.lerp(cardSubtitle, other.cardSubtitle, t)!,
      textFieldInput: TextStyle.lerp(textFieldInput, other.textFieldInput, t)!,
      textFieldDisabledInput: TextStyle.lerp(
        textFieldDisabledInput,
        other.textFieldDisabledInput,
        t,
      )!,
      linkQuestion: TextStyle.lerp(linkQuestion, other.linkQuestion, t)!,
      pinCodeInput: TextStyle.lerp(pinCodeInput, other.pinCodeInput, t)!,
      verificationCodeLabel: TextStyle.lerp(
        verificationCodeLabel,
        other.verificationCodeLabel,
        t,
      )!,
      linkTextLabel: TextStyle.lerp(linkTextLabel, other.linkTextLabel, t)!,
      menuoption: TextStyle.lerp(menuoption, other.menuoption, t)!,
    );
  }
}
