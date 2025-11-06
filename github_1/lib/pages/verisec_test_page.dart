import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerisecTestPage extends StatefulWidget {
  const VerisecTestPage({super.key});

  @override
  _VerisecTestPageState createState() => _VerisecTestPageState();
}

class _VerisecTestPageState extends State<VerisecTestPage> {
  String _resultado = 'Presiona el botón para probar performAffiliation';
  bool _isLoading = false;

  // Puedes cambiar este clientCode por el tuyo
  final String clientCode = "828239";

  Future<void> _testPerformAffiliation() async {
    setState(() {
      _isLoading = true;
      _resultado = 'Ejecutando performAffiliation...';
    });

    try {
      // Canal de comunicación con Android
      final MethodChannel canal = MethodChannel('com.cibanco.superapp/channel');

      debugPrint("🔧 Enviando clientCode: $clientCode");

      // Llamar a performAffiliation
      final activationCode =
          await canal.invokeMethod<String>("performAffiliation", clientCode) ??
          "";

      setState(() {
        if (activationCode.isNotEmpty && !activationCode.startsWith('ERROR')) {
          _resultado =
              '✅ ÉXITO!\n\n'
              '📋 ClientCode enviado: $clientCode\n'
              '🔑 ActivationCode recibido:\n$activationCode\n\n'
              '📧 Este código debe enviarse por email/SMS al usuario';
        } else {
          _resultado = '❌ ERROR:\n$activationCode';
        }
      });
    } catch (e) {
      setState(() {
        _resultado = '❌ EXCEPCIÓN:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba Verisec - performAffiliation'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Información del test
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🧪 Test performAffiliation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('ClientCode: $clientCode'),
                    Text('Canal: com.tuapp.canal/verisec'),
                    Text('Método: performAffiliation'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Botón de prueba
            ElevatedButton(
              onPressed: _isLoading ? null : _testPerformAffiliation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Ejecutando...'),
                      ],
                    )
                  : Text(
                      'Ejecutar performAffiliation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            SizedBox(height: 20),

            // Resultado
            Expanded(
              child: Card(
                color: Colors.grey[50],
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📋 Resultado:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _resultado,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Información adicional
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Qué hace performAffiliation:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('1. Envía clientCode al SDK Verisec'),
                  Text('2. Obtiene activationCode único'),
                  Text('3. Este código se envía por email/SMS'),
                  Text('4. Usuario lo ingresa para aprovisionar token'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
