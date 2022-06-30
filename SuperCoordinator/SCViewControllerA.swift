//
//  SCViewControllerA.swift
//  SuperCoordinator
//
//  Created by coker on 2022/6/28.
//

import UIKit
import SnapKit

class SCViewControllerA: SCViewController {
    var goToPageB: (() -> Void)?

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Coordinator A - Page A"
        return label
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()

    deinit {
        print("🐟🐟 deinit SCViewControllerA")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-50)
        }
    }

    @objc func nextPage() {
        goToPageB?()
    }
}
