//
//  MWRetryTableViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/8/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWRetryTableViewCell: UITableViewCell {

    // MARK: - variables

    static let reuseID = "MWRetryTableViewCell"
    let buttonSize = CGSize(width: 150, height: 40)
    var retryTapped: (() -> Void)?

    // MARK: - gui variables

    private lazy var retryButton: UIButton = {
        let button = MWRoundedButton(text: "Retry".localized(),
                                     image: UIImage(named: "refreshIcon"))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(self.retryButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .white
        self.selectionStyle = .none
        self.contentView.addSubview(self.retryButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    override func updateConstraints() {
        self.retryButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(self.buttonSize)
        }
        super.updateConstraints()
    }

    // MARK: - functions

    @objc private func retryButtonTapped() {
        self.retryTapped?()
    }
}
