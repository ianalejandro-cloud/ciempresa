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

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
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
  }

  // Método para verificar si todos los campos están llenos
  void _updateButtonState() {
    final areAllFilled = _usernameController.text.trim().isNotEmpty;

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
      MinLengthValidator(8, errorText: 'Mínimo 8 caracteres'),
      MaxLengthValidator(10, errorText: 'Máximo 10 caracteres'),
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

    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleRecoveryRequest(
    BuildContext context,
    CredentialSetupProvider provider,
  ) async {
    final username = _usernameController.text.trim();

    LoadingIndicatorDialog().show(context);

    final success = await provider.requestRecoveryCode(username);

    if (mounted) {
      LoadingIndicatorDialog().dismiss();

      if (success) {
        Navigator.of(
          context,
        ).pushNamed(AppRoute.recoveryCode.path, arguments: username);
      } else {
        // Mostrar solo el texto rojo inline
        _showInlineError(provider.errorMessage ?? 'Error desconocido');
      }
    } else {
      LoadingIndicatorDialog().dismiss();
    }
  }

  void _showInlineError(String errorMessage) {
    setState(() {
      _showValidationError = true;
      _errorMessage = errorMessage;
      _showUserError = true; // Pintar el campo de rojo también
      _showPasswordError = false;
    });
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
              context.tr('recover_password_title'),
              style: context.theme.appTextTheme.cardTitle,
            ),
            SizedBox(height: 8),
            Text(
              context.tr('recover_password_subtitle'),
              style: context.theme.appTextTheme.cardSubtitle,
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('recover_password_user'),
                    controller: _usernameController,
                    maxLength: 10,
                    underlineColor: _showUserError
                        ? Colors.red
                        : null, // Solo rojo en error de usuario
                    onChanged: (value) => _clearValidationError(provider),
                    validator: _validateUsername,
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
      appBarImagePath: 'assets/images/progress_three.png', // Ruta a tu imagen
      content: formContent,
      primaryButtonText: context.tr('continue'),
      secondaryButtonText: context.tr('cancel'),
      isPrimaryButtonEnabled: !provider.isLoading && _areAllFieldsFilled,
      // Usamos las funciones del provider para los botones
      onPrimaryButtonPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          await _handleRecoveryRequest(context, provider);
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
