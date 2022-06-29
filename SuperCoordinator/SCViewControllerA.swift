//
//  SCViewControllerA.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit
import SnapKit

class SCViewControllerA: SCViewController {
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "PAGE A"
        return label
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(50)
        }
//        scNavigationController?.willPush = { [weak self] route in
//            print("🐟🐟 A willPush from = \(type(of: route.from)) to = \(type(of: route.to))")
//        }
//        scNavigationController?.didPush = { [weak self] route in
//            print("🐟🐟 A didPush from = \(type(of: route.from)) to = \(type(of: route.to))")
//        }
//        scNavigationController?.willPop = { [weak self] route in
//            print("🐟🐟 A willPop = from = \(type(of: route.from)) to = \(type(of: route.to))")
//        }
//        scNavigationController?.didPop = { [weak self] route in
//            print("🐟🐟 A didPop = from = \(type(of: route.from)) to = \(type(of: route.to))")
//        }
    }

    @objc func nextPage() {
//        navigationController?.pushViewController(SCViewControllerB(), animated: true)
        (navigationController as? SCNavigationController)?.pushViewController(SCViewControllerB(), animated: true, willPushHandler: { route in
            print("🐟🐟 A willPush from = \(type(of: route.from)) to = \(type(of: route.to))")
        }, didPushHandler: { route in
            print("🐟🐟 A didPush from = \(type(of: route.from)) to = \(type(of: route.to))")
        })
    }
}
