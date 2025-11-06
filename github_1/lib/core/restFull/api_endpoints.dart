enum ApiEndpoint {
  userExists('/v1/mvsec/otps/users/exists'),
  validateClient('/v1/mvsec/cimovil/otps/users/search'),
  token('/v1/api/token'),
  refreshToken('/auth/refresh'),
  challege('/v1/mvsec/cimovil/otps/users/search'),
  checkUserAvailability('/v1/mvsec/otps/users/availability'),
  organizationId('/v1/mvsec/otps/organization/id'),
  sendActivationCode('/v1/mvsec/otps/activation-codes/send'),
  validateActivationCode('/v1/mvsec/otps/activation-codes/validate'),
  registerOtpSerial('/v1/mvsec/otps/serials'),
  createUser('/v1/mvsec/otps/users'),

  // Auth service endpoints
  login('/api/v1/authenticate/account/login'),
  changePassword('/api/v1/authenticate/account/change-password'),
  logout('/api/v1/authenticate/account/logout'),
  recoveryCode('/api/v1/authenticate/account/recovery-code'),

  // User management endpoints
  editEmail('/api/v1/user-management/users/editEmail'),

  // Client data endpoints
  clientData('/consultClientData/getClientData');

  const ApiEndpoint(this.path);
  final String path;
}
