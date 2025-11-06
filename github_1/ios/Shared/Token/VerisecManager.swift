import Foundation

enum VerisecError: Error {
    case activationFailed(String)
    case loginFailed(String)
    case otpGenerationFailed(String)
}

final class VerisecManager {
    
    @Published var aprovisionado: Bool {
        didSet {
            UserDefaults.standard.set(aprovisionado, forKey: "aprovisionado")
        }
    }

    @Published var activationCode: String = ""
    @Published var tokenSerialNumber: String = ""
    @Published var OTP: String = ""

    var pinData = Data()
    var miMutableData = NSMutableData()
    
    var fmcManager = FmcManager()

    init() {
        self.aprovisionado = UserDefaults.standard.bool(forKey: "aprovisionado")
    }

    // MARK: - Métodos públicos

    func performAffiliation(clientCode: String) throws -> String {
        let activationCode4ClientCode: String? = try catchException {
            FmcManager.getFmcManager()
                .getFmcWSHandler()
                .getActivationCode4ClientCode(clientCode)
        }

        guard let code = activationCode4ClientCode, !code.isEmpty else {
            throw VerisecError.activationFailed("No se pudo obtener el activation code")
        }

        activationCode = code
        print("Activation code: \(activationCode)")
        return code
    }

    func performLogin(nip: String) throws -> String {
        let pinPolicyObject: Any? = try catchException {
            self.fmcManager.getFmcWSHandler().getProvisioningPinPolicy()
        }

        guard let pinPolicy = pinPolicyObject, !(pinPolicy is FmcPollingResponse) else {
            throw VerisecError.loginFailed("Pin policy no recibida o inválida")
        }

        convertNIP(nip: nip)

        _ = try catchException {
            self.fmcManager.getFmcWSHandler().verifyProvisioning4PinNumber(self.miMutableData)
        } as Void?

        let fmcConfiguration: FmcConfiguration = try catchException {
            self.fmcManager.getFmcConfiguration()
        }

        let token: FmcToken? = try catchException {
            fmcConfiguration.getOnlineToken()
        }

        guard let tokenData = token else {
            throw VerisecError.loginFailed("Token serial no disponible")
        }

        tokenSerialNumber = """
        Usage: \(tokenData.usage), \
        SerialNumber: \(String(describing: tokenData.serialNumber)), \
        OcraSuite: \(String(describing: tokenData.ocraSuite)), \
        Icv: \(String(describing: tokenData.icv))
        """

        aprovisionado = true

        return tokenData.serialNumber
    }

    func generateOTP(nip: String) throws -> String {
        convertNIP(nip: nip)

        let otp: String = try catchException {
            self.fmcManager.generateOTPValue(self.miMutableData)
        }

        OTP = otp
        return otp
    }

    // MARK: - Métodos privados

    private func convertNIP(nip: String) {
        guard let data = nip.data(using: .utf8) else { return }
        pinData = data
        miMutableData = NSMutableData(data: data)
    }

    /// Wrapper para capturar excepciones Obj-C (NSException) como errores Swift
    private func catchException<T>(_ tryBlock: @escaping () -> T?) throws -> T {
        let result = ObjCTryCatchWrapper.tryBlockSimple {
            return tryBlock()
        }

        if let error = result as? NSError {
            throw VerisecError.otpGenerationFailed(error.localizedDescription)
        }

        guard let unwrapped = result as? T else {
            throw VerisecError.otpGenerationFailed("Valor nulo o tipo inválido")
        }

        return unwrapped
    }


}
