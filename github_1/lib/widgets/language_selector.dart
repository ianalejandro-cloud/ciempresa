import 'package:ciempresas/core/i18n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  final Color? iconColor;
  final bool showText;

  const LanguageSelector({super.key, this.iconColor, this.showText = false});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale.languageCode;

    return InkWell(
      onTap: () {
        localeProvider.toggleLocale();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: iconColor ?? Colors.black87),
            if (showText) ...[
              const SizedBox(width: 8),
              Text(
                currentLocale == 'es' ? 'ES' : 'EN',
                style: TextStyle(
                  color: iconColor ?? Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
