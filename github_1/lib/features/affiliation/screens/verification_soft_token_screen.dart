import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:ciempresas/features/affiliation/providers/verification_provider.dart';
import 'package:ciempresas/features/affiliation/services/verification_service.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:ciempresas/widgets/loading/loading_indicator_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:ciempresas/widgets/common/circular_timer_widget.dart';

class VerificationSoftToken extends StatefulWidget {
  final String seletedPIN;
  const VerificationSoftToken({super.key, required this.seletedPIN});

  @override
  State<VerificationSoftToken> createState() => _VerificationSoftTokenState();
}

class _VerificationSoftTokenState extends State<VerificationSoftToken> {
  final TextEditingController _tokenController = TextEditingController();
  CircularTimerWidgetState? _timerState;
  bool _isTokenComplete = false;
  bool _isPinEnabled = true;

  // Variable para almacenar el email del usuario
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _initializeVerification();
    _tokenController.addListener(_onTokenChanged);
    _loadUserEmail();
  }

  Future<void> _initializeVerification() async {
    // El timer se iniciará cuando se cree el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _timerState?.start(60);
      }
    });
  }

  /// Carga el email del usuario desde el almacenamiento seguro
  Future<void> _loadUserEmail() async {
    final secureStorage = context.read<SecureStorageService>();

    try {
      _userEmail = await secureStorage.readString('email');

      // Actualizar la UI con el email cargado
      if (mounted) {
        setState(() {});
      }

      // Log para verificar que el email se cargó correctamente
      debugPrint('📧 Email del usuario cargado: $_userEmail');
    } catch (e) {
      debugPrint('❌ Error al cargar email del usuario: $e');
    }
  }

  @override
  void dispose() {
    _tokenController.removeListener(_onTokenChanged);

    _timerState?.stop();
    super.dispose();
  }

  void _onTokenChanged() {
    // Actualizar estado de completación
    final isComplete = _tokenController.text.length == 6;
    if (_isTokenComplete != isComplete && mounted) {
      setState(() {
        _isTokenComplete = isComplete;
      });
    }
  }

  Future<void> _handleVerification(VerificationProvider provider) async {
    if (!mounted || _tokenController.text.length != 6) return;

    // El loader se mostrará automáticamente por el Consumer cuando provider.isLoading sea true
    await provider.validateActivationCode(
      activationCode: _tokenController.text,
      seletedPIN: widget.seletedPIN,
      errorTemplate: 'Código de activación inválido. Intente nuevamente.',
    );

    if (mounted && provider.state == VerificationState.success) {
      // Cerrar explícitamente el loader antes de navegar
      LoadingIndicatorDialog().dismiss();

      // Navegar a la siguiente pantalla
      Navigator.of(context).pushNamed(AppRoute.affiliationSuccessScreen.path);
    }
  }

  /// Maneja el reenvío del código de activación usando el provider
  Future<void> _handleResendCode(VerificationProvider provider) async {
    if (!mounted) return;

    LoadingIndicatorDialog().show(context, text: 'Generando nuevo código...');

    try {
      final success = await provider.resendActivationCode();

      if (success) {
        // Reiniciar el contador
        _timerState?.restart();
        if (mounted) {
          setState(() {
            _isPinEnabled = true;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nuevo código enviado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.messageError),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      LoadingIndicatorDialog().dismiss();
    }
  }

  String _getButtonText(VerificationProvider provider) {
    return context.tr('continue');
  }

  /// Devuelve el texto descriptivo con el email del usuario
  String _getDescriptionText() {
    if (_userEmail != null) {
      return 'Se ha enviado un código de activación a tu email $_userEmail.';
    } else {
      return context.tr('soft_token_activation_description');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VerificationProvider(
        context.read<VerificationService>(),
        context.read<SecureStorageService>(),
      ),
      child: Consumer<VerificationProvider>(
        builder: (context, provider, _) {
          // Mostrar/ocultar loader según el estado del provider
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              if (provider.isLoading) {
                LoadingIndicatorDialog().show(context, text: 'Procesando...');
              } else {
                LoadingIndicatorDialog().dismiss();
              }
            }
          });
          Widget formContent = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: context.theme.appColors.background,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('soft_token_activation_title'),
                        style: context.theme.appTextTheme.cardTitle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getDescriptionText(),
                        style: context.theme.appTextTheme.cardSubtitle,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        context.tr('registration_code_label'),
                        style: context.theme.appTextTheme.verificationCodeLabel,
                      ),
                      const SizedBox(height: 8),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        obscureText: false,
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
                          activeColor: provider.showVerificationError
                              ? context.theme.appColors.customRed
                              : context.theme.appColors.customGreen,
                          inactiveColor: provider.showVerificationError
                              ? context.theme.appColors.customRed
                              : context.theme.appColors.customGrey,
                          selectedColor: provider.showVerificationError
                              ? context.theme.appColors.customRed
                              : context.theme.appColors.customGreen,
                        ),
                        cursorColor: provider.showVerificationError
                            ? context.theme.appColors.customRed
                            : context.theme.appColors.customGreen,
                        animationDuration: const Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        controller: _tokenController,
                        onChanged: (value) {
                          // Limpiar errores cuando el usuario interactúa
                          provider.clearVerificationError();

                          final isComplete = value.length == 6;
                          if (_isTokenComplete != isComplete && mounted) {
                            setState(() {
                              _isTokenComplete = isComplete;
                            });
                          }
                        },
                        keyboardType: TextInputType.number,
                        enabled: _isPinEnabled,
                      ),
                      const SizedBox(height: 8),
                      if (provider.showVerificationError)
                        Text(
                          provider.messageError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 8),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double baseFontSize = 15;
                          double minFontSize = 10;
                          double fontSize = baseFontSize;
                          final text1 = context.tr('no_code_received_question');
                          final text2 = context.tr('resend');
                          final textStyle1 =
                              context.theme.appTextTheme.linkQuestion;
                          final textStyle2 =
                              context.theme.appTextTheme.linkTextLabel;
                          // Medir el ancho de ambos textos juntos
                          final textPainter1 = TextPainter(
                            text: TextSpan(
                              text: text1,
                              style: textStyle1.copyWith(fontSize: fontSize),
                            ),
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                          );
                          final textPainter2 = TextPainter(
                            text: TextSpan(
                              text: text2,
                              style: textStyle2.copyWith(fontSize: fontSize),
                            ),
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                          );
                          double totalWidth = 0;
                          do {
                            textPainter1.text = TextSpan(
                              text: text1,
                              style: textStyle1.copyWith(fontSize: fontSize),
                            );
                            textPainter2.text = TextSpan(
                              text: text2,
                              style: textStyle2.copyWith(fontSize: fontSize),
                            );
                            textPainter1.layout();
                            textPainter2.layout();
                            totalWidth =
                                textPainter1.width + 4 + textPainter2.width;
                            if (totalWidth > constraints.maxWidth &&
                                fontSize > minFontSize) {
                              fontSize -= 1;
                            } else {
                              break;
                            }
                          } while (fontSize > minFontSize);
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    text1,
                                    style: textStyle1.copyWith(
                                      fontSize: fontSize,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    _handleResendCode(provider);
                                  },
                                  child: Text(
                                    text2,
                                    style: textStyle2.copyWith(
                                      fontSize: fontSize,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CircularTimerWidget(
                onStateCreated: (state) {
                  _timerState = state;
                  if (mounted) {
                    state.start(30);
                  }
                },
                onTimerFinished: () {
                  if (mounted) {
                    setState(() {
                      _isPinEnabled = false;
                    });
                  }
                },
              ),
            ],
          );

          return CenteredContentWithButtons(
            appBarImagePath: 'assets/images/progress_seven.png',
            content: formContent,
            primaryButtonText: _getButtonText(provider),
            secondaryButtonText: context.tr('cancel'),
            onPrimaryButtonPressed: provider.isLoading
                ? () {}
                : () async {
                    await _handleVerification(provider);
                  },
            onSecondaryButtonPressed: () {
              Navigator.pop(context);
            },
            isPrimaryButtonEnabled: _isTokenComplete && !provider.isLoading,
          );
        },
      ),
    );
  }
}
