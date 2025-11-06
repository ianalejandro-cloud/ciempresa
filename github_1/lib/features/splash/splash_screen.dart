import 'dart:async';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart'; // Comentado - usando imagen PNG en lugar de Lottie

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: (3 * 1000).round()), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // Color de la status bar (arriba)
        statusBarColor: context.theme.appColors.customGreen,
        statusBarIconBrightness: Brightness.light, // Iconos claros u oscuros
        // Color de la navigation bar (abajo) - donde están back/home
        systemNavigationBarColor: context.theme.appColors.customGreen,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: context.theme.appColors.customGreen,
        body: content(),
      ),
    );
  }

  Widget content() {
    return Center(
      child: Container(child: Image.asset("assets/images/splash_logo.png")),
    );
  }

  @override
  void dispose() {
    // Restaurar el estilo por defecto al salir
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }
}
