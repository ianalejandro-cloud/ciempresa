import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// An example of an alternative way to group text styles
// can be found in the `lib/app_palette.dart` file.
abstract class AppTypography {
  static const body1 = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

  static const h1 = TextStyle(fontSize: 49, fontWeight: FontWeight.w300);

  static final title = GoogleFonts.lato(fontSize: 24);
  static final title1 = GoogleFonts.lato(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );
  static final title2 = GoogleFonts.lato(fontSize: 12);
  static final title3 = GoogleFonts.raleway(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static final title4 = GoogleFonts.raleway(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  // Estilo específico para títulos de pantallas de afiliación
  static final cardTitle = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w400, // 400 corresponde a FontWeight.normal
    height: 1.0, // line-height: 24px / font-size: 24px = 1.0
    letterSpacing: 0.0,
  );

  // Estilo específico para subtítulos de pantallas de afiliación
  static final cardSubtitle = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400, // 400 corresponde a FontWeight.normal
    height: 1.357, // line-height: 19px / font-size: 14px = 1.357
    letterSpacing: 0.28, // 2% de 14px = 0.28px
  );

  // Estilo específico para texto de entrada de usuario en campos de texto
  static final textFieldInput = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500, // 500 corresponde a FontWeight.w500
    height: 1.5, // line-height: 24px / font-size: 16px = 1.5
    letterSpacing: 0.0, // 0% letter-spacing
  );

  // Estilo específico para texto de entrada deshabilitado en campos de texto
  static final textFieldDisabledInput = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500, // 500 corresponde a FontWeight.w500
    height: 1.5, // line-height: 24px / font-size: 16px = 1.5
    letterSpacing: 0.0, // 0% letter-spacing
    // El color se aplicará en el tema
  );

  // Estilo específico para texto de afiliación
  static final linkQuestion = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400, // 400 corresponde a FontWeight.normal
    letterSpacing: 0.0, // 0% letter-spacing
    //color: const Color.fromRGBA(58, 62, 73, 1), // rgba(58, 62, 73, 1)
  );

  // Estilo específico para entrada de código PIN
  static final pinCodeInput = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400, // 400 corresponde a FontWeight.normal
    height: 1.714, // line-height: 24px / font-size: 14px = 1.714
    letterSpacing: 0.0, // 0% letter-spacing
  );

  // Estilo específico para etiqueta de código de verificación
  static final verificationCodeLabel = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w700, // 700 corresponde a FontWeight.bold
    height: 1.0, // line-height: 100% / font-size: 12px = 1.0
    letterSpacing: 0.0, // 0% letter-spacing
  );

  // Estilo específico para texto de enlace como "reenviar"
  static final linkTextLabel = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w700, // 700 corresponde a FontWeight.bold
    height: 1.0, // line-height: 100% / font-size: 14px = 1.0
    letterSpacing: 0.0, // 0% letter-spacing
  );

  static final menuoption = GoogleFonts.montserrat(
    fontSize: 15,
    fontWeight: FontWeight.w400, // 400 corresponde a FontWeight.normal
    letterSpacing: 0.0, // 0% letter-spacing
    //color: const Color.fromRGBA(58, 62, 73, 1), // rgba(58, 62, 73, 1)
  );
}
