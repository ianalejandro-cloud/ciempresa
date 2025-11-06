//
//  CallHandler.swift
//  Runner
//
//  Created by Gerado Cruz on 24/07/25.
//

import Foundation
import Combine
import Flutter


class CallHandler {
    private var controller: FlutterViewController!
    var verisecM = VerisecManager()

    init(controller: FlutterViewController) throws {
        self.controller = controller
    }

    func handler(
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case Constants.MethodChannel.performAffiliation:
            guard let clientCode = call.arguments as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected clientCode as String", details: nil))
                return
            }

            Task {
                do {
                    let resultado = try verisecM.performAffiliation(clientCode: clientCode)
                    result(resultado)
                } catch {
                    result(FlutterError(code: "AFFILIATION_ERROR", message: error.localizedDescription, details: nil))
                }
            }

        case Constants.MethodChannel.performLogin:
            guard let nip = call.arguments as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected NIP as String", details: nil))
                return
            }

            Task {
                do {
                    let resultado = try verisecM.performLogin(nip: nip)
                    result(resultado)
                } catch {
                    result(FlutterError(code: "LOGIN_ERROR", message: error.localizedDescription, details: nil))
                }
            }

        case Constants.MethodChannel.generateOTP:
            guard let nip = call.arguments as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected NIP as String", details: nil))
                return
            }

            Task {
                do {
                    let resultado = try verisecM.generateOTP(nip: nip)
                    result(resultado)
                } catch {
                    result(FlutterError(code: "OTP_ERROR", message: error.localizedDescription, details: nil))
                }
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}


