import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';
import 'package:ciempresas/features/login/providers/login_provider.dart';

class LoginScreenWithProvider extends StatelessWidget {
  const LoginScreenWithProvider({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos ChangeNotifierProvider para proporcionar el LoginProvider
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: const _LoginScreenWithProviderContent(),
    );
  }
}

class _LoginScreenWithProviderContent extends StatelessWidget {
  const _LoginScreenWithProviderContent();

  @override
  Widget build(BuildContext context) {
    // Obtenemos la instancia del provider
    final loginProvider = Provider.of<LoginProvider>(context);

    // Creamos el contenido del formulario
    Widget formContent = Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: loginProvider.formKey,
          child: Column(
            children: [
              CustomTextFormField(
                labelText: "Usuario",
                controller: loginProvider.usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Usamos Consumer para reconstruir solo este widget cuando cambia obscurePassword
              Consumer<LoginProvider>(
                builder: (_, provider, __) => TextFormField(
                  controller: provider.passwordController,
                  obscureText: provider.obscurePassword,
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
                        provider.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: provider.togglePasswordVisibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Usamos Consumer para reconstruir solo este widget cuando cambia rememberMe
              Consumer<LoginProvider>(
                builder: (_, provider, __) => Row(
                  children: [
                    Image.asset(
                      'assets/images/icon_container_face.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: provider.rememberMe,
                      onChanged: provider.setRememberMe,
                      activeColor: const Color(0xFF4CAF50),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // Acción olvidé contraseña
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
      // Usamos las funciones del provider para los botones
      onPrimaryButtonPressed: () async {
        bool success = await loginProvider.login();
        if (success && context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login exitoso')));
          // Navegar a la siguiente pantalla
        }
      },
      onSecondaryButtonPressed: () {
        loginProvider.clearForm();
        FocusScope.of(context).unfocus();
      },
    );
  }
}
