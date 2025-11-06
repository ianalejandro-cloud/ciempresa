import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class AffiliationSuccessScreen extends StatelessWidget {
  const AffiliationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;

    // Breakpoints más granulares para mejor responsive design
    final isXSmallScreen = screenWidth < 320;
    final isMediumScreen = screenWidth < 600;
    final isLargeScreen = screenWidth >= 600;
    final isVeryShortScreen = screenWidth < 600;
    final isShortScreen = screenWidth < 700;

    // Calculamos valores responsivos
    final horizontalPadding = _getHorizontalPadding(screenWidth);
    final logoHeight = _getLogoHeight(screenWidth);
    final appNameFontSize = _getAppNameFontSize(screenWidth);
    final taglineFontSize = _getTaglineFontSize(screenWidth);
    final welcomeFontSize = _getWelcomeFontSize(screenWidth);
    final descriptionFontSize = _getDescriptionFontSize(screenWidth);
    final spacingUnit = _getSpacingUnit(screenWidth);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img_finish.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Espaciado superior
                          SizedBox(
                            height: isVeryShortScreen
                                ? spacingUnit * 2
                                : spacingUnit * 3,
                          ),

                          // Header con logo y texto adaptativo
                          _buildHeader(
                            context,
                            logoHeight: logoHeight,
                            appNameFontSize: appNameFontSize,
                            taglineFontSize: taglineFontSize,
                            isSmallScreen: isSmallScreen,
                            screenWidth: screenWidth,
                          ),

                          // Espaciado intermedio
                          SizedBox(
                            height: isVeryShortScreen
                                ? spacingUnit * 3
                                : spacingUnit * 5,
                          ),

                          // Mensaje de bienvenida
                          _buildWelcomeMessage(
                            context,
                            welcomeFontSize: welcomeFontSize,
                            descriptionFontSize: descriptionFontSize,
                            screenWidth: screenWidth,
                            isShortScreen: isShortScreen,
                          ),

                          // Spacer que empuja el botón hacia abajo
                          const Spacer(),

                          // Botón en la parte inferior
                          _buildLoginButton(context, screenWidth),

                          // Espaciado inferior mínimo
                          SizedBox(
                            height: isVeryShortScreen
                                ? spacingUnit
                                : spacingUnit * 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required double logoHeight,
    required double appNameFontSize,
    required double taglineFontSize,
    required bool isSmallScreen,
    required double screenWidth,
  }) {
    // En pantallas muy pequeñas, usar layout vertical centrado
    if (screenWidth < 320) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo_ciempresa.png', height: logoHeight),
          SizedBox(height: screenWidth * 0.03),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.tr('app_name'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: appNameFontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                context.tr('app_tagline'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: taglineFontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      );
    }

    // Layout horizontal centrado para pantallas más grandes
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo_ciempresa.png', height: logoHeight),
          SizedBox(width: screenWidth * 0.025),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('app_name'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: appNameFontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                context.tr('app_tagline'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: taglineFontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage(
    BuildContext context, {
    required double welcomeFontSize,
    required double descriptionFontSize,
    required double screenWidth,
    required bool isShortScreen,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: screenWidth > 600 ? 500 : screenWidth * 0.9,
          ),
          child: Text(
            context.tr('affiliation_success_welcome'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: welcomeFontSize,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            maxLines: isShortScreen ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: screenWidth * 0.04),
        Container(
          constraints: BoxConstraints(
            maxWidth: screenWidth > 600 ? 450 : screenWidth * 0.85,
          ),
          child: Text(
            context.tr('affiliation_success_description'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: descriptionFontSize,
              height: 1.4,
            ),
            maxLines: isShortScreen ? 3 : 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, double screenWidth) {
    // Ancho del botón adaptativo para asegurar que el texto quepa en una línea
    final buttonWidth = screenWidth > 600
        ? 350.0
        : screenWidth > 400
        ? screenWidth * 0.85
        : screenWidth * 0.9;

    return Center(
      child: SizedBox(
        width: buttonWidth,
        child: PrimaryButton(
          text: context.tr('login'),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoute.home.path);
          },
        ),
      ),
    );
  }

  // Métodos para calcular valores responsivos

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth < 320) return 16.0;
    if (screenWidth < 400) return 20.0;
    if (screenWidth < 600) return 24.0;
    return 32.0;
  }

  double _getLogoHeight(double screenWidth) {
    if (screenWidth < 320) return 40.0;
    if (screenWidth < 400) return 50.0;
    if (screenWidth < 600) return 60.0;
    return 70.0;
  }

  double _getAppNameFontSize(double screenWidth) {
    if (screenWidth < 320) return 18.0;
    if (screenWidth < 400) return 20.0;
    if (screenWidth < 600) return 24.0;
    return 28.0;
  }

  double _getTaglineFontSize(double screenWidth) {
    if (screenWidth < 320) return 12.0;
    if (screenWidth < 400) return 14.0;
    if (screenWidth < 600) return 16.0;
    return 18.0;
  }

  double _getWelcomeFontSize(double screenWidth) {
    if (screenWidth < 320) return 24.0;
    if (screenWidth < 400) return 28.0;
    if (screenWidth < 600) return 36.0;
    return 42.0;
  }

  double _getDescriptionFontSize(double screenWidth) {
    if (screenWidth < 320) return 13.0;
    if (screenWidth < 400) return 14.0;
    if (screenWidth < 600) return 16.0;
    return 18.0;
  }

  double _getSpacingUnit(double screenWidth) {
    if (screenWidth < 600) return 8.0;
    if (screenWidth < 700) return 12.0;
    if (screenWidth < 800) return 16.0;
    return 20.0;
  }
}
