import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, didConnectWith session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure we have a window scene
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // Create the SwiftUI view that provides the window contents
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
    }

    // Optional: Handle other scene lifecycle methods as needed
}
