import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/core/utils/ofuscacion_reversible.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/custom_masked_text_widget.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';
import 'package:ciempresas/widgets/info_tooltip.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:ciempresas/features/login/providers/change_password_provider.dart';
import 'package:ciempresas/features/login/services/change_password_service.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:ciempresas/widgets/loading/loading_indicator_dialog.dart';
import 'package:ciempresas/features/affiliation/providers/otp_generation_provider.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PasswordResetScreen extends StatefulWidget {
  final String username;
  const PasswordResetScreen({super.key, required this.username});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  //final TextEditingController _currentPasswordController =
  //    TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores
    _otpController.text = '';
    _usernameController.text = OfuscacionReversible.ofuscar(
      widget.username,
      visibles: 4,
      guardarOriginal: true,
    );
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    _usernameController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChangePasswordProvider(
            ChangePasswordServiceImpl(RestManagerV2()),
            SecureStorageService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => OtpGenerationProvider()),
      ],
      child: Consumer2<ChangePasswordProvider, OtpGenerationProvider>(
        builder: (context, passwordProvider, otpProvider, _) =>
            _buildContent(context, passwordProvider, otpProvider),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ChangePasswordProvider provider,
    OtpGenerationProvider otpProvider,
  ) {
    // Cargar username actual si aún no se ha cargado
    if (provider.currentUsername.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.loadCurrentUsername();
      });
    }

    // Actualizar el controlador cuando cambie el username en el provider
    // if (_usernameController.text != provider.currentUsername) {
    //   _usernameController.text = provider.currentUsername;
    // }

    // No actualizamos el OTP aquí para evitar problemas durante la fase de construcción

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
              context.tr('recover_password_recovery_new_password_title'),
              style: context.theme.appTextTheme.cardTitle,
            ),
            SizedBox(height: 8),
            Text(
              context.tr('recover_password_recovery_new_password_subtitle'),
              style: context.theme.appTextTheme.cardSubtitle,
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
                        message: context.tr('rules_password'),
                        iconSize: 25,
                        iconColor: Colors.blueGrey,
                        duration: 10,
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    enabled: false,
                    labelText: context.tr('user_label_short'),
                    controller: _usernameController,
                  ),
                  // const SizedBox(height: 15),
                  // CustomTextFormField(
                  //   labelText: context.tr('current_password_title'),
                  //   controller: _currentPasswordController,
                  //   obscureText: true,
                  //   showPasswordToggle: true,
                  //   maxLength: 15,
                  //   onChanged: (value) {
                  //     provider.updateFormValidity(
                  //       _usernameController.text.trim().isNotEmpty &&
                  //           _currentPasswordController.text.trim().isNotEmpty &&
                  //           _newPasswordController.text.trim().isNotEmpty &&
                  //           _confirmPasswordController.text.trim().isNotEmpty &&
                  //           _nipController.text.trim().length == 6,
                  //     );
                  //   },
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) {
                  //       return context.tr('password_required');
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr(
                      'recover_password_recovery_new_password',
                    ),
                    controller: _newPasswordController,
                    obscureText: true,
                    showPasswordToggle: true,
                    maxLength: 15,
                    onChanged: (value) {
                      provider.updateFormValidity(
                        _usernameController.text.trim().isNotEmpty &&
                            _newPasswordController.text.trim().isNotEmpty &&
                            _confirmPasswordController.text.trim().isNotEmpty &&
                            _nipController.text.trim().length == 6,
                      );
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.tr('password_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('confirm_password_title'),
                    controller: _confirmPasswordController,
                    showPasswordToggle: true,
                    maxLength: 15,
                    onChanged: (value) {
                      provider.updateFormValidity(
                        _usernameController.text.trim().isNotEmpty &&
                            _newPasswordController.text.trim().isNotEmpty &&
                            _confirmPasswordController.text.trim().isNotEmpty &&
                            _nipController.text.trim().length == 6 &&
                            _otpController.text.trim().length == 6,
                      );
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.tr('confirm_password_required');
                      }
                      if (value != _newPasswordController.text) {
                        return context.tr('passwords_mismatch');
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
                              _usernameController.text.trim().isNotEmpty &&
                                  _newPasswordController.text
                                      .trim()
                                      .isNotEmpty &&
                                  _confirmPasswordController.text
                                      .trim()
                                      .isNotEmpty &&
                                  value.length == 6 &&
                                  _otpController.text.trim().isNotEmpty,
                            );
                          },
                          onCompleted: (value) async {
                            LoadingIndicatorDialog().show(
                              context,
                              text: context.tr('generating_otp'),
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
                                    _usernameController.text
                                            .trim()
                                            .isNotEmpty &&
                                        _newPasswordController.text
                                            .trim()
                                            .isNotEmpty &&
                                        _confirmPasswordController.text
                                            .trim()
                                            .isNotEmpty &&
                                        value.length == 6 &&
                                        _otpController.text.trim().isNotEmpty,
                                  );
                                })
                                .catchError((onError) {
                                  LoadingIndicatorDialog().dismiss();
                                });
                          },
                          keyboardType: TextInputType.number,
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
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    return CenteredContentWithButtons(
      appBarImagePath: 'assets/images/progress_seven.png',
      content: formContent,
      primaryButtonText: context.tr('save_changes_title'),
      secondaryButtonText: context.tr('cancel'),
      isPrimaryButtonEnabled: provider.isFormValid && !provider.isLoading,
      onPrimaryButtonPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          // Verificar que el OTP se haya generado correctamente
          if (!otpProvider.hasSuccess || otpProvider.generatedOtp.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.tr('please_generate_valid_otp'))),
            );
            return;
          }

          LoadingIndicatorDialog().show(
            context,
            text: context.tr('changing_password'),
          );
          final success = await provider.changePassword(
            username: OfuscacionReversible.desofuscar(
              _usernameController.text,
              visibles: 4,
            ),
            currentPassword: "",
            newPassword: _newPasswordController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
            token: otpProvider.generatedOtp,
          );
          LoadingIndicatorDialog().dismiss();
          if (mounted && success) {
            Navigator.of(context).pushNamed(
              AppRoute.success.path,
              arguments: {
                'message': context.tr('successful_change_password'),
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
                    child: Text(context.tr('close')),
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
