import 'dart:math';

/// Una clase para generar cadenas de caracteres aleatorias.
///
/// Similar a un juego de Scrabble, puede generar palabras aleatorias
/// o basarse en una palabra existente para crear una nueva.
class RandomWordGenerator {
  static const String _chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final Random _rnd = Random();

  /// Genera una cadena de caracteres puramente aleatoria de una longitud específica.
  ///
  /// [length]: La longitud deseada de la cadena. Por defecto es 8.
  String generateRandomWord({int length = 8}) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
      ),
    );
  }

  /// Genera una nueva cadena basada en una [baseWord].
  ///
  /// Mezcla los caracteres de la [baseWord] y luego ajusta
  /// su longitud a la [length] especificada, ya sea truncándola o
  /// rellenándola con caracteres aleatorios.
  ///
  /// [baseWord]: La palabra a utilizar como base.
  /// [length]: La longitud final deseada de la cadena. Por defecto es 8.
  String generateFromWord(String baseWord, {int length = 8}) {
    if (baseWord.isEmpty) {
      return generateRandomWord(length: length);
    }

    List<String> characters = baseWord.split('')..shuffle(_rnd);

    while (characters.length < length) {
      characters.add(_chars[_rnd.nextInt(_chars.length)]);
    }

    return characters.join('').substring(0, length);
  }
}


// final generator = RandomWordGenerator();

// // Genera una palabra totalmente aleatoria de 8 caracteres
// final word1 = generator.generateRandomWord(); // Ejemplo: "aB5fG9kL"

// // Genera una palabra a partir de "GERARDO"
// final word2 = generator.generateFromWord("GERARDO");