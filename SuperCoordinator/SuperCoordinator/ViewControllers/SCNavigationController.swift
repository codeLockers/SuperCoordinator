//
//  SCNavigationController.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit

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

    public typealias RouteHandler = ((Route) -> Void)

    public var willPushHandler: RouteHandler?
    public var didPushHandler: RouteHandler?
    public var willPopHandler: RouteHandler?
    public var didPopHandler: RouteHandler?
    public var errorHandler: (() -> Void)?

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
            errorHandler?()
        }
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        state = .pushing
        fromViewController = viewControllers.last
        toViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }

    public func pushViewController(_ viewController: UIViewController, animated: Bool, willPushHandler: RouteHandler?, didPushHandler: RouteHandler?) {
        self.willPushHandler = willPushHandler
        self.didPushHandler = { [weak self] route in
            didPushHandler?(route)
            self?.willPushHandler = nil
            self?.didPushHandler = nil
        }
        pushViewController(viewController, animated: animated)
    }
}

extension SCNavigationController {
    public override func popViewController(animated: Bool) -> UIViewController? {
        state = .popping
        fromViewController = viewControllers.last
        if viewControllers.count > 1 {
            toViewController = viewControllers[viewControllers.count - 2]
        }
        if let from = fromViewController,
            let to = toViewController {
            willPopHandler?(Route(from: from, to: to))
        } else {
            resetState(triggerError: true)
        }
        return super.popViewController(animated: animated)
    }

    //if want hook the popHandler, need custom the system back item or call this api directly
    public func popViewController(animated: Bool, willPopHandler: RouteHandler?, didPopHandler: RouteHandler?) -> UIViewController? {
        transpondPopHandler(willPopHandler: willPopHandler, didPopHandler: didPopHandler)
        return popViewController(animated: animated)
    }

    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        state = .popping
        fromViewController = viewControllers.last
        toViewController = viewControllers.first
        if let from = fromViewController,
            let to = toViewController {
            willPopHandler?(Route(from: from, to: to))
        } else {
            resetState(triggerError: true)
        }
        return super.popToRootViewController(animated: animated)
    }

    //if want hook the popHandler, need custom the system back item or call this api directly
    public func popToRootViewController(animated: Bool, willPopHandler: RouteHandler?, didPopHandler: RouteHandler?) -> [UIViewController]? {
        transpondPopHandler(willPopHandler: willPopHandler, didPopHandler: didPopHandler)
        return popToRootViewController(animated: animated)
    }

    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        state = .popping
        fromViewController = viewControllers.last
        toViewController = viewController
        if let from = fromViewController,
            let to = toViewController {
            willPopHandler?(Route(from: from, to: to))
        } else {
            resetState(triggerError: true)
        }
        return super.popToViewController(viewController, animated: animated)
    }

    //if want hook the popHandler, need custom the system back item or call this api directly
    public func popToViewController(_ viewController: UIViewController, animated: Bool, willPopHandler: RouteHandler?, didPopHandler: RouteHandler?) -> [UIViewController]? {
        transpondPopHandler(willPopHandler: willPopHandler, didPopHandler: didPopHandler)
        return popToViewController(viewController, animated: animated)
    }

    @discardableResult
    public func popToViewControllerType(_ type: UIViewController.Type, animated: Bool, willPopHandler: RouteHandler?, didPopHandler: RouteHandler?) -> [UIViewController]? {
        guard let viewController = viewControllers.last(where: { $0.isKind(of: type) }) else {
            resetState()
            errorHandler?()
            return nil
        }
        return popToViewController(viewController, animated: animated, willPopHandler: willPopHandler, didPopHandler: didPopHandler)
    }

    private func transpondPopHandler(willPopHandler: RouteHandler?, didPopHandler: RouteHandler?) {
        self.willPopHandler = willPopHandler
        self.didPopHandler = { [weak self] route in
            didPopHandler?(route)
            self?.willPopHandler = nil
            self?.didPopHandler = nil
        }
    }
}

extension SCNavigationController: UINavigationBarDelegate {
    //won't work, if navigationBar hidden
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        if let from = fromViewController,
            let to = toViewController {
            willPushHandler?(Route(from: from, to: to))
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
            didPushHandler?(Route(from: from, to: to))
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
            didPopHandler?(Route(from: from, to: to))
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
                    willPushHandler?(Route(from: from, to: viewController))
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
                    didPushHandler?(Route(from: from, to: viewController))
                } else {
                    didPopHandler?(Route(from: from, to: viewController))
                }
            } else {
                resetState(triggerError: true)
            }
        }
        resetState()
    }
}
