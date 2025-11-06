import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:ciempresas/features/affiliation/providers/validate_client_provider.dart';
import 'package:ciempresas/widgets/loading/loading_indicator_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class ValidateClienteScreen extends StatefulWidget {
  const ValidateClienteScreen({super.key});

  @override
  State<ValidateClienteScreen> createState() => _ValidateClienteScreenState();
}

class _ValidateClienteScreenState extends State<ValidateClienteScreen> {
  final TextEditingController _clienteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _validateClientNumber(String? value) {
    return MultiValidator([
      RequiredValidator(errorText: 'Número de cliente es requerido'),
      MinLengthValidator(10, errorText: 'Debe tener al menos 8 caracteres'),
      MaxLengthValidator(10, errorText: 'Debe tener máximo 10 caracteres'),
      PatternValidator(r'^[0-9]+$', errorText: 'Solo números permitidos'),
    ]).call(value);
  }

  @override
  void dispose() {
    _clienteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ValidateClientProvider(),
      child: Consumer<ValidateClientProvider>(
        builder: (context, provider, _) => _buildContent(context, provider),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ValidateClientProvider provider) {
    Widget formContent = Card(
      color: context.theme.appColors.background,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('client_identification'),
                style: context.theme.appTextTheme.cardTitle,
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('secure_access'),
                style: context.theme.appTextTheme.cardSubtitle,
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                labelText: context.tr('client_number'),
                maxLength: 10,
                controller: _clienteController,
                validator: _validateClientNumber,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  provider.updateFormValidity(
                    _validateClientNumber(value) == null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    return CenteredContentWithButtons(
      appBarImagePath: 'assets/images/progress.png', // Ruta a tu imagen
      content: formContent,
      primaryButtonText: context.tr('continue'),
      secondaryButtonText: context.tr('cancel'),
      isPrimaryButtonEnabled: provider.isFormValid && !provider.isLoading,
      onPrimaryButtonPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          LoadingIndicatorDialog().show(context, text: 'Validando...');
          final success = await provider.validateClient(
            _clienteController.text,
          );
          LoadingIndicatorDialog().dismiss();
          if (mounted && success) {
            Navigator.of(context).pushNamed(
              AppRoute.verification.path,
              arguments: _clienteController.text.trim(),
            );
          } else {
            ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                content: Text('${provider.errorMessage}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              ),
            );
          }
        }
      },
      onSecondaryButtonPressed: () {
        // loginProvider.clearForm();
        FocusScope.of(context).unfocus();
      },
    );
  }
}
