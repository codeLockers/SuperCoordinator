//
//  SCViewController.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit

public class SCViewController: UIViewController {
    public var scNavigationController: SCNavigationController? {
        navigationController as? SCNavigationController
    }

    public weak var coordinator: Coordinator?

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
