//
//  SceneDelegate.swift
//  SDKtestApp
//

import UIKit
import SupremaAC

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainNavigaionViewController")
        window.makeKeyAndVisible()
        self.window = window
    }

    // Replaces the UIApplicationDelegate foreground/background callbacks, which
    // are no longer delivered once the app adopts the UIScene lifecycle.
    func sceneDidEnterBackground(_ scene: UIScene) {
        if !ACLocalDataManager.getBackgroundScanPermission() {
            SupremaACController.sharedInstance.stopScan()
        } else {
            SupremaACController.sharedInstance.startScan()
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        SupremaACController.sharedInstance.startScan()
    }
}
