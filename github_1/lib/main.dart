import 'package:ciempresas/core/i18n/app_localizations.dart';
import 'package:ciempresas/core/i18n/locale_provider.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/core/utils/Network_info_service.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:ciempresas/features/affiliation/providers/otp_generation_provider.dart';
import 'package:ciempresas/features/affiliation/providers/organization_provider.dart';
import 'package:ciempresas/features/affiliation/providers/soft_token_provider.dart';
import 'package:ciempresas/features/affiliation/services/auth_service.dart';
import 'package:ciempresas/features/affiliation/services/client_service.dart';
import 'package:ciempresas/features/affiliation/services/verification_service.dart';
import 'package:ciempresas/features/affiliation/providers/send_activation_code_provider.dart';
import 'package:ciempresas/routing/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() async {
  // Preservar el splash screen nativo
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _removeSplashAfterDelay();
  }

  // Remover el splash screen nativo después de 2 segundos
  void _removeSplashAfterDelay() {
    Future.delayed(const Duration(seconds: 1), () {
      FlutterNativeSplash.remove();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Core services (singletons)
        Provider<RestManagerV2>(create: (_) => RestManagerV2()),
        Provider<SecureStorageService>(create: (_) => SecureStorageService()),
        Provider<NetworkInfoService>(create: (_) => NetworkInfoService()),

        // 2. Business services (depend on core services)
        ProxyProvider<RestManagerV2, AuthService>(
          update: (_, restManager, __) => AuthServiceImpl(restManager),
        ),
        ProxyProvider<RestManagerV2, VerificationService>(
          update: (_, restManager, __) => VerificationServiceImpl(restManager),
        ),
        ProxyProvider2<RestManagerV2, SecureStorageService, ClientService>(
          update: (_, restManager, secureStorage, __) =>
              ClientServiceImpl(restManager, secureStorage),
        ),

        // 3. UI providers
        ChangeNotifierProvider(create: (_) => AppTheme()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => OrganizationProvider()),
        ChangeNotifierProvider(create: (_) => SendActivationCodeProvider()),
        ChangeNotifierProvider<SoftTokenProvider>(
          create: (context) => SoftTokenProvider(
            context.read<SecureStorageService>(),
          )..loadSoftTokenAvailability(), // Carga el estado al crear el provider
        ),
        ChangeNotifierProvider(create: (_) => OtpGenerationProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) => MaterialApp(
          title: 'Admin',
          // Provide light theme.
          theme: AppTheme.light,
          // Provide dark theme.
          darkTheme: AppTheme.dark,
          // Watch AppTheme changes (ThemeMode).
          themeMode: context.watch<AppTheme>().themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          //home: SplashScreen(),
          onGenerateRoute: RouteGenerator.generateRoute,

          // Configuración de internacionalización
          supportedLocales: const [
            Locale('es', ''), // Español
            Locale('en', ''), // Inglés
          ],
          locale: localeProvider.locale, // Usar el idioma del provider
          localizationsDelegates: const [
            AppLocalizations.delegate, // Nuestro delegado de localización
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
