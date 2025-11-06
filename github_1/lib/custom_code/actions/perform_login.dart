// Automatic FlutterFlow imports
// Imports other custom actions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';

Future<String> performLogin(String nip) async {
  final MethodChannel canal = MethodChannel("com.cibanco.superapp/channel");

  final tokenSerialNumber =
      await canal.invokeMethod<String>("performLogin", nip) ?? "";

  return tokenSerialNumber;
}
