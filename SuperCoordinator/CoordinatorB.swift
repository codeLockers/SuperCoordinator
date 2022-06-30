//
//  CoordinatorB.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/29.
//

import UIKit

class CoordinatorB: Coordinator {
    override func start() {
        let vcB = SCViewControllerB(coordinator: self)
        vcB.goToPageC = { [weak self] in
            self?.goToPageC()
        }
        navigationController.pushViewController(vcB, animated: true)
        startedViewController = vcB
    }

    deinit {
        print("🐟🐟 deinit CoordinatorB")
    }

    private func goToPageC() {
        let coordinatorC = CoordinatorC(navigationController: navigationController)
        startChildCoordinator(coordinatorC, useSuperCoordinatorFinish: false)
    }
}
