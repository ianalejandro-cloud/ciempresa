import 'package:ciempresas/features/affiliation/screens/affiliation_success_screen.dart';
import 'package:ciempresas/features/affiliation/screens/company_details_screen.dart';
import 'package:ciempresas/features/affiliation/screens/credential_setup_screen.dart';
import 'package:ciempresas/features/affiliation/screens/legal_representative_screen.dart';
import 'package:ciempresas/features/affiliation/screens/login_screen.dart';
import 'package:ciempresas/features/affiliation/screens/nip_setup_screen.dart';
import 'package:ciempresas/features/affiliation/screens/password_recovery_screen.dart';
import 'package:ciempresas/features/affiliation/screens/password_reset_screen.dart';
import 'package:ciempresas/features/affiliation/screens/recovery_code_screen.dart'
    hide PasswordRecoveryScreen;
import 'package:ciempresas/features/affiliation/screens/validate_client_screen.dart';
import 'package:ciempresas/features/affiliation/screens/verification_screen.dart';
import 'package:ciempresas/features/affiliation/screens/verification_soft_token_screen.dart';
import 'package:ciempresas/features/home/screens/home.dart';
import 'package:ciempresas/features/login/screens/change_email_screen.dart';
import 'package:ciempresas/features/login/screens/change_password_screen.dart';
import 'package:ciempresas/features/splash/splash_screen.dart';
import 'package:ciempresas/features/home/screens/success_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/validate-client':
        return MaterialPageRoute(builder: (_) => const ValidateClienteScreen());
      case '/verification':
        var clientNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VerificationScreen(clientNumber: clientNumber),
        );
      case '/company-details':
        return MaterialPageRoute(builder: (_) => const CompanyDetailsScreen());
      case '/legal-representative':
        return MaterialPageRoute(
          builder: (_) => const LegalRepresentativeScreen(),
        );
      case '/credential-setup':
        return MaterialPageRoute(builder: (_) => const CredentialSetupScreen());
      case '/nip-setup':
        return MaterialPageRoute(builder: (_) => const NipSetupScreen());
      case '/verification-token':
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VerificationSoftToken(seletedPIN: args),
        );
      case '/affiliation-Success':
        return MaterialPageRoute(
          builder: (_) => const AffiliationSuccessScreen(),
        );
      case '/password-recovery':
        return MaterialPageRoute(
          builder: (_) => const PasswordRecoveryScreen(),
        );
      case '/recovery-code':
        final String args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => RecoveryCodeScreen(username: args),
        );
      case '/password-reset':
        final String args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PasswordResetScreen(username: args),
        );
      case '/change-password':
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case '/change-email':
        return MaterialPageRoute(builder: (_) => const ChangeEmailScreen());
      case '/success':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SuccessScreen(
            successMessage: args['message'] as String,
            onFinishPressed: args['onFinish'] as VoidCallback,
            buttonText: args['buttonText'] as String? ?? 'Finalizar',
          ),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR')),
        );
      },
    );
  }
}
