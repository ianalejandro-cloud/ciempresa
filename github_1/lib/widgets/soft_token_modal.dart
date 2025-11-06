import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/features/affiliation/providers/otp_generation_provider.dart';
import 'package:ciempresas/widgets/loading/loading_indicator_dialog.dart';
import 'package:ciempresas/widgets/soft_token_generated_modal.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class SoftTokenModal extends StatefulWidget {
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;

  const SoftTokenModal({super.key, this.onAccept, this.onCancel});

  @override
  State<SoftTokenModal> createState() => _SoftTokenModalState();
}

class _SoftTokenModalState extends State<SoftTokenModal> {
  final TextEditingController _nipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nipController.addListener(_clearError);
  }

  @override
  void dispose() {
    _nipController.removeListener(_clearError);
    super.dispose();
  }

  void _clearError() {
    // Limpiar error en el provider cuando el usuario modifica el NIP
    context.read<OtpGenerationProvider>().clearError();
  }

  Future<void> _validateAndAccept() async {
    final otpProvider = context.read<OtpGenerationProvider>();

    // Generar OTP usando el provider (incluye validación automática)
    await otpProvider.generateOtp(_nipController.text);

    // Si fue exitoso, asegurar que el loading se oculte y cerrar modal
    if (otpProvider.hasSuccess && mounted) {
      // Cerrar explícitamente el loader antes de navegar
      LoadingIndicatorDialog().dismiss();

      Navigator.of(context).pop();
      showSoftTokenGeneratedModal(
        context,
        generatedOtp: otpProvider.generatedOtp,
      );
    }
    // Si hay error, el Consumer en build() lo mostrará automáticamente
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpGenerationProvider>(
      builder: (context, otpProvider, child) {
        // Mostrar/ocultar loader según el estado del provider
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            if (otpProvider.isLoading) {
              LoadingIndicatorDialog().show(
                context,
                text: context.tr('generating_otp'),
              );
            } else {
              LoadingIndicatorDialog().dismiss();
            }
          }
        });

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título
                Text(
                  context.tr('soft_token'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtítulo
                Text(
                  context.tr('enter_your_nip'),
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),

                // Campos PIN
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
                    activeColor: otpProvider.hasError
                        ? context.theme.appColors.customRed
                        : context.theme.appColors.customGreen,
                    inactiveColor: otpProvider.hasError
                        ? context.theme.appColors.customRed
                        : context.theme.appColors.customGrey,
                    selectedColor: otpProvider.hasError
                        ? context.theme.appColors.customRed
                        : context.theme.appColors.customGreen,
                  ),
                  cursorColor: otpProvider.hasError
                      ? context.theme.appColors.customRed
                      : context.theme.appColors.customGreen,
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  controller: _nipController,
                  onChanged: (value) {},
                  keyboardType: TextInputType.number,
                ),

                if (otpProvider.hasError) ...[
                  const SizedBox(height: 16),
                  Text(
                    otpProvider.errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 32),

                // Botón Aceptar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: otpProvider.isLoading
                        ? null
                        : _validateAndAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: otpProvider.isLoading
                          ? Colors.grey
                          : Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: otpProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            context.tr('accept'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Función helper para mostrar el modal
void showSoftTokenModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SoftTokenModal(
      onAccept: () {
        Navigator.of(context).pop();
        // Aquí puedes agregar lógica adicional después de validar el NIP
        debugPrint(context.tr('nip_validated_successfully'));
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    ),
  );
}
