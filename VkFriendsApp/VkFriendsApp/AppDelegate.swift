import UIKit
import SwiftyVK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        VK.configure(appID: "5702613", delegate: self)
        VK.defaults.language = "en"
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor(red: 82 / 255, green: 123 / 255, blue: 176 / 255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        VK.process(url: url, options: options)
        return true
    }
    
}

func notif(_ s: String) -> Notification.Name {
    return Notification.Name(rawValue: s)
}

extension AppDelegate: VKDelegate {
    public func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        print("success auth")
        NotificationCenter.default.post(name: notif("auth_proceeded"), object: nil)
    }
    
    func vkWillAuthorize() -> [VK.Scope] {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        return [VK.Scope.friends, VK.Scope.offline]
    }
    func vkAutorizationFailedWith(error: VK.Error) {
        print("auth failed")
    }
    func vkDidUnauthorize() {
        print("unauthorized")
    }
    func vkShouldUseTokenPath() -> String? {
        return nil
    }
    func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
}
