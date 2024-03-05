import UIKit
import Flutter
import AppTrackingTransparency

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.requestTrackingAuthorization()
        }
    }
    
    func requestTrackingAuthorization(completion: (() -> Void)? = nil) {
        print("request ATT")
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("ATT Accepted")
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("ATT Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("ATT Not Determined")
                case .restricted:
                    print("ATT Restricted")
                @unknown default:
                    print("ATT Unknown")
                }
                completion?()
            }
        }
    }
}
