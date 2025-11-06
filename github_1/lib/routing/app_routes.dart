enum AppRoute {
  login,
  validateClient,
  verification,
  companyDetailsScreen,
  legalRepresentativeScreen,
  credentialSetupScreen,
  nipSetupScreen,
  verificationToken,
  affiliationSuccessScreen,
  home,
  passwordRecovery,
  recoveryCode,
  passwordReset,
  changePassword,
  changeEmail,
  success;

  String get path {
    switch (this) {
      case AppRoute.login:
        return '/';
      case AppRoute.validateClient:
        return '/validate-client';
      case AppRoute.verification:
        return '/verification';
      case AppRoute.companyDetailsScreen:
        return '/company-details';
      case AppRoute.legalRepresentativeScreen:
        return '/legal-representative';
      case AppRoute.credentialSetupScreen:
        return '/credential-setup';
      case AppRoute.nipSetupScreen:
        return '/nip-setup';
      case AppRoute.verificationToken:
        return '/verification-token';
      case AppRoute.affiliationSuccessScreen:
        return '/affiliation-Success';
      case AppRoute.home:
        return '/home';
      case AppRoute.passwordRecovery:
        return '/password-recovery';
      case AppRoute.recoveryCode:
        return '/recovery-code';
      case AppRoute.passwordReset:
        return '/password-reset';
      case AppRoute.changePassword:
        return '/change-password';
      case AppRoute.changeEmail:
        return '/change-email';
      case AppRoute.success:
        return '/success';
    }
  }
}
