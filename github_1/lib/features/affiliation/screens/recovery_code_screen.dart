import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:ciempresas/features/affiliation/providers/credential_setup_provider.dart';
import 'package:ciempresas/widgets/loading/loading_indicator_dialog.dart';
import 'package:ciempresas/widgets/resend_text_link.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RecoveryCodeScreen extends StatefulWidget {
  final String username;
  const RecoveryCodeScreen({super.key, required this.username});

  @override
  State<RecoveryCodeScreen> createState() => _RecoveryCodeScreenState();
}

class _RecoveryCodeScreenState extends State<RecoveryCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
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
    _codeController.addListener(_updateButtonState);
  }

  // Método para verificar si todos los campos están llenos
  void _updateButtonState() {
    final areAllFilled = _codeController.text.trim().isNotEmpty;

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
      MaxLengthValidator(8, errorText: context.tr('max_length_error')),
      PatternValidator(
        r'^[a-zA-Z0-9]+$',
        errorText: context.tr('alphanumeric_only'),
      ),
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
    _codeController.removeListener(_updateButtonState);

    _codeController.dispose();
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

  void _validateRecoveryToken(
    BuildContext context,
    CredentialSetupProvider provider,
  ) async {
    final recoveryCode = _codeController.text.trim();

    // Mostrar loading
    LoadingIndicatorDialog().show(context);

    final isValid = await provider.validateRecoveryToken(recoveryCode);

    if (mounted) {
      LoadingIndicatorDialog().dismiss();
      if (isValid) {
        // Token válido, navegar a la siguiente pantalla
        Navigator.of(
          context,
        ).pushNamed(AppRoute.passwordReset.path, arguments: widget.username);
      } else {
        // Manejar error de validación
        if (provider.errorType == UserAvailabilityError.serverError) {
          // Error específico de validación - mostrar en la UI
          setState(() {
            _showValidationError = true;
            _showUserError = true;
            _showPasswordError = false;
            _errorMessage =
                provider.errorMessage ?? context.tr('invalid_recovery_code');
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
                  child: Text(context.tr('close')),
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
              context.tr('recover_password_recovery_code_title'),
              style: context.theme.appTextTheme.cardTitle,
            ),
            SizedBox(height: 8),
            Text(
              context.tr('recover_password_recovery_code_subtitle'),
              style: context.theme.appTextTheme.cardSubtitle,
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('recover_password_recovery_code'),
                    controller: _codeController,
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
                  const SizedBox(height: 8),
                  ResendTextLink(
                    text1: context.tr('recover_password_recovery_code_forward'),
                    text2: context.tr('resend'),
                    textStyle1: context.theme.appTextTheme.linkQuestion,
                    textStyle2: context.theme.appTextTheme.linkTextLabel,
                    onTap: () {
                      // Tu lógica para reenviar el código
                      debugPrint(context.tr('resend_clicked'));
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
          _validateRecoveryToken(context, provider);
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
