// Automatic FlutterFlow imports

// Imports other custom actions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';

DateTime? _marcaUltimaOtpGenerada;

Future<String> generarOtpConNip(String? nip) async {
  // Add your function code here!
  if (nip == null || nip.length != 6) {
    return '';
  }

  await esperarSiNoHanTranscurrido30Segundos();

  final MethodChannel platform = MethodChannel("com.cibanco.superapp/channel");
  final otp = await platform.invokeMethod<String?>('generateOTP', nip) ?? '';

  actualizarMarcaTiempoUltimaOtpGenerada();
  return otp;
}

Future<void> esperarSiNoHanTranscurrido30Segundos() async {
  if (_marcaUltimaOtpGenerada != null) {
    final Duration tiempoTranscurrido = DateTime.now().difference(
      _marcaUltimaOtpGenerada!,
    );
    if (tiempoTranscurrido.inSeconds < 30) {
      await Future.delayed(
        Duration(seconds: 30 - tiempoTranscurrido.inSeconds),
      );
    }
  }
}

void actualizarMarcaTiempoUltimaOtpGenerada() {
  _marcaUltimaOtpGenerada = DateTime.now();
}
