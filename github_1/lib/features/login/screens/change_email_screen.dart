import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/custom_masked_text_widget.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';
import 'package:ciempresas/widgets/info_tooltip.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:ciempresas/features/login/providers/change_email_provider.dart';
import 'package:ciempresas/features/login/services/change_email_service.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:ciempresas/widgets/loading/loading_indicator_dialog.dart';
import 'package:ciempresas/features/affiliation/providers/otp_generation_provider.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores
    _otpController.text = '';
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    _currentEmailController.dispose();
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChangeEmailProvider(
            ChangeEmailServiceImpl(RestManagerV2()),
            SecureStorageService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => OtpGenerationProvider()),
      ],
      child: Consumer2<ChangeEmailProvider, OtpGenerationProvider>(
        builder: (context, emailProvider, otpProvider, _) =>
            _buildContent(context, emailProvider, otpProvider),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ChangeEmailProvider provider,
    OtpGenerationProvider otpProvider,
  ) {
    // Cargar email actual si aún no se ha cargado
    if (provider.currentEmail.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.loadCurrentEmail();
      });
    }

    // Actualizar el controlador cuando cambie el email en el provider
    if (_currentEmailController.text != provider.currentEmail) {
      _currentEmailController.text = provider.currentEmail;
    }

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
              context.tr('change_email_title'),
              style: context.theme.appTextTheme.cardTitle,
            ),
            SizedBox(height: 5),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Parte superior derecha con padding
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      right: 10.0,
                      bottom: 5.0,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InfoTooltip(
                        message: context.tr('rules_email'),
                        iconSize: 25,
                        iconColor: Colors.blueGrey,
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    enabled: false,
                    labelText: context.tr('current_email_title'),
                    controller: _currentEmailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('new_email_title'),
                    controller: _newEmailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      provider.updateFormValidity(
                        _newEmailController.text.trim().isNotEmpty &&
                            _confirmEmailController.text.trim().isNotEmpty &&
                            _otpController.text.trim().isNotEmpty &&
                            _nipController.text.trim().length == 6,
                      );
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nuevo email requerido';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('confirm_email_title'),
                    controller: _confirmEmailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      provider.updateFormValidity(
                        _newEmailController.text.trim().isNotEmpty &&
                            _confirmEmailController.text.trim().isNotEmpty &&
                            _otpController.text.trim().isNotEmpty &&
                            _nipController.text.trim().length == 6,
                      );
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Confirmación de email requerida';
                      }
                      if (value != _newEmailController.text) {
                        return 'Los emails no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.tr('enter_nip_label'),
                      style: context.theme.appTextTheme.cardSubtitle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: PinCodeTextField(
                          appContext: context,
                          length: 6,
                          obscureText: _obscure,
                          obscuringCharacter: '•',
                          animationType: AnimationType.fade,
                          textStyle: context.theme.appTextTheme.pinCodeInput,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 48,
                            fieldWidth: 38,
                            borderWidth: 1.5,
                            activeFillColor: context.theme.appColors.customGrey,
                            inactiveFillColor:
                                context.theme.appColors.customGrey,
                            selectedFillColor:
                                context.theme.appColors.background,
                            activeColor: context.theme.appColors.customGreen,
                            inactiveColor: context.theme.appColors.customGrey,
                            selectedColor: context.theme.appColors.customGreen,
                          ),
                          cursorColor: context.theme.appColors.customGreen,
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          controller: _nipController,
                          onChanged: (value) {
                            // Limpiar OTP si el NIP no está completo
                            if (value.length < 6 &&
                                _otpController.text.isNotEmpty) {
                              // Verificar si el widget ha sido eliminado
                              if (!_isDisposed) {
                                // Usar setState fuera del ciclo de construcción
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (mounted && !_isDisposed) {
                                    setState(() {
                                      _otpController.text = '';
                                    });
                                  }
                                });
                              }
                            }

                            provider.updateFormValidity(
                              _newEmailController.text.trim().isNotEmpty &&
                                  _confirmEmailController.text
                                      .trim()
                                      .isNotEmpty &&
                                  _otpController.text.trim().isNotEmpty &&
                                  value.length == 6,
                            );
                          },
                          keyboardType: TextInputType.number,
                          onCompleted: (value) async {
                            LoadingIndicatorDialog().show(
                              context,
                              text: 'Generando OTP...',
                            );
                            // Generar OTP usando el provider cuando se completa el NIP
                            otpProvider
                                .generateOtp(value)
                                .then((onValue) {
                                  // Actualizar manualmente el controlador con el OTP generado
                                  LoadingIndicatorDialog().dismiss();
                                  if (otpProvider.hasSuccess &&
                                      otpProvider.generatedOtp.isNotEmpty) {
                                    if (!_isDisposed) {
                                      setState(() {
                                        _otpController.text =
                                            otpProvider.generatedOtp;
                                      });
                                    }
                                  }
                                  provider.updateFormValidity(
                                    _newEmailController.text
                                            .trim()
                                            .isNotEmpty &&
                                        _confirmEmailController.text
                                            .trim()
                                            .isNotEmpty &&
                                        _otpController.text.trim().isNotEmpty &&
                                        value.length == 6,
                                  );
                                })
                                .catchError((onError) {
                                  LoadingIndicatorDialog().dismiss();
                                });
                          },
                        ),
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomMaskedTextWidget(
                    controller: _otpController,
                    title: context.tr('dynamic_password_title'),
                  ),
                  if (otpProvider.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        otpProvider.errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    return CenteredContentWithButtons(
      appBarImagePath: 'assets/images/progress_seven.png', // Ruta a tu imagen
      content: formContent,
      primaryButtonText: context.tr('save_changes_title'),
      secondaryButtonText: context.tr('cancel'),
      isPrimaryButtonEnabled: provider.isFormValid && !provider.isLoading,
      onPrimaryButtonPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          // Verificar que el OTP se haya generado correctamente
          if (!otpProvider.hasSuccess || otpProvider.generatedOtp.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Por favor, genere un OTP válido')),
            );
            return;
          }

          LoadingIndicatorDialog().show(context, text: 'Cambiando email...');
          final success = await provider.changeEmail(
            newEmail: _newEmailController.text.trim(),
            confirmEmail: _confirmEmailController.text.trim(),
            dynamicPassword: otpProvider.generatedOtp,
          );
          LoadingIndicatorDialog().dismiss();
          if (mounted && success) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Email actualizado correctamente')),
            // );
            // Navigator.of(context).pop();

            // Navegar a la pantalla de éxito usando rutas nombradas
            Navigator.of(context).pushNamed(
              AppRoute.success.path,
              arguments: {
                'message': context.tr('successful_change_email'),
                'buttonText': context.tr('successful_button'),
                'onFinish': () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoute.home.path,
                    (route) => false,
                  );
                },
              },
            );
          } else {
            ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                content: Text(provider.errorMessage),
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
      },
      onSecondaryButtonPressed: () {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
      },
    );
  }
}
