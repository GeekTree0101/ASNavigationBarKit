import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds) // create UIwindow
        if let window = window {
            let navController = UINavigationController(rootViewController: MainViewController())
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
        
        return true
    }
    
    static func getGmailList() -> [Gmail] {
        let bundle = Bundle(for: AppDelegate.self)
        let path = bundle.path(forResource: "gmail_list.json", ofType: nil)!
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return [] }
        return (try? JSONDecoder().decode([Gmail].self, from: data)) ?? []
    }
}

