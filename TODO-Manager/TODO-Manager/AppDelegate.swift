import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var myGreen: UIColor {
        get { return UIColor(red: 99 / 255, green: 188 / 255, blue: 91 / 255, alpha: 1) }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = myGreen
        
        return true
    }

}

