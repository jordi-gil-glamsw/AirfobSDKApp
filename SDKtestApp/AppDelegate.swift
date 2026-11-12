//
//  AppDelegate.swift
//  SDKtestApp
//
//  Created by Jeonjongmin on 2019/11/20.
//  Copyright © 2019 Jeonjongmin. All rights reserved.
//

import UIKit
import SupremaAC

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ACLocalDataManager.configure()

        // call function for background
        ACLocalDataManager.setRelaunchOption(true)
        ACLocalDataManager.setBackgroundScanPermission(true)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}
