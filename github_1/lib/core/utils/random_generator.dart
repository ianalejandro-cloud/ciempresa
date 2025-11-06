import 'dart:math';

/// Una clase de utilidad para generar valores aleatorios.
class RandomGenerator {
  /// Genera una cadena de 8 dígitos numéricos aleatorios.
  ///
  /// El resultado es una cadena que puede incluir ceros a la izquierda,
  /// por ejemplo, "01234567".
  static String generateEightDigitString() {
    final random = Random();
    final buffer = StringBuffer();
    for (int i = 0; i < 8; i++) {
      buffer.write(random.nextInt(10));
    }
    return buffer.toString();
  }
}
