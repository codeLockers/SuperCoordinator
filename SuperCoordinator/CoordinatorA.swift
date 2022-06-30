//
//  CoordinatorA.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/29.
//

import UIKit

class CoordinatorA: Coordinator {
    var window: UIWindow?

    override func start() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vcA = SCViewControllerA(coordinator: self)
        vcA.goToPageB = { [weak self] in
            self?.goToPageB()
        }
        navigationController.pushViewController(vcA, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        startedViewController = vcA
    }

    deinit {
        print("🐟🐟 deinit CoordinatorA")
    }

    private func goToPageB() {
        let coordinatorB = CoordinatorB(navigationController: navigationController)
        startChildCoordinator(coordinatorB)
    }
}
