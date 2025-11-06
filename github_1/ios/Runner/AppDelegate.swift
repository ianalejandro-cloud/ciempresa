import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    
  var batteryChannel : FlutterMethodChannel!
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller: FlutterViewController  = window?.rootViewController as! FlutterViewController
      
      batteryChannel = FlutterMethodChannel(
          name: Constants.canal,
          binaryMessenger: controller.binaryMessenger
      )
      
      guard let callHandler = try? CallHandler(
          controller: controller
      ) else {
          return false
      }
      
      batteryChannel.setMethodCallHandler(callHandler.handler)
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
