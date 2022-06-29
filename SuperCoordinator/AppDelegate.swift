//
//  AppDelegate.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVc = SCNavigationController(rootViewController: SCViewControllerA())
        window?.rootViewController = rootVc
        window?.makeKeyAndVisible()
        return true
    }
}

