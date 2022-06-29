//
//  Coordinator.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit

class Coordinator {

}

//
////
////  Coordinator.swift
////  Core
////
////  Created by Ville Välimaa on 2020/6/15.
////  Copyright © 2020 Wiredcraft. All rights reserved.
////
//
//import UIKit
//
///// The base class for Coordinator pattern, it holds manage convience properties
/////
///// childCoordinators: manages the child coordinators
///// superCoordinator: refrence to the coordinator that holds current coordinator
///// context: AppContext
///// useSuperCoordinatorFinish: if set true, will call superCoordinator to handle the finish action
///// afterFinishExtraHandler: some extra handler after coordinator finish
//
//open class Coordinator: NSObject {
//    public var childCoordinators: [Coordinator] = []
//    public weak var superCoordinator: Coordinator?
//    public var context: Context
//    public private(set) var useSuperCoordinatorFinish: Bool = false
//    public var afterFinishExtraHandler: EmptyBlock?
//    public var navigationController: NavigationController?
//    public weak var presentingViewController: UIViewController?
//
//    public init(context: Context) {
//        self.context = context
//        super.init()
//    }
//    /// always call this to start a child coordinator
//    public func startChildCoordinator(_ coordinator: Coordinator,
//                                      useSuperCoordinatorFinish: Bool = false,
//                                      afterFinishExtraHandler: EmptyBlock? = nil) {
//        childCoordinators.append(coordinator)
//        coordinator.superCoordinator = self
//        coordinator.useSuperCoordinatorFinish = useSuperCoordinatorFinish
//        coordinator.afterFinishExtraHandler = afterFinishExtraHandler
//        coordinator.start()
//    }
//    /// always call this to finish the current coordinator
//    public func removeFromSuperCoordinator(animated: Bool = true, completion: EmptyBlock? = nil) {
//        let newCompletion: EmptyBlock = { [weak self] in
//            completion?()
//            self?.afterFinishExtraHandler?()
//            self?.superCoordinator?.childCoordinators.removeAll(where: { $0 == self })
//        }
//
//        guard animated else {
//            newCompletion()
//            return
//        }
//        if useSuperCoordinatorFinish {
//            superCoordinator?.removeFromSuperCoordinator(animated: animated, completion: newCompletion)
//        } else {
//            self.finish(newCompletion)
//        }
//    }
//    public func findCoordinator(where filter: (Coordinator) -> Bool) -> Coordinator? {
//        if filter(self) {
//            return self
//        } else {
//            return superCoordinator?.findCoordinator(where: filter)
//        }
//    }
//    /// page transition animations and navigations goes here
//    open func start() {
//        fatalError("Override this function to present/push your viewcontrollers")
//    }
//    /// viewcontrollers dismiss/pop actions goes here, always remember to call completion
//    open func finish(_ completion: EmptyBlock?) {
//        fatalError("Override this function to dismiss/pop your viewcontrollers")
//    }
//}
