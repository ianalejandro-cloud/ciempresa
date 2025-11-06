import 'package:flutter/material.dart';

class ResendTextLink extends StatelessWidget {
  final String text1;
  final String text2;
  final TextStyle textStyle1;
  final TextStyle textStyle2;
  final VoidCallback onTap;

  const ResendTextLink({
    super.key,
    required this.text1,
    required this.text2,
    required this.textStyle1,
    required this.textStyle2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double baseFontSize = 15;
        double minFontSize = 10;
        double fontSize = baseFontSize;

        final textPainter1 = TextPainter(
          text: TextSpan(
            text: text1,
            style: textStyle1.copyWith(fontSize: fontSize),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );
        final textPainter2 = TextPainter(
          text: TextSpan(
            text: text2,
            style: textStyle2.copyWith(fontSize: fontSize),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );

        double totalWidth = 0;
        do {
          textPainter1.text = TextSpan(
            text: text1,
            style: textStyle1.copyWith(fontSize: fontSize),
          );
          textPainter2.text = TextSpan(
            text: text2,
            style: textStyle2.copyWith(fontSize: fontSize),
          );
          textPainter1.layout();
          textPainter2.layout();
          totalWidth = textPainter1.width + 4 + textPainter2.width;
          if (totalWidth > constraints.maxWidth && fontSize > minFontSize) {
            fontSize -= 1;
          } else {
            break;
          }
        } while (fontSize > minFontSize);

        return SizedBox(
          width: constraints.maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  text1,
                  style: textStyle1.copyWith(fontSize: fontSize),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  text2,
                  style: textStyle2.copyWith(fontSize: fontSize),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
