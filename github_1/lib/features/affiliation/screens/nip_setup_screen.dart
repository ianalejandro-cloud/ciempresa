import 'dart:io';

import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:ciempresas/custom_code/actions/perform_affiliation.dart'
    as actions;
import 'package:ciempresas/features/affiliation/providers/organization_provider.dart';
import 'package:ciempresas/features/affiliation/providers/send_activation_code_provider.dart';
import 'package:ciempresas/features/home/providers/main_screen_provider.dart';
import 'package:ciempresas/features/home/services/main_screen_service.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:ciempresas/widgets/loading/loading_indicator_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class NipSetupScreen extends StatefulWidget {
  const NipSetupScreen({super.key});

  @override
  State<NipSetupScreen> createState() => _NipSetupScreenState();
}

class _NipSetupScreenState extends State<NipSetupScreen> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _confirmNipController = TextEditingController();
  final SecureStorageService _storageService = SecureStorageService();
  bool _obscure = true;
  bool _showNipError = false;

  @override
  void initState() {
    super.initState();
    // Agregar listeners para limpiar errores automáticamente
    _nipController.addListener(_clearNipError);
    _confirmNipController.addListener(_clearNipError);

    // Llamar al servicio de organización después de crear los elementos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrganizationProvider>(
        context,
        listen: false,
      ).getOrganizationId();
    });
  }

  @override
  void dispose() {
    _nipController.removeListener(_clearNipError);
    _confirmNipController.removeListener(_clearNipError);
    super.dispose();
  }

  void _clearNipError() {
    if (_showNipError) {
      setState(() {
        _showNipError = false;
      });
    }
  }

  bool _validateNip() {
    // Validar que ambos campos tengan 6 dígitos
    if (_nipController.text.length != 6 ||
        _confirmNipController.text.length != 6) {
      setState(() {
        _showNipError = true;
      });
      return false;
    }

    // Validar que coincidan
    if (_nipController.text != _confirmNipController.text) {
      setState(() {
        _showNipError = true;
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MainScreenProvider(
            MainScreenServiceImpl(RestManagerV2()),
            SecureStorageService(),
          ),
        ),
      ],
      child: Consumer2<OrganizationProvider, MainScreenProvider>(
        builder: (context, organizationProvider, mainScreenProvider, _) =>
            _buildContent(context, organizationProvider, mainScreenProvider),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    OrganizationProvider organizationProvider,
    MainScreenProvider mainScreenProvider,
  ) {
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
              context.tr('nip_setup_title'),
              style: context.theme.appTextTheme.cardTitle,
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('nip_setup_description'),
              style: context.theme.appTextTheme.cardSubtitle,
            ),
            const SizedBox(height: 24),
            Text(
              context.tr('create_nip_label'),
              style: context.theme.appTextTheme.verificationCodeLabel,
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
                      inactiveFillColor: context.theme.appColors.customGrey,
                      selectedFillColor: context.theme.appColors.background,
                      activeColor: _showNipError
                          ? context.theme.appColors.customRed
                          : context.theme.appColors.customGreen,
                      inactiveColor: _showNipError
                          ? context.theme.appColors.customRed
                          : context.theme.appColors.customGrey,
                      selectedColor: _showNipError
                          ? context.theme.appColors.customRed
                          : context.theme.appColors.customGreen,
                    ),
                    cursorColor: _showNipError
                        ? context.theme.appColors.customRed
                        : context.theme.appColors.customGreen,
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _nipController,
                    onChanged: (value) {},
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
            const SizedBox(height: 5),
            Text(
              context.tr('confirm_nip_label'),
              style: context.theme.appTextTheme.verificationCodeLabel,
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
                      inactiveFillColor: context.theme.appColors.customGrey,
                      selectedFillColor: context.theme.appColors.background,
                      activeColor: _showNipError
                          ? context.theme.appColors.customRed
                          : context.theme.appColors.customGreen,
                      inactiveColor: _showNipError
                          ? context.theme.appColors.customRed
                          : context.theme.appColors.customGrey,
                      selectedColor: _showNipError
                          ? context.theme.appColors.customRed
                          : context.theme.appColors.customGreen,
                    ),
                    cursorColor: _showNipError
                        ? context.theme.appColors.customRed
                        : context.theme.appColors.customGreen,
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _confirmNipController,
                    onChanged: (value) {},
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
            // Mostrar error solo cuando sea necesario
            if (_showNipError)
              Text(
                context.tr('nip_mismatch_error'),
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
          ],
        ),
      ),
    );

    return CenteredContentWithButtons(
      appBarImagePath: 'assets/images/progress_six.png', // Ruta a tu imagen
      content: formContent,
      primaryButtonText: context.tr('continue'),
      secondaryButtonText: context.tr('close_app'),
      // Usamos las funciones del provider para los botones
      onPrimaryButtonPressed: () async {
        final organizationProvider = Provider.of<OrganizationProvider>(
          context,
          listen: false,
        );
        // Validar antes de continuar
        if (_validateNip() && organizationProvider.organizationId != null) {
          LoadingIndicatorDialog().show(context);
          bool navigate = false;
          try {
            String activationCode = await actions.performAffiliation(
              organizationProvider.organizationId!,
            );

            if (activationCode.isNotEmpty &&
                !activationCode.startsWith('ERROR')) {
              debugPrint(
                "Paso 1 exitoso. Código de activación obtenido: $activationCode",
              );

              final sendCodeProvider = Provider.of<SendActivationCodeProvider>(
                context,
                listen: false,
              );

              // Obtener email y phone del almacenamiento seguro
              final email = await _storageService.readString('email');
              final phone = await _storageService.readString('phone');

              final sendSuccess = await sendCodeProvider.sendCode(
                email: email ?? "",
                phone: phone ?? "",
                activationCode: activationCode,
              );

              if (sendSuccess) {
                debugPrint("Paso 2 exitoso. Navegación pendiente.");
                navigate = true;
              } else {
                debugPrint(
                  "Error en Paso 2: El servicio de envío de código falló.",
                );
              }
            } else {
              debugPrint(
                "Error en Paso 1: No se pudo obtener el código de activación. Respuesta: $activationCode",
              );
            }
          } catch (e) {
            debugPrint("Excepción durante el proceso de afiliación: $e");
          } finally {
            LoadingIndicatorDialog().dismiss();
            if (navigate && mounted) {
              Navigator.of(context).pushNamed(
                AppRoute.verificationToken.path,
                arguments: _confirmNipController.text.trim(),
              );
            }
          }
        }
      },
      onSecondaryButtonPressed: () async {
        LoadingIndicatorDialog().show(context, text: 'Cerrando sesión...');
        final logoutSuccess = await mainScreenProvider.logout();
        LoadingIndicatorDialog().dismiss();

        if (logoutSuccess || !mounted) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error al cerrar sesión: ${mainScreenProvider.errorMessage}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }
}
