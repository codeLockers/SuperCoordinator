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

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
