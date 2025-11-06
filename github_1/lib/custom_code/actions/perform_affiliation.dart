
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Future<String> performAffiliation(String clientCode) async {
  try {
    // Canal de comunicación con Android
    final MethodChannel canal = MethodChannel("com.cibanco.superapp/channel");

    // Llamar al método nativo performAffiliation
    final activationCode =
        await canal.invokeMethod<String>("performAffiliation", clientCode) ??
        "";

    debugPrint("📋 ClientCode enviado: $clientCode");
    debugPrint("✅ ActivationCode recibido: $activationCode");

    return activationCode;
  } catch (e) {
    debugPrint("❌ Error en performAffiliation: $e");
    return "ERROR: $e";
  }
}
