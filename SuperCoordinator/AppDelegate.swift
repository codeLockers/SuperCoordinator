//
//  AppDelegate.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var coordinatorA: CoordinatorA?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        coordinatorA = CoordinatorA(navigationController: SCNavigationController())
        coordinatorA?.start()
        return true
    }
}

