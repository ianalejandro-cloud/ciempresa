import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:ciempresas/features/affiliation/providers/credential_setup_provider.dart';
import 'package:ciempresas/widgets/loading/loading_indicator_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';

class CredentialSetupScreen extends StatefulWidget {
  const CredentialSetupScreen({super.key});

  @override
  State<CredentialSetupScreen> createState() => _CredentialSetupScreenState();
}

class _CredentialSetupScreenState extends State<CredentialSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _showValidationError = false;
  String _errorMessage = '';
  bool _showUserError = false; // Variable para controlar error de usuario
  bool _showPasswordError =
      false; // Nueva variable para controlar error de contraseñas
  bool _areAllFieldsFilled =
      false; // Variable para controlar si todos los campos están llenos

  @override
  void initState() {
    super.initState();
    // Agregar listeners para actualizar el estado del botón cuando cambien los campos
    _usernameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  // Método para verificar si todos los campos están llenos
  void _updateButtonState() {
    final areAllFilled =
        _usernameController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty &&
        _confirmPasswordController.text.trim().isNotEmpty;

    if (areAllFilled != _areAllFieldsFilled) {
      setState(() {
        _areAllFieldsFilled = areAllFilled;
      });
    }
  }

  // Método simplificado con MultiValidator (solo alfanumérico activo)
  String? _validateUsername(String? value) {
    return MultiValidator([
      RequiredValidator(errorText: context.tr('user_required')),
      MaxLengthValidator(8, errorText: 'Máximo 8 caracteres'),
      PatternValidator(r'^[a-zA-Z0-9]+$', errorText: 'Solo letras y números'),
      // PatternValidator(r'^[a-zA-Z]', errorText: 'Debe empezar con letra'),
      // PatternValidator(r'[A-Z]', errorText: 'Falta letra mayúscula'),
      // PatternValidator(r'[a-z]', errorText: 'Falta letra minúscula'),
    ]).call(value?.trim());

    // Validaciones comentadas por el momento:
    // - Máximo 8 caracteres
    // - Debe empezar con letra
    // - Debe contener mayúsculas
    // - Debe contener minúsculas
    // - Sin números consecutivos
  }

  @override
  void dispose() {
    // Remover listeners antes de dispose
    _usernameController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _confirmPasswordController.removeListener(_updateButtonState);

    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearValidationError(CredentialSetupProvider? provider) {
    if (_showValidationError || _showUserError || _showPasswordError) {
      setState(() {
        _showValidationError = false;
        _errorMessage = '';
        _showUserError = false; // Limpiar error de usuario
        _showPasswordError = false; // Limpiar error de contraseñas
      });

      // También limpiar errores del provider si existe y se pasó como parámetro
      if (provider != null &&
          (provider.errorMessage != null || provider.errorType != null)) {
        provider.clearError();
      }
    }
  }

  void _validateCredentials(
    BuildContext context,
    CredentialSetupProvider provider,
  ) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Datos ficticios para validación simulada
    // const String validUsername = "admin123";
    const String validPassword = "Password123";

    // VALIDACIÓN ORDENADA:

    // 1. Primero validar el usuario
    // if (username != validUsername) {
    //   setState(() {
    //     _showValidationError = true;
    //     _showUserError = true; // Activar error de usuario para pintar todos los bordes
    //     _showPasswordError = false; // Desactivar error de contraseñas
    //     _errorMessage = context.tr('user_exists_error');
    //   });
    //   return;
    // }

    // 2. Segundo validar que las contraseñas coincidan entre sí
    if (password != confirmPassword) {
      setState(() {
        _showValidationError = true;
        _showUserError = false; // Desactivar error de usuario
        _showPasswordError =
            true; // Activar error de contraseñas para pintar solo campos de contraseña
        _errorMessage = context.tr('passwords_mismatch_error');
      });
      return;
    }

    // 3. Tercero validar que la contraseña sea la correcta
    if (password != validPassword) {
      setState(() {
        _showValidationError = true;
        _showUserError = false; // Desactivar error de usuario
        _showPasswordError =
            false; // Desactivar error de contraseñas (este es error de validación, no de coincidencia)
        _errorMessage = context.tr('password_invalid_error');
      });
      return;
    }
    // 4. Si todas las validaciones locales pasan, verificar disponibilidad del usuario en el servidor
    LoadingIndicatorDialog().show(context);

    final isAvailable = await provider.checkUserAvailability(username);

    if (mounted) {
      LoadingIndicatorDialog().dismiss();
      if (isAvailable) {
        // Usuario disponible, navegar a la siguiente pantalla
        Navigator.of(context).pushNamed(AppRoute.nipSetupScreen.path);
      } else {
        // Manejar diferentes tipos de error
        if (provider.errorType == UserAvailabilityError.userExists) {
          // Error de usuario existente - mostrar en la UI como validación local
          setState(() {
            _showValidationError = true;
            _showUserError =
                true; // Activar error de usuario para pintar todos los bordes
            _showPasswordError = false;
            _errorMessage = context.tr('user_exists_error');
          });
        } else {
          // Error de servidor genérico - mostrar MaterialBanner
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text('${provider.errorMessage}'),
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    provider.clearError();
                  },
                  child: Text('Cerrar'),
                ),
              ],
            ),
          );
        }
      }
    } else {
      LoadingIndicatorDialog().dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CredentialSetupProvider(),
      child: Consumer<CredentialSetupProvider>(
        builder: (context, provider, _) => _buildContent(context, provider),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CredentialSetupProvider provider) {
    Widget formContent = Card(
      color: context.theme.appColors.background,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('credential_setup_title'),
              style: context.theme.appTextTheme.cardTitle,
            ),
            SizedBox(height: 8),
            Text(
              context.tr('credential_setup_description'),
              style: context.theme.appTextTheme.cardSubtitle,
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    labelText: context.tr('user_label'),
                    controller: _usernameController,
                    maxLength: 8,
                    underlineColor: _showUserError
                        ? Colors.red
                        : null, // Solo rojo en error de usuario
                    onChanged: (value) => _clearValidationError(provider),
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('password_label'),
                    controller: _passwordController,
                    obscureText: true,
                    showPasswordToggle: true,
                    maxLength: 15,
                    underlineColor: (_showUserError || _showPasswordError)
                        ? Colors.red
                        : null, // Rojo en error de usuario O error de contraseñas
                    onChanged: (value) => _clearValidationError(provider),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.tr('password_required');
                      }
                      // if (value.length < 6) {
                      //   return 'La contraseña debe tener al menos 6 caracteres';
                      // }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('confirm_password_label'),
                    controller: _confirmPasswordController,
                    showPasswordToggle: true,
                    maxLength: 15,
                    underlineColor: (_showUserError || _showPasswordError)
                        ? Colors.red
                        : null, // Rojo en error de usuario O error de contraseñas
                    onChanged: (value) => _clearValidationError(provider),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.tr('confirm_password_required');
                      }
                      // if (value != _passwordController.text) {
                      //   return 'Las contraseñas no coinciden.Asegúrate de escribir la misma contraseña en ambos campos.';
                      // }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Mostrar mensaje de error dinámico solo cuando sea necesario
            if (_showValidationError) ...[
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );

    return CenteredContentWithButtons(
      appBarImagePath: 'assets/images/progress_five.png', // Ruta a tu imagen
      content: formContent,
      primaryButtonText: context.tr('continue'),
      secondaryButtonText: context.tr('cancel'),
      isPrimaryButtonEnabled: !provider.isLoading && _areAllFieldsFilled,
      // Usamos las funciones del provider para los botones
      onPrimaryButtonPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          _validateCredentials(context, provider);
        }
      },
      onSecondaryButtonPressed: () {
        // loginProvider.clearForm();
        //FocusScope.of(context).unfocus();
        Navigator.pop(context);
      },
    );
  }
}
