import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/restFull/api_endpoints.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:ciempresas/widgets/common/circular_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final String clientNumber;

  const VerificationScreen({super.key, required this.clientNumber});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _obscure = true;
  bool _showVerificationError = false;
  final _restManager = RestManagerV2();
  CircularTimerWidgetState? _timerState;
  bool _isCodeComplete = false;
  bool _isPinEnabled = true;

  Future<bool> validateClient(String clientNumber) async {
    try {
      final result = await _restManager.postWithBearerToken(
        endpoint: ApiEndpoint.validateClient,
        body: {'client_number': clientNumber.trim(), 'channel': 'CN101'},
      );

      switch (result) {
        case Success(value: final data):
          debugPrint('Cliente Verificacion (Reto): $data');
          return true;
        case Failure():
          return false;
      }
    } catch (e) {
      return false;
    }
  }

  void clearError() {}

  @override
  void initState() {
    super.initState();
    // Ejecutar validateClient al iniciar
    _initializeVerification();

    // Limpiar error cuando el usuario empiece a escribir
    _codeController.addListener(_clearVerificationError);
  }

  Future<void> _initializeVerification() async {
    final success = await validateClient(widget.clientNumber);
    if (success) {
      // El timer se iniciará cuando se cree el widget
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _timerState?.start(120);
      });
    }
  }

  @override
  void dispose() {
    _codeController.removeListener(_clearVerificationError);
    super.dispose();
  }

  void _clearVerificationError() {
    if (_showVerificationError) {
      setState(() {
        _showVerificationError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget formContent = Column(
      children: [
        Card(
          color: context.theme.appColors.background,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('verification_code'),
                  style: context.theme.appTextTheme.cardTitle,
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr('verification_code_instruction'),
                  style: context.theme.appTextTheme.cardSubtitle,
                ),
                const SizedBox(height: 24),
                Text(
                  context.tr('verification_code'),
                  style: context.theme.appTextTheme.verificationCodeLabel,
                ),
                const SizedBox(height: 8),
                // LayoutBuilder mejorado para mejor responsividad
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      children: [
                        Flexible(
                          flex: 1,
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
                              activeFillColor:
                                  context.theme.appColors.customGrey,
                              inactiveFillColor:
                                  context.theme.appColors.customGrey,
                              selectedFillColor:
                                  context.theme.appColors.background,
                              activeColor: _showVerificationError
                                  ? context.theme.appColors.customRed
                                  : context.theme.appColors.customGreen,
                              inactiveColor: _showVerificationError
                                  ? context.theme.appColors.customRed
                                  : context.theme.appColors.customGrey,
                              selectedColor: _showVerificationError
                                  ? context.theme.appColors.customRed
                                  : context.theme.appColors.customGreen,
                              disabledColor: Colors.grey.shade200,
                            ),
                            cursorColor: _showVerificationError
                                ? context.theme.appColors.customRed
                                : context.theme.appColors.customGreen,

                            animationDuration: const Duration(
                              milliseconds: 300,
                            ),
                            backgroundColor: Colors.transparent,
                            enableActiveFill: true,
                            controller: _codeController,
                            onChanged: (value) {
                              if (_isCodeComplete && value.length < 6) {
                                setState(() {
                                  _isCodeComplete = false;
                                });
                              }
                            },
                            onCompleted: (value) {
                              setState(() {
                                _isCodeComplete = true;
                              });
                            },
                            keyboardType: TextInputType.number,
                            enabled: _isPinEnabled,
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
                    );
                  },
                ),
                const SizedBox(height: 8),
                // Mostrar mensaje de error solo cuando sea necesario
                if (_showVerificationError) ...[
                  Text(
                    context.tr('verification_code_error'),
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 16),
                // Uso de Row y LayoutBuilder para forzar ambos textos en un solo renglón
                LayoutBuilder(
                  builder: (context, constraints) {
                    double baseFontSize = 15;
                    double minFontSize = 10;
                    double fontSize = baseFontSize;
                    final text1 = context.tr('no_code_received');
                    final text2 = context.tr('resend');
                    final textStyle1 = context.theme.appTextTheme.linkQuestion;
                    final textStyle2 = context.theme.appTextTheme.linkTextLabel;
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
                      totalWidth = textPainter1.width + 8 + textPainter2.width;
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              text1,
                              style: textStyle1.copyWith(fontSize: fontSize),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              _timerState?.restart();
                              setState(() {
                                _isPinEnabled = true;
                              });
                            },
                            child: Text(
                              text2,
                              style: textStyle2.copyWith(fontSize: fontSize),
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
        const SizedBox(height: 40),
        CircularTimerWidget(
          onStateCreated: (state) {
            _timerState = state;
            state.start(120);
          },
          onTimerFinished: () {
            setState(() {
              _isPinEnabled = false;
            });
          },
        ),
      ],
    );

    return CenteredContentWithButtons(
      appBarImagePath: 'assets/images/progrees_two.png', // Ruta a tu imagen
      content: formContent,
      primaryButtonText: context.tr('continue'),
      secondaryButtonText: context.tr('cancel'),
      // Usamos las funciones del provider para los botones
      onPrimaryButtonPressed: () async {
        // Validar que el código tenga la longitud correcta
        if (_codeController.text.length == 6) {
          _validateVerificationCode();
        } else {
          // Si el código no está completo, mostrar error
          setState(() {
            _showVerificationError = true;
          });
        }
      },
      onSecondaryButtonPressed: () {
        // loginProvider.clearForm();
        //FocusScope.of(context).unfocus();
        Navigator.pop(context);
      },
      isPrimaryButtonEnabled: _isCodeComplete,
    );
  }

  void _validateVerificationCode() {
    final code = _codeController.text.trim();

    if (code == "123456" || code == "000000") {
      // Código válido - continuar
      Navigator.of(context).pushNamed(AppRoute.companyDetailsScreen.path);
    } else {
      // Código inválido - mostrar error
      setState(() {
        _showVerificationError = true;
      });
    }
  }
}
