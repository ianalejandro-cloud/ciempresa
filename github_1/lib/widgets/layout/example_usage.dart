import 'package:flutter/material.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';

/// Ejemplo de uso del widget CenteredContentWithButtons
class LoginFormExample extends StatefulWidget {
  const LoginFormExample({super.key});

  @override
  State<LoginFormExample> createState() => _LoginFormExampleState();
}

class _LoginFormExampleState extends State<LoginFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    // Creamos el contenido que queremos mostrar
    Widget formContent = Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                  fillColor: const Color(0xFFEDEFF1),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF95C60F),
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
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
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
    );

    // Usamos el widget base con nuestro contenido personalizado
    return CenteredContentWithButtons(
      content: formContent,
      primaryButtonText: 'Ingresar',
      secondaryButtonText: 'Cancelar',
      onPrimaryButtonPressed: () {
        if (_formKey.currentState!.validate()) {
          // Acción de login
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Procesando datos...')));
        }
      },
      onSecondaryButtonPressed: () {
        // Acción de cancelar
        _usernameController.clear();
        _passwordController.clear();
        FocusScope.of(context).unfocus();
      },
    );
  }
}
