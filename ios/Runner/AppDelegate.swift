<<<<<<< HEAD
import UIKit
import Flutter
import FirebaseCore

@UIApplicationMain
=======
import Flutter
import UIKit

@main
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
<<<<<<< HEAD
      GeneratedPluginRegistrant.register(with: self)
    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
=======
    GeneratedPluginRegistrant.register(with: self)
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
