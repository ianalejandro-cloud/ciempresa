//import 'package:ciempresas/functions/restFull/rest_manager.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:ciempresas/core/theme/app_theme.dart';

class CenteredFormWithButtons extends StatefulWidget {
  const CenteredFormWithButtons({super.key});

  @override
  State<CenteredFormWithButtons> createState() =>
      _CenteredFormWithButtonsState();
}

class _CenteredFormWithButtonsState extends State<CenteredFormWithButtons> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  final bool _obscurePassword = true;
  static const Color underlineBorderColor = Color(0xFF95C60F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Configuración clave para el comportamiento del teclado
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Ejemplo')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Área de formulario con scroll
          Positioned.fill(
            bottom: 140, // Espacio para los botones
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Card(
                  color: context.theme.appColors.background,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            labelText: "Usuario",
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su usuario';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              filled: true,
                              fillColor: Color(0xFFEDEFF1),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: underlineBorderColor,
                                  width: 2.0,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  // Toggle password visibility
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su contraseña';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/icon_container_face.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8),
                              Switch(
                                value: _rememberMe,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    _rememberMe = newValue;
                                  });
                                },
                                activeColor: const Color(0xFF4CAF50),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  // Forgot password action
                                },
                                child: const Text(
                                  'Olvidé mi contraseña',
                                  style: TextStyle(
                                    color: Color(0xFF2196F3),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF2196F3),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Botones fijos en la parte inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Acción continuar
                          //_login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción cancelar
                        // textController.clear();
                        // FocusScope.of(context).unfocus();
                        //_getToken();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
