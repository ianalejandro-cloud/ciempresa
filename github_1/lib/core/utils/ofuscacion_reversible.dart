class OfuscacionReversible {
  static String? _originalGuardado;

  /// Retorna si hay un dato original guardado
  static bool get tieneDatoGuardado => _originalGuardado != null;

  /// Ofusca el texto dejando visibles los últimos [visibles] caracteres.
  /// Si se pasa [guardarOriginal] como true, guarda el valor original internamente.
  static String ofuscar(
    String texto, {
    int visibles = 3,
    bool guardarOriginal = false,
  }) {
    if (texto.length <= visibles) {
      if (guardarOriginal) _originalGuardado = texto;
      return '*' * texto.length;
    }

    final visiblePart = texto.substring(texto.length - visibles);
    final maskedPart = '*' * (texto.length - visibles);
    final resultado = maskedPart + visiblePart;

    if (guardarOriginal) {
      _originalGuardado = texto;
    }

    return resultado;
  }

  /// Desofusca el texto usando el [original] si se proporciona,
  /// o usando el valor original guardado previamente.
  static String desofuscar(
    String textoOfuscado, {
    String? original,
    int visibles = 3,
  }) {
    final originalAUsar = original ?? _originalGuardado;

    if (originalAUsar == null) {
      throw ArgumentError('No se proporcionó un original ni hay uno guardado.');
    }

    if (textoOfuscado.length != originalAUsar.length) {
      throw ArgumentError('Las longitudes no coinciden.');
    }

    final originalVisiblePart = originalAUsar.substring(
      originalAUsar.length - visibles,
    );
    final ofuscadoVisiblePart = textoOfuscado.substring(
      textoOfuscado.length - visibles,
    );

    if (originalVisiblePart != ofuscadoVisiblePart) {
      throw ArgumentError('La parte visible no coincide con el original.');
    }

    return originalAUsar;
  }

  /// Borra el dato original almacenado
  static void limpiarDatoGuardado() {
    _originalGuardado = null;
  }
}
