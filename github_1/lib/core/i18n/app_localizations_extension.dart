import 'package:flutter/material.dart';
import 'app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get i18n => AppLocalizations.of(this);
  
  String tr(String key) => AppLocalizations.of(this).translate(key);
}