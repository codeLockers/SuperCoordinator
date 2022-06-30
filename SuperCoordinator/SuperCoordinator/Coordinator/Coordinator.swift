//
//  Coordinator.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit
import RxSwift
import RxCocoa

open class Coordinator: NSObject {
    private let disposeBag = DisposeBag()
    public let navigationController: SCNavigationController
    public var startedViewController: UIViewController?
    public var childCoordinators: [Coordinator] = []
    public weak var superCoordinator: Coordinator?
    public private(set) var useSuperCoordinatorFinish: Bool = false


    public init(navigationController: SCNavigationController) {
        self.navigationController = navigationController
        super.init()
        handleRxBindings()
    }

    private func handleRxBindings() {
        navigationController.actionSubject
            .bind { [weak self] action in
                switch action {
                case .willPush, .didPush, .willPop, .error:
                    break
                case .didPop:
                    self?.checkIfAutoFinish()
                }
            }.disposed(by: disposeBag)
    }

    private func checkIfAutoFinish() {
        if let startedViewController = startedViewController, !navigationController.viewControllers.contains(startedViewController) {
            removeFromSuperCoordinator()
        }
    }

    private func removeFromSuperCoordinator() {
        superCoordinator?.childCoordinators.removeAll(where: { $0 == self })
    }

    public func startChildCoordinator(_ coordinator: Coordinator, useSuperCoordinatorFinish: Bool = false) {
        childCoordinators.append(coordinator)
        coordinator.superCoordinator = self
        coordinator.useSuperCoordinatorFinish = useSuperCoordinatorFinish
        coordinator.start()
    }

    /// page transition animations and navigations goes here
    open func start() {
        fatalError("Override this function to present/push your viewcontrollers")
    }

    open func back(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }

    open func finish(animated: Bool = true) {
        if let superCoordinator = superCoordinator, useSuperCoordinatorFinish {
            superCoordinator.finish(animated: animated)
        } else {
            guard
                let startedViewController = self.startedViewController,
                let index = navigationController.viewControllers.firstIndex(of: startedViewController),
                index >= 1
            else { return }
            let toViewController = navigationController.viewControllers[index - 1]
            navigationController.popToViewController(toViewController, animated: animated)
        }
    }
}
