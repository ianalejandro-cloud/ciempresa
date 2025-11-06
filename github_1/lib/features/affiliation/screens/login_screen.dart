import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/core/utils/ofuscacion_reversible.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:ciempresas/features/affiliation/providers/login_provider.dart';
import 'package:ciempresas/features/affiliation/providers/soft_token_provider.dart';
import 'package:ciempresas/features/affiliation/services/auth_service.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/buttons/primary_button.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';
import 'package:ciempresas/widgets/loading/loading_indicator_dialog.dart';
import 'package:ciempresas/widgets/soft_token_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _rememberMe = false;
  static const Color underlineBorderColor = Color(0xFF95C60F);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(LoginProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    LoadingIndicatorDialog().show(
      context,
      text: context.tr('loading_validate'),
    );

    // Determinar el username a enviar
    String usernameToSend;
    if (OfuscacionReversible.tieneDatoGuardado) {
      // Si hay un usuario guardado, desofuscar antes de enviar
      try {
        usernameToSend = OfuscacionReversible.desofuscar(
          _usernameController.text,
          visibles: 4,
        );
      } catch (e) {
        // Si falla la desofuscación, usar el texto tal como está
        usernameToSend = _usernameController.text;
      }
    } else {
      // Si no hay usuario guardado, usar el texto tal como está
      usernameToSend = _usernameController.text;
    }

    await provider.login(
      username: usernameToSend,
      password: _passwordController.text,
      errorTemplate: 'Credenciales incorrectas.',
      lastAttemptTemplate: 'Último intento antes del bloqueo.',
      lockedTemplate: 'Cuenta bloqueada por múltiples intentos fallidos.',
    );

    if (provider.state == LoginState.success) {
      _handleLoginSuccess(provider);
    } else {
      LoadingIndicatorDialog().dismiss();
    }
  }

  void _handleLoginSuccess(LoginProvider provider) {
    LoadingIndicatorDialog().dismiss();
    switch (provider.result) {
      case LoginResult.newUser:
        context.read<SoftTokenProvider>().activateSoftToken();
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoute.nipSetupScreen.path,
          (route) => false,
        );
        break;
      case LoginResult.existingUser:
        context.read<SoftTokenProvider>().activateSoftToken();
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoute.home.path, (route) => false);
        break;
      case LoginResult.none:
        break;
    }
    provider.clearResult();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(
        context.read<AuthService>(),
        context.read<SecureStorageService>(),
      ),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: context.theme.appColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      height -
                      mediaQuery.padding.top -
                      mediaQuery.padding.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.025),
                      Text(
                        context.tr('welcome'),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.asset(
                          'assets/images/login_logo.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      SizedBox(height: height * 0.025),
                      Card(
                        color: context.theme.appColors.background,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Consumer2<LoginProvider, SoftTokenProvider>(
                                  builder: (context, loginProvider, softTokenProvider, _) {
                                    // Load saved username if soft token is available
                                    if (softTokenProvider
                                            .isSoftTokenAvailable &&
                                        _usernameController.text.isEmpty) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) async {
                                            final storageService = context
                                                .read<SecureStorageService>();
                                            final savedUsername =
                                                await storageService.readString(
                                                  'username',
                                                );
                                            if (savedUsername != null &&
                                                savedUsername.isNotEmpty) {
                                              setState(() {
                                                _usernameController.text =
                                                    OfuscacionReversible.ofuscar(
                                                      savedUsername,
                                                      visibles: 4,
                                                      guardarOriginal: true,
                                                    );
                                              });
                                            }
                                          });
                                    }

                                    return CustomTextFormField(
                                      labelText: context.tr('username'),
                                      controller: _usernameController,
                                      enabled: !OfuscacionReversible
                                          .tieneDatoGuardado, // Deshabilitar si hay usuario guardado
                                      onChanged: (value) {
                                        loginProvider.clearLoginError();
                                        // Si el usuario modifica manualmente el campo, limpiar el dato guardado
                                        if (OfuscacionReversible
                                                .tieneDatoGuardado &&
                                            !value.contains('*')) {
                                          OfuscacionReversible.limpiarDatoGuardado();
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return context.tr('name_required');
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: height * 0.018),
                                Consumer<LoginProvider>(
                                  builder: (context, provider, _) {
                                    return CustomTextFormField(
                                      labelText: context.tr('password'),
                                      controller: _passwordController,
                                      onChanged: (_) =>
                                          provider.clearLoginError(),
                                      showPasswordToggle: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return context.tr(
                                            'password_required_login',
                                          );
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: height * 0.012),
                                Consumer<LoginProvider>(
                                  builder: (context, provider, _) {
                                    if (provider.showLoginError) {
                                      return Column(
                                        children: [
                                          Text(
                                            provider.messageError,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.012),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                Consumer<SoftTokenProvider>(
                                  builder: (context, softTokenProvider, _) {
                                    // Si el token no está disponible, no mostramos nada.
                                    if (!softTokenProvider
                                        .isSoftTokenAvailable) {
                                      return const SizedBox.shrink();
                                    }
                                    return Row(
                                      children: [
                                        // Image.asset(
                                        //   'assets/images/icon_container_face.png',
                                        //   width: 30,
                                        //   height: 30,
                                        //   fit: BoxFit.cover,
                                        // ),
                                        // const SizedBox(width: 8),
                                        // Switch(
                                        //   value: _rememberMe,
                                        //   onChanged: (value) {
                                        //     setState(() {
                                        //       _rememberMe = value;
                                        //     });
                                        //   },
                                        //   activeColor: underlineBorderColor,
                                        // ),
                                        Flexible(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                AppRoute.passwordRecovery.path,
                                              );
                                            },
                                            child: Text(
                                              context.tr('forgot_password'),
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                  44,
                                                  118,
                                                  142,
                                                  1,
                                                ),
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Color.fromRGBO(
                                                  44,
                                                  118,
                                                  142,
                                                  1,
                                                ),
                                              ),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.018),
                      Consumer<SoftTokenProvider>(
                        builder: (context, softTokenProvider, _) {
                          // Si el token no está disponible, no mostramos nada.
                          if (!softTokenProvider.isSoftTokenAvailable) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              Card(
                                color: context.theme.appColors.background,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: InkWell(
                                  onTap: () => showSoftTokenModal(context),
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      'assets/images/key.png',
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.tr('soft_token'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: height * 0.012),
                      Consumer<LoginProvider>(
                        builder: (context, provider, _) {
                          return PrimaryButton(
                            text: context.tr('login'),
                            onPressed: provider.isLoginLocked
                                ? () {}
                                : () => _handleLogin(provider),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
