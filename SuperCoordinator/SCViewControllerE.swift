//
//  SCViewControllerE.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit

class SCViewControllerE: SCViewController {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "PAGE E"
        return label
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()

    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setTitle("Previous", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
        return button
    }()

    private lazy var popToSpecialButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pop to Special", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(popToSpecialPage), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(50)
        }

        view.addSubview(previousButton)
        previousButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nextButton.snp.bottom).offset(50)
        }

        view.addSubview(popToSpecialButton)
        popToSpecialButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(previousButton.snp.bottom).offset(50)
        }

        //        scNavigationController?.willPushHandler = { [weak self] route in
        //            print("🐟🐟 E willPush from = \(type(of: route.from)) to = \(type(of: route.to))")
        //        }
        //        scNavigationController?.didPushHandler = { [weak self] route in
        //            print("🐟🐟 E didPush from = \(type(of: route.from)) to = \(type(of: route.to))")
        //        }
        //        scNavigationController?.willPopHandler = { [weak self] route in
        //            print("🐟🐟 E willPop = from = \(type(of: route.from)) to = \(type(of: route.to))")
        //        }
        //        scNavigationController?.didPopHandler = { [weak self] route in
        //            print("🐟🐟 E didPop = from = \(type(of: route.from)) to = \(type(of: route.to))")
        //        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @objc func nextPage() {
        navigationController?.pushViewController(SCViewControllerE(), animated: true)
    }

    @objc func previousPage() {
        navigationController?.popViewController(animated: true)
    }

    @objc func popToSpecialPage() {
        (navigationController as? SCNavigationController)?.popToViewControllerType(SCViewControllerB.self, animated: true, willPopHandler: { route in
            print("🐟🐟 B willPop = from = \(type(of: route.from)) to = \(type(of: route.to))")
        }, didPopHandler: { route in
            print("🐟🐟 B didPop = from = \(type(of: route.from)) to = \(type(of: route.to))")
        })
    }
}
