//
//  SCNavigationController.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit
import RxSwift
import RxCocoa

public class SCNavigationController: UINavigationController {
    public struct Route {
        let from: UIViewController
        let to: UIViewController
    }

    public enum State {
        case normal
        case popping
        case pushing

        var isPopping: Bool {
            switch self {
            case .popping:
                return true
            case .normal, .pushing:
                return false
            }
        }

        var isPushing: Bool {
            switch self {
            case .pushing:
                return true
            case .normal, .popping:
                return false
            }
        }

        var isNormal: Bool {
            switch self {
            case .normal:
                return true
            case .pushing, .popping:
                return false
            }
        }
    }

    public enum Action {
        case willPush(Route)
        case didPush(Route)
        case willPop(Route)
        case didPop(Route)
        case error
    }

    public typealias RouteHandler = ((Route) -> Void)
    public let actionSubject = PublishSubject<Action>()
    private var fromViewController: UIViewController?
    private var toViewController: UIViewController?
    private var state: State = .normal

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    private func resetState(triggerError: Bool = false) {
        state = .normal
        if triggerError {
            actionSubject.onNext(.error)
        }
        //relese
        fromViewController = nil
        toViewController = nil
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        state = .pushing
        fromViewController = viewControllers.last
        toViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

extension SCNavigationController {
    @discardableResult
    public override func popViewController(animated: Bool) -> UIViewController? {
        state = .popping
        fromViewController = viewControllers.last
        if viewControllers.count > 1 {
            toViewController = viewControllers[viewControllers.count - 2]
        }
        if let from = fromViewController,
            let to = toViewController {
            actionSubject.onNext(.willPop(Route(from: from, to: to)))
        } else {
            resetState(triggerError: true)
        }
        return super.popViewController(animated: animated)
    }

    @discardableResult
    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        state = .popping
        fromViewController = viewControllers.last
        toViewController = viewControllers.first
        if let from = fromViewController,
            let to = toViewController {
            actionSubject.onNext(.willPop(Route(from: from, to: to)))
        } else {
            resetState(triggerError: true)
        }
        return super.popToRootViewController(animated: animated)
    }

    @discardableResult
    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        state = .popping
        fromViewController = viewControllers.last
        toViewController = viewController
        if let from = fromViewController,
            let to = toViewController {
            actionSubject.onNext(.willPop(Route(from: from, to: to)))
        } else {
            resetState(triggerError: true)
        }
        return super.popToViewController(viewController, animated: animated)
    }

    @discardableResult
    public func popToViewControllerType(_ type: UIViewController.Type, animated: Bool) -> [UIViewController]? {
        guard let viewController = viewControllers.last(where: { $0.isKind(of: type) }) else {
            resetState()
            actionSubject.onNext(.error)
            return nil
        }
        return popToViewController(viewController, animated: animated)
    }
}

extension SCNavigationController: UINavigationBarDelegate {
    //won't work, if navigationBar hidden
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        if let from = fromViewController,
            let to = toViewController {
            actionSubject.onNext(.willPush(Route(from: from, to: to)))
        } else {
            if viewControllers.count > 1 {
                resetState(triggerError: true)
            }
            //skip first launch page
        }
        return true
    }

    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        if let from = fromViewController,
            let to = toViewController {
            actionSubject.onNext(.didPush(Route(from: from, to: to)))
        } else {
            if viewControllers.count > 1 {
                resetState(triggerError: true)
            }
            //skip first launch page
        }
        state = .normal
    }

    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        return true
    }

    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        if let from = fromViewController,
            let to = toViewController {
            actionSubject.onNext(.didPop(Route(from: from, to: to)))
        } else {
            resetState(triggerError: true)
        }
        resetState()
    }
}

extension SCNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if isNavigationBarHidden {
            //if navigationBar is hidden, will use this delegate
            if let from = fromViewController {
                if viewControllers.contains(from) && state.isPushing {
                    actionSubject.onNext(.willPush(Route(from: from, to: viewController)))
                }
            } else {
                resetState(triggerError: true)
            }
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if isNavigationBarHidden {
            //if navigationBar is hidden, will use this delegate
            if let from = fromViewController {
                if viewControllers.contains(from) {
                    actionSubject.onNext(.didPush(Route(from: from, to: viewController)))
                } else {
                    actionSubject.onNext(.didPop(Route(from: from, to: viewController)))
                }
            } else {
                resetState(triggerError: true)
            }
        }
        resetState()
    }
}
