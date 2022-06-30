//
//  CoordinatorC.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/29.
//

import UIKit

class CoordinatorC: Coordinator {
    override func start() {
        let vcC = SCViewControllerC(coordinator: self)
        vcC.goToPageD = { [weak self] in
            self?.goToPageD()
        }
        navigationController.pushViewController(vcC, animated: true)
        startedViewController = vcC
    }

    deinit {
        print("🐟🐟 deinit CoordinatorC")
    }

    private func goToPageD() {
        let vcD = SCViewControllerD(coordinator: self)
        vcD.goToPageE = { [weak self] in
            self?.goToPageE()
        }
        navigationController.pushViewController(vcD, animated: true)
    }

    private func goToPageE() {
        let vcE = SCViewControllerE(coordinator: self)
        vcE.goToPageF = { [weak self] in
            self?.goToPageF()
        }
        navigationController.pushViewController(vcE, animated: true)
    }

    private func goToPageF() {
        let vcF = SCViewControllerF(coordinator: self)
        navigationController.pushViewController(vcF, animated: true)
    }
}
