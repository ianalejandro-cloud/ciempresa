import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Un widget base que muestra contenido centrado con botones fijos en la parte inferior.
///
/// Este widget permite insertar cualquier contenido en el área central y mantiene
/// dos botones fijos en la parte inferior de la pantalla.
class CenteredContentWithButtons extends StatelessWidget {
  /// El contenido principal que se mostrará en el área central con scroll.
  final Widget content;

  /// Título para la AppBar. Requerido si no se provee `appBarImagePath`.
  final String? title;

  /// Ruta a la imagen PNG que se mostrará en la AppBar.
  final String? appBarImagePath;

  /// Texto para el botón principal (generalmente "Continuar").
  final String primaryButtonText;

  /// Texto para el botón secundario (generalmente "Cancelar"). Opcional.
  final String? secondaryButtonText;

  /// Acción a ejecutar cuando se presiona el botón principal.
  final VoidCallback? onPrimaryButtonPressed;

  /// Acción a ejecutar cuando se presiona el botón secundario. Opcional.
  final VoidCallback? onSecondaryButtonPressed;

  /// Si el botón principal está habilitado.
  final bool isPrimaryButtonEnabled;

  /// Color del botón principal.
  final Color primaryButtonColor;

  /// Color del botón secundario.
  final Color secondaryButtonColor;

  /// Espacio reservado en la parte inferior para los botones.
  final double bottomSpace;

  const CenteredContentWithButtons({
    super.key,
    required this.content,
    this.title,
    this.appBarImagePath,
    required this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
    this.primaryButtonColor = Colors.black,
    this.secondaryButtonColor = Colors.grey,
    this.bottomSpace = 140,
    this.isPrimaryButtonEnabled = true,
  }) : assert(
         title != null || appBarImagePath != null,
         'Se debe proveer un título (title) o una ruta de imagen (appBarImagePath).',
       );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: context.theme.appColors.background,
          title: appBarImagePath != null
              ? Image.asset(
                  appBarImagePath!,
                  height: 40, // Altura de la imagen en el AppBar
                )
              : Text(title!),
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Área de contenido con scroll
            Positioned.fill(
              bottom: bottomSpace, // Espacio para los botones
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: content,
                ),
              ),
            ),

            // Botones fijos en la parte inferior
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isPrimaryButtonEnabled
                            ? onPrimaryButtonPressed
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.theme.appColors.primary,
                          disabledBackgroundColor:
                              context.theme.appColors.grey300,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          primaryButtonText,
                          style: isPrimaryButtonEnabled
                              ? TextStyle(color: Colors.white)
                              : context.theme.appTextTheme.title4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (secondaryButtonText != null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onSecondaryButtonPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryButtonColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            secondaryButtonText!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
