//
//  SCViewControllerC.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit

class SCViewControllerC: SCViewController {
    var goToPageD: (() -> Void)?

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Coordinator C - Page C"
        return label
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()

    private lazy var finishButton: UIButton = {
        let button = UIButton()
        button.setTitle("Finish", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(finsh), for: .touchUpInside)
        return button
    }()

    deinit {
        print("🐟🐟 deinit SCViewControllerC")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nextButton.snp.bottom).offset(50)
        }

        view.addSubview(finishButton)
        finishButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(50)
        }

        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-50)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @objc func nextPage() {
        goToPageD?()
    }

    @objc func back() {
        coordinator?.back()
    }

    @objc func finsh() {
        coordinator?.finish()
    }
}
